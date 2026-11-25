// An import, and it names one symbol out of a namespace rather than the whole
// of it. Std is the standard library; the project's own namespace is this file's
// name, which is why the test imports <project>.Encode.
//
// Comments are two slashes to end of line, and three slashes is a doc comment
// which must sit immediately before a declaration. There is no block form.
import Std.Arrays.IndexRange;

/// Writes `value` across `register` as a little-endian bit pattern.
///
/// This is the greeter this language can have. A Q# string has no length, no
/// index, no split and no join, so there is no greeting to build and nothing to
/// return it as -- writing an integer into a register is the nearest thing to
/// handing back a value made out of an argument.
///
/// `operation` rather than `function`: an operation may act on qubits and a
/// function may not, so the keyword is a promise about what the body does.
/// `Unit` is the return type, which is what a language with no void calls it.
operation Encode(value : Int, register : Qubit[]) : Unit {
    // Qubit[] is the only collection here. There is no map and no set, so a
    // kata that wants a dictionary has to carry parallel arrays.
    //
    // IndexRange gives the valid indices of an array, which is the idiom rather
    // than counting to Length(register) - 1 yourself.
    for index in IndexRange(register) {
        // >>> is the arithmetic right shift and &&& is bitwise and. Q# spells
        // the bitwise operators with three characters so that a single & is
        // never silently the wrong one.
        if ((value >>> index) &&& 1) == 1 {
            // X flips a qubit, which is the quantum equivalent of a NOT. Every
            // operation here is reversible, which is why there is no assignment
            // anywhere in this file: you apply an operation to a qubit rather
            // than storing a value in it.
            X(register[index]);
        }
    }
}
