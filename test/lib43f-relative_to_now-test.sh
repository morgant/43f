#!/usr/bin/env roundup

source ./lib43f

describe "lib43f relative_to_now()"

it_errors_with_no_adjustment_string() {
  ! relative_to_now "" "+%d"
}

it_doesnt_error_with_a_valid_adjustment_string() {
  relative_to_now "+1d" "+%d"
}

it_errors_without_a_leading_plus_symbol_on_format_string() {
  ! relative_to_now "+1d" "%d"
}

it_doesnt_error_with_a_leading_plus_symbol_on_format_string() {
  relative_to_now "+1d" "+%d"
}

it_adjusts_the_day_by_zero_offset() {
  # without leading +/-
  out="$(relative_to_now "0d" "+%d")"
  test "$out" = "$(date "+%d")"

  # with leading +
  out="$(relative_to_now "+0d" "+%d")"
  test "$out" = "$(date "+%d")"

  # with leading -
  out="$(relative_to_now "-0d" "+%d")"
  test "$out" = "$(date "+%d")"
}

it_adjusts_the_day_forward() {
  out="$(relative_to_now "+1d" "+%d")"
  test "$out" = "$(dadd -f "%d" "$(date "+%Y-%m-%d %H:%M:%S")" "+1d")"
}

it_adjusts_the_day_backward() {
  out="$(relative_to_now "-1d" "+%d")"
  test "$out" = "$(dadd -f "%d" "$(date "+%Y-%m-%d %H:%M:%S")" "-1d")"
}

it_adjusts_the_month_by_zero_offset() {
  # without leading +/-
  out="$(relative_to_now "0m" "+%m")"
  test "$out" = "$(date "+%m")"

  # with leading +
  out="$(relative_to_now "+0m" "+%m")"
  test "$out" = "$(date "+%m")"

  # with leading -
  out="$(relative_to_now "-0m" "+%m")"
  test "$out" = "$(date "+%m")"
}

it_adjusts_the_month_forward() {
  out="$(relative_to_now "+1m" "+%m")"
  test "$out" = "$(dadd -f "%m" "$(date "+%Y-%m-%d %H:%M:%S")" "+1m")"
}

it_adjusts_the_month_backward() {
  out="$(relative_to_now "-1m" "+%m")"
  test "$out" = "$(dadd -f "%m" "$(date "+%Y-%m-%d %H:%M:%S")" "-1m")"
}

it_adjusts_the_year_by_zero_offset() {
  #without leading +/-
  out="$(relative_to_now "0y" "+%Y")"
  test "$out" = "$(date "+%Y")"

  # with leading +
  out="$(relative_to_now "+0y" "+%Y")"
  test "$out" = "$(date "+%Y")"

  # with leading -
  out="$(relative_to_now "-0y" "+%Y")"
  test "$out" = "$(date "+%Y")"
}

it_adjusts_the_year_forward() {
  out="$(relative_to_now "+1y" "+%Y")"
  test "$out" = "$(dadd -f "%Y" "$(date "+%Y-%m-%d %H:%M:%S")" "+1y")"
}

it_adjusts_the_year_backward() {
  out="$(relative_to_now "-1y" "+%Y")"
  test "$out" = "$(dadd -f "%Y" "$(date "+%Y-%m-%d %H:%M:%S")" "-1y")"
}
