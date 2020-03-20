#!/usr/bin/env roundup

source ./lib43f

describe "lib43f init_repository_symlinks()"

before() {
  if [ ! -d tmp ]; then mkdir -p tmp/43f; fi
  init_repository "tmp/43f" ""

  # set some global variables that init_repository relies upon
  dry_run=false
  y="$(date +%Y)"
  d="$(date +%d)"
}

after() {
  rm -r tmp
}

# mock notify to prevent errors
notify() {
  true
}

it_returns_false_with_empty_repository_path() {
  ! init_repository_symlinks ""
}

it_returns_true_with_initialized_repostory() {
  init_repository_symlinks "tmp/43f"
}

it_returns_false_with_uninitialized_repository() {
  mkdir "tmp/43f-empty"
  ! init_repository_symlinks "tmp/43f-empty"
}

it_creates_today_symlink() {
  init_repository_symlinks "tmp/43f"
  test -h "tmp/43f/today"
  test "$(readlink "tmp/43f/today")" = "tmp/43f/$(date +%Y)/d$(date +%d)"
}

it_does_not_create_today_symlink_with_dry_run() {
  dry_run=true
  init_repository_symlinks "tmp/43f"
  ! test -h "tmp/43f/today"
}

it_creates_yesterday_symlink() {
  init_repository_symlinks "tmp/43f"
  test -h "tmp/43f/yesterday"
  test "$(readlink "tmp/43f/yesterday")" = "tmp/43f/$(dadd -f %Y "$(date "+%Y-%m-%d %H:%M:%S")" -1d)/d$(dadd -f %d "$(date "+%Y-%m-%d %H:%M:%S")" -1d)"
}

it_does_not_create_yesterday_symlink_with_dry_run() {
  dry_run=true
  init_repository_symlinks "tmp/43f"
  ! test -h "tmp/43f/yesterday"
}

it_creates_weekday_symlinks() {
  init_repository_symlinks "tmp/43f"
  now="$(date "+%Y-%m-%d %H:%M:%S")"
  # past weekdays
  for i in 1 2 3 4 5 6 7; do
    year="$(dadd -f %Y "$now" "-${i}d")"
    day="$(dadd -f %d "$now" "-${i}d")"
    weekday="$(dadd -f %A "$now" "-${i}d" | tr '[:upper:]' '[:lower:]')"
    test -h "tmp/43f/${weekday}"
    test "$(readlink "tmp/43f/${weekday}")" = "tmp/43f/${year}/d${day}"
  done
}

it_does_not_create_weekday_symlinks_with_dry_run() {
  dry_run=true
  init_repository_symlinks "tmp/43f"
  ! test -h "tmp/43f/sunday"
  ! test -h "tmp/43f/monday"
  ! test -h "tmp/43f/tuesday"
  ! test -h "tmp/43f/wednesday"
  ! test -h "tmp/43f/thursday"
  ! test -h "tmp/43f/friday"
  ! test -h "tmp/43f/saturday"
}
