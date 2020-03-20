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
  ! init_repository "" ""
}

it_creates_repository_if_repository_path_does_not_exist() {
  init_repository "tmp/43f-new" ""
  test -d "tmp/43f-new"
}

it_returns_false_with_invalid_year_string() {
  ! init_repository "tmp/43f" "A113"
}

it_creates_year_directory_for_current_year_with_empty_year_string() {
  init_repository "tmp/43f" ""
  test -d "tmp/43f/$(date +%Y)"
}

it_creates_year_directory_for_year_string() {
  init_repository "tmp/43f" "2000"
  test -d "tmp/43f/2000"
}

it_creates_month_directories() {
  init_repository "tmp/43f" "2019"
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

it_creates_day_directories() {
  init_repository "tmp/43f" "2019"
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

it_does_not_create_repository_with_dry_run() {
  dry_run=true
  init_repository "tmp/43f-new" ""
  ! test -d "tmp/43f-new"
}

it_does_not_create_year_directory_with_dry_run() {
  dry_run=true
  init_repository "tmp/43f" "2000"
  ! test -d "tmp/43f/2000"
}

it_does_not_create_month_directories_with_dry_run() {
  dry_run=true
  init_repository "tmp/43f" "2019"
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
  init_repository "tmp/43f" "2019"
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
