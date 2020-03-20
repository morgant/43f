#!/usr/bin/env roundup

source ./lib43f

describe "lib43f purge_year_directories()"

before() {
  if [ ! -d tmp ]; then mkdir -p tmp/43f; fi

  # set some global variables that init_repository relies upon
  dry_run=false
  y="$(date +%Y)"
  d="$(date +%d)"

  # set some global variables that purge_year_directories relies upon
  config_keep_years="3"

  # init 43f repo with 7 years of folders
  for (( year=$y; year > $(( $y - 7 )); year-- )); do
    init_repository "tmp/43f" "$year"
  done
}

after() {
  rm -r tmp
}

# mock notify to prevent errors
notify() {
  true
}

it_returns_false_if_repository_does_not_exist() {
  ! purge_year_directories "tmp/43f-test"
}

it_does_not_delete_current_year_directory() {
  purge_year_directories "tmp/43f"
  test -d "tmp/43f/${y}"
}

it_does_not_delete_year_directories_less_than_years_to_keep() {
  purge_year_directories "tmp/43f"
  for (( year=$y; year > $(( $y - $config_keep_years )); year-- )); do
    test -d "tmp/43f/${year}"
  done
}

it_does_delete_year_directories_greater_than_years_to_keep() {
  purge_year_directories "tmp/43f"
  for (( year=$(( $y - $config_keep_years - 1)); year > $(( $y - 7 )); year-- )); do
    ! test -e "tmp/43f/${year}"
  done
}

it_does_not_delete_any_year_directories_with_dryrun() {
  dry_run=true
  purge_year_directories "tmp/43f"
  for (( year=$y; year > $(( $y - 7 )); year-- )); do
    test -d "tmp/43f/${year}"
  done
}
