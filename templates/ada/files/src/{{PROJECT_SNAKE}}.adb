--  The package body. It supplies a body for everything the specification
--  declared, and the compiler checks that the two agree -- a signature that
--  drifts is an error here rather than a link failure later.
package body {{PROJECT_SNAKE}} is

   --  The signature is written out again. Nothing generates it from the spec, so
   --  a change means editing both files, and the compiler is what keeps them
   --  honest.
   --
   --  `is` opens the declarative part -- local variables would go between here
   --  and `begin` -- and `begin ... end Greet` is the body. Repeating the name
   --  on the `end` is optional and conventional, and the compiler checks it
   --  matches, which is how a misplaced `end` gets caught at the right line.
   function Greet (Name : String) return String is
   begin
      --  & concatenates arrays, and a String is an array, which is why the same
      --  operator joins text. There is no interpolation in the language.
      --
      --  The result is sized from its value rather than declared: Ada allows a
      --  function to return an unconstrained String, and the caller takes the
      --  bounds from what came back.
      return "Hello, " & Name & "!";
   end Greet;

end {{PROJECT_SNAKE}};
