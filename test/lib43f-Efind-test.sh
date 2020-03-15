#!/usr/bin/env roundup

source ./lib43f

describe "lib43f Efind()"

before() {
  if [ ! -d tmp ]; then mkdir tmp; fi
}

after() {
  rm -r tmp
}

it_finds_files_with_dot_star_regex() {
  out="$(Efind . ".*" | head -n 1)"
  test "$out" = "."
}

it_finds_files_with_test_file_regex() {
  out="$(Efind . ".*-test\.sh" | head -n 1)"
  test "$out" = "./test/43f-test.sh"
}

it_finds_files_with_year_regex() {
  touch tmp/file_with_year-2019.txt
  out="$(Efind tmp "[0-9]{4}" | head -n 1)"
  rm tmp/file_with_year-2019.txt
  test "$out" = "tmp/file_with_year-2019.txt"
}
