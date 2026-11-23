' Fifteen passing assertions: the toolbox for solving a kata in Visual Basic.

Imports System.Collections.Generic
Imports System.Linq
Imports Xunit

Namespace KitchenSink

    Public Class KitchenSink

        ' collections
        ' The .NET collections, reached through VB's own declaration syntax --
        ' which is where the surprises are. An array is declared by its upper
        ' bound rather than its length, and ReDim is the only way to resize one.

        <Fact>
        Public Sub AnArrayIsDeclaredByItsUpperBoundNotItsLength()
            Dim sized(5) As Integer
            Dim values() As Integer = {1, 2, 4}

            Assert.Equal(6, sized.Length)
            Assert.Equal(3, values.Length)
            Assert.Equal(4, values(2))
        End Sub

        <Fact>
        Public Sub ADictionaryAnswersAMissingKeyOnlyIfYouAsk()
            Dim counts As New Dictionary(Of String, Integer) From {{"a", 1}, {"b", 2}}
            counts("c") = 3

            Assert.Equal(3, counts("c"))
            Assert.False(counts.ContainsKey("z"))
            Assert.Throws(Of KeyNotFoundException)(Function() counts("z"))
        End Sub

        <Fact>
        Public Sub AListGrowsAndAHashSetDeduplicates()
            Dim items As New List(Of String) From {"red", "blue", "red"}
            items.Add("green")

            Assert.Equal(4, items.Count)
            Assert.Equal(3, New HashSet(Of String)(items).Count)
            Assert.Contains("blue", items)
        End Sub

        ' strings

        <Fact>
        Public Sub SplitAndJoinAreTheMatchedPair()
            Dim record = "a,b,c"

            Dim parts = record.Split(","c)

            Assert.Equal(3, parts.Length)
            Assert.Equal("a-b-c", String.Join("-", parts))
        End Sub

        <Fact>
        Public Sub SubstringCountsFromZeroAndMidCountsFromOne()
            Dim text = "kitchen"

            Assert.Equal(7, text.Length)
            Assert.Equal("kitc", text.Substring(0, 4))
            Assert.Equal("kitc", Mid(text, 1, 4))
        End Sub

        <Fact>
        Public Sub InterpolationAndPaddingBothAvoidConcatenation()
            Dim name = "ada"

            Assert.Equal("Hello, ada!", $"Hello, {name}!")
            Assert.Equal("-----", New String("-"c, 5))
            Assert.Equal("  ada", name.PadLeft(5))
        End Sub

        ' types and branching
        ' A Structure is a value type and a Class is a reference type, which is
        ' the whole of the distinction. An Enum is a real type rather than a
        ' string, so Select Case over one is checked at compile time.

        <Fact>
        Public Sub AStructureIsCopiedWhereAClassIsShared()
            Dim first = New Measurement With {.Name = "ada", .Length = 3}
            Dim second = first
            second.Length = 9

            Assert.Equal(3, first.Length)
            Assert.Equal(9, second.Length)
        End Sub

        <Fact>
        Public Sub SelectCaseOverAnEnumYieldsAValuePerState()
            Dim verdicts = New List(Of String)

            For Each state In {Gate.Locked, Gate.Unlocked, Gate.Wedged}
                Select Case state
                    Case Gate.Locked
                        verdicts.Add("refusing")
                    Case Gate.Unlocked
                        verdicts.Add("opening")
                    Case Else
                        verdicts.Add("unknown")
                End Select
            Next

            Assert.Equal({"refusing", "opening", "unknown"}, verdicts)
        End Sub

        <Fact>
        Public Sub IfIsAlsoAFunctionThatYieldsAValue()
            Dim count = 0

            Assert.Equal("none", If(count = 0, "none", "some"))
            Assert.Equal("fallback", If(Nothing, "fallback"))
        End Sub

        ' iteration

        <Fact>
        Public Sub ForCountsUpToAndIncludingItsUpperBound()
            Dim total = 0

            For i = 0 To 3
                total += i
            Next

            Assert.Equal(6, total)
        End Sub

        <Fact>
        Public Sub LookaheadWalksTheIndexRatherThanTheElement()
            Dim values = {3, 1, 4, 1}
            Dim rises = 0

            For i = 0 To values.Length - 2
                If values(i) < values(i + 1) Then rises += 1
            Next

            Assert.Equal(1, rises)
        End Sub

        ' functions

        <Fact>
        Public Sub ALambdaIsAValueAndFuncIsItsType()
            Dim twice As Func(Of String, String) = Function(s) s & s
            Dim scale As Func(Of Integer, Integer) = Function(n) n * 2

            Assert.Equal("abab", twice("ab"))
            Assert.Equal({2, 4, 6}, {1, 2, 3}.Select(scale).ToArray())
        End Sub

        <Fact>
        Public Sub AggregateIsTheFold()
            Dim values = {1, 2, 3, 4}

            Assert.Equal(10, values.Aggregate(Function(acc, n) acc + n))
            Assert.Equal(24, values.Aggregate(1, Function(acc, n) acc * n))
        End Sub

        ' errors
        ' Failure is a thrown exception. Throw raises one, a Catch ... When
        ' clause filters without unwinding, and Assert.Throws is how a test
        ' demands one and gets the object back to inspect.

        <Fact>
        Public Sub ARefusalIsAThrownExceptionATestCanDemand()
            Dim halve =
                Function(n As Integer) As Integer
                    If n Mod 2 <> 0 Then
                        Throw New ArgumentException($"not even: {n}", NameOf(n))
                    End If
                    Return n \ 2
                End Function

            Dim thrown = Assert.Throws(Of ArgumentException)(Function() halve(7))

            Assert.StartsWith("not even: 7", thrown.Message)
            Assert.Equal(3, halve(6))
        End Sub

        ' gotchas
        ' The hour this saves. And and Or evaluate both sides, always -- they
        ' are bitwise operators that happen to accept Booleans, not the
        ' short-circuiting ones. So a guard written with And runs the thing it
        ' was guarding against. AndAlso and OrElse are the ones that stop.

        <Fact>
        Public Sub AndEvaluatesBothSidesAndAndAlsoDoesNot()
            Dim calls = 0

            Dim touch =
                Function(result As Boolean) As Boolean
                    calls += 1
                    Return result
                End Function

            Dim ignored = False And touch(True)
            Assert.Equal(1, calls)

            ignored = False AndAlso touch(True)
            Assert.Equal(1, calls)
        End Sub

    End Class

    Public Enum Gate
        Locked
        Unlocked
        Wedged
    End Enum

    Public Structure Measurement
        Public Name As String
        Public Length As Integer
    End Structure

End Namespace
