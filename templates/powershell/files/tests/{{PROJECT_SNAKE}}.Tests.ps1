BeforeAll {
    . "$PSScriptRoot/../src/{{PROJECT_SNAKE}}.ps1"
}

Describe 'Get-Greeting' {
    It 'addresses the name it is given' {
        Get-Greeting -Name 'world' | Should -Be 'Hello, world!'
    }
}
