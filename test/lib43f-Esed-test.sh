#!/usr/bin/env roundup

source ./lib43f

describe "lib43f Esed()"

it_replaces_percent_Y_with_year_regex() {
  out="$(echo -n "%Y" | Esed "s/%Y/([0-9]{4})/g" | head -n 1)"
  test "$out" = "([0-9]{4})"
}

it_replaces_percent_m_with_month_regex() {
  out="$(echo -n "%m" | Esed "s/%m/(0[123456789]|1[012])/g" | head -n 1)"
  test "$out" = "(0[123456789]|1[012])"
}

it_replaces_percent_d_with_day_regex() {
  out="$(echo -n "%d" | Esed "s/%d/(0[123456789]|[12][0-9]|3[01])/g" | head -n 1)"
  test "$out" = "(0[123456789]|[12][0-9]|3[01])"
}

it_replaces_percent_H_with_hours_regex() {
  out="$(echo -n "%H" | Esed "s/%H/([01][0-9]|2[0123])/g" | head -n 1)"
  test "$out" = "([01][0-9]|2[0123])"
}

it_replaces_percent_M_with_minutes_regex() {
  out="$(echo -n "%M" | Esed "s/%M/([012345][0-9])/g" | head -n 1)"
  test "$out" = "([012345][0-9])"
}

it_replaces_percent_S_with_seconds_regex() {
  out="$(echo -n "%S" | Esed "s/%S/([012345][0-9])/g" | head -n 1)"
  test "$out" = "([012345][0-9])"
}

it_replaces_percent_percent_with_percent() {
  out="$(echo -n "%%" | Esed "s/%%/%/g" | head -n 1)"
  test "$out" = "%"
}
