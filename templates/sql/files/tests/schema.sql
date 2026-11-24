BEGIN;

SELECT plan(2);

SELECT is(
    (
        SELECT count(*)::integer
        FROM records
    ),
    4,
    'the schema loads, seeded with four records'
);

SELECT is(
    (
        SELECT kept
        FROM totals()
        WHERE state = 'open'
    ),
    2::bigint,
    'the totals function folds the records that share a state'
);

SELECT finish FROM finish();

ROLLBACK;
