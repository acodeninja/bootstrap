--  Fifteen passing assertions: the toolbox for solving a kata in Ada.

with Ada.Command_Line;
with Ada.Containers.Indefinite_Ordered_Maps;
with Ada.Containers.Ordered_Sets;
with Ada.Strings.Fixed;
with AUnit;              use AUnit;
with AUnit.Assertions;   use AUnit.Assertions;
with AUnit.Reporter.Text;
with AUnit.Run;
with AUnit.Test_Caller;
with AUnit.Test_Fixtures;
with AUnit.Test_Suites;

procedure Kitchen_Sink is

   type Fixture is new AUnit.Test_Fixtures.Test_Fixture with null record;
   package Caller is new AUnit.Test_Caller (Fixture);

   package Counts is new Ada.Containers.Indefinite_Ordered_Maps
     (Key_Type => String, Element_Type => Integer);

   package Letters is new Ada.Containers.Ordered_Sets
     (Element_Type => Character);

   type Point is record
      X : Integer;
      Y : Integer;
   end record;

   type State is (Locked, Unlocked);

   type Mapper is access function (Value : Integer) return Integer;

   Values : constant array (1 .. 4) of Integer := (1, 2, 4, 8);

   Refused : exception;

   function Doubled (Value : Integer) return Integer is
   begin
      return Value * 2;
   end Doubled;

   function Apply_To (Transform : Mapper; Value : Integer) return Integer is
   begin
      return Transform (Value);
   end Apply_To;

   function Parse_Positive (Text : String) return Integer is
   begin
      for Letter of Text loop
         if Letter not in '0' .. '9' then
            raise Refused with "not a number: " & Text;
         end if;
      end loop;
      return Integer'Value (Text);
   end Parse_Positive;

   --  collections

   procedure Test_Array_Order (T : in out Fixture) is
      pragma Unreferenced (T);
      Items : constant array (1 .. 3) of Character := ('a', 'b', 'c');
   begin
      Assert (Items'Length = 3, "wrong length");
      Assert (Items (2) = 'b', "wrong element");
      Assert (Items'First = 1 and Items'Last = 3, "wrong bounds");
   end Test_Array_Order;

   --  A map asked for a key it does not hold raises rather than answering, so
   --  Contains is how you look before you leap.
   procedure Test_Map_Miss (T : in out Fixture) is
      pragma Unreferenced (T);
      Seen : Counts.Map;
   begin
      Seen.Insert ("a", 2);

      Assert (Seen.Element ("a") = 2, "wrong element");
      Assert (not Seen.Contains ("z"), "found a key that was never inserted");
      Assert (Natural (Seen.Length) = 1, "wrong length");
   end Test_Map_Miss;

   procedure Test_Set_Duplicates (T : in out Fixture) is
      pragma Unreferenced (T);
      Seen : Letters.Set;
   begin
      Seen.Include ('a');
      Seen.Include ('b');
      Seen.Include ('a');

      Assert (Natural (Seen.Length) = 2, "a duplicate was kept");
      Assert (Seen.Contains ('b'), "lost a member");
      Assert (not Seen.Contains ('z'), "found a member that was never added");
   end Test_Set_Duplicates;

   --  strings

   procedure Test_Split (T : in out Fixture) is
      pragma Unreferenced (T);
      Text : constant String := "one two three";
      At_Space : constant Natural := Ada.Strings.Fixed.Index (Text, " ");
   begin
      Assert (At_Space = 4, "wrong position");
      Assert (Text (Text'First .. At_Space - 1) = "one", "wrong first word");
      Assert (Text (At_Space + 1 .. Text'Last) = "two three", "wrong rest");
   end Test_Split;

   procedure Test_Slice (T : in out Fixture) is
      pragma Unreferenced (T);
      Text : constant String := "abcdef";
   begin
      Assert (Text (1 .. 1) = "a", "wrong first character");
      Assert (Text (1 .. 3) = "abc", "wrong slice");
      Assert (Text (Text'Last - 1 .. Text'Last) = "ef", "wrong last slice");
   end Test_Slice;

   --  Every one of these is a String constant first, because with more than
   --  one "=" in scope the compiler calls the comparison ambiguous.
   procedure Test_Building_Text (T : in out Fixture) is
      pragma Unreferenced (T);
      Joined   : constant String := "one" & "-" & "two";
      Repeated : constant String := Ada.Strings.Fixed."*" (3, "ab");
      Trimmed  : constant String :=
        Ada.Strings.Fixed.Trim ("  padded  ", Ada.Strings.Both);
   begin
      Assert (Joined = "one-two", "concatenation is wrong");
      Assert (Repeated = "ababab", "repetition is wrong");
      Assert (Trimmed = "padded", "trim failed");
   end Test_Building_Text;

   --  types and branching

   procedure Test_Record_Copies (T : in out Fixture) is
      pragma Unreferenced (T);
      Origin : constant Point := (X => 1, Y => 2);
      Moved  : Point := Origin;
   begin
      Moved.X := 5;

      Assert (Moved.X = 5, "the copy was not written to");
      Assert (Origin.X = 1, "the original was written to as well");
      Assert (Moved.Y = Origin.Y, "the rest of the copy is wrong");
   end Test_Record_Copies;

   procedure Test_Enumeration (T : in out Fixture) is
      pragma Unreferenced (T);
   begin
      Assert (State'First = Locked, "wrong first value");
      Assert (State'Last = Unlocked, "wrong last value");
      Assert (State'Image (Unlocked) = "UNLOCKED", "wrong image");
   end Test_Enumeration;

   --  A case statement has to cover every value of the type, and needs no
   --  others when it already does. An if expression yields a value instead.
   procedure Test_Branching (T : in out Fixture) is
      pragma Unreferenced (T);
      Current   : constant State := Unlocked;
      Described : constant String :=
        (if Current = Locked then "shut" else "open");
      Outcome   : String (1 .. 4);
   begin
      case Current is
         when Locked   => Outcome := "shut";
         when Unlocked => Outcome := "open";
      end case;

      Assert (Outcome = "open", "the case assigned the wrong arm");
      Assert (Described = "open", "the if expression produced the wrong value");
   end Test_Branching;

   --  iteration

   procedure Test_Loop_Index (T : in out Fixture) is
      pragma Unreferenced (T);
      Weighted : Integer := 0;
   begin
      for At_Index in Values'Range loop
         Weighted := Weighted + At_Index * Values (At_Index);
      end loop;

      Assert (Weighted = 49, "wrong weighted total");
      Assert (Values'First = 1, "the range did not start at one");
   end Test_Loop_Index;

   procedure Test_Lookahead (T : in out Fixture) is
      pragma Unreferenced (T);
      Widest : Integer := 0;
   begin
      for At_Index in Values'First .. Values'Last - 1 loop
         Widest := Integer'Max (Widest, Values (At_Index + 1) - Values (At_Index));
      end loop;

      Assert (Widest = 4, "wrong widest gap");
   end Test_Lookahead;

   --  functions

   procedure Test_Function_Argument (T : in out Fixture) is
      pragma Unreferenced (T);
   begin
      Assert (Apply_To (Doubled'Access, 4) = 8, "the function was not applied");
      Assert (Doubled (3) = 6, "the function itself is wrong");
   end Test_Function_Argument;

   --  There is no fold in the standard library, so the loop is the fold.
   procedure Test_Fold (T : in out Fixture) is
      pragma Unreferenced (T);
      Total : Integer := 0;
   begin
      for Value of Values loop
         Total := Total + Value;
      end loop;

      Assert (Total = 15, "wrong total");
   end Test_Fold;

   --  errors

   --  Failure is an exception, and the handler catches by name. Ada raises one
   --  of its own for arithmetic that will not fit, without being asked.
   procedure Test_Refusal (T : in out Fixture) is
      pragma Unreferenced (T);
      Refused_It : Boolean := False;
      Too_Big    : Boolean := False;
   begin
      Assert (Parse_Positive ("42") = 42, "a valid input was refused");

      begin
         Assert (Parse_Positive ("nope") = 0, "an invalid input was accepted");
      exception
         when Refused =>
            Refused_It := True;
      end;

      begin
         declare
            --  Through 'Value so that the compiler cannot see the number: it
            --  rejects Natural'Last + 1 outright as a static overflow, and
            --  warns about one it can still follow through a variable.
            Biggest : constant Natural :=
              Natural'Value (Natural'Image (Natural'Last));
            Small   : Natural := 0;
         begin
            Small := Biggest + 1;
            Assert (Small = 0, "the overflow was not noticed");
         end;
      exception
         when Constraint_Error =>
            Too_Big := True;
      end;

      Assert (Refused_It, "the invalid input did not raise");
      Assert (Too_Big, "the overflow did not raise");
   end Test_Refusal;

   --  gotchas

   --  The hour this saves: a slice keeps the indices it had in the string it
   --  came from. It compares equal to a literal, and it is still not indexed
   --  from one, so Slice (1) raises where Slice (Slice'First) does not.
   procedure Test_Slice_Indices (T : in out Fixture) is
      pragma Unreferenced (T);
      Text  : constant String := "abcdef";
      Slice : constant String := Text (3 .. 5);
   begin
      Assert (Slice = "cde", "the slice holds the wrong characters");
      Assert (Slice'First = 3, "the slice was renumbered from one");
      Assert (Slice'Length = 3, "the slice is the wrong length");
   end Test_Slice_Indices;

   function Suite return AUnit.Test_Suites.Access_Test_Suite is
      S : constant AUnit.Test_Suites.Access_Test_Suite :=
        AUnit.Test_Suites.New_Suite;
   begin
      S.Add_Test
        (Caller.Create
           ("an array knows its own bounds", Test_Array_Order'Access));
      S.Add_Test
        (Caller.Create
           ("a map raises for a key it does not hold", Test_Map_Miss'Access));
      S.Add_Test
        (Caller.Create
           ("a set discards duplicates", Test_Set_Duplicates'Access));
      S.Add_Test
        (Caller.Create
           ("a string is split by finding the separator", Test_Split'Access));
      S.Add_Test
        (Caller.Create
           ("a slice is taken between two positions", Test_Slice'Access));
      S.Add_Test
        (Caller.Create
           ("text is built by concatenation and repetition",
            Test_Building_Text'Access));
      S.Add_Test
        (Caller.Create
           ("assigning a record copies its value", Test_Record_Copies'Access));
      S.Add_Test
        (Caller.Create
           ("an enumeration knows its own range", Test_Enumeration'Access));
      S.Add_Test
        (Caller.Create
           ("a case covers every value and an if yields one",
            Test_Branching'Access));
      S.Add_Test
        (Caller.Create
           ("a loop takes its range from the array", Test_Loop_Index'Access));
      S.Add_Test
        (Caller.Create
           ("a sequence is walked two items at a time",
            Test_Lookahead'Access));
      S.Add_Test
        (Caller.Create
           ("a function can be handed to another function",
            Test_Function_Argument'Access));
      S.Add_Test
        (Caller.Create
           ("a total is accumulated, because there is no fold",
            Test_Fold'Access));
      S.Add_Test
        (Caller.Create
           ("an invalid input and an overflow both raise",
            Test_Refusal'Access));
      S.Add_Test
        (Caller.Create
           ("a slice keeps the indices it came with",
            Test_Slice_Indices'Access));
      return S;
   end Suite;

   function Run is new AUnit.Run.Test_Runner_With_Status (Suite);

   Reporter : AUnit.Reporter.Text.Text_Reporter;

begin
   if Run (Reporter) /= AUnit.Success then
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   end if;
end Kitchen_Sink;
