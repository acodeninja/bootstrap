-- The schema for {{PROJECT_NAME}}.
-- That name keeps a line to itself: sqlfluff counts comments against the
-- eighty character limit as well, and a long project name would break it.
--
-- Every file under src/ is read into a fresh in-memory database before each
-- test file runs, so a test sees these tables without naming the file they
-- came from.

CREATE TABLE states (
    state TEXT PRIMARY KEY,
    label TEXT NOT NULL
);

CREATE TABLE records (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    state TEXT NOT NULL REFERENCES states (state),
    parent_id INTEGER REFERENCES records (id),
    amount INTEGER NOT NULL CHECK (amount >= 0)
);

CREATE TABLE tags (
    record_id INTEGER NOT NULL REFERENCES records (id),
    tag TEXT NOT NULL,
    PRIMARY KEY (record_id, tag)
);

CREATE VIEW totals AS
SELECT
    state,
    count(*) AS kept,
    sum(amount) AS amount
FROM records
GROUP BY state;

INSERT INTO states (state, label) VALUES
('open', 'Open'),
('held', 'On hold'),
('done', 'Closed');

INSERT INTO records (id, name, state, parent_id, amount) VALUES
(1, 'first', 'open', NULL, 3),
(2, 'second', 'held', 1, 5),
(3, 'third', 'open', 1, 7),
(4, 'fourth', 'done', NULL, 0);

INSERT INTO tags (record_id, tag) VALUES
(1, 'alpha'),
(1, 'beta'),
(3, 'alpha'),
(3, 'gamma');
