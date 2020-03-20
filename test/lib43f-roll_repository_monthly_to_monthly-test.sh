#!/usr/bin/env roundup

source ./lib43f

describe "lib43f roll_repository_monthly_to_monthly()"

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
  ! roll_repository_monthly_to_monthly "" "2019" "12" "11"
}

it_returns_false_with_empty_year() {
  ! roll_repository_monthly_to_monthly "tmp/43f" "" "12" "11"
}

it_returns_false_with_empty_day() {
  ! roll_repository_monthly_to_monthly "tmp/43f" "2019" "" "11"
}

it_returns_false_with_empty_month() {
  ! roll_repository_monthly_to_monthly "tmp/43f" "2019" "12" ""
}

it_moves_files_from_src_month_directory_to_dst_month_directory() {
  touch "tmp/43f/2019/m12/test_file"
  roll_repository_monthly_to_monthly "tmp/43f/" "2019" "12" "11"
  test -f "tmp/43f/2019/m11/test_file"
}
