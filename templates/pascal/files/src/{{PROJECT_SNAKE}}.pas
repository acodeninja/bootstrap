// A unit, and its name must match the filename -- rename one and you rename
// both. This one carries the project name.
unit {{PROJECT_SNAKE}};

// Not a comment. Braces are the comment form in Pascal, but a brace followed by
// a dollar sign is a compiler directive, and these two change how the whole file
// is compiled: objfpc mode turns on the Object Pascal dialect, and H+ makes
// `string` mean a long, heap-managed AnsiString rather than the 255-character
// ShortString it meant in 1990.
//
// So a prose comment must never begin with a dollar sign. Pascal has three
// comment forms -- braces, the (* *) pair, and // to end of line -- and neither
// of the block forms nests, so commenting out a block that contains a comment
// breaks. This file uses // throughout for that reason.
{$mode objfpc}{$H+}

// The interface section is the whole of visibility: what is declared here is
// reachable by any unit that `uses` this one, and anything declared only in the
// implementation below is private to the file. One file, two sections -- where C
// and Ada split the same idea across two files.
interface

// The declaration. `const` on the parameter means it will not be assigned to,
// which also lets the compiler pass it without copying. The return type comes
// after the colon at the end.
function Greet(const Name: string): string;

implementation

// The signature is written out again, and the compiler checks the two agree.
function Greet(const Name: string): string;
begin
  // There is no `return` statement. Every function has an implicit variable
  // called Result of the return type, and whatever it holds when the function
  // ends is the answer -- so a branch that never assigns to it returns the
  // type default rather than failing in any visible way.
  //
  // + concatenates strings as well as adding numbers, and there is no
  // interpolation in the language.
  Result := 'Hello, ' + Name + '!';
end;

// `end.` with a full stop closes the unit. `end;` with a semicolon closes a
// block, and getting the two the wrong way round is a confusing error message.
end.
