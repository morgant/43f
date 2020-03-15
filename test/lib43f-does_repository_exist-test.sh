#!/usr/bin/env roundup

source ./lib43f

describe "lib43f does_repository_exist()"

before() {
  if [ ! -d tmp ]; then mkdir -p tmp/43f; fi
}

after() {
  rm -r tmp
}

it_returns_false_if_repostory_path_is_empty() {
  ! does_repository_exist ""
}

it_returns_false_if_repository_path_does_not_exist() {
  ! does_repository_exist "tmp/invalid"
}

it_returns_false_if_repository_path_is_not_a_directory() {
  touch "tmp/file"
  ! does_repository_exist "tmp/file"
}

it_returns_true_if_repository_path_is_a_directory() {
  does_repository_exist "tmp/43f"
}
