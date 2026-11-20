unit greet_test;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry, {{PROJECT_SNAKE}};

type
  TGreetTest = class(TTestCase)
  published
    procedure AGreetingAddressesTheNameItIsGiven;
  end;

implementation

procedure TGreetTest.AGreetingAddressesTheNameItIsGiven;
begin
  AssertEquals('Hello, world!', Greet('world'));
end;

initialization
  RegisterTest(TGreetTest);

end.
