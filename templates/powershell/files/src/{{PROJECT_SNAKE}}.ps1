# Functions for {{PROJECT_NAME}}. A test file reaches these by dot-sourcing the file,
# which runs it in the caller's scope and leaves the functions behind -- the
# whole of a module system for a project this size.

# The name is Verb-Noun, and that is a real convention rather than a style
# preference: PowerShell has an approved verb list, and PSScriptAnalyzer -- which
# `make lint` runs with every default rule on -- will tell you about a function
# named anything else. Get- is for something that reads and returns.
function Get-Greeting {
    # CmdletBinding turns this from a function into something that behaves like a
    # compiled cmdlet: it gets -Verbose, -ErrorAction and the rest for free, and
    # its parameters are bound and validated rather than read positionally.
    [CmdletBinding()]
    # What the function emits. Nothing enforces it at run time; it is for the
    # reader and for tab completion.
    [OutputType([string])]
    # Parameters are declared in a param block rather than after the name. Each
    # one is a type and a variable, with attributes above it -- Mandatory here,
    # so calling this with no -Name prompts rather than passing $null.
    param(
        [Parameter(Mandatory)]
        [string] $Name
    )

    # No `return`. Every value an expression produces goes to the output
    # pipeline, and a function returns all of them -- which is the single
    # biggest surprise in the language: a stray expression anywhere in the body
    # becomes part of the result. `return` exists and only sets where to stop.
    #
    # Double quotes interpolate and single quotes do not. $Name interpolates a
    # variable and $($expression) is the form for anything more.
    "Hello, $Name!"
}
