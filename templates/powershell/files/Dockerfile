# syntax=docker/dockerfile:1
FROM debian:trixie-20261104-slim AS toolchain

# Microsoft publishes a powershell image and this does not use it, because it
# has no arm64: the Debian tags stop at bookworm, and `7.5-debian-12` answers
# with a single-arch manifest rather than a list. The arm64 images are Azure
# Linux only. The release tarballs do cover both, so the toolchain comes from
# there -- the debian base is multi-arch and each tarball is not, so the
# architecture buildkit is targeting chooses both the download and its checksum.
ARG TARGETARCH
ARG PWSH_VERSION=7.7.0

# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl \
    && rm -rf /var/lib/apt/lists/* \
    && case "$TARGETARCH" in \
         amd64) pwsh_arch=x64; pwsh_sha=c89d9c682d2c403dfe726f3df948e359675235a5bd6fab535776de69729ca0cb ;; \
         arm64) pwsh_arch=arm64; pwsh_sha=e59c89776eaa59790d44b3edd14277435225ab08b6e7603763101b89de83d935 ;; \
         *) echo "no powershell release tarball for architecture: $TARGETARCH" >&2; exit 1 ;; \
       esac \
    && curl -fsSL -o /tmp/pwsh.tar.gz \
         "https://github.com/PowerShell/PowerShell/releases/download/v${PWSH_VERSION}/powershell-${PWSH_VERSION}-linux-${pwsh_arch}.tar.gz" \
    && printf '%s  /tmp/pwsh.tar.gz\n' "$pwsh_sha" > /tmp/pwsh.sha256 \
    && sha256sum -c /tmp/pwsh.sha256 \
    && mkdir -p /opt/microsoft/powershell/7 \
    && tar -xzf /tmp/pwsh.tar.gz -C /opt/microsoft/powershell/7 \
    && chmod +x /opt/microsoft/powershell/7/pwsh \
    && rm /tmp/pwsh.tar.gz /tmp/pwsh.sha256

FROM debian:trixie-20261104-slim

COPY --from=toolchain /opt/microsoft/powershell/7 /opt/microsoft/powershell/7

# PowerShell links against ICU and OpenSSL and will not start without them.
# Setting DOTNET_SYSTEM_GLOBALIZATION_INVARIANT instead would start it, and
# then quietly change how every string comparison and ToUpper behaves -- which
# the suite asserts on, so the libraries are the answer rather than the flag.
#
# The datestamped base tag already fixes the package set; an apt version pin on
# top of it only breaks the build when Debian rotates its snapshots.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
         ca-certificates \
         libicu76 \
         libssl3t64 \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s /opt/microsoft/powershell/7/pwsh /usr/local/bin/pwsh

# Pester and PSScriptAnalyzer are modules rather than packages, and AllUsers
# puts them under /usr/local/share/powershell -- in the image, where the pin
# belongs, rather than in the /cache volume where a later run could change them.
# PSGallery is untrusted by default and Install-Module prompts for it, which
# would hang a build that has no console.
ARG PESTER_VERSION=6.2.0
ARG PSSA_VERSION=1.25.0
RUN pwsh -NoLogo -NoProfile -Command " \
      Set-PSRepository -Name PSGallery -InstallationPolicy Trusted; \
      Install-Module -Name Pester -RequiredVersion '${PESTER_VERSION}' -Scope AllUsers -Force; \
      Install-Module -Name PSScriptAnalyzer -RequiredVersion '${PSSA_VERSION}' -Scope AllUsers -Force"

# Two drivers, each a shell wrapper around a script in /usr/local/lib. A
# shebang line passes everything after the interpreter as a single argument on
# Linux, so `#!/usr/local/bin/pwsh -NoLogo -NoProfile -File` would hand pwsh
# one option named "-NoLogo -NoProfile -File" and fail. The wrapper is how the
# flags survive.
#
# Pester's own -CI switch is what this would otherwise be, and it is the wrong
# tool twice over: it writes testResults.xml into the bind mount, which is a
# tree CI asserts stays clean, and building that report shells out to `id` for
# the user's name -- which has no passwd entry at this uid, so every green run
# ends with an error on stderr. Run.Exit on its own is the part that was wanted.
COPY <<'PWSH' /usr/local/lib/pwsh-test.ps1
# Pester raises "No test files were found" rather than reporting an empty run,
# so the suite has to be deletable by this check rather than by Pester.
$found = Get-ChildItem -Path 'src', 'tests' -Filter '*.Tests.ps1' -Recurse -ErrorAction SilentlyContinue

if (-not $found) {
    Write-Output 'no tests found under src/ or tests/'
    exit 0
}

$config = New-PesterConfiguration
$config.Run.Path = @('src', 'tests')
$config.Run.Exit = $true
$config.TestResult.Enabled = $false
$config.Output.Verbosity = 'Detailed'

Invoke-Pester -Configuration $config
PWSH

COPY --chmod=0755 <<'SH' /usr/local/bin/pwsh-test
#!/bin/sh
set -eu
exec pwsh -NoLogo -NoProfile -File /usr/local/lib/pwsh-test.ps1
SH

# Invoke-Formatter returns the formatted text rather than writing it, so there
# is no --fix to call and `make fmt` needs this. WriteAllText is given the exact
# bytes the formatter returned, so a file that was already formatted comes back
# byte-identical and `make fmt` is idempotent.
COPY <<'PWSH' /usr/local/lib/pwsh-fmt.ps1
# The whole project, not just src/ and tests/: `make lint` checks every file it
# can find, including the settings file below, and a formatter that covered
# less would leave lint complaining about something fmt refused to fix.
$settings = Join-Path $PWD 'PSScriptAnalyzerSettings.psd1'
$files = Get-ChildItem -Path . -Include '*.ps1', '*.psd1', '*.psm1' -Recurse -ErrorAction SilentlyContinue

if (-not $files) {
    Write-Output 'no PowerShell files found'
    exit 0
}

foreach ($file in $files) {
    $before = Get-Content -Path $file.FullName -Raw
    $after = Invoke-Formatter -ScriptDefinition $before -Settings $settings

    if ($before -ne $after) {
        [System.IO.File]::WriteAllText($file.FullName, $after)
        Write-Output "formatted $($file.FullName)"
    }
}
PWSH

COPY --chmod=0755 <<'SH' /usr/local/bin/pwsh-fmt
#!/bin/sh
set -eu
exec pwsh -NoLogo -NoProfile -File /usr/local/lib/pwsh-fmt.ps1
SH

ENV HOME=/cache/home

# Empty and world-writable so the first run creates its files as whoever is
# calling. See docs/containers.md "File ownership".
RUN mkdir -p /cache/home && chmod -R 777 /cache

WORKDIR /work
