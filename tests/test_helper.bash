#!/bin/bash

setup_env_vars () {
if [[ -z "$TMPDIR" ]]; then
  PI_TMPDIR='/tmp'
else
  PI_TMPDIR="${TMPDIR%/}"
fi
PI_TEST_FILENAME="$1"
PI_TEST_DIRNAME="${PI_TEST_FILENAME%/*}"
PI_TEST_NAMES=()
}

fixtures() {
  FIXTURE_ROOT="$PI_TEST_DIRNAME/fixtures/$1"
  RELATIVE_FIXTURE_ROOT="${FIXTURE_ROOT#$BATS_CWD/}"
}

make_pi_test_suite_tmpdir() {
  export PI_TEST_SUITE_TMPDIR="$PI_TMPDIR/pi-test-tmp"
  mkdir -p "$PI_TEST_SUITE_TMPDIR"
}

filter_control_sequences() {
  "$@" | sed $'s,\x1b\\[[0-9;]*[a-zA-Z],,g'
}

if ! command -v tput >/dev/null; then
  tput() {
    printf '1000\n'
  }
  export -f tput
fi

emit_debug_output() {
  printf '%s\n' 'output:' "$output" >&2
}

teardown() {
  if [[ -n "$PI_TEST_SUITE_TMPDIR" ]]; then
    rm -rf "$PI_TEST_SUITE_TMPDIR"
  fi
}
