SELECT '1..2';

SELECT
    iif(count(*) = 4, 'ok', 'not ok')
    || ' 1 - the schema loads with four records'
FROM records;

SELECT
    iif(kept = 2 AND amount = 10, 'ok', 'not ok')
    || ' 2 - the totals view sums the records sharing a state'
FROM totals
WHERE state = 'open';
