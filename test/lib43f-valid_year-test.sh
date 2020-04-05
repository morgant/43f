#!/usr/bin/env roundup

source ./lib43f

describe "lib43f valid_year()"

it_returns_false_if_year_is_less_than_four_digits() {
  ! valid_year 0
}

it_returns_false_if_year_is_greater_than_four_digits() {
  ! valid_year 10000
}

it_returns_true_if_year_has_four_digits() {
  valid_year "$(date +%Y)"
}
