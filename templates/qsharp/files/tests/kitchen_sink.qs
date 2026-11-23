import Std.Arrays.All, Std.Arrays.Fold, Std.Arrays.IndexOf, Std.Arrays.IndexRange;
import Std.Arrays.Most, Std.Arrays.Rest, Std.Arrays.Zipped;
import Std.Convert.DoubleAsStringWithPrecision, Std.Convert.ResultArrayAsInt;
import Std.Diagnostics.CheckZero, Std.Diagnostics.Fact;
import Std.Math.PI;
import Std.Measurement.MeasureEachZ;

// collections -- the array is the only collection in the language. There is no
// map and no set, which is why a Q# solution carries its own lookup.

@Test()
function AnArrayGrowsByConcatenationAndSlicesWithARange() : Unit {
    let values = [1, 2, 3] + [4, 5];

    Fact(Length(values) == 5 and values[1..3] == [2, 3, 4], "five values, sliced three");
}

@Test()
function SearchingAnArrayOfPairsStandsInForTheMissingMap() : Unit {
    let entries = [("a", 1), ("b", 2)];

    let found = IndexOf(((key, _)) -> key == "b", entries);
    let missing = IndexOf(((key, _)) -> key == "z", entries);

    Fact(found == 1 and missing == -1, "a key that is absent answers minus one");
}

@Test()
operation MeasuringARegisterGivesOneResultForEveryQubitInIt() : Unit {
    use register = Qubit[3];

    X(register[1]);
    let outcomes = MeasureEachZ(register);
    ResetAll(register);

    Fact(outcomes == [Zero, One, Zero], "only the flipped qubit reads as one");
}

// strings -- concatenation and interpolation are the whole of the API. A string
// has no length, no index, no split and no join, so text a kata takes apart
// belongs in an array before it reaches Q#.

@Test()
function ConcatenationIsTheOnlyWayToPutTwoStringsTogether() : Unit {
    Fact("ab" + "cd" == "abcd", "the halves keep their order");
}

@Test()
function AnInterpolatedStringRendersAMeasurementOutcomeByName() : Unit {
    Fact($"outcome {One}" == "outcome One", "One renders as its own name");
}

@Test()
function ADoubleRendersWithAFixedNumberOfDecimalPlaces() : Unit {
    Fact(DoubleAsStringWithPrecision(PI(), 4) == "3.1416", "four places, rounded");
}

// types and branching -- a struct is the record. There is no enum and no sum
// type: Result and Pauli are the only closed sets of states shipped, nothing
// checks that a branch covered every case, and the ternary is how a branch
// yields a value rather than performing a statement.

struct Record {
    Count : Int,
    Label : String
}

@Test()
function AStructIsBuiltByFieldNameAndReadBackByField() : Unit {
    let record = new Record { Count = 2, Label = "ab" };

    Fact(record.Count == 2 and record.Label == "ab", "both fields survive the trip");
}

@Test()
function ACopyConstructorReplacesOneFieldAndCarriesTheRestOver() : Unit {
    let record = new Record { Count = 2, Label = "ab" };

    let bumped = new Record { ...record, Count = 3 };

    Fact(bumped.Count == 3 and bumped.Label == "ab", "the label came along unasked");
}

@Test()
operation ATernaryTurnsAMeasurementOutcomeIntoAValue() : Unit {
    use qubit = Qubit();

    X(qubit);
    let outcome = MResetZ(qubit);

    Fact((outcome == One ? 1 | 0) == 1, "a flipped qubit measures as one");
}

// iteration -- zipping a sequence against its own tail is how a kata looks
// ahead one item, because there is no index arithmetic to get it wrong.

@Test()
operation ALoopOverARegistersIndicesWritesABitPatternIntoIt() : Unit {
    use register = Qubit[4];

    for index in IndexRange(register) {
        if index % 2 == 0 {
            X(register[index]);
        }
    }
    let bits = MeasureEachZ(register);
    ResetAll(register);

    Fact(ResultArrayAsInt(bits) == 5, "bits zero and two are set, little end first");
}

@Test()
operation WalkingNeighboursShowsBothHalvesOfAnEntangledPairAgree() : Unit {
    use register = Qubit[2];

    H(register[0]);
    Controlled X([register[0]], register[1]);
    let bits = MeasureEachZ(register);
    ResetAll(register);

    Fact(
        All(((left, right)) -> left == right, Zipped(Most(bits), Rest(bits))),
        "neither outcome is predictable alone, and the two always match"
    );
}

// functions -- a function is deterministic, an operation may touch a qubit, and
// either is a value you can pass. An operation declared `is Adj` hands over the
// operation that undoes it as well, which is the half with no classical twin.

operation ApplyThenUndo(op : Qubit => Unit is Adj, target : Qubit) : Unit {
    op(target);
    Adjoint op(target);
}

@Test()
operation TheAdjointFunctorTurnsAnOperationIntoItsOwnUndo() : Unit {
    use qubit = Qubit();

    ApplyThenUndo(S, qubit);

    Fact(CheckZero(qubit), "the qubit is back where it started");
}

@Test()
function FoldingAnArrayWithALambdaReducesItToOneValue() : Unit {
    Fact(Fold((total, value) -> total + value, 0, [1, 2, 3, 4]) == 10, "four values, one total");
}

// errors -- `fail "..."` is the failure idiom and it stops the program where it
// stands. There is no try, no catch and no Result type, so nothing can assert a
// refusal after the fact: a callable that may refuse returns a flag beside its
// value, and the test reads the flag.

function Halved(value : Int) : (Bool, Int) {
    return value % 2 == 0 ? (true, value / 2) | (false, 0);
}

@Test()
function ARefusalArrivesAsAFlagBecauseNothingCatchesAFailure() : Unit {
    let (accepted, half) = Halved(7);

    Fact(not accepted and half == 0, "an odd value is refused rather than halved");
}

// gotchas -- a measurement is destructive, so the second one below is not a
// second coin flip. The other half of the same rule costs more: a qubit must be
// back in |0> before it leaves scope, or the run dies at release, and Reset is
// the only thing that puts it there.

@Test()
operation ASuperpositionMeasuredTwiceAnswersTheSameWayBothTimes() : Unit {
    use qubit = Qubit();

    H(qubit);
    let first = M(qubit);
    let second = M(qubit);
    Reset(qubit);

    Fact(first == second, "the first measurement collapsed the superposition");
}
