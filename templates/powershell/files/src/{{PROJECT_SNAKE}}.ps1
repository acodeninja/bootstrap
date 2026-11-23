# Functions for {{PROJECT_NAME}}. A test file reaches these by dot-sourcing the file,
# which runs it in the caller's scope and leaves the functions behind -- the
# whole of a module system for a project this size.

function Get-Greeting {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Name
    )

    "Hello, $Name!"
}
