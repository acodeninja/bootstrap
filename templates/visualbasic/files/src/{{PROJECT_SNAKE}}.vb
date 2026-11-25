' Visual Basic has no block comment. Every line of this needs its own
' apostrophe, and a line continued with an underscore cannot carry one at all --
' which is worth knowing before you try to explain anything long.
'
' The namespace is not the filename: this file is named after the project, and
' Greeting is what callers write. Nothing lists the file anywhere; the SDK
' compiles every .vb it finds.
Namespace Greeting

    ' A Module is how Visual Basic spells a container of functions: no instance
    ' to make, and members reached as Greeter.Greet. A Class would need one.
    ' `Public` is what makes it visible outside this assembly; the default is
    ' Friend, which is assembly-only.
    Public Module Greeter

        ' A Function returns a value and a Sub does not -- two keywords where
        ' most languages have one, and the compiler will not let you return from
        ' a Sub. The parameter type comes after `As`, and so does the return
        ' type, at the end of the line.
        '
        ' $"..." is an interpolated string, the same syntax as C#. Without the
        ' leading $ the braces are literal characters.
        Public Function Greet(name As String) As String
            Return $"Hello, {name}!"
        End Function

    End Module

End Namespace
