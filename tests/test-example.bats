#!/usr/bin/env bats

load '/opt/bats-libs/bats-support/load.bash'
load '/opt/bats-libs/bats-assert/load.bash'
load '/opt/bats-libs/bats-assertion/bats-assertion.bash'
load '/opt/bats-libs/bats-file/load.bash'
load '/opt/bats-libs/bats-mock-lox/stub.bash'
load '/opt/bats-libs/bats-mock-grayhemp/load.bash'
load '/code/tests/test_helpers.bash'

setup() {
    touch /tmp/bats_test_file
}

teardown() {
    rm -f /tmp/bats_test_file
}

@test "Simple echo test" {
    echo "Hello Bats"
}

@test "I can use an assert() from helper bats-assert" {
    assert [ -e '/tmp/bats_test_file' ]
}

@test "I can use an assert_success() from helper bats-assertion" {
    run bash -c 'exit 0'
    assert_success
}

@test "I can use an assert_file_exist() from helper bats-file" {
    assert_file_exist '/tmp/bats_test_file'
}

@test "I can use an assert_exists_and_is_executable() from test_helpers" {
    run bash -c 'chmod +x /tmp/bats_test_file'
    assert_exists_and_is_executable '/tmp/bats_test_file'
}
