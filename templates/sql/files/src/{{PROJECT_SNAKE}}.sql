-- The schema and the routines for {{PROJECT_NAME}}.
-- That name keeps a line to itself: sqlfluff counts comments against the
-- eighty character limit as well, and a long project name would break it.
--
-- Every file under src/ is loaded into a fresh public schema before the tests
-- run, so a test sees all of this without naming the file it came from.

CREATE TYPE record_state AS ENUM ('open', 'held', 'done');

CREATE TYPE record_total AS (
    state record_state,
    kept bigint,
    amount bigint
);

-- DEFERRABLE INITIALLY DEFERRED moves the check from the insert to the commit,
-- so a test can insert the one row it cares about and leave the rest of the
-- graph alone. A test that never commits never pays for the reference at all.
CREATE TABLE records (
    id integer PRIMARY KEY,
    title text NOT NULL,
    state record_state NOT NULL,
    parent_id integer REFERENCES records (id) DEFERRABLE INITIALLY DEFERRED,
    amount integer NOT NULL CHECK (amount >= 0)
);

CREATE TABLE tags (
    record_id integer NOT NULL
    REFERENCES records (id) DEFERRABLE INITIALLY DEFERRED,
    tag text NOT NULL,
    PRIMARY KEY (record_id, tag)
);

-- CASE is the whole of the dispatch. A value carries no behaviour here, so
-- there is nothing to override and nowhere to hang a method.
CREATE FUNCTION label(value record_state) RETURNS text
LANGUAGE plpgsql IMMUTABLE AS $$
BEGIN
    RETURN CASE value
        WHEN 'open' THEN 'Open'
        WHEN 'held' THEN 'On hold'
        WHEN 'done' THEN 'Closed'
    END;
END;
$$;

CREATE FUNCTION sum_to(last integer) RETURNS integer
LANGUAGE plpgsql IMMUTABLE AS $$
DECLARE
    total integer := 0;
BEGIN
    FOR step IN 1..last LOOP
        total := total + step;
    END LOOP;

    RETURN total;
END;
$$;

CREATE FUNCTION totals() RETURNS SETOF record_total
LANGUAGE plpgsql STABLE AS $$
BEGIN
    RETURN QUERY
    SELECT
        records.state,
        count(*),
        sum(records.amount)
    FROM records
    GROUP BY records.state
    ORDER BY records.state;
END;
$$;

CREATE FUNCTION hold(record_id integer) RETURNS void
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE records SET state = 'held' WHERE records.id = hold.record_id;

    IF NOT found THEN
        RAISE EXCEPTION 'no record %', hold.record_id;
    END IF;
END;
$$;

CREATE FUNCTION share(total integer, parts integer) RETURNS integer
LANGUAGE plpgsql IMMUTABLE AS $$
BEGIN
    RETURN total / parts;
EXCEPTION
    WHEN division_by_zero THEN
        RETURN 0;
END;
$$;

-- ASSERT is how a function states what it believes about its own data. It
-- raises P0004, and it is meant for an invariant rather than for an argument
-- a caller could reasonably get wrong.
CREATE FUNCTION checked_amount(record_id integer) RETURNS integer
LANGUAGE plpgsql AS $$
DECLARE
    held integer;
BEGIN
    SELECT amount INTO STRICT held
    FROM records
    WHERE records.id = checked_amount.record_id;

    ASSERT held > 0, 'amount must be positive';

    RETURN held;
END;
$$;

INSERT INTO records (id, title, state, parent_id, amount) VALUES
(1, 'first', 'open', NULL, 3),
(2, 'second', 'held', 1, 5),
(3, 'third', 'open', 1, 7),
(4, 'fourth', 'done', NULL, 0);

INSERT INTO tags (record_id, tag) VALUES
(1, 'alpha'),
(1, 'beta'),
(3, 'alpha'),
(3, 'gamma');
