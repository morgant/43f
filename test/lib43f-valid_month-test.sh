#!/usr/bin/env roundup

source ./lib43f

describe "lib43f valid_month()"

it_returns_false_if_month_is_less_than_one() {
  ! valid_month 0
}

it_returns_false_if_month_is_greater_than_twelve() {
  ! valid_month 13
}

it_returns_true_if_month_is_valid() {
  for (( i=1; i<=12; i++ )); do
    valid_month "$i"
  done
}

it_returns_true_if_month_is_valid_with_leading_zero() {
  months="01 02 03 04 05 06 07 08 09"
  for m in $months; do
    valid_month "$m"
  done
}
