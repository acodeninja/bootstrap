package greet

import "testing"

func TestGreetAddressesTheNameItIsGiven(t *testing.T) {
	name := "world"

	greeting := Greet(name)

	if greeting != "Hello, world!" {
		t.Errorf("Greet(%q) = %q, want %q", name, greeting, "Hello, world!")
	}
}
