#!/bin/bash

load test_helper

INSTALL_DIR=
PI_ROOT=

setup() {
  setup_env_vars
  make_pi_test_suite_tmpdir
  INSTALL_DIR="$PI_TEST_SUITE_TMPDIR/pi"
  PI_ROOT="${PI_TEST_DIRNAME%/*}"
}

@test "install.sh creates a valid installation" {
  skip
  run "$PI_ROOT/install.sh" "$INSTALL_DIR"
  [ "$status" -eq 0 ]
  [ "$output" == "Installed Pi to $INSTALL_DIR/bin/pi" ]
  [ -x "$INSTALL_DIR/bin/pi" ]
  [ -x "$INSTALL_DIR/libexec/pi/pi" ]
  [ -x "$INSTALL_DIR/libexec/pi/bats-exec-suite" ]

  run "$INSTALL_DIR/bin/bats" -v
  [ "$status" -eq 0 ]
  [ "${output%% *}" == 'Bats' ]
}

