#!/usr/bin/env roundup

source ./lib43f

describe "lib43f relative_date()"

it_errors_with_no_adjustment_string() {
  ! relative_date "%Y-%m-%d %H:%M:%S" "$(date "+%Y-%m-%d %H:%M:%S")" "" "+%d"
}

it_doesnt_error_with_valid_adjustment_string() {
  relative_date "%Y-%m-%d %H:%M:%S" "$(date "+%Y-%m-%d %H:%M:%S")" "+1d" "+%d"
}

it_errors_with_leading_plus_symbol_on_in_format_string() {
  ! relative_date "+%Y-%m-%d %H:%M:%S" "$(date "+%Y-%m-%d %H:%M:%S")" "+1d" "+%d"
}

it_doesnt_error_without_leading_plus_symbol_on_in_format_string() {
  relative_date "%Y-%m-%d %H:%M:%S" "$(date "+%Y-%m-%d %H:%M:%S")" "+1d" "+%d"
}

it_errors_without_leading_plus_symbol_on_out_format_string() {
  ! relative_date "%Y-%m-%d %H:%M:%S" "$(date "+%Y-%m-%d %H:%M:%S")" "+1d" "%d"
}

it_doesnt_error_with_leading_plus_symbol_on_out_format_string() {
  relative_date "%Y-%m-%d %H:%M:%S" "$(date "+%Y-%m-%d %H:%M:%S")" "+1d" "+%d"
}

it_does_error_with_no_in_date_string() {
  ! relative_date "%Y-%m-%d %H:%M:%S" "" "+1d" "+%d"
}

it_doesnt_error_with_valid_in_date_string() {
  relative_date "%Y-%m-%d %H:%M:%S" "$(date "+%Y-%m-%d %H:%M:%S")" "+1d" "+%d"
}

it_adjusts_the_day_by_zero_offset() {
  # without leading +/-
  out="$(relative_date "%Y-%m-%d %H:%M:%S" "$(date "+%Y-%m-%d %H:%M:%S")" "0d" "+%d")"
  test "$out" = "$(date "+%d")"

  # with leading +
  out="$(relative_date "%Y-%m-%d %H:%M:%S" "$(date "+%Y-%m-%d %H:%M:%S")" "+0d" "+%d")"
  test "$out" = "$(date "+%d")"

  # with leading -
  out="$(relative_date "%Y-%m-%d %H:%M:%S" "$(date "+%Y-%m-%d %H:%M:%S")" "-0d" "+%d")"
  test "$out" = "$(date "+%d")"
}

it_adjusts_the_day_forward() {
  out="$(relative_date "%Y-%m-%d %H:%M:%S" "$(date "+%Y-%m-%d %H:%M:%S")" "+1d" "+%d")"
  test "$out" = "$(dadd -f "%d" "$(date "+%Y-%m-%d %H:%M:%S")" "+1d")"
}

it_adjusts_the_day_backward() {
  out="$(relative_date "%Y-%m-%d %H:%M:%S" "$(date "+%Y-%m-%d %H:%M:%S")" "-1d" "+%d")"
  test "$out" = "$(dadd -f "%d" "$(date "+%Y-%m-%d %H:%M:%S")" "-1d")"
}

it_adjusts_the_month_by_zero_offset() {
  # without leading +/-
  out="$(relative_date "%Y-%m-%d %H:%M:%S" "$(date "+%Y-%m-%d %H:%M:%S")" "0mo" "+%m")"
  test "$out" = "$(date "+%m")"

  # with leading +
  out="$(relative_date "%Y-%m-%d %H:%M:%S" "$(date "+%Y-%m-%d %H:%M:%S")" "+0mo" "+%m")"
  test "$out" = "$(date "+%m")"

  # with leading -
  out="$(relative_date "%Y-%m-%d %H:%M:%S" "$(date "+%Y-%m-%d %H:%M:%S")" "-0mo" "+%m")"
  test "$out" = "$(date "+%m")"
}

it_adjusts_the_month_forward() {
  out="$(relative_date "%Y-%m-%d %H:%M:%S" "$(date "+%Y-%m-%d %H:%M:%S")" "+1mo" "+%m")"
  test "$out" = "$(dadd -f "%m" "$(date "+%Y-%m-%d %H:%M:%S")" "+1mo")"
}

it_adjusts_the_month_backward() {
  out="$(relative_date "%Y-%m-%d %H:%M:%S" "$(date "+%Y-%m-%d %H:%M:%S")" "-1mo" "+%m")"
  test "$out" = "$(dadd -f "%m" "$(date "+%Y-%m-%d %H:%M:%S")" "-1mo")"
}

it_adjusts_the_year_by_zero_offset() {
  #without leading +/-
  out="$(relative_date "%Y-%m-%d %H:%M:%S" "$(date "+%Y-%m-%d %H:%M:%S")" "0y" "+%Y")"
  test "$out" = "$(date "+%Y")"

  # with leading +
  out="$(relative_date "%Y-%m-%d %H:%M:%S" "$(date "+%Y-%m-%d %H:%M:%S")" "+0y" "+%Y")"
  test "$out" = "$(date "+%Y")"

  # with leading -
  out="$(relative_date "%Y-%m-%d %H:%M:%S" "$(date "+%Y-%m-%d %H:%M:%S")" "-0y" "+%Y")"
  test "$out" = "$(date "+%Y")"
}

it_adjusts_the_year_forward() {
  out="$(relative_date "%Y-%m-%d %H:%M:%S" "$(date "+%Y-%m-%d %H:%M:%S")" "+1y" "+%Y")"
  test "$out" = "$(dadd -f "%Y" "$(date "+%Y-%m-%d %H:%M:%S")" "+1y")"
}

it_adjusts_the_year_backward() {
  out="$(relative_date "%Y-%m-%d %H:%M:%S" "$(date "+%Y-%m-%d %H:%M:%S")" "-1y" "+%Y")"
  test "$out" = "$(dadd -f "%Y" "$(date "+%Y-%m-%d %H:%M:%S")" "-1y")"
}
