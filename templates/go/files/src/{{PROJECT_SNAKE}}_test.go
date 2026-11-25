// The same package as the code under test, so the test can reach unexported
// names too. Appending _test to the package name instead would make this an
// external test package, which sees only what a real caller sees.
package greet

import "testing"

// Nothing names this file. `go test ./...` finds every file ending in _test.go
// and runs every function in them whose name starts with Test and which takes a
// *testing.T -- so a test is found by being named, and deleting one is safe.
//
// The function name is the test name: Go identifiers cannot contain spaces and
// there is no annotation to carry a sentence, so it is camel case and reads as
// closely to one as it can.
func TestGreetAddressesTheNameItIsGiven(t *testing.T) {
	// Arrange, act, assert, separated by blank lines. Every test in this
	// project has those three parts in that order.
	name := "world"

	greeting := Greet(name)

	// There is no assertion library, by design, and nothing in the standard
	// one. A test fails because you compared the values yourself and called
	// t.Errorf, which records the failure and carries on; t.Fatalf would stop
	// this test there.
	//
	// The message is the whole error report, so it says what was called, what
	// came back and what was wanted. %q quotes the string, which is how you
	// see a trailing space or an empty value rather than guessing at it.
	if greeting != "Hello, world!" {
		t.Errorf("Greet(%q) = %q, want %q", name, greeting, "Hello, world!")
	}
}
