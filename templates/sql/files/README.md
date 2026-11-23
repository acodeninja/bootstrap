# {{PROJECT_NAME}}

## Prerequisites

- **Docker**, with the daemon running
- **make** — on Windows, `winget install ezwinports.make`

You do not need sqlite3 or sqlfluff. The toolchain lives in the container,
pinned by the `Dockerfile`, so a green suite here is a green suite anywhere.

## Commands

```console
$ make test    # run the test suite
$ make lint    # check every statement with sqlfluff
$ make fmt     # reformat every statement with sqlfluff
$ make build   # a no-op: SQLite reads the schema as it runs
$ make shell   # open a shell in the container
```

## The project is a schema

`src/{{PROJECT_SNAKE}}.sql` is the schema, not an application. Every `.sql`
file under `src/` is read into a fresh in-memory database before each test
file runs, so a test sees the tables without naming the file they came from —
and the tests never share state, because each one gets its own database.

## Tests

Every `.sql` file under `tests/` prints [TAP](https://testanything.org/) and
nothing else. Add one and it runs; delete one and nothing refers to it.

```sql
SELECT '1..1';

SELECT
    iif(count(*) = 4, 'ok', 'not ok')
    || ' 1 - the schema loads with four records'
FROM records;
```

`iif(condition, 'ok', 'not ok')` concatenated with the number and the name is
the whole of the framework. `CASE WHEN ... THEN 'ok' ELSE 'not ok' END` is the
same thing spelled longhand.

**The plan line is the safety net.** `sqlite3` exits 0 for a query returning
the string `not ok` exactly as it does for any other string, so the exit
status is `tap-run`'s to decide: it fails on a `not ok`, on a `sqlite3` that
exited non-zero, and on a file whose results do not match the count it
promised. That last one is what catches a script cut short — an error in the
middle of a file stops that statement and the results simply stop arriving.

## Lint and format

`sqlfluff` is both, and `.sqlfluff` is where the dialect is set. `make lint`
reports violations and exits non-zero; `make fmt` fixes the ones that are
layout. The two agree: a file this project ships is already formatted, so
`make fmt` on a fresh clone has nothing to do.

Formatting only ever moves whitespace, so reformatting a test cannot change
what it prints.

## Adding a dependency

SQLite has no package manager and no `IMPORT`. A schema is split across files
in `src/`, which `tap-run` reads in sorted order — so a file that depends on
another has to sort after it. An extension is a shared library the
`Dockerfile` installs and `.load` brings in.

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

## Licence

MIT — see [LICENSE](LICENSE).
