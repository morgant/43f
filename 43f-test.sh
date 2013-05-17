#!/usr/bin/env roundup

describe "43f"

before() {
	# make a temp dir
	if [ ! -d tmp ]; then
		mkdir tmp
	fi
	
	# make a valid temp config
	touch tmp/temp.conf
	cat << 'EOF' > tmp/temp.conf
repository=tmp
notify=morgan@smalldog.com
days=7
months=6
years=3
datestamp=%Y-%m-%d
EOF
}

after() {
	rm -rf tmp
}

it_fails_with_no_args() {
	out="$(./43f | head -n 1)"
	test "$out" = "No options or arguments were specified!"
}

it_displays_usage() {
	out="$(./43f -h | head -n 1)"
	test "$out" = "Usage: 43f [-h|-t|-V] [-v] [-c file] COMMAND"
}

it_fails_initialze_repository_with_no_path() {
	out="$(./43f init | head -n 1)"
	test "$out" = "ERROR! Cannot initialize repository with empty path!"
}

it_initializes_repository() {
	success=0
	if ./43f init tmp; then
		# was the year directory created?
		y="$(date +%Y)"
		if [ ! -d "tmp/$y" ]; then success=1; fi
		# were the month directories created?
		for (( i=1; i<=12; i++ )); do
			printf -v m "%02i" "$i"
			if [ ! -d "tmp/${y}/m${m}" ]; then success=1; fi
		done
		# were the day directories created?
		for (( i=1; i<=31; i++ )); do
			printf -v d "%02i" "$i"
			if [ ! -d "tmp/${y}/d${d}" ]; then success=1; fi
		done
	else
		success=1
	fi
	return $success;
}

it_passes_config_test_with_valid_config() {
	out="$(./43f -c tmp/temp.conf -t | head -n 1)"
	test "$out" = "Config file 'tmp/temp.conf' loaded & tested successfully."
}

it_fails_config_test_with_invalid_repository() {
	cat tmp/temp.conf | sed -E 's/^repository=.+$/repository=tmp\/nonexistent/' > tmp/invalid.conf
	out="$(./43f -c tmp/invalid.conf -t | head -n 1)"
	test "$out" = "  ERROR! 'repository' value in config file is either invalid or not a directory! You may need to run '43f init' to initialize the repository."
}

it_fails_config_test_with_invalid_notify() {
	cat tmp/temp.conf | sed -E 's/^notify=.+$/notify=morgan@smalldogcom/' > tmp/invalid.conf
	out="$(./43f -c tmp/invalid.conf -t | head -n 1)"
	test "$out" = "  ERROR! 'notify' value in config file is not a valid email address!"
}

it_fails_config_test_with_invalid_days() {
	cat tmp/temp.conf | sed -E 's/^days=.+$/days=32/' > tmp/invalid.conf
	out="$(./43f -c tmp/invalid.conf -t | head -n 1)"
	test "$out" = "  ERROR! 'days' value in config file is out of range (1-31)!"
}

it_fails_config_test_with_invalid_months() {
	cat tmp/temp.conf | sed -E 's/^months=.+$/months=13/' > tmp/invalid.conf
	out="$(./43f -c tmp/invalid.conf -t | head -n 1)"
	test "$out" = "  ERROR! 'months' value in config file is out of range (1-12)!"
}

it_fails_config_test_with_invalid_years() {
	cat tmp/temp.conf | sed -E 's/^years=.+$/years=0/' > tmp/invalid.conf
	out="$(./43f -c tmp/invalid.conf -t | head -n 1)"
	test "$out" = "  ERROR! 'years' value in config file is out of range (1+)!"
}

it_fails_config_test_with_invalid_datestamp() {
	cat tmp/temp.conf | sed -E 's/^datestamp=.+$/datestamp=Z/' > tmp/invalid.conf
	out="$(./43f -c tmp/invalid.conf -t | head -n 1)"
	test "$out" = "  ERROR! 'datestamp' value in config file is out of range!"
}

