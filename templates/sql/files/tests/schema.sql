-- Nothing names this file. make test runs pg_prove over tests/, which takes
-- every .sql in it, so a test file is found by existing and deleting one is
-- safe. Run the suite with make test.
--
-- BEGIN and the ROLLBACK at the foot of this file are what make a test
-- repeatable: every insert, every sequence bump and every schema change inside
-- the transaction is thrown away, so the next file starts from the same seeded
-- data. This is the one runner in this repo whose isolation is a database
-- feature rather than a framework one.
BEGIN;

-- pgTAP, and this is TAP: the plan is the number of assertions about to be
-- made, and the runner checks it against the ok lines. Add one and this number
-- changes with it.
SELECT plan(3);

-- is() takes the actual value, the expected value, and the name -- so an
-- assertion is a SELECT like anything else, and the test suite is a query. The
-- name is what a failure prints, so write it to read on its own.
--
-- The call is a scalar subquery in parentheses, because is() compares values
-- and greet returns one row of one column.
SELECT is(
    (SELECT greet('world')),
    'Hello, world!',
    'a greeting addresses the name it is given'
);

-- The casts are not decoration. is() is polymorphic but needs both sides to be
-- the same type, and count() returns bigint where the literal 4 is integer --
-- so one of the two has to say which it means, or the function call is
-- ambiguous rather than merely wrong.
SELECT is(
    (
        SELECT count(*)::integer
        FROM records
    ),
    4,
    'the schema loads, seeded with four records'
);

-- A set-returning function used where a table would go, which is the thing to
-- notice: totals() is selected FROM rather than called, because in SQL the
-- result of a function can be a relation.
SELECT is(
    (
        SELECT kept
        FROM totals()
        WHERE state = 'open'
    ),
    2::bigint,
    'the totals function folds the records that share a state'
);

-- Prints the summary pg_prove reads. Without it the plan goes unchecked.
SELECT finish FROM finish();

ROLLBACK;
