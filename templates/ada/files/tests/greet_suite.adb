--  `with` makes a unit available; `use` additionally brings its names into scope
--  unqualified, which is why Assert below needs no prefix. The two are separate
--  on purpose, and writing `with` alone is the cautious habit.
with Ada.Command_Line;
with AUnit;              use AUnit;
with AUnit.Assertions;   use AUnit.Assertions;
with AUnit.Reporter.Text;
with AUnit.Run;
with AUnit.Test_Caller;
with AUnit.Test_Fixtures;
with AUnit.Test_Suites;
with {{PROJECT_SNAKE}};

--  A test is a whole program: fixture, procedures and suite in one body, so
--  the file stands alone and nothing else names it. That is also the discovery
--  story -- `make test` builds and runs each main under tests/, so a test file
--  is found by existing and deleting one is safe. Run them with `make test`.
procedure Greet_Suite is

   --  AUnit needs a fixture type even when there is nothing to set up, so this
   --  one is a record with no fields. Caller is a generic package instantiated
   --  for it, and instantiating a generic is how Ada does what other languages
   --  do with inheritance here.
   type Fixture is new AUnit.Test_Fixtures.Test_Fixture with null record;
   package Caller is new AUnit.Test_Caller (Fixture);

   --  The test itself. It takes the fixture whether it wants it or not, and the
   --  pragma says so -- without it, `gnatwae` makes the unused parameter a
   --  warning and `make lint` treats every warning as an error.
   procedure Test_Greeting (T : in out Fixture) is
      pragma Unreferenced (T);
   begin
      --  Assert takes a condition and the message to print when it does not
      --  hold, so the comparison is yours to write. The message is the failure
      --  report rather than the test name, so it says what went wrong.
      --
      --  `=` compares two Strings by value here, array against array. There is
      --  no pointer involved and nothing to intern.
      Assert
        ({{PROJECT_SNAKE}}.Greet ("world") = "Hello, world!",
         "the greeting did not address the name");
   end Test_Greeting;

   --  Registration is explicit: a suite is built, and a test not added to it
   --  does not run. Caller.Create pairs the readable name with the procedure,
   --  and the apostrophe in Test_Greeting'Access is Ada attribute syntax -- it
   --  takes a reference to the procedure rather than calling it.
   --
   --  This string is the test name, and it is what the report prints.
   function Suite return AUnit.Test_Suites.Access_Test_Suite is
      S : constant AUnit.Test_Suites.Access_Test_Suite :=
        AUnit.Test_Suites.New_Suite;
   begin
      S.Add_Test
        (Caller.Create
           ("a greeting addresses the name it is given", Test_Greeting'Access));
      return S;
   end Suite;

   --  Another generic instantiation, this time of the runner, bound to the
   --  suite above.
   function Run is new AUnit.Run.Test_Runner_With_Status (Suite);

   Reporter : AUnit.Reporter.Text.Text_Reporter;

--  The program body. AUnit reports failures and still exits zero, so the exit
--  status has to be set by hand -- without these three lines a failing suite
--  would print its failures and the build would go green.
begin
   if Run (Reporter) /= AUnit.Success then
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   end if;
end Greet_Suite;
