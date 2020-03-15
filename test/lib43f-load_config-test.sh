#!/usr/bin/env roundup

source ./lib43f

describe "lib43f load_config()"

before() {
  if [ ! -d tmp ]; then mkdir -p tmp/43f; fi
}

after() {
  rm -r tmp
}

# mock notify to prevent errors
notify() {
  true
}

it_errors_with_blank_config_file_path() {
  ! load_config ""
}

it_errors_with_invalid_config_file_path() {
  ! load_config "tmp/43f-invalid.conf"
}

it_loads_empty_config_file() {
  echo "" > "tmp/43f-empty.conf"
  load_config "tmp/43f-empty.conf"
}

# comments & unknown variables

it_ignores_comments_in_config_file() {
  echo "# this is a comment" > "tmp/43f-comment.conf"
  load_config "tmp/43f-comment.conf"
}

it_ignores_unknown_variables_with_no_equals_symbol_in_config_file() {
  echo "unknown" > "tmp/43f-unknown.conf"
  load_config "tmp/43f-unknown.conf"
}

it_ignores_unknown_variables_in_config_file() {
  echo "unknown=nothing" > "tmp/43f-unknown.conf"
  load_config "tmp/43f-unknown.conf"
}

# repository

it_errors_with_empty_repository_in_config_file() {
  echo "repository=" > "tmp/43f-repository.conf"
  ! load_config "tmp/43f-respository.conf"
}

it_errors_with_non_directory_repository_in_config_file() {
  echo "repository=tmp/43f-repository.conf" > "tmp/43f-repository.conf"
  ! load_config "tmp/45f-repository.conf"
}

it_sets_config_repository_with_directory_repository_in_config_file() {
  echo "repository=tmp/43f" > "tmp/43f-repository.conf"
  load_config "tmp/43f-repository.conf"
  test "$config_repository" = "tmp/43f"
}

# notify

it_errors_with_empty_notify_in_config_file() {
  echo "notify=" > "tmp/43f-notify.conf"
  ! load_config "tmp/43f-notify.conf"
}

it_errors_with_invalid_notify_in_config_file() {
  echo "notify=somebody" > "tmp/43f-notify.conf"
  ! load_config "tmp/43f-notify.conf"
}

it_sets_config_notify_email_with_valid_notify_in_config_file() {
  echo "notify=somebody@example.com" > "tmp/43f-notify.conf"
  load_config "tmp/43f-notify.conf"
  test "$config_notify_email" = "somebody@example.com"
}

it_sets_config_notify_email_with_valid_long_tld_notify_in_config_file() {
  echo "notify=somebody@example.business" > "tmp/43f-notify.conf"
  load_config "tmp/43f-notify.conf"
  test "$config_notify_email" = "somebody@example.business"
}

# days

it_errors_with_empty_days_in_config_file() {
  echo "days=" > "tmp/43f-days.conf"
  ! load_config "tmp/43f-days.conf"
}

it_errors_with_zero_days_in_config_file() {
  echo "days=0" > "tmp/43f-days.conf"
  ! load_config "tmp/43f-days.conf"
}

it_errors_with_greater_than_31_days_in_config_file() {
  echo "days=32" > "tmp/43f-days.conf"
  ! load_config "tmp/43f-days.conf"
}

it_sets_config_keep_days_with_valid_days_in_config_file() {
  echo "days=31" > "tmp/43f-days.conf"
  load_config "tmp/43f-days.conf"
  test "$config_keep_days" = "31"
}

# months

it_errors_with_empty_months_in_config_file() {
  echo "months=" > "tmp/43f-months.conf"
  ! load_config "tmp/43f-months.conf"
}

it_errors_with_zero_months_in_config_file() {
  echo "months=0" > "tmp/43f-months.conf"
  ! load_config "tmp/43f-months.conf"
}

it_errors_with_greater_than_12_months_in_config_file() {
  echo "months=13" > "tmp/43f-months.conf"
  ! load_config "tmp/43f-months.conf"
}

it_sets_config_keep_months_with_valid_months_in_config_file() {
  echo "months=12" > "tmp/43f-months.conf"
  load_config "tmp/43f-months.conf"
  test "$config_keep_months" = "12"
}

# years

it_errors_with_empty_years_in_config_file() {
  echo "years=" > "tmp/43f-years.conf"
  ! load_config "tmp/43f-years.conf"
}

it_errors_with_zero_years_in_config_file() {
  echo "years=0" > "tmp/43f-years.conf"
  ! load_config "tmp/43f-years.conf"
}

it_sets_config_keep_years_with_valid_years_in_config_file() {
  echo "years=7" > "tmp/43f-years.conf"
  load_config "tmp/43f-years.conf"
  test "$config_keep_years" = "7"
}

# datestamp

it_errors_with_empty_datestamp_in_config_file() {
  echo "datestamp=" > "tmp/43f-datestamp.conf"
  ! load_config "tmp/43f-datestamp.conf"
}

it_errors_with_spaces_in_datestamp_in_config_file() {
  echo "datestamp=Ymd HMS" > "tmp/43f-datestamp.conf"
  ! load_config "tmp/43f-datestamp.conf"
}

it_error_with_invalid_characters_in_datestamp_in_config_file() {
  echo "datestamp=ABCDEFGIJKLNOPQRTUVWXYZabcefghijklnopqrstuvwxyz01234567890" > "tmp/43f-datestamp.conf"
  ! load_config "tmp/43f-datestamp.conf"
}

it_sets_config_date_format_with_valid_datestamp_in_config_file() {
  echo "datestamp=Ymd-HMS" > "tmp/43f-datestamp.conf"
  load_config "tmp/43f-datestamp.conf"
  test "$config_date_format" = "Ymd-HMS"
}
