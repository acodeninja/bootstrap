#!/usr/bin/env bash
#
# bootstrap.sh -- scaffold a project with a pinned toolchain and a passing test.
#
# Implements docs/cli.md. Where this script and that document disagree, this
# script is wrong.
#
# Requires bash 3.2 or newer: ${BASH_SOURCE[0]} detects clone vs remote mode,
# ${v//pat/rep} substitutes tokens without sed, `read -d ''` reads a file
# byte-exactly, and PIPESTATUS inspects the build while streaming it. macOS
# ships 3.2, so ${v,,}, associative arrays, mapfile and globstar are all out.

if [ -z "${BASH_VERSION:-}" ]; then
  printf 'error: bootstrap.sh requires bash, not sh\n' >&2
  exit 1
fi

set -u
export LC_ALL=C
shopt -s nullglob dotglob

OPT_NAME=
OPT_FORCE=0
OPT_NO_GIT=0
OPT_NO_BUILD=0
OPT_DRY=0
OPT_LIST=0
TEMPLATE_ID=
TARGET=
TEMPLATE_DIR=
TEMPLATE_ROOT=
DISPLAY=
PROJECT_NAME=
PROJECT_SLUG=
PROJECT_SNAKE=
AUTHOR=
YEAR=
REPLY_CONTENT=
FILE_COUNT=0

usage() {
  printf '%s\n' \
    'Usage:' \
    '  bootstrap.sh <template-id> <target-dir> [options]' \
    '  bootstrap.sh --list' \
    '  bootstrap.sh --help' \
    '' \
    'Options:' \
    '  --name <name>   Project name. Defaults to the basename of <target-dir>.' \
    '  --force         Scaffold into a non-empty directory, overwriting collisions.' \
    '  --no-git        Skip git init and the initial commit.' \
    '  --no-build      Skip the image build and the verification test run.' \
    '  --dry-run       Print the files that would be written and exit 0.' \
    '  --list          Print available templates and exit 0.' \
    '  --help          Print this and exit 0.' \
    '' \
    'Exit codes:' \
    '  0 success   1 usage   2 unknown template   3 target not empty' \
    '  4 docker unavailable or build failed       5 generated tests failed' \
    '  6 templates unavailable'
}

step() { printf '==> %-12s %s\n' "$1" "$2"; }
warn() { printf 'warning: %s\n' "$1" >&2; }

die() {
  local code=$1 msg=$2
  shift 2
  printf 'error: %s\n' "$msg" >&2
  while [ $# -gt 0 ]; do
    printf '       %s\n' "$1" >&2
    shift
  done
  exit "$code"
}

parse_args() {
  local positional=()
  while [ $# -gt 0 ]; do
    case $1 in
      --help | -h)
        usage
        exit 0
        ;;
      --list) OPT_LIST=1 ;;
      --force) OPT_FORCE=1 ;;
      --no-git) OPT_NO_GIT=1 ;;
      --no-build) OPT_NO_BUILD=1 ;;
      --dry-run)
        OPT_DRY=1
        OPT_NO_GIT=1
        OPT_NO_BUILD=1
        ;;
      --name)
        shift
        [ $# -gt 0 ] || die 1 "--name requires a value"
        OPT_NAME=$1
        ;;
      --name=*) OPT_NAME=${1#--name=} ;;
      --)
        shift
        while [ $# -gt 0 ]; do
          positional[${#positional[@]}]=$1
          shift
        done
        break
        ;;
      -*) die 1 "unknown option '$1'" 'run --help for usage' ;;
      *) positional[${#positional[@]}]=$1 ;;
    esac
    shift
  done

  [ ${#positional[@]} -le 2 ] || die 1 'too many arguments' 'run --help for usage'
  TEMPLATE_ID=${positional[0]:-}
  TARGET=${positional[1]:-}
}

# The script's own directory, or empty when it was never a file -- which is how
# remote mode announces itself. See docs/install.md.
script_root() {
  local src=${BASH_SOURCE[0]:-} dir
  [ -n "$src" ] || return 0
  dir=$(cd -- "$(dirname -- "$src")" && pwd) || return 0
  [ -d "$dir/templates" ] || return 0
  printf '%s' "$dir"
}

# Parsed, not sourced: template.env is display data, and sourcing it would
# execute whatever it happened to contain.
display_name() {
  local line name=
  while IFS= read -r line || [ -n "$line" ]; do
    case $line in
      DISPLAY_NAME=*)
        name=${line#DISPLAY_NAME=}
        name=${name%\"}
        name=${name#\"}
        ;;
    esac
  done <"$1"
  printf '%s' "$name"
}

template_ids() {
  local env_file id
  for env_file in "$TEMPLATE_ROOT"/*/template.env; do
    id=${env_file%/template.env}
    printf '%s\n' "${id##*/}"
  done
}

template_count() {
  local count=0 id
  for id in $(template_ids); do
    count=$((count + 1))
  done
  printf '%s' "$count"
}

list_templates() {
  local env_file id name
  for env_file in "$TEMPLATE_ROOT"/*/template.env; do
    id=${env_file%/template.env}
    id=${id##*/}
    name=$(display_name "$env_file")
    [ -n "$name" ] || name=$id
    printf '%s\t%s\n' "$id" "$name"
  done
}

did_you_mean() {
  local wanted=$1 id
  for id in $(template_ids); do
    case $id in
      *"$wanted"*)
        printf '%s' "$id"
        return 0
        ;;
    esac
    case $wanted in
      "$id"*)
        printf '%s' "$id"
        return 0
        ;;
    esac
  done
}

resolve_template() {
  local suggestion
  TEMPLATE_DIR="$TEMPLATE_ROOT/$TEMPLATE_ID"
  if [ ! -f "$TEMPLATE_DIR/template.env" ]; then
    suggestion=$(did_you_mean "$TEMPLATE_ID")
    if [ -n "$suggestion" ]; then
      die 2 "no template '$TEMPLATE_ID'" \
        "did you mean: $suggestion" \
        "run --list to see all $(template_count) templates"
    fi
    die 2 "no template '$TEMPLATE_ID'" \
      "run --list to see all $(template_count) templates"
  fi
  DISPLAY=$(display_name "$TEMPLATE_DIR/template.env")
  [ -n "$DISPLAY" ] || DISPLAY=$TEMPLATE_ID
}

# Lowercase, collapse every non-alphanumeric run to one separator, and trim the
# separator from both ends -- in one pass, with no tr and no bash-4 case
# conversion. Deferring the separator rather than appending it is what makes
# the collapsing and the trimming fall out together.
slugify() {
  local s=$1 sep=$2 out='' c i rest idx pending=0
  local up=ABCDEFGHIJKLMNOPQRSTUVWXYZ lo=abcdefghijklmnopqrstuvwxyz
  for ((i = 0; i < ${#s}; i++)); do
    c=${s:i:1}
    case $c in
      [a-z0-9])
        if [ "$pending" -eq 1 ] && [ -n "$out" ]; then out=$out$sep; fi
        out=$out$c
        pending=0
        ;;
      [A-Z])
        rest=${up#*"$c"}
        idx=$((${#up} - ${#rest} - 1))
        if [ "$pending" -eq 1 ] && [ -n "$out" ]; then out=$out$sep; fi
        out=$out${lo:idx:1}
        pending=0
        ;;
      *) pending=1 ;;
    esac
  done
  # npm rejects an empty package name, and so would most things downstream.
  [ -n "$out" ] || out=project
  printf '%s' "${out:0:60}"
}

derive_names() {
  local base=$TARGET resolved
  while [ "${base%/}" != "$base" ]; do base=${base%/}; done
  base=${base##*/}
  case $base in
    . | .. | '')
      resolved=$(cd -- "$TARGET" 2>/dev/null && pwd) || resolved=project
      base=${resolved##*/}
      ;;
  esac

  PROJECT_NAME=${OPT_NAME:-$base}
  PROJECT_NAME=${PROJECT_NAME//\\/}
  PROJECT_NAME=${PROJECT_NAME//\"/}
  PROJECT_SLUG=$(slugify "$PROJECT_NAME" -)
  PROJECT_SNAKE=$(slugify "$PROJECT_NAME" _)
  AUTHOR=$(git config user.name 2>/dev/null) || AUTHOR=
  AUTHOR=${AUTHOR//\\/}
  [ -n "$AUTHOR" ] || AUTHOR='Your Name'
  YEAR=$(date +%Y)
}

check_target() {
  local entries
  [ -e "$TARGET" ] || return 0
  [ -d "$TARGET" ] || die 3 "target '$TARGET' exists and is not a directory"
  entries=("$TARGET"/*)
  [ ${#entries[@]} -eq 0 ] && return 0
  [ "$OPT_FORCE" -eq 1 ] && return 0
  die 3 "target '$TARGET' exists and is not empty" \
    'pass --force to scaffold into it anyway'
}

install_hint() {
  case $OSTYPE in
    msys* | cygwin* | win32)
      if [ "$1" = make ]; then
        printf 'winget install ezwinports.make'
      else
        printf 'install Docker Desktop: https://docs.docker.com/desktop/'
      fi
      ;;
    darwin*)
      if [ "$1" = make ]; then
        printf 'xcode-select --install'
      else
        printf 'install Docker Desktop: https://docs.docker.com/desktop/'
      fi
      ;;
    *)
      if [ "$1" = make ]; then
        printf 'apt install make'
      else
        printf 'install Docker: https://docs.docker.com/engine/install/'
      fi
      ;;
  esac
}

# Only runs when something will actually be built. Under --no-build or
# --dry-run neither docker nor make is needed to produce a valid project, and
# demanding them would make --dry-run fail on a machine that has neither.
preflight() {
  local docker_version make_version
  command -v docker >/dev/null 2>&1 ||
    die 4 'docker is not installed' "$(install_hint docker)"
  docker info >/dev/null 2>&1 ||
    die 4 'the docker daemon is not reachable' 'start Docker and try again'
  command -v make >/dev/null 2>&1 ||
    die 4 'make is not installed' "$(install_hint make)"

  docker_version=$(docker version --format '{{.Client.Version}}' 2>/dev/null) || docker_version='?'
  make_version=$(make --version 2>/dev/null | while IFS= read -r l; do
    printf '%s' "${l##* }"
    break
  done)
  step preflight "docker $docker_version, make ${make_version:-?}"
}

apply_tokens() {
  local t=$1
  t=${t//'{{PROJECT_NAME}}'/"$PROJECT_NAME"}
  t=${t//'{{PROJECT_SLUG}}'/"$PROJECT_SLUG"}
  t=${t//'{{PROJECT_SNAKE}}'/"$PROJECT_SNAKE"}
  t=${t//'{{AUTHOR}}'/"$AUTHOR"}
  t=${t//'{{YEAR}}'/"$YEAR"}
  printf '%s' "$t"
}

# read -d '' stops at NUL, so it returns 1 at EOF while still setting the
# variable -- and unlike $(cat) it keeps the file's trailing newlines exactly.
# Binary files are excluded by docs/template-contract.md.
read_file() {
  REPLY_CONTENT=
  IFS= read -r -d '' REPLY_CONTENT <"$1" || :
}

walk() {
  local src=$1 rel=$2 mode=$3 entry base name dest
  for entry in "$src"/*; do
    base=${entry##*/}
    name=$(apply_tokens "$base")
    dest=${rel:+$rel/}$name
    if [ -d "$entry" ]; then
      if [ "$mode" = write ]; then mkdir -p "$TARGET/$dest"; fi
      walk "$entry" "$dest" "$mode"
    else
      FILE_COUNT=$((FILE_COUNT + 1))
      if [ "$mode" = dry ]; then
        printf '%s\n' "$dest"
      else
        read_file "$entry"
        apply_tokens "$REPLY_CONTENT" >"$TARGET/$dest"
      fi
    fi
  done
}

scaffold() {
  FILE_COUNT=0
  walk "$TEMPLATE_DIR/files" '' "$1"
}

# Docker Desktop maps ownership itself, and $UID under Git Bash is a Windows
# RID that means nothing to a Linux container -- so Windows gets no .env and
# compose falls back to its 1000:1000 defaults. Same reasoning
# docs/containers.md already gives for bootstrap.ps1 omitting it.
write_env() {
  case $OSTYPE in
    msys* | cygwin* | win32) return 0 ;;
  esac
  printf 'DOCKER_UID=%s\nDOCKER_GID=%s\n' "$UID" "${GROUPS[0]}" >"$TARGET/.env"
  FILE_COUNT=$((FILE_COUNT + 1))
}

git_init() {
  if ! git -C "$TARGET" init -q 2>/dev/null; then
    warn 'git init failed; the project is scaffolded but not under version control'
    return 0
  fi
  git -C "$TARGET" symbolic-ref HEAD refs/heads/main 2>/dev/null
  git -C "$TARGET" add -A 2>/dev/null
  if git -C "$TARGET" commit -q -m "chore: bootstrap $TEMPLATE_ID project" 2>/dev/null; then
    step git 'initialised, 1 commit'
  else
    step git 'initialised, no commit (set git user.name and user.email)'
  fi
}

# docs/cli.md wants the build streamed unmodified, and wants toomanyrequests
# named when it happens. Reading the stream at all costs the TTY renderer, so
# --progress plain keeps it line-oriented rather than emitting redraws.
build_image() {
  local status
  (
    cd "$TARGET" || exit 1
    docker compose build --progress plain 2>&1 |
      {
        rate_limited=0
        while IFS= read -r line; do
          printf '%s\n' "$line"
          case $line in
            *toomanyrequests* | *'pull rate limit'*) rate_limited=1 ;;
          esac
        done
        exit "$rate_limited"
      }
    if [ "${PIPESTATUS[0]}" -eq 0 ]; then exit 0; fi
    if [ "${PIPESTATUS[1]}" -eq 1 ]; then exit 2; fi
    exit 1
  )
  status=$?
  case $status in
    0) return 0 ;;
    2)
      die 4 "image build failed for '$TEMPLATE_ID'" \
        'the registry reported: toomanyrequests' \
        'Docker Hub limits anonymous pulls. Run docker login and try again.'
      ;;
    *)
      die 4 "image build failed for '$TEMPLATE_ID'" \
        'the build output above is the whole story'
      ;;
  esac
}

# Deliberately unpiped: a failing test's own output is the most useful thing on
# the screen at that moment, and piping it would cost its TTY and its colour.
run_tests() {
  (cd "$TARGET" && make test) ||
    die 5 "the generated project's test run failed" \
      "the project is scaffolded at '$TARGET'; the output above says why"
}

next_steps() {
  printf '\nReady. Next:\n'
  printf '  cd %s\n' "$TARGET"
  printf '  make test\n'
  printf '  read kitchen-sink/ for the language, then pick a kata from KITCHEN-SINK.md\n'
}

main() {
  parse_args "$@"

  TEMPLATE_ROOT=$(script_root)
  if [ -z "$TEMPLATE_ROOT" ]; then
    die 6 'this build of bootstrap.sh only supports running from a clone' \
      'git clone git@github.com:acodeninja/bootstrap.git && cd bootstrap' \
      './bootstrap.sh javascript ../my-js'
  fi
  TEMPLATE_ROOT=$TEMPLATE_ROOT/templates

  if [ "$OPT_LIST" -eq 1 ]; then
    list_templates
    exit 0
  fi

  [ -n "$TEMPLATE_ID" ] ||
    die 1 'a template id is required' 'run --list to see them, --help for usage'
  [ -n "$TARGET" ] || die 1 'a target directory is required' 'run --help for usage'

  resolve_template
  step template "$DISPLAY"
  check_target
  derive_names

  if [ "$OPT_DRY" -eq 1 ]; then
    scaffold dry
    step dry-run "$FILE_COUNT files -> $TARGET"
    exit 0
  fi

  if [ "$OPT_NO_BUILD" -eq 0 ]; then preflight; fi

  mkdir -p "$TARGET" || die 3 "could not create '$TARGET'"
  scaffold write
  write_env
  step scaffold "$FILE_COUNT files -> $TARGET"

  if [ "$OPT_NO_GIT" -eq 0 ]; then git_init; fi

  if [ "$OPT_NO_BUILD" -eq 0 ]; then
    build_image
    step image "built $PROJECT_SLUG-dev"
    run_tests
  fi

  next_steps
}

main "$@"
