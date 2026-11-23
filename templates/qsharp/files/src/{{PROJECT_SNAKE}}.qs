import Std.Arrays.IndexRange;

/// Writes `value` across `register` as a little-endian bit pattern.
operation Encode(value : Int, register : Qubit[]) : Unit {
    for index in IndexRange(register) {
        if ((value >>> index) &&& 1) == 1 {
            X(register[index]);
        }
    }
}
