# Set

Lua has no set type. Make one: a table that stores membership, reports its size through
`#`, joins another set with `+`, answers membership with indexing, and prints as something
readable.

Then make a second type that inherits from it.

## What it teaches

Metatables, which are the one mechanism behind every feature Lua appears not to have.
`__index` is lookup and therefore inheritance, `__add` and `__len` are operators,
`__tostring` is printing, and `__newindex` is the hook that lets you refuse a write. There
is no class syntax because there is no need for one.

It is also where the table itself finally makes sense. List, map, record, set, module,
namespace and object are one data structure in Lua, and the thing that makes them different
is the metatable you attached.

## Where it sits

Step 3 on `lua`. It assumes FizzBuzz, and leads to
[roman numerals](roman-numerals.md) and [mars rover](mars-rover.md).

## Not available in

`python` dunder methods are the closest relative and cover operators but not lookup in the
same breath. `ruby` and `smalltalk` have real classes. Nothing else here builds its object
model out of one hook you can see.

## Source

Written for this repo. Documented in
[Programming in Lua, chapter 13](https://www.lua.org/pil/13.html).
