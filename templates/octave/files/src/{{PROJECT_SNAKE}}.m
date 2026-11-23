## Greeting for {{PROJECT_NAME}}.
##
## Octave takes a function's name from its filename, so this file is the
## project's entry point rather than a module of many -- and the %!test block
## below it is where Octave keeps a function's tests.

function out = {{PROJECT_SNAKE}} (name)
  out = sprintf ("Hello, %s!", name);
end

%!test
%! assert ({{PROJECT_SNAKE}} ("world"), "Hello, world!");
