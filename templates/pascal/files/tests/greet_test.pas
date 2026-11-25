// The unit name must match the filename here too.
unit greet_test;

// Compiler directives rather than comments -- see the greeter under src/ for
// what they do and why a prose comment must not begin with a dollar sign.
{$mode objfpc}{$H+}

interface

// `uses` makes other units available. fpcunit is the framework, testregistry is
// what RegisterTest below comes from, and the third is the code under test.
uses
  fpcunit, testregistry, {{PROJECT_SNAKE}};

type
  // A test case is a class descending from TTestCase. The `published` section
  // is the discovery mechanism and the reason this works: published members get
  // runtime type information, and fpcunit reads that to find the test methods.
  // A method in a `public` section instead would compile and never run.
  TGreetTest = class(TTestCase)
  published
    // The method name is the test name -- Pascal identifiers cannot contain
    // spaces and there is no string anywhere to put a sentence in, so it is
    // Pascal case and reads as closely to one as it can.
    procedure AGreetingAddressesTheNameItIsGiven;
  end;

implementation

// The body, qualified with the class name. The declaration above and this have
// to agree.
procedure TGreetTest.AGreetingAddressesTheNameItIsGiven;
begin
  // Expected first, actual second. AssertEquals is overloaded per type, so the
  // compiler picks the string version here and would reject a comparison
  // between two different types rather than coercing them.
  AssertEquals('Hello, world!', Greet('world'));
end;

// An initialization section runs when the unit is loaded, before the program
// body. RTTI makes the methods findable; this is what tells fpcunit the class
// exists at all, so a test case without it is never looked at.
initialization
  RegisterTest(TGreetTest);

end.
