# Fifteen passing assertions: the toolbox for solving a kata in BQN.

⟨Plan, Ok, TapDone⟩ ← •Import "./tester.bqn"

Plan 15

# collections
values ← 1‿2‿4‿8

"a list is picked from by index and counted by its length" Ok ⟨4, 4⟩ ≡ ⟨2 ⊑ values, ≠ values⟩

# There is no map type. A pair of lists is the map, and ⊐ is the lookup.
keys ← ⟨"one", "two", "four"⟩
At ← {⊑ keys ⊐ ⟨𝕩⟩}

"a missing key indexes one past the last key, because there is no map type" Ok ⟨2, 3⟩ ≡ ⟨(At "two") ⊑ values, At "nope"⟩

"a set is a list with its duplicates dropped, and ∊ answers for a whole list at once" Ok ⟨"abcd", 1‿0⟩ ≡ ⟨⍷ "abcabd", "cz" ∊ "abcabd"⟩

# strings
text ← "kitchen sink"

"a string is a list of characters, so it counts and slices like any other list" Ok ⟨12, "kitchen", "sink"⟩ ≡ ⟨≠ text, 7 ↑ text, 8 ↓ text⟩

# There is no split. ⊔ groups the characters by a key each, and a key of ¯1
# discards that character -- so the separators choose themselves out.
line ← "one two three"
mask ← ' ' = line
groups ← ((¬ mask) × +` mask) - mask

"splitting groups the characters by a running count of the separators" Ok ⟨"one", "two", "three"⟩ ≡ groups ⊔ line

"joining puts the separator before every part and drops the first one" Ok "one, two, three" ≡ 2 ↓ ∾ ", "⊸∾¨ ⟨"one", "two", "three"⟩

# types and branching
point ← {x ⇐ 3 ⋄ y ⇐ 4}

"a namespace is the record: fields are declared with ⇐ and read with a dot" Ok ⟨3, 4⟩ ≡ ⟨point.x, point.y⟩

# There is no enum and no exhaustive match. A list of names is the type, and
# nothing anywhere notices a state you left out.
states ← ⟨"locked", "unlocked"⟩

"a fixed set of states is a list of names, and nothing checks a branch covered them" Ok 1 ≡ ⊑ states ⊐ ⟨"unlocked"⟩

Sign ← (0⊸<) ◶ ⟨"zero or less", "positive"⟩

"◶ picks its branch by index, which is how a condition yields a value" Ok ⟨"positive", "zero or less"⟩ ≡ ⟨Sign 3, Sign ¯1⟩

# iteration
# The loop is the operator: ´ folds, ` scans, ¨ maps, and not one of them is a
# body you write. So there is no counter to increment and no cursor to step --
# the two assertions below are the whole of iteration in BQN, which is the one
# thing no other template here can say.

"the index is itself a list, so a loop over indices is arithmetic on ↕" Ok 34 ≡ +´ values × ↕ ≠ values

"lookahead is the list minus its own shift, with no cursor to step" Ok 4 ≡ ⌈´ (1 ↓ values) - ¯1 ↓ values

# functions
_twice ← {𝔽 𝔽 𝕩}

"a function reaches another function as the operand 𝔽 of a modifier" Ok 5 ≡ (+⟜1) _twice 3

"´ folds from the right with any dyadic function, a block included" Ok 321 ≡ {𝕨 + 𝕩 × 10}´ 1‿2‿3

# errors
# ! raises, and the message it is given is the whole error value: there are no
# error types, no hierarchy and no Result. ⎊ is the only catch there is, and
# its right operand is handed the same argument the failing function got.
Digit ← {"not a digit" ! ('0' ≤ 𝕩) ∧ 𝕩 ≤ '9' ⋄ 𝕩 - '0'}

"! raises the message it is given, and ⎊ hands that message on" Ok ⟨7, "not a digit"⟩ ≡ ⟨Digit '7', Digit ⎊ {•CurrentError 𝕩} 'x'⟩

# gotchas
# The hour this saves. A brace block naming no parameter is not a function
# waiting to be called: it runs where it is written. {2+2} is the number 4, and
# the function is {𝕤 ⋄ 2+2}. The namespace above is this rule working as
# intended; every "why has my function already run" is this rule biting.

"a brace block that names no parameter runs where it is written" Ok ⟨4, 4⟩ ≡ ⟨{2+2}, {𝕤 ⋄ 2+2} @⟩

TapDone @
