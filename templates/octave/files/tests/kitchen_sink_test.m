## Fifteen passing assertions: the toolbox for solving a kata in Octave.
##
## A %!test block is where Octave puts a test: the interpreter ignores the
## whole file as a comment, and `test` reads the blocks back out of it. Nothing
## declares them anywhere, which is why deleting this file takes the tests with
## it and leaves the project standing.

1;

## collections
## Everything is a matrix, including a single number -- so there is no scalar
## type, no list type, and indexing counts from one. A cell array is the only
## heterogeneous container, and a struct stands in for a map.

%!test
%! ## An array grows by assigning past its end, and `end` indexes backwards.
%! values = [1 2 4];
%! values(end+1) = 8;
%! assert (numel (values), 4);
%! assert (values(3), 4);
%! assert (values(2:3), [2 4]);

%!test
%! ## A cell array needs braces to reach the element and parentheses to reach
%! ## the cell that holds it, which are two different types.
%! items = {1, "two", [3 3 3]};
%! assert (items{2}, "two");
%! assert (class (items(2)), "cell");
%! assert (numel (items), 3);

%!test
%! ## There is no set and no map. `unique` sorts and deduplicates, `ismember`
%! ## asks the membership question, and a struct's fields are the nearest
%! ## thing to keys.
%! items = {"red", "blue", "red", "green"};
%! assert (numel (unique (items)), 3);
%! assert (ismember ("blue", items));
%! counts = struct ("a", 1, "b", 2);
%! assert (isfield (counts, "z"), false);

## strings

%!test
%! ## strsplit and strjoin are the pair, and both work on cell arrays.
%! record = "a,b,c";
%! parts = strsplit (record, ",");
%! assert (numel (parts), 3);
%! assert (strjoin (parts, "-"), "a-b-c");

%!test
%! ## A string is a row vector of characters, so every array operation applies
%! ## to it -- including concatenation with square brackets.
%! text = "kitchen";
%! assert (numel (text), 7);
%! assert (text(1:4), "kitc");
%! assert (["kit", "chen"], text);

%!test
%! ## Padding, repetition and substitution, none of which need a loop.
%! assert (repmat ("-", 1, 5), "-----");
%! assert (strtrim ("  spaced  "), "spaced");
%! assert (regexprep ("kitchen", "t", "T"), "kiTchen");

## types and branching
## There are no enums and no sum types. A struct is the record, a string plus
## `switch` is the state machine, and every number is a double until something
## says otherwise.

%!test
%! ## A struct is the record, and it is also an array of them: assigning to
%! ## index 2 makes the whole thing a 1x2 struct array.
%! record = struct ("name", "ada", "length", 3);
%! assert (record.name, "ada");
%! assert (numel (fieldnames (record)), 2);

%!test
%! ## switch matches strings, which C's switch cannot do, and a cell array as
%! ## a case label matches any entry in it. One table, three states, so the
%! ## otherwise arm is exercised rather than described.
%! verdicts = {};
%! for state = {"locked", "ajar", "wedged"}
%!   switch (state{1})
%!     case "locked"
%!       verdicts{end+1} = "refusing";
%!     case {"unlocked", "ajar"}
%!       verdicts{end+1} = "opening";
%!     otherwise
%!       verdicts{end+1} = "unknown";
%!   endswitch
%! endfor
%! assert (verdicts, {"refusing", "opening", "unknown"});

%!test
%! ## A literal is a double. An integer type is a different thing entirely: it
%! ## rounds rather than truncating, and it saturates rather than wrapping.
%! assert (class (3), "double");
%! assert (int32 (2.5), int32 (3));
%! assert (int8 (200), int8 (127));

## iteration

%!test
%! ## A for loop walks the columns of whatever it is given, so a matrix yields
%! ## vectors rather than elements -- and a row vector yields its elements only
%! ## because each one is its own column.
%! total = 0;
%! for column = [1 2; 3 4]
%!   total += sum (column);
%! endfor
%! assert (total, 10);

%!test
%! ## The vectorised spelling is the idiom, and it replaces the lookahead loop:
%! ## diff is the gap between neighbours.
%! values = [3 1 4 1];
%! assert (sum (diff (values) > 0), 1);
%! assert (cumsum (values), [3 4 8 9]);

## functions

%!test
%! ## A handle is made with @ and passed like any value; cellfun and arrayfun
%! ## are what take one.
%! twice = @(s) [s s];
%! assert (twice ("ab"), "abab");
%! assert (arrayfun (@(n) n * 2, [1 2 3]), [2 4 6]);

%!test
%! ## There is no fold in the language, because the reductions are built in and
%! ## take a dimension argument instead.
%! assert (sum ([1 2 3 4]), 10);
%! assert (prod ([1 2 3 4]), 24);

## errors
## Failure is a raised error carrying an identifier: error with a "pkg:id"
## first argument sets one, try/catch binds the object, and a %!error block is
## how a test demands one without catching it by hand.

%!test
%! ## A test can also demand a raise in one line rather than catching it by
%! ## hand: an `%!error id=...:notEven halve (7)` block asserts exactly this,
%! ## and is what to reach for once the raising code has a home of its own.
%! try
%!   error ("{{PROJECT_SNAKE}}:notEven", "not even: %d", 7);
%!   assert (false);
%! catch err
%!   assert (err.identifier, "{{PROJECT_SNAKE}}:notEven");
%!   assert (err.message, "not even: 7");
%! end_try_catch

## gotchas
## The hour this saves. `==` compares elementwise and `if` demands that every
## element be true, so comparing two arrays of different content takes the else
## branch without complaining -- and comparing against an empty array takes it
## too, because `if` on an empty value is false. isequal is the spelling that
## asks the question you meant.

%!test
%! a = [1 2 3];
%! b = [1 9 3];
%! if (a == b)
%!   taken = "then";
%! else
%!   taken = "else";
%! endif
%! assert (taken, "else");
%! assert (isequal (a, b), false);
%! assert (isequal (a, [1 2 3]), true);
