-- Fifteen passing assertions: the toolbox for solving a kata in Lua.

-- collections

it("a table used as a list keeps what you put in it, in order", function()
  local items = { "a", "b" }

  table.insert(items, "c")

  assert.equal(3, #items)
  assert.equal("b", items[2])
  assert.same({ "b", "c" }, { items[2], items[3] })
end)

it("a lookup for a key that is not there comes back nil", function()
  local counts = { a = 2, b = 1 }

  assert.equal(2, counts.a)
  assert.is_nil(counts.z)
  assert.equal(0, counts.z or 0)
end)

it("a table used as a set stores presence, not count", function()
  local letters = {}

  for letter in ("aba"):gmatch(".") do
    letters[letter] = true
  end

  assert.is_true(letters.a)
  assert.is_nil(letters.z)
end)

-- strings

it("a string is walked piece by piece with a pattern, not split into a list", function()
  local words = {}

  for word in ("one two three"):gmatch("%S+") do
    table.insert(words, word)
  end

  assert.same({ "one", "two", "three" }, words)
  assert.equal("one-two-three", table.concat(words, "-"))
end)

it("a slice of a string counts from one and includes both ends", function()
  local text = "abcdef"

  assert.equal("a", text:sub(1, 1))
  assert.equal("abc", text:sub(1, 3))
  assert.equal("ef", text:sub(-2))
end)

it("text is built by formatting, because Lua has no interpolation", function()
  local line = string.format("%s x%d", "world", 2)

  assert.equal("world x2", line)
  assert.equal("ababab", ("ab"):rep(3))
  assert.equal("padded", ("  padded  "):match("^%s*(.-)%s*$"))
end)

-- types and branching

it("a table groups related fields under one name, and copying it copies the reference", function()
  local point = { x = 1, y = 2 }

  local moved = point
  moved.x = 5

  assert.equal(5, point.x)
  assert.equal(5, moved.x)
end)

it("a fixed set of named states is matched by a lookup table, since Lua has no enums", function()
  local next_state = { locked = "open", open = "locked" }

  assert.equal("open", next_state.locked)
  assert.equal("locked", next_state.open)
  assert.is_nil(next_state.broken)
end)

it("a branch produces a value instead of setting one", function()
  local function describe(n)
    if n < 0 then
      return "negative"
    elseif n == 0 then
      return "zero"
    else
      return "positive"
    end
  end

  assert.equal("negative", describe(-1))
  assert.equal("zero", describe(0))
  assert.equal("positive", describe(1))
end)

-- iteration

it("a loop can read both the index and the item", function()
  local items = { "a", "b" }
  local seen = {}

  for index, item in ipairs(items) do
    table.insert(seen, index .. ":" .. item)
  end

  assert.same({ "1:a", "2:b" }, seen)
end)

it("a sequence can be walked two items at a time", function()
  local values = { 1, 2, 3, 4 }
  local sums = {}

  for i = 1, #values - 1 do
    table.insert(sums, values[i] + values[i + 1])
  end

  assert.same({ 3, 5, 7 }, sums)
end)

-- functions

it("a function can be handed to another function", function()
  -- Lua's standard library has no map: it is a loop, written once.
  local function map(values, apply)
    local results = {}
    for i, value in ipairs(values) do
      results[i] = apply(value)
    end
    return results
  end

  local doubled = map({ 1, 2, 3 }, function(n)
    return n * 2
  end)

  assert.same({ 2, 4, 6 }, doubled)
end)

it("a list is folded down to a single value", function()
  local values = { 1, 2, 3, 4 }
  local total = 0

  for _, value in ipairs(values) do
    total = total + value
  end

  assert.equal(10, total)
end)

-- errors

it("an invalid input returns nil and a message instead of raising", function()
  local function parse_percentage(input)
    local value = tonumber(input)
    if not value or value < 0 or value > 100 then
      return nil, "not a percentage: " .. input
    end
    return value
  end

  local value, err = parse_percentage("40")
  assert.equal(40, value)
  assert.is_nil(err)

  local bad, bad_err = parse_percentage("140")
  assert.is_nil(bad)
  assert.matches("not a percentage", bad_err)
end)

-- gotchas

it("assigning nil to a table key removes it, but # over the hole is unreliable", function()
  -- # is undefined once there is a hole; ipairs is the guarantee instead:
  -- it stops at the first nil.
  local values = { 1, 2, 3 }

  values[2] = nil

  local seen = 0
  for _ in ipairs(values) do
    seen = seen + 1
  end

  assert.is_nil(values[2])
  assert.equal(3, values[3])
  assert.equal(1, seen)
end)
