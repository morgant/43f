#!/usr/bin/env roundup

source ./lib43f

describe "lib43f roll_repository_directories()"

before() {
  if [ ! -d tmp ]; then mkdir -p tmp/43f; fi

  # set some global variables that init_repository relies upon
  dry_run=false
  y="$(date +%Y)"
  m="$(date +%m)"
  d="$(date +%d)"

  # set some global variables that roll_repository_directories relies upon
  config_keep_years="3"
  config_keep_months="6"
  config_keep_days="14"

  # init 43f repo with 7 years of folders
  for (( year=$y; year > $(( $y - 7 )); year-- )); do
    init_repository "tmp/43f" "$year"
  done
}

after() {
  rm -r tmp
}

# mock notify to prevent errors
notify() {
  true
}

it_returns_false_if_repository_does_not_exist() {
  ! roll_repository_directories "tmp/43f-test"
}

it_does_not_move_files_modified_today_from_todays_directory() {
  printf -v today "%02i" $(( 10#$d ))
  touch "tmp/43f/${y}/d${today}/test_file"

  roll_repository_directories "tmp/43f"

  test -e "tmp/43f/${y}/d${today}/test_file"
}

it_does_move_files_modified_before_today_from_todays_directory() {
  printf -v today "%02i" $(( 10#$d ))
  printf -v modified_time "%04i%02i%02i0000" $(( $y - 1 )) $(( 10#$m )) $(( 10#$d ))
  touch -t "${modified_time}" "tmp/43f/${y}/d${today}/test_file"

  roll_repository_directories "tmp/43f"

  ! test -e "tmp/43f/${y}/d${today}/test_file"
}

it_does_not_move_files_within_days_to_keep_directories() {
  # create files in all the "to keep" day directories
  for (( i=0; i < $config_keep_days; i++ )); do
    year=$y
    if (( ( 10#$d - 10#$i ) > 0 )); then
      printf -v day "%02i" $(( 10#$d - 10#$i ))
    else
      printf -v day "%02i" $(( 31 - ( 10#$i - 10#$d ) ))
      if (( 10#$m == 1 )); then
        year=$(( $year - 1 ))
      fi
    fi
    touch "tmp/43f/${year}/d${day}/${day}_test_file"
  done

  roll_repository_directories "tmp/43f"

  # all files in the "to keep" day directories should have remained
  for (( i=0; i < $config_keep_days; i++ )); do
    year=$y
    if (( ( 10#$d - 10#$i ) > 0 )); then
      printf -v day "%02i" $(( 10#$d - 10#$i ))
    else
      printf -v day "%02i" $(( 31 - ( 10#$i - 10#$d ) ))
      if (( 10#$m == 1 )); then
        year=$(( $year - 1 ))
      fi
    fi
    test -e "tmp/43f/${year}/d${day}/${day}_test_file"
  done
}

it_does_move_files_outside_days_to_keep_directories() {
  # create files outside of the "to keep" day directories
  year=$y
  for (( i=$config_keep_days; i<31; i++ )); do
    if (( ( 10#$d - 10#$i ) > 0 )); then
      printf -v day "%02i" $(( 10#$d - 10#$i ))
    else
      printf -v day "%02i" $(( 31 - ( 10#$i - 10#$d ) ))
      if (( 10#$day == 31 )); then
        if (( 10#$m == 1 )); then
          year=$(( $year - 1 ))
        fi
      fi
    fi
    touch "tmp/43f/${year}/d${day}/${day}_test_file"
  done

  roll_repository_directories "tmp/43f"

  # all files outside of "to keep" day directories should have been moved to approprieate month directory
  for (( i=$config_keep_days; i<31; i++ )); do
    year=$y
    if (( ( 10#$d - 10#$i ) > 0 )); then
      printf -v day "%02i" $(( 10#$d - 10#$i ))
      printf -v month "%02i" $(( 10#$m ))
    else
      printf -v day "%02i" $(( 31 - ( 10#$i - 10#$d ) ))
      printf -v month "%02i" $(( 10#$m - 1 ))
      if (( 10#$month < 1 )); then
        year=$(( $year - 1 ))
        month=12
      fi
    fi
    ! test -e "tmp/43f/${year}/d${day}/${day}_test_file"
    test -e "tmp/43f/${year}/m${month}/${day}_test_file"
  done
}

#xit_does_move_files_outside_days_to_keep_directories_across_year_boundary

it_does_not_move_files_inside_months_to_keep_directories() {
  # create files in all the "to keep" month directories
  year=$y
  for (( i=0; i < $config_keep_months; i++ )); do
    if (( ( 10#$m - 10#$i ) > 0 )); then
      printf -v month "%02i" $(( 10#$m - 10#$i ))
    else
      printf -v month "%02i" $(( 12 - ( 10#$i - 10#$m ) ))
      if (( 10#$month == 12 )); then
        year=$(( $year - 1 ))
      fi
    fi
    touch "tmp/43f/${year}/m${month}/${month}_test_file"
  done

  roll_repository_directories "tmp/43f"

  # all files in the "to keep" month directories should have remained
  year=$y
  for (( i=0; i < $config_keep_months; i++ )); do
    if (( ( 10#$m - 10#$i ) > 0 )); then
      printf -v month "%02i" $(( 10#$m - 10#$i ))
    else
      printf -v month "%02i" $(( 12 - ( 10#$i - 10#$m ) ))
      if (( 10#$month == 12 )); then
        year=$(( $year - 1 ))
      fi
    fi
    test -e "tmp/43f/${year}/m${month}/${month}_test_file"
  done
}

it_does_move_files_outside_months_to_keep_directories() {
  # create files outside of the "to keep" month directories
  for (( i=$config_keep_months; i<12; i++ )); do
    year=$y
    if (( ( 10#$m - 10#$i ) > 0 )); then
      printf -v month "%02i" $(( 10#$m - 10#$i ))
    else
      printf -v month "%02i" $(( 12 - ( 10#$i - 10#$m ) ))
      year=$(( $year - 1 ))
    fi
    touch "tmp/43f/${year}/m${month}/${month}_test_file"
  done

  roll_repository_directories "tmp/43f"

  # all files outside of "to keep" month directories should have been moved to approprieate month directory
  for (( i=$config_keep_months; i<12; i++ )); do
    # determine which month directory files should have been moved to
    if (( ( 10#$m - ( 10#$config_keep_months - 1 ) ) > 0 )); then
      printf -v keep_month "%02i" $(( 10#$m - ( 10#$config_keep_months - 1 ) ))
      keep_year=$y
    else
      printf -v keep_month "%02i" $(( 12 - ( 10#$config_keep_months - 1 - 10#$m ) ))
      keep_year=$(( $y - 1 ))
    fi

    year=$y
    if (( ( 10#$m - 10#$i ) > 0 )); then
      printf -v month "%02i" $(( 10#$m - 10#$i ))
    else
      printf -v month "%02i" $(( 12 - ( 10#$i - 10#$m ) ))
      year=$(( $year - 1 ))
      keep_year=$(( $keep_year - 1 ))
      keep_month=12
    fi
    ! test -e "tmp/43f/${year}/m${month}/${month}_test_file"
    test -e "tmp/43f/${keep_year}/m${keep_month}/${month}_test_file"
  done
}

it_does_not_delete_directories_inside_years_to_keep_directories() {
  roll_repository_directories "tmp/43f"

  for (( i=0; i<$config_keep_years; i++ )); do
    year=$(( $y - $i ))
    for (( d=1; d<=31; d++ )); do
      printf -v day "%02i" $(( 10#$d ))
      test -e "tmp/43f/${year}/d${day}"
    done
    for (( m=1; m<=12; m++ )); do
      printf -v month "%02i" $(( 10#$m ))
      test -e "tmp/43f/${year}/m${month}"
    done
  done
}

it_does_delete_directories_outside_years_to_keep_directories() {
  roll_repository_directories "tmp/43f"

  for (( i=$config_keep_years; i<7; i++ )); do
    year=$(( $y - $i ))
    ! test -e "tmp/43f/${year}"
  done
}

#it_does_not_consolidate_files_with_different_names
#it_does_consolidate_files_with_same_name_different_date
