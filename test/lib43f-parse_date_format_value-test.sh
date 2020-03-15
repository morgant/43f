#!/usr/bin/env roundup

source ./lib43f

describe "lib43f parse_date_format_value()"

it_returns_full_date_with_empty_format_string() {
  out="$(parse_date_format_value "" "2019-11-23 1517" "%Y")"
  test "$out" = "2019-11-23 1517"
}

it_returns_empty_string_with_empty_date_string() {
  out="$(parse_date_format_value "%Y-%m-%d %H%M" "" "%Y")"
  test "$out" = ""
}

it_returns_empty_string_with_empty_parse_sequence_string() {
  out="$(parse_date_format_value "%Y-%m-%d %H%M" "2019-11-23 1517" "")"
  test "$out" = ""
}

it_parses_four_digit_year_from_date_string() {
  out="$(parse_date_format_value "%Y-%m-%d %H%M" "2019-11-23 1517" "%Y")"
  test "$out" = "2019"
}

it_parses_two_digit_month_from_date_string() {
  out="$(parse_date_format_value "%Y-%m-%d %H%M" "2019-11-23 1517" "%m")"
  test "$out" = "11"
}

it_parses_two_digit_day_from_date_string() {
  out="$(parse_date_format_value "%Y-%m-%d %H%M" "2019-11-23 1517" "%d")"
  test "$out" = "23"
}

it_parses_two_digit_hour_from_date_string() {
  out="$(parse_date_format_value "%Y-%m-%d %H%M" "2019-11-23 1517" "%H")"
  test "$out" = "15"
}

it_parses_two_digit_minute_from_date_string() {
  out="$(parse_date_format_value "%Y-%m-%d %H%M" "2019-11-23 1517" "%M")"
  test "$out" = "17"
}
