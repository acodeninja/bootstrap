## Greeting for {{PROJECT_NAME}}.
##
## Octave takes a function's name from its filename, so this file is the
## project's entry point rather than a module of many -- which is why the
## function below is named after the project rather than called greet, and
## why there is nothing to export.
##
## Both % and # start a comment, and %{ %} is a block form. This file uses
## ## for prose, because %! means something else: it marks a test block,
## which the last paragraph here is about. Keep a line under eighty
## characters -- mh_style counts comments too, and reports one it cannot fix.

## A function declaration names its output first: the name before the equals
## sign is bound in the body, and whatever it holds when the function ends is
## the answer. There is no return statement, and a branch that never assigns
## to it is an error rather than an empty value.
##
## Nothing is typed. Every value is a matrix here, including a scalar, and a
## string is a row vector of characters -- which is why every array operation
## applies to text as well.
function out = {{PROJECT_SNAKE}} (name)
  ## sprintf formats into a string where printf writes it out, and %s is the
  ## specifier for a string. Note there is no interpolation syntax in the
  ## language; the other way to build this is concatenation with [ ].
  out = sprintf ("Hello, %s!", name);
end

## The test, and it lives in this file because that is where Octave keeps
## one: a %! line is a test block the interpreter ignores and the `test`
## command reads back out of the source. Nothing names the file, so a test is
## found by being in one -- and deleting it means editing the greeter.
##
## A plain ## line inside the block would end it, so a comment in there has
## to be written as a %! line too. There is no name string, which is the one
## thing this runner cannot give you: a failure reports file and line.
%!test
%! ## assert takes the actual value first and the expected second, and raises
%! ## when they differ. On two strings it compares the characters.
%! assert ({{PROJECT_SNAKE}} ("world"), "Hello, world!");
