-- A cheatsheet for PostgreSQL and PL/pgSQL, and fifteen assertions that all
-- pass on the first run. Delete this file when you start real work: nothing
-- in src/ refers to it. The katas these tools are chosen for are at
-- https://learn.madetech.com/technology/katas/.
--
-- pgTAP supplies the assertions and pg_prove runs the file, holding it to the
-- plan below. The transaction never commits, so a test can insert whatever it
-- needs and the next run starts from exactly the same place.

BEGIN;

SELECT plan(15);

-- collections: an array is a value a single column can hold, jsonb is the
-- map, and a rowset is still what everything else gets read into.

SELECT is(
    cardinality(ARRAY[10, 20, 30]),
    3,
    'an array is one value, and cardinality counts what is inside it'
);

SELECT is(
    '{"held": "On hold"}'::jsonb ->> 'held',
    'On hold',
    'jsonb is the map, and the arrow operator reads a key out as text'
);

SELECT is(
    (
        SELECT count(DISTINCT tag)::integer
        FROM tags
        WHERE tag IN ('alpha', 'beta')
    ),
    2,
    'distinct makes a set, and in asks whether a value is in one'
);

-- strings: there is interpolation, there is a split, and a regex hands back
-- its captures as an array rather than an object you ask questions of.

SELECT is(
    format('%s holds %s tags', 'first', 2),
    'first holds 2 tags',
    'format interpolates, and %s takes whatever type it is handed'
);

SELECT is(
    split_part('On hold', ' ', 2),
    'hold',
    'split_part takes a separator and counts the parts from one'
);

SELECT is(
    (regexp_match('record-42', '([0-9]+)'))[1],
    '42',
    'regexp_match returns its captures as an array, not a match object'
);

-- types and branching: an enum is a type of its own, a composite names the
-- fields of a row, and a case expression is the only dispatch there is.

SELECT is(
    label('held'),
    'On hold',
    'an enum value passes as itself, and case in the body is the dispatch'
);

SELECT ok(
    'open'::record_state < 'done'::record_state,
    'an enum orders by the order it was declared in, not alphabetically'
);

SELECT is(
    (
        SELECT kept
        FROM totals()
        WHERE state = 'open'
    ),
    2::bigint,
    'a composite type names the fields of the row a function returns'
);

-- iteration: plpgsql has the loop that SQL does not, and a recursive cte is
-- the same answer with nothing to accumulate in.

SELECT is(
    sum_to(5),
    15,
    'plpgsql has a for loop, and the loop declares its own index'
);

SELECT is(
    (
        WITH RECURSIVE counter (i) AS (
            SELECT 1
            UNION ALL
            SELECT i + 1
            FROM counter
            WHERE i < 5
        )

        SELECT sum(i)
        FROM counter
    ),
    15::bigint,
    'a recursive cte is that loop again, with no variable to carry a total'
);

-- functions: a body can catch what it raises, and it can state what it
-- believes about its own data.

SELECT is(
    share(10, 0),
    0,
    'exception when catches inside the body, and the function still returns'
);

SELECT is(
    checked_amount(1),
    3,
    'assert states an invariant, and passes for as long as it holds'
);

-- errors: raise ends the function where it stands and carries a code, which
-- is what a caller matches on rather than the message.

SELECT throws_ok(
    $$SELECT hold(99)$$,
    'P0001',
    'no record 99',
    'raise exception ends the function and carries a sqlstate with it'
);

-- gotchas: ASSERT is not a check you can count on being there. One setting
-- turns every one of them off at once, and nothing tells you the invariant
-- stopped being tested. The third argument keeps it inside this transaction.

DO $$
BEGIN
    PERFORM set_config('plpgsql.check_asserts', 'off', true);
END
$$;

SELECT is(
    checked_amount(4),
    0,
    'assert is skipped entirely when plpgsql.check_asserts is off'
);

SELECT finish FROM finish();

ROLLBACK;
