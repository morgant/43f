#!/usr/bin/env roundup

source ./lib43f

describe "lib43f is_repository_initialized()"

before() {
  if [ ! -d tmp ]; then mkdir -p tmp/43f; fi

  # set some global variables that init_repository() and is_repository_initialized() rely upon
  dry_run=false
  y="$(date +%Y)"
}

after() {
  rm -r tmp
}

it_returns_false_if_repostory_path_is_empty() {
  ! is_repository_initialized ""
}

it_returns_false_if_repository_path_does_not_exist() {
  ! is_repository_initialized "tmp/invalid"
}

it_returns_false_if_repository_path_is_not_a_directory() {
  touch "tmp/file"
  ! is_repository_initialized "tmp/file"
}

it_returns_false_if_year_directory_does_not_exist_in_repository() {
  ! is_repository_initialized "tmp/43f"
}

it_returns_false_if_any_month_directories_do_not_exist_in_repository() {
  init_repository "tmp/43f" "$y"
  rm -r "tmp/43f/${y}/m01"
  ! is_repository_initialized "tmp/43f"
}

it_returns_false_if_any_day_directories_do_not_exist_in_repository() {
  init_repository "tmp/43f" "$y"
  rm -r "tmp/43f/${y}/d01"
  ! is_repository_initialized "tmp/43f"
}

it_returns_true_if_year_day_and_month_directories_exist_in_repository() {
  init_repository "tmp/43f" "$y"
  is_repository_initialized "tmp/43f"
}
