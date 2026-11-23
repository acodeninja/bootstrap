"Fifteen passing tests: the toolbox for solving a kata in Smalltalk."

Object subclass: Tally [
    | count |

    count [ ^ count ]

    count: anInteger [ count := anInteger ]
]

Error subclass: InvalidInput [
    <comment: 'Signalled by the errors section below.'>
]

TestCase subclass: KitchenSink [

    "collections"

    testAnOrderedCollectionGrowsAtEitherEndAndIsIndexedFromOne [
        | items |
        items := OrderedCollection new.
        items add: 'b'.
        items add: 'c'.

        items addFirst: 'a'.

        self assert: items asArray = #('a' 'b' 'c').
        self assert: items size = 3.
        self assert: (items at: 1) = 'a'
    ]

    testADictionaryNeedsIfAbsentToAnswerForAKeyItDoesNotHold [
        | counts |
        counts := Dictionary new.

        counts at: 'a' put: 2.

        self assert: (counts at: 'a') = 2.
        self assert: (counts at: 'z' ifAbsent: [0]) = 0.
        self deny: (counts includesKey: 'z')
    ]

    testASetKeepsOneOfEachAndAnswersMembershipDirectly [
        | letters |
        letters := Set withAll: #('a' 'b' 'a').

        self assert: letters size = 2.
        self assert: (letters includes: 'a').
        self deny: (letters includes: 'z')
    ]

    "strings"

    testSubstringsSplitsOnASeparatorAndFoldPutsThePiecesBack [
        | words |
        words := 'one two three' substrings: ' '.

        self assert: words size = 3.
        self assert: words first = 'one'.
        self assert: (words fold: [:left :right | left, '-', right]) = 'one-two-three'
    ]

    testAStringIsAnIndexedCollectionOfCharactersNumberedFromOne [
        | text |
        text := 'abcdef'.

        self assert: (text at: 1) = $a.
        self assert: (text copyFrom: 1 to: 3) = 'abc'.
        self assert: (text last: 2) = 'ef'
    ]

    testCommaJoinsTextAndBindWithFillsNumberedSlotsInIt [
        | label |
        label := 'world'.

        self assert: ('Hello, ', label, '!') = 'Hello, world!'.
        self assert: ('%1 x%2' bindWith: label with: 2) = 'world x2'.
        self assert: '  padded  ' trimSeparators = 'padded'
    ]

    "types and branching"

    testAnObjectSubclassHoldsItsStateInInstanceVariables [
        | record other |
        record := Tally new.
        record count: 2.

        other := record copy.
        other count: 3.

        self assert: record count = 2.
        self assert: other count = 3.
        self assert: (other isKindOf: Tally)
    ]

    testABranchIsAMessageToABooleanAndItAnswersAValue [
        | size |
        size := 3.

        self assert: (size > 2 ifTrue: ['big'] ifFalse: ['small']) = 'big'.
        self assert: (size even ifTrue: ['even'] ifFalse: ['odd']) = 'odd'.
        self assert: (nil ifNil: ['missing']) = 'missing'
    ]

    testAFixedSetOfStatesIsSymbolsAndNothingChecksYouCoveredThem [
        | transitions |
        transitions := Dictionary new.
        transitions at: #locked put: #open.
        transitions at: #open put: #locked.

        self assert: (transitions at: #locked) == #open.
        self assert: (transitions at: #open) == #locked.
        self assert: (transitions at: #broken ifAbsent: [#unknown]) == #unknown
    ]

    "iteration"

    testKeysAndValuesDoReadsThePositionAndTheItemInOnePass [
        | items labelled |
        items := #('a' 'b').
        labelled := OrderedCollection new.

        items keysAndValuesDo: [:index :item |
            labelled add: index printString, ':', item].

        self assert: labelled asArray = #('1:a' '2:b').
        self assert: (items indexOf: 'b') = 2
    ]

    testWalkingASequenceWithLookaheadStopsOneShortOfTheEnd [
        | values pairs |
        values := #(1 2 3 4).
        pairs := OrderedCollection new.

        1 to: values size - 1 do: [:index |
            pairs add: (Array with: (values at: index) with: (values at: index + 1))].

        self assert: pairs size = 3.
        self assert: pairs first = #(1 2).
        self assert: (pairs collect: [:pair | pair first + pair last]) asArray = #(3 5 7)
    ]

    "functions"

    testABlockIsAnObjectAndValueIsTheMessageThatRunsIt [
        | twice |
        twice := [:each | each * 2].

        self assert: (twice value: 3) = 6.
        self assert: (#(1 2 3) collect: [:each | twice value: each]) asArray = #(2 4 6).
        self assert: (#(1 2 3) select: [:each | each > 1]) asArray = #(2 3)
    ]

    testInjectIntoFoldsACollectionDownToOneValue [
        | values |
        values := #(1 2 3 4).

        self assert: (values inject: 0 into: [:running :each | running + each]) = 10.
        self assert: (values inject: '' into: [:running :each | running, each printString]) = '1234'
    ]

    "errors"

    testAnInputThatCannotBeReadSignalsRatherThanGuessing [
        | parse |
        parse := [:input |
            (input allSatisfy: [:each | each isDigit])
                ifTrue: [input asNumber]
                ifFalse: [InvalidInput new signal: 'not a number: ', input]].

        self assert: (parse value: '40') = 40.
        self should: [parse value: 'half'] raise: InvalidInput.
        self assert: ([parse value: 'half']
            on: InvalidInput
            do: [:signal | signal messageText]) = 'not a number: half'
    ]

    "gotchas"

    testAddAnswersTheItemItWasGivenAndNotTheCollection [
        | items added |
        items := OrderedCollection new.

        added := items add: 'a'.

        self assert: added = 'a'.
        self deny: added == items.
        self assert: (items add: 'b'; yourself) asArray = #('a' 'b')
    ]
]
