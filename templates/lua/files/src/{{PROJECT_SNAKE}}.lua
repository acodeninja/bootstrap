-- The module pattern, and it is a pattern rather than a language feature: Lua
-- has no module keyword, so a file builds a table, puts things in it, and
-- returns it. `require` hands the caller whatever the file returned.
--
-- `local` is what makes M private to this file. Leave it off and the name goes
-- into the global table instead, which is the single easiest mistake to make
-- here -- it works, and then two files quietly share one variable.
local M = {}

-- A field on that table, which is how Lua spells an exported function. The dot
-- form takes its arguments plainly; a colon -- function M:greet(name) -- would
-- add a hidden `self` parameter, which is the method form and not wanted here.
--
-- There are no type annotations anywhere in the language, so nothing checks
-- what `name` is until something tries to use it.
function M.greet(name)
  -- `..` concatenates. It is not `+`, which is arithmetic and would try to
  -- coerce both sides to numbers -- and would succeed for "10" .. "20" in a way
  -- that no test of this length would notice.
  return "Hello, " .. name .. "!"
end

-- The return value of the file. Without this line `require` hands back `true`
-- and the caller gets nothing it can use.
return M
