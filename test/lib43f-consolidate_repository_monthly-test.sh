#!/usr/bin/env roundup

source ./lib43f

describe "lib43f consolidate_repository_monthly()"

before() {
  if [ ! -d tmp ]; then mkdir -p tmp/43f; fi

  # set some global variables that init_repository relies upon
  dry_run=false
  y="$(date +%Y)"
  d="$(date +%d)"

  init_repository "tmp/43f" ""

  # set some global variables that compare_date_stamped_filenames relies upon
  config_date_format="%Y%m%d-%H%M%S"
}

after() {
  rm -r tmp
}

# mock notify to prevent errors
notify() {
  true
}

it_returns_false_if_repository_does_not_exist() {
  ! consolidate_repository_monthly "tmp/43f-test" "$y" "12"
}

it_does_not_delete_any_files_if_there_is_only_one_file_in_month_directory() {
  touch "tmp/43f/${y}/m12/test"
  consolidate_repository_monthly "tmp/43f" "$y" "12"
  test -e "tmp/43f/${y}/m12/test"
}

it_does_not_delete_any_files_without_datestamp() {
  touch "tmp/43f/${y}/m12/test"
  touch "tmp/43f/${y}/m12/another_test"
  consolidate_repository_monthly "tmp/43f" "$y" "12"
  test -e "tmp/43f/${y}/m12/test"
  test -e "tmp/43f/${y}/m12/another_test"
}

it_does_not_delete_differing_filenames_with_datestamp() {
  touch "tmp/43f/${y}/m12/test-20191217-120000"
  touch "tmp/43f/${y}/m12/another_test-20191217-130000"
  consolidate_repository_monthly "tmp/43f" "$y" "12"
  test -e "tmp/43f/${y}/m12/test-20191217-120000"
  test -e "tmp/43f/${y}/m12/another_test-20191217-130000"
}

it_does_not_delete_matching_filename_with_newer_datestamp() {
  touch "tmp/43f/${y}/m12/test-20191217-120000"
  touch "tmp/43f/${y}/m12/test-20191217-130000"
  (set +e; consolidate_repository_monthly "tmp/43f" "$y" "12")
  test -e "tmp/43f/${y}/m12/test-20191217-130000"
}

it_does_delete_matching_filename_with_older_datestamp() {
  touch "tmp/43f/${y}/m12/test-20191217-120000"
  touch "tmp/43f/${y}/m12/test-20191217-130000"
  (set +e; consolidate_repository_monthly "tmp/43f" "$y" "12")
  ! test -e "tmp/43f/${y}/m12/test-20191217-120000"
}

it_does_delete_multiple_matching_filenames_with_older_datestamps() {
  touch "tmp/43f/${y}/m12/test-20191217-120000"
  touch "tmp/43f/${y}/m12/test-20191217-130000"
  touch "tmp/43f/${y}/m12/test-20191217-140000"
  touch "tmp/43f/${y}/m12/test-20191217-150000"
  touch "tmp/43f/${y}/m12/test-20191217-160000"
  (set +e; consolidate_repository_monthly "tmp/43f" "$y" "12")
  ! test -e "tmp/43f/${y}/m12/test-20191217-120000"
  ! test -e "tmp/43f/${y}/m12/test-20191217-130000"
  ! test -e "tmp/43f/${y}/m12/test-20191217-140000"
  ! test -e "tmp/43f/${y}/m12/test-20191217-150000"
}

it_does_not_delete_any_matching_filename_with_datestamps_with_dryrun() {
  touch "tmp/43f/${y}/m12/test-20191217-120000"
  touch "tmp/43f/${y}/m12/test-20191217-130000"
  touch "tmp/43f/${y}/m12/test-20191217-140000"
  touch "tmp/43f/${y}/m12/test-20191217-150000"
  touch "tmp/43f/${y}/m12/test-20191217-160000"
  dry_run=true
  (set +e; consolidate_repository_monthly "tmp/43f" "$y" "12")
  test -e "tmp/43f/${y}/m12/test-20191217-120000"
  test -e "tmp/43f/${y}/m12/test-20191217-130000"
  test -e "tmp/43f/${y}/m12/test-20191217-140000"
  test -e "tmp/43f/${y}/m12/test-20191217-150000"
  test -e "tmp/43f/${y}/m12/test-20191217-160000"
}
