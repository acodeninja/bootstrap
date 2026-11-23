-- A cheatsheet for SQLite, and fifteen assertions that all pass on the first
-- run. Delete this file when you start real work: nothing in src/ refers to
-- it. The katas these tools are chosen for are at
-- https://learn.madetech.com/technology/katas/.
--
-- Every assertion prints its own TAP line, because SQL has no test framework
-- and sqlite3 exits 0 whether a query returns 'ok' or 'not ok'. tap-run
-- compares the plan below against the results and decides the exit status.

SELECT '1..15';

-- collections: a table is the only collection. There is no array, no map and
-- no set that can be the value of a column, so all three are shapes a rowset
-- is put into.

WITH items (value) AS (VALUES (10), (20), (30))

SELECT
    iif(count(*) = 3, 'ok', 'not ok')
    || ' 1 - a values list is the literal collection, count is its length'
FROM items;

WITH wanted (state) AS (VALUES ('held'), ('gone'))

SELECT
    iif(count(states.label) = 1, 'ok', 'not ok')
    || ' 2 - a left join is the lookup, and a missing key gives null'
FROM wanted
LEFT JOIN states ON wanted.state = states.state;

SELECT
    iif(count(DISTINCT tag) = 2, 'ok', 'not ok')
    || ' 3 - distinct makes a set, and in asks whether a value is in one'
FROM tags
WHERE tag IN ('alpha', 'beta');

-- strings: there is no interpolation and no split. Concatenation is an
-- operator, and taking a string apart means finding the separator yourself.

SELECT
    iif(length(name || state) = 9, 'ok', 'not ok')
    || ' 4 - two pipes concatenate, and length counts characters'
FROM records
WHERE id = 1;

SELECT
    iif(substr(label, 1, instr(label, ' ') - 1) = 'On', 'ok', 'not ok')
    || ' 5 - substr counts from one, and instr locates the separator'
FROM states
WHERE state = 'held';

-- The ORDER BY belongs inside the aggregate: without it the order rows arrive
-- in is whatever the query plan happened to produce.
SELECT
    iif(
        group_concat(
            tag, ','
            ORDER BY tag
        ) = 'alpha,beta', 'ok', 'not ok'
    ) || ' 6 - group_concat joins a column into one ordered string'
FROM tags
WHERE record_id = 1;

-- types and branching: no struct literal and no enum. A table declaration is
-- the record type, a declared type is an affinity rather than a guarantee,
-- and a lookup table is where a fixed set of named states lives.

SELECT
    iif(typeof(parent_id) = 'null', 'ok', 'not ok')
    || ' 7 - typeof reports the type of the value, not of the column'
FROM records
WHERE id = 1;

SELECT
    iif(count(states.label) = 4, 'ok', 'not ok')
    || ' 8 - a lookup table is the enum, and every record resolves in it'
FROM records
INNER JOIN states ON records.state = states.state;

SELECT
    iif(sum(CASE state WHEN 'open' THEN 1 ELSE 0 END) = 2, 'ok', 'not ok')
    || ' 9 - case yields a value per branch, and iif is the two way form'
FROM records;

-- iteration: there are no loops. A recursive CTE walks a sequence it builds
-- as it goes, and a window function is how one row reads its neighbours.

WITH RECURSIVE counter (i) AS (
    SELECT 1
    UNION ALL
    SELECT i + 1
    FROM counter
    WHERE i < 5
)

SELECT
    iif(sum(i) = 15, 'ok', 'not ok')
    || ' 10 - a recursive cte is the loop, and its column is the index'
FROM counter;

WITH ordered AS (
    SELECT
        amount,
        lead(amount) OVER (ORDER BY id) AS next_amount
    FROM records
)

SELECT
    iif(next_amount = 5, 'ok', 'not ok')
    || ' 11 - lead reads the following row without a second pass'
FROM ordered
WHERE amount = 3;

-- functions: there are no first class functions and nothing to pass one to.
-- A view is the named, reusable query, and an aggregate is the fold.

SELECT
    iif(count(*) = 3, 'ok', 'not ok')
    || ' 12 - a view is a stored query, read back exactly like a table'
FROM totals;

SELECT
    iif(sum(amount) = 15, 'ok', 'not ok')
    || ' 13 - an aggregate folds every row down to one value'
FROM records;

-- errors: nothing is raised and nothing catches. A constraint refuses the
-- row, and without OR IGNORE that refusal stops the whole script where it
-- stands, which is why the plan line above is the safety net.

INSERT OR IGNORE INTO records (id, name, state, amount)
VALUES (1, 'clash', 'open', 1);

SELECT
    iif(changes() = 0, 'ok', 'not ok')
    || ' 14 - a constraint refuses the row and changes() counts none';

-- gotchas: NULL is the absence of a value rather than a value, so comparing
-- against it is unknown rather than false. NOT IN over a column holding one
-- is therefore unknown for every row, and the query quietly returns nothing.

SELECT
    iif(count(*) = 0, 'ok', 'not ok')
    || ' 15 - not in over a nullable column matches no rows at all'
FROM records
WHERE records.id NOT IN (SELECT child.parent_id FROM records AS child);
