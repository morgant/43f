#!/usr/bin/env roundup

source ./lib43f

describe "lib43f convdatestr()"

it_errors_with_blank_input_format_string() {
  ! convdatestr "" "2019-11-23 1517" "+%s"
}

it_errors_with_blank_date_string() {
  ! convdatestr "%Y-%m-%d %H%M" "" "+%s"
}

it_errors_with_blank_output_format_string() {
  ! convdatestr "%Y-%m-%d %H%M" "2019-11-23 1517" ""
}

it_converts_date_to_seconds() {
  out="$(convdatestr "%Y-%m-%d %H%M%S" "2019-11-23 151700" "+%s")"
  test "$out" = "1574540220"
}
