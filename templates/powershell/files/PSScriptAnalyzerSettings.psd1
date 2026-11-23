@{
    # Everything, then the exceptions below, so a rule added upstream arrives
    # enabled rather than silently missing.
    IncludeDefaultRules = $true

    ExcludeRules = @(
        # Pester's own vocabulary. A test file is a script of bare Describe and
        # It calls, and this rule reads every assignment inside one as a
        # variable nobody went on to use.
        'PSUseDeclaredVarsMoreThanAssignments'
    )

    # PSAlignAssignmentStatement is deliberately absent, and the two rules
    # below are why: it pads the left of an `=` so a block of assignments
    # lines up, and CheckOperator then rejects the padding as more than one
    # space around an operator. Invoke-Formatter applies the alignment, so
    # enabling both makes `make fmt` produce a file `make lint` refuses.
    Rules = @{
        PSUseConsistentIndentation = @{
            Enable = $true
            Kind = 'space'
            IndentationSize = 4
        }

        PSUseConsistentWhitespace = @{
            Enable = $true
            CheckOperator = $true
            CheckSeparator = $true
        }
    }
}
