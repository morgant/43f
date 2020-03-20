#!/usr/bin/env roundup

source ./lib43f

describe "lib43f roll_repository_daily_to_monthly()"

before() {
  if [ ! -d tmp ]; then mkdir -p tmp/43f; fi
  init_repository "tmp/43f" "2019"

  # set some global variables that init_repository relies upon
  dry_run=false
}

after() {
  rm -r tmp
}

# mock notify to prevent errors
notify() {
  true
}

it_returns_false_with_empty_repository_path() {
  ! roll_repository_daily_to_monthly "" "2019" "7" "12" true
}

it_returns_false_with_empty_year() {
  ! roll_repository_daily_to_monthly "tmp/43f" "" "7" "12" true
}

it_returns_false_with_empty_day() {
  ! roll_repository_daily_to_monthly "tmp/43f" "2019" "" "12" true
}

it_returns_false_with_empty_month() {
  ! roll_repository_daily_to_monthly "tmp/43f" "2019" "07" "" true
}

it_moves_files_from_day_directory_to_month_directory_when_including_files_modified_today() {
  touch "tmp/43f/2019/d07/test_file"
  roll_repository_daily_to_monthly "tmp/43f" "2019" "7" "12" true
  test -f "tmp/43f/2019/m12/test_file"
}

it_does_not_move_files_from_day_directory_to_month_directory_when_excluding_files_modified_today() {
  touch "tmp/43f/2019/d07/test_file"
  roll_repository_daily_to_monthly "tmp/43f" "2019" "7" "12" false
  ! test -f "tmp/43f/2019/m12/test_file"
}
