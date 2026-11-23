import Std.Convert.ResultArrayAsInt;
import Std.Diagnostics.Fact;
import Std.Measurement.MeasureEachZ;
import {{PROJECT_SNAKE}}.Encode;

@Test()
operation EncodeWritesTheBitsOfAnIntegerIntoARegister() : Unit {
    use register = Qubit[4];

    Encode(9, register);
    let bits = MeasureEachZ(register);
    ResetAll(register);

    Fact(ResultArrayAsInt(bits) == 9, "nine reads back from the register it was written to");
}
