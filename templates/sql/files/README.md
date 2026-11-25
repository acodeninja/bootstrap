# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need PostgreSQL, psql or sqlfluff. The toolchain lives in the
container, pinned by the `Dockerfile`, so a green suite here is a green suite
anywhere.

## Commands

```console
$ make test    # run every test file through pg_prove
$ make lint    # check every statement, and every function body
$ make fmt     # reformat every statement with sqlfluff
$ make build   # load src/ into a fresh schema
$ make shell   # open a shell beside a running database
```

## Two containers

`compose.yaml` runs two. `db` is the server; `dev` is where psql, sqlfluff and
pg_prove run. Both use the same image, because pgTAP and plpgsql_check are
server extensions and have to be installed where the server is. No port is
published, and `make test` waits for the server's healthcheck itself.

The database lives in a volume and survives between runs.
`docker compose down -v` is how you start over from nothing.

## The project is a schema and its routines

`src/{{PROJECT_SNAKE}}.sql` holds the types, the tables and the functions.
Every `.sql` file under `src/` is loaded into a fresh `public` schema before
the tests run, so a test sees them without naming the file they came from.

A kata here is a function. `fizzbuzz(n integer) returns text` is the unit,
PL/pgSQL is where the loop and the branch live, and a table only appears when
the problem actually has data in it.

## Tests

Every `.sql` file under `tests/` is a [pgTAP](https://pgtap.org/) script.
`pg_prove` runs each one and holds it to the plan it declared. Add a file and
it runs; delete one and nothing refers to it.

```sql
BEGIN;

SELECT plan(1);

SELECT is(fizzbuzz(3), 'Fizz', 'three is Fizz');

SELECT finish FROM finish();

ROLLBACK;
```

`plan(n)` promises how many assertions follow and `finish` checks that many
arrived, which is what tells a failed assertion from a script that stopped
half way through. The transaction never commits, so a test can insert
whatever it needs and the next run starts from the same place.

The four worth knowing: `is(got, want, name)`, `ok(boolean, name)`,
`throws_ok(sql, sqlstate, message, name)` and `lives_ok(sql, name)`.

### Red, then green

`make test` reloads `src/` first, so an edited function replaces the old one
rather than shadowing it. Write the assertion, watch it fail, then write the
function:

```console
$ make test
tests/fizzbuzz.sql .. 1/1
not ok 1 - three is Fizz
#   have: NULL
#   want: Fizz
```

For one file, a shell is quicker than a full run:

```console
$ make shell
$ with-pg psql -f tests/fizzbuzz.sql
```

## Lint and format

Two tools, because they see different things. `sqlfluff` reads the statements,
and `.sqlfluff` holds its dialect and its one capitalisation choice.
`plpgsql_check` reads what sqlfluff cannot: a dollar quoted body is a single
literal to it, so without the second tool nothing checks inside a function at
all. `make lint` runs both and exits non-zero on either; `make fmt` fixes the
layout violations sqlfluff can.

Formatting only ever moves whitespace, so reformatting a test cannot change
what it asserts.

## Adding a dependency

PostgreSQL has no package manager for SQL. A schema split across files in
`src/` is loaded in sorted order, so a file that depends on another has to
sort after it. Everything else is an extension: install it in the
`Dockerfile`, then `CREATE EXTENSION` from a file in `src/`.

## CI

`.github/workflows/ci.yml` builds the image and runs lint and tests on every
push, and needs no secrets to do it.

`.github/workflows/actions.lock` pins the actions that workflow uses to exact
commits, so a tag that moves upstream cannot change what runs. It is
machine-generated: after you add a workflow or edit a `uses:` line, install the
tool once with `gh extension install github/gh-actions-lock` and run
`gh actions-lock` to rebuild it. Turning on Dependabot for `github-actions`
keeps the workflow and the lockfile in step without that.

`DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` are optional, and worth setting only
if the build starts failing to pull its base image: Docker Hub rate-limits
anonymous pulls and GitHub's runners share IP addresses, so the error looks
nothing like the real cause.

## Course

Three katas, in this order, each introducing one thing the last one did not:

1. [Hello, World](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/hello-world.md) — the toolchain, not you, and already solved beside this file
2. [FizzBuzz](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/fizzbuzz.md) — a loop, a branch, and your first test
3. [Running total](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/set-at-a-time.md) — a row that knows about the other rows

Then, when the group wants more: [Bowling](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/bowling.md) → [Turnstile](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/turnstile.md) → [Test framework](https://github.com/acodeninja/bootstrap/blob/main/docs/katas/test-framework.md).

The rest of the catalogue, and why this language gets these, is in
[docs/katas](https://github.com/acodeninja/bootstrap/tree/main/docs/katas).

Delete this section when the project becomes real work.

## Licence

MIT — see [LICENSE](LICENSE).
