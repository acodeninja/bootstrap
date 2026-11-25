// Four imports, each naming one symbol. The last reaches the project's own
// namespace, which is this file's sibling under src/.
import Std.Convert.ResultArrayAsInt;
import Std.Diagnostics.Fact;
import Std.Measurement.MeasureEachZ;
import {{PROJECT_SNAKE}}.Encode;

// Nothing names this file. `make test` evaluates every tests/*.qs and runs what
// is marked @Test(), so a test is found by the attribute and deleting one is
// safe. Run the suite with `make test`.
//
// The name is the operation identifier -- Q# has no string anywhere to put a
// sentence in, so it is Pascal case and reads as closely to one as it can. The
// message on the Fact below is where the readable version lives.
@Test()
operation EncodeWritesTheBitsOfAnIntegerIntoARegister() : Unit {
    // `use` borrows qubits for the scope and returns them at the end of it,
    // which is the only way to get one: there is no allocation and no `new`.
    // They arrive in the zero state.
    use register = Qubit[4];

    // Arrange, act, assert -- except the act has three steps, because a qubit
    // cannot simply be read. Encode writes, MeasureEachZ collapses each qubit
    // to a classical Result, and ResetAll puts them back to zero.
    //
    // The reset is not tidiness. Qubits must be returned in the zero state, and
    // the simulator will tell you off if they are not.
    Encode(9, register);
    let bits = MeasureEachZ(register);
    ResetAll(register);

    // Fact takes a condition and a message, so the comparison is yours to
    // write -- and the message is what a failure prints, which is why it is a
    // sentence where the operation name above cannot be.
    //
    // There is no try, no catch and no Result type in this language, so a
    // function that refuses an input returns a tuple saying so. Fact raising
    // is the one exception-shaped thing here, and it is for tests.
    Fact(ResultArrayAsInt(bits) == 9, "nine reads back from the register it was written to");
}
