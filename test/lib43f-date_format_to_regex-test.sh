#!/usr/bin/env roundup

source ./lib43f

describe "lib43f date_format_to_regex()"

it_returns_an_empty_string_with_an_empty_date_format_string() {
  out="$(date_format_to_regex "")"
  test "$out" = ""
}

it_does_not_modify_string_with_no_date_format_conversion_specifications() {
  out="$(date_format_to_regex "something")"
  test "$out" = "something"
}

# conversion specifications

it_replaces_percent_Y_with_year_regex_in_date_format_string() {
  out="$(date_format_to_regex "%Y")"
  test "$out" = "([0-9]{4})"
}

it_replaces_percent_m_with_month_regex_in_date_format_string() {
  out="$(date_format_to_regex "%m")"
  test "$out" = "(0[123456789]|1[012])"
}

it_replaces_percent_d_with_day_regex_in_date_format_string() {
  out="$(date_format_to_regex "%d")"
  test "$out" = "(0[123456789]|[12][0-9]|3[01])"
}

it_replaces_percent_H_with_hour_regex_in_date_format_string() {
  out="$(date_format_to_regex "%H")"
  test "$out" = "([01][0-9]|2[0123])"
}

it_replaces_percent_M_with_minute_regex_in_date_format_string() {
  out="$(date_format_to_regex "%M")"
  test "$out" = "([012345][0-9])"
}

it_replaces_percent_S_with_second_regex_in_date_format_string() {
  out="$(date_format_to_regex "%S")"
  test "$out" = "([012345][0-9])"
}

it_replaces_double_percent_with_single_percent_in_date_format_string() {
  out="$(date_format_to_regex "%%")"
  test "$out" = "%"
}

it_replaces_multiple_conversion_specifications_in_date_format_string() {
  out="$(date_format_to_regex "%Y%m%d%H%M%S")"
  test "$out" = "([0-9]{4})(0[123456789]|1[012])(0[123456789]|[12][0-9]|3[01])([01][0-9]|2[0123])([012345][0-9])([012345][0-9])"
}
