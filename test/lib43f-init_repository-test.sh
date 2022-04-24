#!/usr/bin/env roundup

source ./lib43f

describe "lib43f init_repository()"

before() {
  if [ ! -d tmp ]; then mkdir -p tmp/43f; fi

  # set some global variables that init_repository relies upon
  dry_run=false
  y="$(date +%Y)"
}

after() {
  rm -r tmp
}

# mock notify to prevent errors
notify() {
  true
}

it_returns_false_with_empty_repository_path() {
  ! init_repository "" "" ""
}

it_returns_false_with_invalid_mode() {
  ! init_repository "tmp/43f-new" "" "89898"
}

it_creates_repository_if_repository_path_does_not_exist() {
  init_repository "tmp/43f-new" "" ""
  test -d "tmp/43f-new"
}

it_creates_repository_with_mode_if_repository_path_does_not_exist() {
  init_repository "tmp/43f-new" "" "1777"
  test -d "tmp/43f-new"
  test "$(stat -f "%OMp%OLp" "tmp/43f-new")" = "1777"
}

it_returns_false_with_invalid_year_string() {
  ! init_repository "tmp/43f" "A113" ""
}

it_creates_year_directory_for_current_year_with_empty_year_string() {
  init_repository "tmp/43f" "" ""
  test -d "tmp/43f/$(date +%Y)"
}

it_creates_year_directory_with_mode_for_current_year_with_empty_year_string() {
  init_repository "tmp/43f" "" "1777"
  test -d "tmp/43f/$(date +%Y)"
  test "$(stat -f "%OMp%OLp" "tmp/43f/$(date +%Y)")" = "1777"
}

it_creates_year_directory_for_year_string() {
  init_repository "tmp/43f" "2000" ""
  test -d "tmp/43f/2000"
}

it_creates_year_directory_with_mode_for_year_string() {
  init_repository "tmp/43f" "2000" "1777"
  test -d "tmp/43f/2000"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2000")" = "1777"
}

it_creates_month_directories() {
  init_repository "tmp/43f" "2019" ""
  test -d "tmp/43f/2019/m01"
  test -d "tmp/43f/2019/m02"
  test -d "tmp/43f/2019/m03"
  test -d "tmp/43f/2019/m04"
  test -d "tmp/43f/2019/m05"
  test -d "tmp/43f/2019/m06"
  test -d "tmp/43f/2019/m07"
  test -d "tmp/43f/2019/m08"
  test -d "tmp/43f/2019/m09"
  test -d "tmp/43f/2019/m10"
  test -d "tmp/43f/2019/m11"
  test -d "tmp/43f/2019/m12"
}

it_creates_month_directories_with_mode() {
  init_repository "tmp/43f" "2019" "1777"
  test -d "tmp/43f/2019/m01"
  test -d "tmp/43f/2019/m02"
  test -d "tmp/43f/2019/m03"
  test -d "tmp/43f/2019/m04"
  test -d "tmp/43f/2019/m05"
  test -d "tmp/43f/2019/m06"
  test -d "tmp/43f/2019/m07"
  test -d "tmp/43f/2019/m08"
  test -d "tmp/43f/2019/m09"
  test -d "tmp/43f/2019/m10"
  test -d "tmp/43f/2019/m11"
  test -d "tmp/43f/2019/m12"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/m01")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/m02")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/m03")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/m04")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/m05")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/m06")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/m07")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/m08")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/m09")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/m10")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/m11")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/m12")" = "1777"
}

it_creates_day_directories() {
  init_repository "tmp/43f" "2019" ""
  test -d "tmp/43f/2019/d01"
  test -d "tmp/43f/2019/d02"
  test -d "tmp/43f/2019/d03"
  test -d "tmp/43f/2019/d04"
  test -d "tmp/43f/2019/d05"
  test -d "tmp/43f/2019/d06"
  test -d "tmp/43f/2019/d07"
  test -d "tmp/43f/2019/d08"
  test -d "tmp/43f/2019/d09"
  test -d "tmp/43f/2019/d10"
  test -d "tmp/43f/2019/d11"
  test -d "tmp/43f/2019/d12"
  test -d "tmp/43f/2019/d13"
  test -d "tmp/43f/2019/d14"
  test -d "tmp/43f/2019/d15"
  test -d "tmp/43f/2019/d16"
  test -d "tmp/43f/2019/d17"
  test -d "tmp/43f/2019/d18"
  test -d "tmp/43f/2019/d19"
  test -d "tmp/43f/2019/d20"
  test -d "tmp/43f/2019/d21"
  test -d "tmp/43f/2019/d22"
  test -d "tmp/43f/2019/d23"
  test -d "tmp/43f/2019/d24"
  test -d "tmp/43f/2019/d25"
  test -d "tmp/43f/2019/d26"
  test -d "tmp/43f/2019/d27"
  test -d "tmp/43f/2019/d28"
  test -d "tmp/43f/2019/d29"
  test -d "tmp/43f/2019/d30"
  test -d "tmp/43f/2019/d31"
}

it_creates_day_directories_with_mode() {
  init_repository "tmp/43f" "2019" "1777"
  test -d "tmp/43f/2019/d01"
  test -d "tmp/43f/2019/d02"
  test -d "tmp/43f/2019/d03"
  test -d "tmp/43f/2019/d04"
  test -d "tmp/43f/2019/d05"
  test -d "tmp/43f/2019/d06"
  test -d "tmp/43f/2019/d07"
  test -d "tmp/43f/2019/d08"
  test -d "tmp/43f/2019/d09"
  test -d "tmp/43f/2019/d10"
  test -d "tmp/43f/2019/d11"
  test -d "tmp/43f/2019/d12"
  test -d "tmp/43f/2019/d13"
  test -d "tmp/43f/2019/d14"
  test -d "tmp/43f/2019/d15"
  test -d "tmp/43f/2019/d16"
  test -d "tmp/43f/2019/d17"
  test -d "tmp/43f/2019/d18"
  test -d "tmp/43f/2019/d19"
  test -d "tmp/43f/2019/d20"
  test -d "tmp/43f/2019/d21"
  test -d "tmp/43f/2019/d22"
  test -d "tmp/43f/2019/d23"
  test -d "tmp/43f/2019/d24"
  test -d "tmp/43f/2019/d25"
  test -d "tmp/43f/2019/d26"
  test -d "tmp/43f/2019/d27"
  test -d "tmp/43f/2019/d28"
  test -d "tmp/43f/2019/d29"
  test -d "tmp/43f/2019/d30"
  test -d "tmp/43f/2019/d31"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/d01")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/d02")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/d03")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/d04")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/d05")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/d06")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/d07")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/d08")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/d09")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/d10")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/d11")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/d12")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/d13")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/d14")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/d15")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/d16")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/d17")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/d18")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/d19")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/d20")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/d21")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/d22")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/d23")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/d24")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/d25")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/d26")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/d27")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/d28")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/d29")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/d30")" = "1777"
  test "$(stat -f "%OMp%OLp" "tmp/43f/2019/d31")" = "1777"
}

it_does_not_create_repository_with_dry_run() {
  dry_run=true
  init_repository "tmp/43f-new" "" ""
  ! test -d "tmp/43f-new"
}

it_does_not_create_repository_with_mode_with_dry_run() {
  dry_run=true
  init_repository "tmp/43f-new" "" "1777"
  ! test -d "tmp/43f-new"
}

it_does_not_create_year_directory_with_dry_run() {
  dry_run=true
  init_repository "tmp/43f" "2000" ""
  ! test -d "tmp/43f/2000"
}

it_does_not_create_year_directory_with_mode_with_dry_run() {
  dry_run=true
  init_repository "tmp/43f" "2000" "1777"
  ! test -d "tmp/43f/2000"
}

it_does_not_create_month_directories_with_dry_run() {
  dry_run=true
  init_repository "tmp/43f" "2019" ""
  ! test -d "tmp/43f/2019/m01"
  ! test -d "tmp/43f/2019/m02"
  ! test -d "tmp/43f/2019/m03"
  ! test -d "tmp/43f/2019/m04"
  ! test -d "tmp/43f/2019/m05"
  ! test -d "tmp/43f/2019/m06"
  ! test -d "tmp/43f/2019/m07"
  ! test -d "tmp/43f/2019/m08"
  ! test -d "tmp/43f/2019/m09"
  ! test -d "tmp/43f/2019/m10"
  ! test -d "tmp/43f/2019/m11"
  ! test -d "tmp/43f/2019/m12"
}

it_does_not_create_month_directories_with_mode_with_dry_run() {
  dry_run=true
  init_repository "tmp/43f" "2019" "1777"
  ! test -d "tmp/43f/2019/m01"
  ! test -d "tmp/43f/2019/m02"
  ! test -d "tmp/43f/2019/m03"
  ! test -d "tmp/43f/2019/m04"
  ! test -d "tmp/43f/2019/m05"
  ! test -d "tmp/43f/2019/m06"
  ! test -d "tmp/43f/2019/m07"
  ! test -d "tmp/43f/2019/m08"
  ! test -d "tmp/43f/2019/m09"
  ! test -d "tmp/43f/2019/m10"
  ! test -d "tmp/43f/2019/m11"
  ! test -d "tmp/43f/2019/m12"
}

it_does_not_create_day_directories_with_dry_run() {
  dry_run=true
  init_repository "tmp/43f" "2019" ""
  ! test -d "tmp/43f/2019/d01"
  ! test -d "tmp/43f/2019/d02"
  ! test -d "tmp/43f/2019/d03"
  ! test -d "tmp/43f/2019/d04"
  ! test -d "tmp/43f/2019/d05"
  ! test -d "tmp/43f/2019/d06"
  ! test -d "tmp/43f/2019/d07"
  ! test -d "tmp/43f/2019/d08"
  ! test -d "tmp/43f/2019/d09"
  ! test -d "tmp/43f/2019/d10"
  ! test -d "tmp/43f/2019/d11"
  ! test -d "tmp/43f/2019/d12"
  ! test -d "tmp/43f/2019/d13"
  ! test -d "tmp/43f/2019/d14"
  ! test -d "tmp/43f/2019/d15"
  ! test -d "tmp/43f/2019/d16"
  ! test -d "tmp/43f/2019/d17"
  ! test -d "tmp/43f/2019/d18"
  ! test -d "tmp/43f/2019/d19"
  ! test -d "tmp/43f/2019/d20"
  ! test -d "tmp/43f/2019/d21"
  ! test -d "tmp/43f/2019/d22"
  ! test -d "tmp/43f/2019/d23"
  ! test -d "tmp/43f/2019/d24"
  ! test -d "tmp/43f/2019/d25"
  ! test -d "tmp/43f/2019/d26"
  ! test -d "tmp/43f/2019/d27"
  ! test -d "tmp/43f/2019/d28"
  ! test -d "tmp/43f/2019/d29"
  ! test -d "tmp/43f/2019/d30"
  ! test -d "tmp/43f/2019/d31"
}

it_does_not_create_day_directories_with_mode_with_dry_run() {
  dry_run=true
  init_repository "tmp/43f" "2019" "1777"
  ! test -d "tmp/43f/2019/d01"
  ! test -d "tmp/43f/2019/d02"
  ! test -d "tmp/43f/2019/d03"
  ! test -d "tmp/43f/2019/d04"
  ! test -d "tmp/43f/2019/d05"
  ! test -d "tmp/43f/2019/d06"
  ! test -d "tmp/43f/2019/d07"
  ! test -d "tmp/43f/2019/d08"
  ! test -d "tmp/43f/2019/d09"
  ! test -d "tmp/43f/2019/d10"
  ! test -d "tmp/43f/2019/d11"
  ! test -d "tmp/43f/2019/d12"
  ! test -d "tmp/43f/2019/d13"
  ! test -d "tmp/43f/2019/d14"
  ! test -d "tmp/43f/2019/d15"
  ! test -d "tmp/43f/2019/d16"
  ! test -d "tmp/43f/2019/d17"
  ! test -d "tmp/43f/2019/d18"
  ! test -d "tmp/43f/2019/d19"
  ! test -d "tmp/43f/2019/d20"
  ! test -d "tmp/43f/2019/d21"
  ! test -d "tmp/43f/2019/d22"
  ! test -d "tmp/43f/2019/d23"
  ! test -d "tmp/43f/2019/d24"
  ! test -d "tmp/43f/2019/d25"
  ! test -d "tmp/43f/2019/d26"
  ! test -d "tmp/43f/2019/d27"
  ! test -d "tmp/43f/2019/d28"
  ! test -d "tmp/43f/2019/d29"
  ! test -d "tmp/43f/2019/d30"
  ! test -d "tmp/43f/2019/d31"
}
