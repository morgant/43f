#!/usr/bin/env roundup

source ./lib43f

describe "lib43f valid_day()"

it_returns_false_if_day_is_less_than_one() {
  ! valid_day 0
}

it_returns_false_if_day_is_greater_than_thirty_one() {
  ! valid_day 32
}

it_returns_true_if_day_is_valid() {
  for (( i=1; i<=31; i++ )); do
    valid_day "$i"
  done
}

it_returns_true_if_day_is_valid_with_leading_zero() {
  days="01 02 03 04 05 06 07 08 09"
  for d in $days; do
    valid_day "$d"
  done
}
