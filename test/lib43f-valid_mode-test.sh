#!/usr/bin/env roundup

source ./lib43f

describe "lib43f valid_mode()"

it_returns_false_if_mode_is_less_than_three_digits() {
  ! valid_mode 7
}

it_returns_false_if_mode_is_greater_than_four_digits() {
  ! valid_mode 31337
}

it_returns_false_if_mode_contains_non_octal_digits() {
  ! valid_mode 8989
}

it_returns_true_if_mode_has_three_octal_digits() {
  valid_mode 777
}

it_returns_true_if_mode_has_four_octal_digits() {
  valid_mode 2777
}
