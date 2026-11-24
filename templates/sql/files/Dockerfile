# syntax=docker/dockerfile:1
FROM postgres:17.12-trixie

# pgTAP is the test framework, and plpgsql_check reads the function bodies
# sqlfluff cannot see into. Both are server extensions, which is why the
# database service runs this image instead of the official one untouched.
# https://github.com/theory/pgtap/releases/tag/v1.3.4
ARG PGTAP_VERSION=1.3.4-1.pgdg13+2
# https://github.com/okbob/plpgsql_check/releases/tag/v2.10.16
ARG PLPGSQL_CHECK_VERSION=2.10.16-1.pgdg13+2
# pg_prove runs the test files and holds each one to the plan it declared.
# https://metacpan.org/release/TAP-Parser-SourceHandler-pgTAP
ARG PG_PROVE_VERSION=3.37-1.pgdg130+1

# sqlfluff is the linter and the formatter for the statements themselves, and
# it is a Python package rather than anything the base image ships. The wheel
# is py3-none-any, so one pin covers both architectures.
# https://github.com/sqlfluff/sqlfluff/releases/tag/${SQLFLUFF_VERSION}
ARG SQLFLUFF_VERSION=4.5.0

# python3 and its venv exist to carry sqlfluff and nothing else, so they are
# the one pair left to whatever the base image's package set holds.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
         "libtap-parser-sourcehandler-pgtap-perl=${PG_PROVE_VERSION}" \
         "postgresql-17-pgtap=${PGTAP_VERSION}" \
         "postgresql-17-plpgsql-check=${PLPGSQL_CHECK_VERSION}" \
         python3 \
         python3-venv \
    && rm -rf /var/lib/apt/lists/*

# A venv rather than --break-system-packages: trixie marks its interpreter
# externally managed, and overriding that to install one tool is the thing the
# marker exists to stop.
RUN python3 -m venv /opt/sqlfluff \
    && /opt/sqlfluff/bin/pip install --no-cache-dir "sqlfluff==${SQLFLUFF_VERSION}" \
    && ln -s /opt/sqlfluff/bin/sqlfluff /usr/local/bin/sqlfluff

# The image stays generic and the command comes from the Makefile, so this
# readies a database and then runs whatever it was handed. compose has already
# waited for the server's healthcheck, so there is no readiness loop here.
#
# pgTAP keeps a schema of its own: dropping public between runs is what makes a
# run repeatable -- an edited function is replaced rather than shadowed -- and
# a thousand pgTAP functions should not be collateral.
COPY --chmod=0755 <<'SH' /usr/local/bin/with-pg
#!/bin/sh
set -eu

psql --quiet --no-psqlrc -v ON_ERROR_STOP=1 <<'EOSQL'
-- Quiet for this setup only. A RAISE NOTICE a reader adds while working on
-- a function is the first debugger they reach for, and it has to show.
SET client_min_messages = warning;
CREATE SCHEMA IF NOT EXISTS tap;
CREATE EXTENSION IF NOT EXISTS pgtap SCHEMA tap;
DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;
EOSQL

found=no
for schema in src/*.sql; do
  [ -e "$schema" ] || break
  found=yes
  psql --quiet --no-psqlrc -v ON_ERROR_STOP=1 -f "$schema"
done
[ "$found" = yes ] || echo "no schema found under src/"

if [ "$#" -eq 0 ]; then
  psql --quiet --no-psqlrc -tA <<'EOSQL'
SELECT count(*) || ' routines loaded into public'
FROM pg_proc
WHERE pronamespace = 'public'::regnamespace;
EOSQL
else
  exec "$@"
fi
SH

# plpgsql_check type checks a body against the schema it runs on, so it needs
# the database with src/ already in it. Hence a script rather than a psql line
# in the Makefile: lint has to go through with-pg like test does.
COPY --chmod=0755 <<'SH' /usr/local/bin/pg-check
#!/bin/sh
set -eu

exec psql --quiet --no-psqlrc -v ON_ERROR_STOP=1 \
  -f /usr/local/share/plpgsql-check.sql
SH

COPY <<'SQL' /usr/local/share/plpgsql-check.sql
SET client_min_messages = warning;

CREATE EXTENSION IF NOT EXISTS plpgsql_check;

DO $$
DECLARE
    routine regprocedure;
    finding text;
    found int := 0;
BEGIN
    FOR routine IN
        SELECT p.oid::regprocedure
        FROM pg_proc AS p
        INNER JOIN pg_namespace AS n ON n.oid = p.pronamespace
        INNER JOIN pg_language AS l ON l.oid = p.prolang
        WHERE n.nspname = 'public' AND l.lanname = 'plpgsql'
        ORDER BY 1
    LOOP
        FOR finding IN SELECT * FROM plpgsql_check_function(routine) LOOP
            RAISE WARNING '%: %', routine, finding;
            found := found + 1;
        END LOOP;
    END LOOP;

    IF found > 0 THEN
        RAISE EXCEPTION 'plpgsql_check reported % problem(s)', found;
    END IF;
END
$$;
SQL

# The only thing /cache holds. sqlfluff keeps no on-disk cache, and the venv
# above ships the bytecode pip compiled, so PYTHONPYCACHEPREFIX would make
# python ignore it and recompile -- measured at 600ms added to the first run.
ENV HOME=/cache/home

# Empty and world-writable so the first run creates its files as whoever is
# calling. See docs/containers.md "File ownership".
RUN mkdir -p /cache/home && chmod -R 777 /cache

WORKDIR /work
