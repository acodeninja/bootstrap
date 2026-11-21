# Implements docs/cli.md. Where this script and that document disagree, this
# script is wrong.
#
# It is a separate implementation of that contract, not a port of bootstrap.sh.
# The two must agree on flags, exit codes, --list output byte for byte, and the
# set of files produced -- see docs/cli.md "Parity". A windows-latest job holds
# three of those four; what it cannot reach is anything needing a container.
#
# Windows PowerShell 5.1 and nothing else. No modules, no classes (5.1 parses
# them but the remote form is a scriptblock, where a class declaration is a
# parse-time construct and cannot be reached).

Set-StrictMode -Version 2.0

# Native commands report failure through their exit code, not an exception, and
# every failure path here is explicit -- the same reason bootstrap.sh runs under
# set -u alone.
$ErrorActionPreference = 'Continue'

$script:OptName = ''
$script:OptForce = $false
$script:OptNoGit = $false
$script:OptNoBuild = $false
$script:OptNoPull = $false
$script:OptDryRun = $false
$script:OptList = $false
$script:TemplateId = ''
# Target as the user typed it, because that is what the output prints.
# TargetRoot absolute, for the .NET file APIs: they resolve a relative path
# against the process working directory, which Set-Location does not move.
$script:Target = ''
$script:TargetRoot = ''
$script:TemplateRoot = ''
$script:TemplateDir = ''
$script:Display = ''
$script:KitchenSink = ''
$script:ProjectName = ''
$script:ProjectSlug = ''
$script:ProjectSnake = ''
$script:Author = ''
$script:Year = ''
$script:FileCount = 0
$script:DryFiles = @()
$script:TempRoot = ''
$script:RemoteRoot = ''
# A function's return value is its whole output stream, so nothing user-facing
# can be communicated by returning it. These carry control flow instead.
$script:Code = 0
$script:Done = $false

# The ref this script was served from. A copy taken from a tag must fetch that
# tag's templates -- see docs/install.md "Pinning a version".
$script:DefaultRef = 'refs/heads/main'

$script:Utf8NoBom = New-Object System.Text.UTF8Encoding $false

function Write-Usage {
    $lines = @(
        'Usage:'
        '  bootstrap.ps1 <template-id> <target-dir> [options]'
        '  bootstrap.ps1 --list'
        '  bootstrap.ps1 --help'
        ''
        'Options:'
        '  --name <name>   Project name. Defaults to the basename of <target-dir>.'
        '  --force         Scaffold into a non-empty directory, overwriting collisions.'
        '  --no-git        Skip git init and the initial commit.'
        '  --no-build      Skip the image build and the verification test run.'
        '  --no-pull       Build the image locally instead of pulling the published one.'
        '  --dry-run       Print the files that would be written and exit 0.'
        '  --list          Print available templates and exit 0.'
        '  --help          Print this and exit 0.'
        ''
        'Exit codes:'
        '  0 success   1 usage   2 unknown template   3 target not empty'
        '  4 docker unavailable or build failed       5 generated tests failed'
        '  6 templates unavailable'
    )
    $lines | ForEach-Object { Write-Output $_ }
}

function Write-Step {
    param([string]$Label, [string]$Detail)
    Write-Output ('==> {0,-12} {1}' -f $Label, $Detail)
}

function Write-Note {
    param([string]$Message)
    [Console]::Error.WriteLine("warning: $Message")
}

# Carries the exit code out through the one catch in Invoke-Main. `exit` cannot
# do it: under [scriptblock]::Create there is no process of our own to leave, so
# exiting here would end the caller's session. See the foot of this file.
function Stop-Bootstrap {
    param([int]$Code, [string]$Message, [string[]]$Hints = @())
    $e = New-Object System.Management.Automation.ErrorRecord(
        (New-Object System.Exception $Message),
        'BootstrapFailure',
        [System.Management.Automation.ErrorCategory]::OperationStopped,
        $Code)
    $e.ErrorDetails = New-Object System.Management.Automation.ErrorDetails(
        (@($Message) + $Hints) -join "`n")
    throw $e
}

function Read-Args {
    param([string[]]$Argv)
    $positional = @()
    $i = 0
    while ($i -lt $Argv.Count) {
        $a = $Argv[$i]
        switch -CaseSensitive ($a) {
            '--help' { Write-Usage; $script:Done = $true; return }
            '-h' { Write-Usage; $script:Done = $true; return }
            '--list' { $script:OptList = $true }
            '--force' { $script:OptForce = $true }
            '--no-git' { $script:OptNoGit = $true }
            '--no-build' { $script:OptNoBuild = $true }
            '--no-pull' { $script:OptNoPull = $true }
            '--dry-run' {
                $script:OptDryRun = $true
                $script:OptNoGit = $true
                $script:OptNoBuild = $true
            }
            '--name' {
                $i++
                if ($i -ge $Argv.Count) { Stop-Bootstrap 1 '--name needs a value' @('run --help for usage') }
                $script:OptName = $Argv[$i]
            }
            '--' {
                # Everything after this is positional, whatever it looks like.
                for ($j = $i + 1; $j -lt $Argv.Count; $j++) { $positional += $Argv[$j] }
                $i = $Argv.Count
            }
            default {
                if ($a.StartsWith('--name=', [StringComparison]::Ordinal)) {
                    $script:OptName = $a.Substring(7)
                }
                elseif ($a.StartsWith('-', [StringComparison]::Ordinal)) {
                    Stop-Bootstrap 1 "unknown option '$a'" @('run --help for usage')
                }
                else {
                    $positional += $a
                }
            }
        }
        $i++
    }
    if ($positional.Count -gt 2) { Stop-Bootstrap 1 'too many arguments' @('run --help for usage') }
    if ($positional.Count -ge 1) { $script:TemplateId = $positional[0] }
    if ($positional.Count -ge 2) { $script:Target = $positional[1] }
}

# The script's own directory, or empty when it was never a file -- which is how
# remote mode announces itself. See docs/install.md.
function Get-ScriptRoot {
    if ([string]::IsNullOrEmpty($PSScriptRoot)) { return '' }
    if (-not (Test-Path -LiteralPath (Join-Path $PSScriptRoot 'templates'))) { return '' }
    return $PSScriptRoot
}

# One archive rather than per-file requests: raw HTTP cannot list a directory.
# See docs/install.md "Fetching templates".
function Expand-RemoteTemplates {
    $ref = $script:DefaultRef
    if (-not [string]::IsNullOrEmpty($env:BOOTSTRAP_REF)) { $ref = $env:BOOTSTRAP_REF }

    # The 5.1 progress bar costs an order of magnitude on Invoke-WebRequest, and
    # TLS 1.2 is not the default on older configurations. A user hitting either
    # has no way to know what went wrong.
    $ProgressPreference = 'SilentlyContinue'
    try {
        [Net.ServicePointManager]::SecurityProtocol =
        [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    }
    catch {
        Write-Note 'could not request TLS 1.2; the download may fail on this host'
    }

    $script:TempRoot = Join-Path ([IO.Path]::GetTempPath()) ("bootstrap-" + [Guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $script:TempRoot -Force | Out-Null

    $zip = Join-Path $script:TempRoot 'templates.zip'
    $url = "https://github.com/acodeninja/bootstrap/archive/$ref.zip"
    try {
        Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing
    }
    catch {
        Stop-Bootstrap 6 "could not download templates from $url" @(
            'check the network, or set BOOTSTRAP_REF to a ref that exists')
    }

    try {
        Expand-Archive -LiteralPath $zip -DestinationPath $script:TempRoot -Force
    }
    catch {
        Stop-Bootstrap 6 'could not extract the template archive' @(
            'the download may be truncated; try again')
    }

    # Expand-Archive has no --strip-components, so find the single top-level
    # directory the archive carries.
    $root = Get-ChildItem -LiteralPath $script:TempRoot -Directory |
    Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'templates') } |
    Select-Object -First 1
    if ($null -eq $root) {
        Stop-Bootstrap 6 'the archive contained no templates directory' @(
            "fetched from $url")
    }

    $count = @(Get-ChildItem -LiteralPath (Join-Path $root.FullName 'templates') -Directory).Count
    # docs/cli.md prints the ref's short name, so a default main reads as
    # `@ main` rather than `@ refs/heads/main`. A BOOTSTRAP_REF given as a bare
    # branch or a sha has no prefix to drop and shows as itself.
    $display = $ref
    foreach ($prefix in @('refs/heads/', 'refs/tags/')) {
        if ($display.StartsWith($prefix, [StringComparison]::Ordinal)) {
            $display = $display.Substring($prefix.Length)
            break
        }
    }
    Write-Step 'fetch' "acodeninja/bootstrap @ $display ($count templates)"
    $script:RemoteRoot = $root.FullName
}

function Get-ManifestValue {
    param([string]$Path, [string]$Key)
    $value = ''
    foreach ($line in [IO.File]::ReadAllLines($Path)) {
        if ($line.StartsWith("$Key=", [StringComparison]::Ordinal)) {
            $value = $line.Substring($Key.Length + 1)
            if ($value.EndsWith('"', [StringComparison]::Ordinal)) { $value = $value.Substring(0, $value.Length - 1) }
            if ($value.StartsWith('"', [StringComparison]::Ordinal)) { $value = $value.Substring(1) }
        }
    }
    return $value
}

# Ordinal sort: bash gets this from glob order under LC_ALL=C, and docs/cli.md
# requires the two --list outputs match byte for byte.
function Get-TemplateIds {
    if (-not (Test-Path -LiteralPath $script:TemplateRoot)) { return @() }
    return @(Get-ChildItem -LiteralPath $script:TemplateRoot -Directory |
        Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'template.env') } |
        ForEach-Object { $_.Name } |
        Sort-Object -Culture ([Globalization.CultureInfo]::InvariantCulture))
}

function Write-TemplateList {
    foreach ($id in Get-TemplateIds) {
        $name = Get-ManifestValue (Join-Path (Join-Path $script:TemplateRoot $id) 'template.env') 'DISPLAY_NAME'
        if ([string]::IsNullOrEmpty($name)) { $name = $id }
        Write-Output ("$id`t$name")
    }
}

function Get-Suggestion {
    param([string]$Wanted)
    $ids = Get-TemplateIds
    foreach ($id in $ids) {
        if ($id.IndexOf($Wanted, [StringComparison]::Ordinal) -ge 0) { return $id }
    }
    foreach ($id in $ids) {
        if ($Wanted.StartsWith($id, [StringComparison]::Ordinal)) { return $id }
    }
    return ''
}

function Resolve-Template {
    $script:TemplateDir = Join-Path $script:TemplateRoot $script:TemplateId
    $manifest = Join-Path $script:TemplateDir 'template.env'
    if (-not (Test-Path -LiteralPath $manifest)) {
        $count = @(Get-TemplateIds).Count
        $suggestion = Get-Suggestion $script:TemplateId
        $hints = @()
        if (-not [string]::IsNullOrEmpty($suggestion)) { $hints += "did you mean: $suggestion" }
        $hints += "run --list to see all $count templates"
        Stop-Bootstrap 2 "no template '$($script:TemplateId)'" $hints
    }
    $script:Display = Get-ManifestValue $manifest 'DISPLAY_NAME'
    if ([string]::IsNullOrEmpty($script:Display)) { $script:Display = $script:TemplateId }
    $script:KitchenSink = Get-ManifestValue $manifest 'KITCHEN_SINK'
    if ([string]::IsNullOrEmpty($script:KitchenSink)) { $script:KitchenSink = 'the kitchen sink file' }
}

# Lowercase, collapse every non-alphanumeric run to one separator, trim the
# separator from both ends. ASCII only and culture-invariant, so it agrees with
# bash's [a-z0-9] ranges under LC_ALL=C.
function Get-Slug {
    param([string]$Text, [string]$Separator)
    $sb = New-Object Text.StringBuilder
    $pending = $false
    foreach ($ch in $Text.ToCharArray()) {
        $code = [int][char]$ch
        $isLower = ($code -ge 97 -and $code -le 122)
        $isDigit = ($code -ge 48 -and $code -le 57)
        $isUpper = ($code -ge 65 -and $code -le 90)
        if ($isLower -or $isDigit -or $isUpper) {
            if ($pending -and $sb.Length -gt 0) { [void]$sb.Append($Separator) }
            if ($isUpper) { [void]$sb.Append([char]($code + 32)) } else { [void]$sb.Append($ch) }
            $pending = $false
        }
        else {
            $pending = $true
        }
    }
    $out = $sb.ToString()
    # npm rejects an empty package name, and so would most things downstream.
    if ($out.Length -eq 0) { $out = 'project' }
    if ($out.Length -gt 60) { $out = $out.Substring(0, 60) }
    return $out
}

function Resolve-ProjectNames {
    # Windows separators as well as POSIX: a basename taken by splitting on '/'
    # alone would leave C:\src\my-zig whole and the backslash strip below would
    # then fold it to csrcmy-zig.
    $base = $script:Target.TrimEnd('/', '\')
    $cut = [Math]::Max($base.LastIndexOf('/'), $base.LastIndexOf('\'))
    if ($cut -ge 0) { $base = $base.Substring($cut + 1) }

    if ($base -eq '.' -or $base -eq '..' -or $base -eq '') {
        $resolved = ''
        try { $resolved = (Resolve-Path -LiteralPath $script:Target -ErrorAction Stop).Path } catch { $resolved = '' }
        if ([string]::IsNullOrEmpty($resolved)) { $base = 'project' }
        else { $base = Split-Path -Leaf $resolved.TrimEnd('/', '\') }
    }

    if ([string]::IsNullOrEmpty($script:OptName)) { $script:ProjectName = $base }
    else { $script:ProjectName = $script:OptName }
    $script:ProjectName = $script:ProjectName.Replace('\', '').Replace('"', '')

    $script:ProjectSlug = Get-Slug $script:ProjectName '-'
    $script:ProjectSnake = Get-Slug $script:ProjectName '_'

    $script:Author = ''
    try {
        $name = & git config user.name 2>$null
        if ($LASTEXITCODE -eq 0 -and $null -ne $name) { $script:Author = [string]$name }
    }
    catch {
        $script:Author = ''
    }
    $script:Author = $script:Author.Replace("`r", '').Replace("`n", '').Replace('\', '')
    if ($script:Author.Length -eq 0) { $script:Author = 'Your Name' }

    $script:Year = (Get-Date).Year.ToString([Globalization.CultureInfo]::InvariantCulture)
}

function Test-Target {
    if (-not (Test-Path -LiteralPath $script:Target)) { return }
    if (-not (Test-Path -LiteralPath $script:Target -PathType Container)) {
        Stop-Bootstrap 3 "target '$($script:Target)' exists and is not a directory"
    }
    # -Force so a directory holding only .git counts as non-empty, matching
    # bash's dotglob.
    $entries = @(Get-ChildItem -LiteralPath $script:Target -Force)
    if ($entries.Count -eq 0) { return }
    if ($script:OptForce) { return }
    Stop-Bootstrap 3 "target '$($script:Target)' exists and is not empty" @(
        'pass --force to scaffold into it anyway')
}

function Invoke-Preflight {
    $docker = Get-Command docker -ErrorAction SilentlyContinue
    if ($null -eq $docker) {
        Stop-Bootstrap 4 'docker is not installed' @(
            'install Docker Desktop: https://docs.docker.com/desktop/install/windows-install/')
    }
    & docker info *> $null
    if ($LASTEXITCODE -ne 0) {
        Stop-Bootstrap 4 'the docker daemon is not reachable' @('start Docker Desktop and try again')
    }
    $make = Get-Command make -ErrorAction SilentlyContinue
    if ($null -eq $make) {
        Stop-Bootstrap 4 'make is not installed' @('winget install ezwinports.make')
    }

    $dockerVersion = '?'
    $v = & docker version --format '{{.Client.Version}}' 2>$null
    if ($LASTEXITCODE -eq 0 -and $null -ne $v) { $dockerVersion = ([string]$v).Trim() }

    $makeVersion = '?'
    $m = & make --version 2>$null | Select-Object -First 1
    if ($null -ne $m) {
        $parts = ([string]$m).Trim() -split ' '
        if ($parts.Count -gt 0) { $makeVersion = $parts[-1] }
    }

    Write-Step 'preflight' "docker $dockerVersion, make $makeVersion"
}

# Literal substitution with .Replace, never -replace: the latter is a regex on
# both sides, so a '$' or a backslash in an author name would be a substitution.
function Expand-Tokens {
    param([string]$Text)
    $t = $Text
    $t = $t.Replace('{{PROJECT_NAME}}', $script:ProjectName)
    $t = $t.Replace('{{PROJECT_SLUG}}', $script:ProjectSlug)
    $t = $t.Replace('{{PROJECT_SNAKE}}', $script:ProjectSnake)
    $t = $t.Replace('{{AUTHOR}}', $script:Author)
    $t = $t.Replace('{{YEAR}}', $script:Year)
    return $t
}

function Copy-TemplateTree {
    param([string]$Source, [string]$Relative, [string]$SourceRelative, [string]$Mode)
    # -Force to carry dotfiles: .gitignore, .dockerignore, .editorconfig,
    # .gitattributes and .github all have to arrive.
    foreach ($entry in Get-ChildItem -LiteralPath $Source -Force) {
        $name = Expand-Tokens $entry.Name
        if ([string]::IsNullOrEmpty($Relative)) { $dest = $name } else { $dest = "$Relative/$name" }
        if ([string]::IsNullOrEmpty($SourceRelative)) { $src = $entry.Name } else { $src = "$SourceRelative/$($entry.Name)" }
        if ($entry.PSIsContainer) {
            if ($Mode -eq 'write') {
                New-Item -ItemType Directory -Path (Join-Path $script:Target $dest) -Force | Out-Null
            }
            Copy-TemplateTree $entry.FullName $dest $src $Mode
        }
        else {
            $script:FileCount++
            if ($Mode -eq 'dry') {
                $script:DryFiles += , @($src, $dest)
            }
            else {
                # ReadAllText/WriteAllText rather than Get-Content/Set-Content:
                # 5.1's cmdlets add a BOM and rewrite line endings, which breaks
                # the eol=lf the templates ship.
                $content = Expand-Tokens ([IO.File]::ReadAllText($entry.FullName))
                [IO.File]::WriteAllText((Join-Path $script:TargetRoot $dest), $content, $script:Utf8NoBom)
            }
        }
    }
}

function Invoke-Scaffold {
    param([string]$Mode)
    $script:FileCount = 0
    $script:DryFiles = @()
    Copy-TemplateTree (Join-Path $script:TemplateDir 'files') '' '' $Mode
    if ($Mode -ne 'dry') { return }
    # Keyed on the template's own filename, not the expanded one, and compared
    # ordinally: bootstrap.sh gets this list from a glob under LC_ALL=C, so
    # src/test_{{PROJECT_SNAKE}}.py precedes src/{{PROJECT_SNAKE}}.py -- `t`
    # sorts before `{`. Sorting the expanded names reverses that pair, and a
    # culture comparison ignores case and puts compose.yaml before Dockerfile.
    $keys = [string[]]@($script:DryFiles | ForEach-Object { $_[0] })
    $paths = [string[]]@($script:DryFiles | ForEach-Object { $_[1] })
    [Array]::Sort($keys, $paths, [StringComparer]::Ordinal)
    $paths | ForEach-Object { Write-Output $_ }
}

function Initialize-Repository {
    # Nested repositories are nobody's intent, and with --force the add -A
    # below would commit the whole scaffold into the surrounding repo's history.
    $inside = ''
    try {
        $answer = & git -C $script:Target rev-parse --is-inside-work-tree 2>$null
        if ($LASTEXITCODE -eq 0 -and $null -ne $answer) { $inside = ([string]$answer).Trim() }
    }
    catch {
        $inside = ''
    }
    if ($inside -eq 'true') {
        Write-Step 'git' 'skipped (already inside a git repository)'
        return
    }

    & git -C $script:Target init -q *> $null
    if ($LASTEXITCODE -ne 0) {
        Write-Note 'git init failed; the project is scaffolded but not a repository'
        return
    }
    & git -C $script:Target symbolic-ref HEAD refs/heads/main *> $null
    & git -C $script:Target add -A *> $null
    & git -C $script:Target commit -q -m "chore: bootstrap $($script:TemplateId) project" *> $null
    if ($LASTEXITCODE -eq 0) {
        Write-Step 'git' 'initialised, 1 commit'
    }
    else {
        Write-Step 'git' 'initialised, no commit (set git user.name and user.email)'
    }
}

# Read back rather than rebuilt from the template id, so the name in the step
# line cannot drift from the one compose will actually run.
function Get-ComposeImage {
    foreach ($line in [IO.File]::ReadAllLines((Join-Path $script:TargetRoot 'compose.yaml'))) {
        $at = $line.IndexOf('image: ', [StringComparison]::Ordinal)
        if ($at -ge 0) { return $line.Substring($at + 7) }
    }
    return ''
}

# A published image turns the first run into a download instead of a toolchain
# build. Quiet and discarded: a failure here is not an error, it is the ordinary
# path when no image has been published for this template or architecture yet,
# and the Dockerfile beside it remains authoritative either way.
function Test-ImagePull {
    Push-Location -LiteralPath $script:Target
    try {
        & docker compose pull --quiet *> $null
        return ($LASTEXITCODE -eq 0)
    }
    finally {
        Pop-Location
    }
}

function Invoke-ImageBuild {
    # The analyzer reads $rateLimited as write-only: its check does not follow
    # the read into the ForEach-Object block below. The read is real, and so is
    # the write, because ForEach-Object runs its block in the caller's scope.
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSUseDeclaredVarsMoreThanAssignments', 'rateLimited')]
    param()
    $rateLimited = $false
    Push-Location -LiteralPath $script:Target
    try {
        # --progress plain keeps the stream line-oriented; reading it at all
        # costs buildkit its TTY renderer, which docs/cli.md allows for.
        & docker compose build --progress plain 2>&1 | ForEach-Object {
            $line = [string]$_
            Write-Output $line
            if ($line -match 'toomanyrequests' -or $line -match 'pull rate limit') { $rateLimited = $true }
        }
        $status = $LASTEXITCODE
    }
    finally {
        Pop-Location
    }
    if ($status -eq 0) { return }
    if ($rateLimited) {
        Stop-Bootstrap 4 "image build failed for '$($script:TemplateId)'" @(
            'the registry reported: toomanyrequests'
            'Docker Hub limits anonymous pulls. Run `docker login` and try again.')
    }
    Stop-Bootstrap 4 "image build failed for '$($script:TemplateId)'" @(
        'the build output above is the whole story')
}

# Deliberately unpiped: a failing test's own output is the most useful thing on
# the screen at that moment, and piping it would cost its TTY and its colour.
function Invoke-TestRun {
    Push-Location -LiteralPath $script:Target
    try {
        & make test
        $status = $LASTEXITCODE
    }
    finally {
        Pop-Location
    }
    if ($status -ne 0) {
        Stop-Bootstrap 5 "the generated project's test run failed" @(
            "the project is scaffolded at '$($script:Target)'; the output above says why")
    }
}

function Write-NextSteps {
    Write-Output ''
    Write-Output 'Ready. Next:'
    Write-Output "  cd $($script:Target)"
    Write-Output '  make test'
    Write-Output "  read $($script:KitchenSink) for the language, then pick a kata:"
    Write-Output '  https://learn.madetech.com/technology/katas/'
}

# docs/cli.md: running with no arguments is not a usage error, because
# `iex (irm ...)` cannot pass any and a bare iex that exited 1 would make the
# documented Windows command look broken. Prompting needs a terminal; without
# one, missing arguments are a usage error as normal.
function Read-MissingArgs {
    if ([Console]::IsInputRedirected) { return }
    if (-not [Environment]::UserInteractive) { return }
    if (-not [string]::IsNullOrEmpty($script:TemplateId) -and -not [string]::IsNullOrEmpty($script:Target)) { return }

    if ([string]::IsNullOrEmpty($script:TemplateId)) {
        Write-TemplateList
        Write-Output ''
        $answer = Read-Host 'template'
        if ($null -ne $answer) { $script:TemplateId = ([string]$answer).Trim() }
    }
    if ([string]::IsNullOrEmpty($script:Target)) {
        $answer = Read-Host 'target directory'
        if ($null -ne $answer) { $script:Target = ([string]$answer).Trim() }
    }
}

function Invoke-Main {
    param([string[]]$Argv)

    Read-Args $Argv
    if ($script:Done) { return }

    $root = Get-ScriptRoot
    if ([string]::IsNullOrEmpty($root)) {
        Expand-RemoteTemplates
        $root = $script:RemoteRoot
    }
    $script:TemplateRoot = Join-Path $root 'templates'

    if ($script:OptList) { Write-TemplateList; return }

    Read-MissingArgs

    if ([string]::IsNullOrEmpty($script:TemplateId)) {
        Stop-Bootstrap 1 'a template id is required' @('run --list to see them, --help for usage')
    }
    if ([string]::IsNullOrEmpty($script:Target)) {
        Stop-Bootstrap 1 'a target directory is required' @('run --help for usage')
    }

    Resolve-Template
    Write-Step 'template' $script:Display
    Test-Target
    Resolve-ProjectNames

    if ($script:OptDryRun) {
        Invoke-Scaffold 'dry'
        Write-Step 'dry-run' "$($script:FileCount) files -> $($script:Target)"
        return
    }

    if (-not $script:OptNoBuild) { Invoke-Preflight }

    try {
        New-Item -ItemType Directory -Path $script:Target -Force | Out-Null
        $script:TargetRoot = (Resolve-Path -LiteralPath $script:Target).ProviderPath
    }
    catch {
        Stop-Bootstrap 3 "could not create '$($script:Target)'"
    }

    Invoke-Scaffold 'write'

    # No .env here, unlike bootstrap.sh on Linux: Docker Desktop handles file
    # ownership itself and the compose defaults are never used on Windows. See
    # docs/containers.md "File ownership".
    Write-Step 'scaffold' "$($script:FileCount) files -> $($script:Target)"

    if (-not $script:OptNoGit) { Initialize-Repository }

    if (-not $script:OptNoBuild) {
        if ((-not $script:OptNoPull) -and (Test-ImagePull)) {
            Write-Step 'image' "pulled $(Get-ComposeImage)"
        }
        else {
            Invoke-ImageBuild
            Write-Step 'image' "built $(Get-ComposeImage)"
        }
        Invoke-TestRun
    }

    Write-NextSteps
}

try {
    Invoke-Main $args
}
catch {
    $record = $_
    $detail = $record.ErrorDetails
    if ($null -ne $detail) {
        $lines = @($detail.Message -split "`n")
        [Console]::Error.WriteLine("error: $($lines[0])")
        for ($k = 1; $k -lt $lines.Count; $k++) {
            [Console]::Error.WriteLine("       $($lines[$k])")
        }
    }
    else {
        [Console]::Error.WriteLine("error: $($record.Exception.Message)")
    }
    $script:Code = 1
    if ($null -ne $record.TargetObject) { $script:Code = [int]$record.TargetObject }
}
finally {
    if (-not [string]::IsNullOrEmpty($script:TempRoot) -and (Test-Path -LiteralPath $script:TempRoot)) {
        Remove-Item -LiteralPath $script:TempRoot -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# `exit` inside a scriptblock built from a string does not return from the block,
# it ends the host process -- and in remote mode that process is the user's own
# session, so the documented one-liner would close their shell on every run,
# success included. bash has no equivalent problem: `bash -c` is a child.
# A file was invoked for its exit status, so exit; a scriptblock leaves the code
# in $LASTEXITCODE, which is what a scripted caller reads. See docs/install.md.
$global:LASTEXITCODE = $script:Code
if (-not [string]::IsNullOrEmpty($PSScriptRoot)) { exit $script:Code }
