# Settings for the PSScriptAnalyzer run docs/cli.md requires of bootstrap.ps1.
@{
    ExcludeRules = @(
        # Reports every call to an internal function that takes its arguments
        # positionally. It is aimed at published cmdlets; nothing here is one.
        'PSAvoidUsingPositionalParameters'

        # Wants Read-Args renamed Read-Arg, Expand-Tokens renamed Expand-Token.
        # Each of them does act on all of them, so the singular name would be
        # the inaccurate one.
        'PSUseSingularNouns'

        # Triggered by the Stop- verb on Stop-Bootstrap, which changes no system
        # state: it throws. -WhatIf on a function whose whole job is to abort
        # has nothing to offer.
        'PSUseShouldProcessForStateChangingFunctions'
    )
}
