#!/usr/bin/env roundup

source ./lib43f

describe "lib43f days_in_previous_month()"

it_returns_a_valid_number_of_days() {
  out="$(days_in_previous_month)"
  test "$out" -ge 28 -a "$out" -le 31
}
