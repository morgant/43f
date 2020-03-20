#!/usr/bin/env roundup

source ./lib43f

describe "lib43f compare_date_stamped_filenames()"

before() {
  config_date_format="%Y%m%d-%H%M%S"
}

it_returns_zero_for_emtpy_filenames() {
  compare_date_stamped_filenames "" ""
  test $? -eq 0
}

it_returns_zero_if_the_filenames_do_not_match() {
  compare_date_stamped_filenames "foo" "bar"
  test $? -eq 0
}

it_returns_zero_if_filenames_match_but_do_not_contain_date() {
  compare_date_stamped_filenames "foo" "foo"
  test $? -eq 0
}

it_returns_zero_if_filenames_do_not_match_but_contain_matching_dates() {
  compare_date_stamped_filenames "foo-20191203-184400" "bar-20191203-184400"
  test $? -eq 0
}

it_returns_one_if_filenames_match_and_first_date_greater_than_second_date() {
  if compare_date_stamped_filenames "foo-20191203-184400" "foo-20191203-184200"; then
    false
  else
    test $? -eq 1
  fi
}

it_returns_two_if_filenames_match_and_first_date_less_than_second_date() {
  if compare_date_stamped_filenames "foo-20191203-184400" "foo-20191203-184600"; then
    false
  else
    test $? -eq 2
  fi
}
