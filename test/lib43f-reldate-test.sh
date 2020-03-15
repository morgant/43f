#!/usr/bin/env roundup

source ./lib43f

describe "lib43f reldate()"

it_errors_with_no_adjustment_string() {
  ! reldate "" "%d"
}

it_doesnt_error_with_a_valid_adjustment_string() {
  reldate "+1d" "%d"
}

it_errors_without_a_leading_plus_symbol_on_format_string() {
  ! reldate "+1d" "%d"
}

it_doesnt_error_with_a_leading_plus_symbol_on_format_string() {
  reldate "+1d" "+%d"
}

it_adjusts_the_day_forward() {
  out="$(reldate "+1d" "+%d")"
  test "$out" = "$(dadd -f "%d" "$(date "+%Y-%m-%d %H:%M:%S")" "+1d")"
}

it_adjusts_the_day_backward() {
  out="$(reldate "-1d" "+%d")"
  test "$out" = "$(dadd -f "%d" "$(date "+%Y-%m-%d %H:%M:%S")" "-1d")"
}

it_adjusts_the_month_forward() {
  out="$(reldate "+1m" "+%m")"
  test "$out" = "$(dadd -f "%m" "$(date "+%Y-%m-%d %H:%M:%S")" "+1m")"
}

it_adjusts_the_month_backward() {
  out="$(reldate "-1m" "+%m")"
  test "$out" = "$(dadd -f "%m" "$(date "+%Y-%m-%d %H:%M:%S")" "-1m")"
}

it_adjusts_the_year_forward() {
  out="$(reldate "+1y" "+%Y")"
  test "$out" = "$(dadd -f "%Y" "$(date "+%Y-%m-%d %H:%M:%S")" "+1y")"
}

it_adjusts_the_year_backward() {
  out="$(reldate "-1y" "+%Y")"
  test "$out" = "$(dadd -f "%Y" "$(date "+%Y-%m-%d %H:%M:%S")" "-1y")"
}
