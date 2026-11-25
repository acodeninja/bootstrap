# Nothing names this file. `make test` points Pester at tests/, which takes every
# *.Tests.ps1 in it -- so a test file is found by that suffix, and deleting one
# is safe. Run the suite with `make test`.
#
# BeforeAll runs once for the file, before any test in it. The leading dot is
# dot-sourcing: it runs the script in this scope rather than its own, which is
# what leaves the function behind afterwards. Running it without the dot would
# define the function inside a scope that then ends.
#
# $PSScriptRoot is the directory of this file, so the path holds whatever
# directory the suite is run from.
BeforeAll {
    . "$PSScriptRoot/../src/{{PROJECT_SNAKE}}.ps1"
}

# Describe is required here, and it is the one place this project nests a test
# inside a block: Pester discovers tests by running the file and collecting what
# it finds, and an It outside a Describe or Context is a discovery error rather
# than a lone test.
#
# The name of each is an ordinary string, so both read as English. A failure
# prints them together, which is why this one is a noun and the It below
# continues the sentence.
Describe 'Get-Greeting' {
    It 'addresses the name it is given' {
        # One line doing three things, read left to right. The call uses a named
        # parameter -- -Name 'world' -- which is the normal way to call anything
        # in PowerShell; the pipe sends the result to the assertion; and
        # Should -Be compares it.
        #
        # Should is a Pester command rather than a method, so there are no
        # parentheses and the operator is a parameter: -Be, -Match, -Throw and
        # the rest. Actual on the left, expected on the right.
        Get-Greeting -Name 'world' | Should -Be 'Hello, world!'
    }
}
