# Fifteen passing assertions: the toolbox for solving a kata in PowerShell.
#
# One Describe wraps the file because Pester requires it -- an It outside a
# Describe or Context is a discovery error, so this is the one template whose
# suite has a grouping block. The names below are still written to read on
# their own rather than as a continuation of the line above.

BeforeAll {
    . "$PSScriptRoot/../src/{{PROJECT_SNAKE}}.ps1"
}

Describe 'PowerShell' {

    # collections
    # An array is fixed length, so += builds a new one every time; a hashtable
    # is the map. Both are .NET types wearing PowerShell syntax, which is why
    # the methods and the operators sit side by side throughout.

    It 'grows an array by rebuilding it, and slices with a range' {
        $values = @(1, 2, 4)
        $values += 8

        $values.Length | Should -Be 4
        $values[2] | Should -Be 4
        $values[1..2] | Should -Be @(2, 4)
    }

    It 'answers a missing hashtable key with nothing at all' {
        $counts = @{ a = 1; b = 2 }
        $counts['c'] = 3

        $counts['c'] | Should -Be 3
        $counts['z'] | Should -BeNullOrEmpty
        $counts.ContainsKey('z') | Should -BeFalse
    }

    It 'has no set type, so unique and contains do that work' {
        $items = @('red', 'blue', 'red', 'green')

        ($items | Select-Object -Unique).Count | Should -Be 3
        $items -contains 'blue' | Should -BeTrue
        'mauve' -in $items | Should -BeFalse
    }

    # strings

    It 'splits and joins with operators rather than methods' {
        $record = 'a,b,c'

        $parts = $record -split ','

        $parts.Count | Should -Be 3
        ($parts -join '-') | Should -Be 'a-b-c'
    }

    It 'replaces by regex with the operator and literally with the method' {
        $text = 'kitchen'

        $text.Length | Should -Be 7
        $text.Substring(0, 4) | Should -Be 'kitc'
        $text -replace 't.', 'T' | Should -Be 'kiThen'
        $text.Replace('t.', 'T') | Should -Be 'kitchen'
    }

    It 'interpolates an expression only inside a subexpression' {
        $name = 'ada'

        "Hello, $name!" | Should -Be 'Hello, ada!'
        "length $($name.Length)" | Should -Be 'length 3'
        ('-' * 5) | Should -Be '-----'
    }

    # types and branching
    # There are no sum types and no records of the kind a functional language
    # means. A pscustomobject is the record, an enum is a real .NET type, and
    # switch is a statement that nothing forces you to make exhaustive.

    It 'uses a pscustomobject where another language would have a record' {
        $record = [pscustomobject]@{ Name = 'ada'; Length = 3 }

        $record.Name | Should -Be 'ada'
        $record.PSObject.Properties.Name | Should -Be @('Name', 'Length')
    }

    It 'matches an enum in a switch, with default standing in for the rest' {
        $verdicts = foreach ($state in 'Locked', 'Unlocked', 'Wedged') {
            switch ($state) {
                'Locked' { 'refusing' }
                'Unlocked' { 'opening' }
                default { 'unknown' }
            }
        }

        $verdicts | Should -Be @('refusing', 'opening', 'unknown')
    }

    It 'yields a value from a branch with the ternary operator' {
        $count = 0

        ($count -eq 0 ? 'none' : 'some') | Should -Be 'none'
        ($null ?? 'fallback') | Should -Be 'fallback'
    }

    # iteration

    It 'counts with an index in a C-style for loop' {
        $total = 0

        for ($i = 0; $i -lt 4; $i++) {
            $total += $i
        }

        $total | Should -Be 6
    }

    It 'walks the index rather than the element to look ahead' {
        $values = @(3, 1, 4, 1)
        $rises = 0

        for ($i = 0; $i -lt $values.Length - 1; $i++) {
            if ($values[$i] -lt $values[$i + 1]) { $rises++ }
        }

        $rises | Should -Be 1
    }

    # functions

    It 'passes a scriptblock as a value and calls it with the call operator' {
        $twice = { param($s) "$s$s" }

        (& $twice 'ab') | Should -Be 'abab'
        (1, 2, 3 | ForEach-Object { $_ * 2 }) | Should -Be @(2, 4, 6)
    }

    It 'folds with Measure-Object rather than a reduce of its own' {
        $values = @(1, 2, 3, 4)

        ($values | Measure-Object -Sum).Sum | Should -Be 10
        ($values | Measure-Object -Maximum).Maximum | Should -Be 4
    }

    # errors
    # Two kinds of failure, and the distinction is the whole idiom. throw is
    # terminating and stops the script; Write-Error is not, and execution
    # carries on past it unless -ErrorAction Stop promotes it.

    It 'stops on a throw and carries on past a Write-Error' {
        $halve = {
            param([int] $n)
            if ($n % 2) { throw "not even: $n" }
            $n / 2
        }

        { & $halve 7 } | Should -Throw -ExpectedMessage 'not even: 7'
        (& $halve 6) | Should -Be 3

        # The line after Write-Error still runs, and its value still comes
        # back. Nothing here is caught: the error went to the error stream and
        # execution never left.
        $carried = & {
            Write-Error 'a complaint' -ErrorAction SilentlyContinue
            'reached the end'
        }

        $carried | Should -Be 'reached the end'
    }

    # gotchas
    # The hour this saves. The pipeline unrolls its output, so a filter that
    # matched exactly once hands back the element rather than a one-item array
    # -- and indexing that element gives you its first character instead of
    # itself. Wrapping the pipeline in @() is the spelling that always returns
    # an array, however many matches there were.

    It 'returns the element, not an array, when a filter matches once' {
        $matched = 'alpha', 'beta' | Where-Object { $_ -eq 'beta' }

        $matched -is [array] | Should -BeFalse
        $matched[0] | Should -Be 'b'

        $wrapped = @('alpha', 'beta' | Where-Object { $_ -eq 'beta' })

        $wrapped -is [array] | Should -BeTrue
        $wrapped[0] | Should -Be 'beta'
    }
}
