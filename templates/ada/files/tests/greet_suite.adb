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
--  the file stands alone and nothing else names it.
procedure Greet_Suite is

   type Fixture is new AUnit.Test_Fixtures.Test_Fixture with null record;
   package Caller is new AUnit.Test_Caller (Fixture);

   procedure Test_Greeting (T : in out Fixture) is
      pragma Unreferenced (T);
   begin
      Assert
        ({{PROJECT_SNAKE}}.Greet ("world") = "Hello, world!",
         "the greeting did not address the name");
   end Test_Greeting;

   function Suite return AUnit.Test_Suites.Access_Test_Suite is
      S : constant AUnit.Test_Suites.Access_Test_Suite :=
        AUnit.Test_Suites.New_Suite;
   begin
      S.Add_Test
        (Caller.Create
           ("a greeting addresses the name it is given", Test_Greeting'Access));
      return S;
   end Suite;

   function Run is new AUnit.Run.Test_Runner_With_Status (Suite);

   Reporter : AUnit.Reporter.Text.Text_Reporter;

begin
   if Run (Reporter) /= AUnit.Success then
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   end if;
end Greet_Suite;
