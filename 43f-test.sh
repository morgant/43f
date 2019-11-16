#!/usr/bin/env roundup

describe "43f"

# temporarily set the date & time using the specified format string & value with the ability to restore the original date & time later (adjusted for the time spent with the temporary date & time)
start_date_test() {
	original_start_time=$(date +%s)
	date -f "$1" "$2"
	temp_start_time=$(date +%s)
}

# restore the original date & time from when start_date_test() was called (adjusted for the time spent in the temporary date & time)
stop_date_test() {
	date -f "%s" $(( $(date +%s) - $temp_start_time + $original_start_time ))
}

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
	out="$(./43f -N init | head -n 1)"
	test "$out" = "ERROR! Cannot initialize repository with empty path!"
}

it_initializes_repository() {
	success=0
	if ./43f -N init tmp; then
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

it_initializes_repository_with_spaces_in_path() {
	success=0
	if ./43f -N init "tmp/repo with spaces"; then
		# was the year directory created?
		y="$(date +%Y)"
		if [ ! -d "tmp/repo with spaces/$y" ]; then success=1; fi
		# were the month directories created?
		for (( i=1; i<=12; i++ )); do
			printf -v m "%02i" "$i"
			if [ ! -d "tmp/repo with spaces/${y}/m${m}" ]; then success=1; fi
		done
		# were the day directories created?
		for (( i=1; i<=31; i++ )); do
			printf -v d "%02i" "$i"
			if [ ! -d "tmp/repo with spaces/${y}/d${d}" ]; then success=1; fi
		done
	else
		success=1
	fi
	return $success;
}

it_fails_initialze_repository_with_invalid_year() {
	out="$(./43f -N init tmp qwerty | head -n 1)"
	test "$out" = "ERROR! Cannot initialize repository with invalid year 'qwerty'!"
}

it_initializes_repository_with_year() {
	success=0
	if ./43f -N init tmp 2012; then
		# was the year directory created?
		y=2012
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
	out="$(./43f -N -c tmp/temp.conf -t | head -n 1)"
	test "$out" = "Config file 'tmp/temp.conf' loaded & tested successfully."
}

it_fails_config_test_with_invalid_repository() {
	cat tmp/temp.conf | sed -E 's/^repository=.+$/repository=tmp\/nonexistent/' > tmp/invalid.conf
	out="$(./43f -N -c tmp/invalid.conf -t | head -n 1)"
	test "$out" = "  ERROR! 'repository' value in config file is either invalid or not a directory! You may need to run '43f init' to initialize the repository."
}

it_fails_config_test_with_invalid_notify() {
	cat tmp/temp.conf | sed -E 's/^notify=.+$/notify=morgan@smalldogcom/' > tmp/invalid.conf
	out="$(./43f -N -c tmp/invalid.conf -t | head -n 1)"
	test "$out" = "  ERROR! 'notify' value in config file is not a valid email address!"
}

it_fails_config_test_with_invalid_days() {
	cat tmp/temp.conf | sed -E 's/^days=.+$/days=32/' > tmp/invalid.conf
	out="$(./43f -N -c tmp/invalid.conf -t | head -n 1)"
	test "$out" = "  ERROR! 'days' value in config file is out of range (1-31)!"
}

it_fails_config_test_with_invalid_months() {
	cat tmp/temp.conf | sed -E 's/^months=.+$/months=13/' > tmp/invalid.conf
	out="$(./43f -N -c tmp/invalid.conf -t | head -n 1)"
	test "$out" = "  ERROR! 'months' value in config file is out of range (1-12)!"
}

it_fails_config_test_with_invalid_years() {
	cat tmp/temp.conf | sed -E 's/^years=.+$/years=0/' > tmp/invalid.conf
	out="$(./43f -N -c tmp/invalid.conf -t | head -n 1)"
	test "$out" = "  ERROR! 'years' value in config file is out of range (1+)!"
}

it_fails_config_test_with_invalid_datestamp() {
	cat tmp/temp.conf | sed -E 's/^datestamp=.+$/datestamp=Z/' > tmp/invalid.conf
	out="$(./43f -N -c tmp/invalid.conf -t | head -n 1)"
	test "$out" = "  ERROR! 'datestamp' value in config file is out of range!"
}

xit_does_create_year_directory_on_january_1st() {
	success=0
	
	# temporarily change the date to the first of the year
	y="$(date +%Y)"
	start_date_test "%Y-%m-%d" "${y}-01-01"
	
	# do just a `43f run` and see if the new year directory was created
	if ./43f -Nv -c tmp/temp.conf run; then
		# was the year directory created?
		if [ ! -d "tmp/$y" ]; then success=1; fi
		# were the month directories created? (they should have been)
		for (( i=1; i<=12; i++ )); do
			printf -v m "%02i" "$i"
			if [ ! -d "tmp/${y}/m${m}" ]; then success=1; fi
		done
		# were the day directories created? (they should have been)
		for (( i=1; i<=31; i++ )); do
			printf -v d "%02i" "$i"
			if [ ! -d "tmp/${y}/d${d}" ]; then success=1; fi
		done
	else
		success=1
	fi
	
	# restore the date & time
	stop_date_test
	
	return $success;
}

xit_does_not_create_year_directory_after_january_1st() {
	success=0
	
	# temporarily change the date to the first of the year
	y="$(date +%Y)"
	start_date_test "%Y-%m-%d" "${y}-01-02"
	
	# do just a `43f run` and see if the new year directory was created
	if ./43f -Nv -c tmp/temp.conf run; then
		# was the year directory created?
		if [ -d "tmp/$y" ]; then success=1; fi
		# were the month directories created? (they should not have been)
		for (( i=1; i<=12; i++ )); do
			printf -v m "%02i" "$i"
			if [ -d "tmp/${y}/m${m}" ]; then success=1; fi
		done
		# were the day directories created? (they should not have been)
		for (( i=1; i<=31; i++ )); do
			printf -v d "%02i" "$i"
			if [ -d "tmp/${y}/d${d}" ]; then success=1; fi
		done
	else
		success=1
	fi
	
	# restore the date & time
	stop_date_test
	
	return $success;
}

it_does_create_convenience_symlinks() {
	success=0
	
	# build the today, yesterday, and sunday-saturday paths to check symlinks against (remember, they should always be <= today)
	printf -v today "tmp/%04i/d%02i" "$(( 10#$(date +%Y) ))" "$(( 10#$(date +%d) ))"
	printf -v yesterday "tmp/%04i/d%02i" "$(( 10#$(date -j -v-1d +%Y) ))" "$(( 10#$(date -j -v-1d +%d) ))"
	if [ "$(date +%A)" != "Sunday" ]; then
		printf -v sunday "tmp/%04i/d%02i" "$(( 10#$(date -j -v-sunday +%Y) ))" "$(( 10#$(date -j -v-sunday +%d) ))"
	else
		printf -v sunday "tmp/%04i/d%02i" "$(( 10#$(date -j -v-1w +%Y) ))" "$(( 10#$(date -j -v-1w +%d) ))"
	fi
	if [ "$(date +%A)" != "Monday" ]; then
		printf -v monday "tmp/%04i/d%02i" "$(( 10#$(date -j -v-monday +%Y) ))" "$(( 10#$(date -j -v-monday +%d) ))"
	else
		printf -v monday "tmp/%04i/d%02i" "$(( 10#$(date -j -v-1w +%Y) ))" "$(( 10#$(date -j -v-1w +%d) ))"
	fi
	if [ "$(date +%A)" != "Tuesday" ]; then
		printf -v tuesday "tmp/%04i/d%02i" "$(( 10#$(date -j -v-tuesday +%Y) ))" "$(( 10#$(date -j -v-tuesday +%d) ))"
	else
		printf -v tuesday "tmp/%04i/d%02i" "$(( 10#$(date -j -v-1w +%Y) ))" "$(( 10#$(date -j -v-1w +%d) ))"
	fi
	if [ "$(date +%A)" != "Wednesday" ]; then
		printf -v wednesday "tmp/%04i/d%02i" "$(( 10#$(date -j -v-wednesday +%Y) ))" "$(( 10#$(date -j -v-wednesday +%d) ))"
	else
		printf -v wednesday "tmp/%04i/d%02i" "$(( 10#$(date -j -v-1w +%Y) ))" "$(( 10#$(date -j -v-1w +%d) ))"
	fi
	if [ "$(date +%A)" != "Thursday" ]; then
		printf -v thursday "tmp/%04i/d%02i" "$(( 10#$(date -j -v-thursday +%Y) ))" "$(( 10#$(date -j -v-thursday +%d) ))"
	else
		printf -v thursday "tmp/%04i/d%02i" "$(( 10#$(date -j -v-1w +%Y) ))" "$(( 10#$(date -j -v-1w +%d) ))"
	fi
	if [ "$(date +%A)" != "Friday" ]; then
		printf -v friday "tmp/%04i/d%02i" "$(( 10#$(date -j -v-friday +%Y) ))" "$(( 10#$(date -j -v-friday +%d) ))"
	else
		printf -v friday "tmp/%04i/d%02i" "$(( 10#$(date -j -v-1w +%Y) ))" "$(( 10#$(date -j -v-1w +%d) ))"
	fi
	if [ "$(date +%A)" != "Saturday" ]; then
		printf -v saturday "tmp/%04i/d%02i" "$(( 10#$(date -j -v-saturday +%Y) ))" "$(( 10#$(date -j -v-saturday +%d) ))"
	else
		printf -v saturday "tmp/%04i/d%02i" "$(( 10#$(date -j -v-1w +%Y) ))" "$(( 10#$(date -j -v-1w +%d) ))"
	fi
	
	# do `43f run`
	./43f -N init tmp
	./43f -N -c tmp/temp.conf run
	
	# it should have created symlinks for today, yesterday, and sunday-saturday
	if [ ! -L "tmp/today" -o "$today" != "$(readlink tmp/today)" ]; then
		success=1
	fi
	if [ ! -L "tmp/yesterday" -o "$yesterday" != "$(readlink tmp/yesterday)" ]; then
		success=1
	fi
	if [ ! -L "tmp/sunday" -o "$sunday" != "$(readlink tmp/sunday)" ]; then
		success=1
	fi
		if [ ! -L "tmp/monday" -o "$monday" != "$(readlink tmp/monday)" ]; then
		success=1
	fi
	if [ ! -L "tmp/tuesday" -o "$tuesday" != "$(readlink tmp/tuesday)" ]; then
		success=1
	fi
	if [ ! -L "tmp/wednesday" -o "$wednesday" != "$(readlink tmp/wednesday)" ]; then
		success=1
	fi
	if [ ! -L "tmp/thursday" -o "$thursday" != "$(readlink tmp/thursday)" ]; then
		success=1
	fi
	if [ ! -L "tmp/friday" -o "$friday" != "$(readlink tmp/friday)" ]; then
		success=1
	fi
	if [ ! -L "tmp/saturday" -o "$saturday" != "$(readlink tmp/saturday)" ]; then
		success=1
	fi
	return $success
}

it_does_not_move_files_modified_today_from_todays_dir() {
	y="$(date +%Y)"
	printf -v d "d%02i" "$(( 10#$(date +%d) ))"
	
	# create a file in today's directory (leaving creation/modification time set to today) and do `43f run`
	./43f -N init tmp
	touch "tmp/${y}/${d}/test_file"
	./43f -N -c tmp/temp.conf run
	
	# it should've stayed put in today's directory
	test -f "tmp/${y}/${d}/test_file"
}

it_does_move_files_modified_last_month_from_todays_dir() {
	y="$(date +%Y)"
	printf -v d "d%02i" "$(( 10#$(date +%d) ))"
	
	# create a file in today's directory (setting the creation/modification time to last month) and do `43f run`
	./43f -N init tmp
	./43f -N init tmp "$(date -j -v-1y +%Y)"
	touch -t "$(date -j -v-1m +%Y%m%d%H%M.%S)" "tmp/${y}/${d}/test_file"
	./43f -N -c tmp/temp.conf run
	
	# it should've been moved to last month's directory
	y="$(date -j -v-1m +%Y)"
	printf -v m "m%02i" "$(( 10#$(date -j -v-1m +%m) ))"
	test -f "tmp/${y}/${m}/test_file"
}

it_does_not_move_files_within_days_to_keep_dirs() {
	# create files in all the "to keep" day dirs and do `43f run`
	./43f -N init tmp
	./43f -N init tmp "$(date -j -v1y +%Y)"
	today="$(date +%d)"
	for (( i=0; i<7; i++ )); do
		y="$(date +%Y)"
		if (( ( 10#$today - $i ) > 0 )); then
			printf -v d "d%02i" $(( $today - $i ))
		else
			printf -v d "d%02i" $(( 31 - ( $i - $today ) ))
			if [ "$(date +%m)" -eq 1 ]; then
				y="$(( $y - 1 ))"
			fi
		fi
		touch "tmp/${y}/${d}/${d}_test_file"
	done
	./43f -N -c tmp/temp.conf run
	
	# they all should've stayed put in the "to keep" day dirs
	success=0
	for (( i=0; i<7; i++ )); do
		y="$(date +%Y)"
		if (( ( $today - $i ) > 0 )); then
			printf -v d "d%02i" $(( $today - $i ))
		else
			printf -v d "d%02i" $(( 31 - ( $i - $today ) ))
			if [ "$(date +%m)" -eq 1 ]; then
				y="$(( $y - 1 ))"
			fi
		fi
		if [ ! -f "tmp/${y}/${d}/${d}_test_file" ]; then success=1; fi
	done
	
	return $success
}

it_does_move_files_outside_days_to_keep_dirs() {
	# create files in all the directories except the "to keep" day dirs and do `43f run`
	./43f -N init tmp
	./43f -N init tmp "$(date -j -v1y +%Y)"
	today="$(date +%d)"
	for (( i=7; i<31; i++ )); do
		y="$(date +%Y)"
		if (( ( 10#$today - $i ) > 0 )); then
			printf -v d "d%02i" $(( 10#$today - $i ))
		else
			printf -v d "d%02i" $(( 31 - ( $i - 10#$today ) ))
			if [ "$(date +%m)" -eq 1 ]; then
				y="$(( $y - 1 ))"
			fi
		fi
		touch "tmp/${y}/${d}/${d}_test_file"
	done
	./43f -N -c tmp/temp.conf run
	
	# they all should've been moved to the appropriate month dirs
	success=0
	for (( i=7; i<31; i++ )); do
		y="$(date +%Y)"
		m="$(date +%m)"
		if (( ( 10#$today - $i ) > 0 )); then
			printf -v d "d%02i" $(( 10#$today - $i ))
		else
			printf -v d "d%02i" $(( 31 - ( $i - 10#$today ) ))
			m="$(( 10#$m - 1))"
			if (( 10#$m < 1 )); then
				y="$(( $y - 1 ))"
				m=12
			fi
		fi
		printf -v m "m%02i" "$(( 10#$m ))"
		if [ ! -f "tmp/${y}/${m}/${d}_test_file" ]; then success=1; fi
	done
	
	return $success
}

xit_does_move_files_outside_days_to_keep_dirs_across_year_boundary() {
	success=0
	
	# temporarily change the date so the days to keep will straddle the year boundary
	y="$(date +%Y)"
	start_date_test "%Y-%m-%d" "${y}-01-05"
	
	# run the normal it_does_move_files_outside_days_to_keep_dirs() test
	success=it_does_move_files_outside_days_to_keep_dirs_across_year_boundary
	
	# restore the date & time
	stop_date_test
	
	return $success;
}

it_does_not_move_files_inside_months_to_keep_dirs() {
	# set up the repository, incl. the previous year's directories
	./43f -N init tmp
	y="$(date +%Y)"
	prev_year="$(( $y - 1 ))"
	mkdir "tmp/${prev_year}"
	for (( i=1; i<=12; i++ )); do
		printf -v m "m%02i" $i
		mkdir "tmp/${prev_year}/${m}"
	done
	for (( i=1; i<=31; i++ )); do
		printf -v d "d%02i" $i
		mkdir "tmp/${prev_year}/${d}"
	done

	# create files in all the "to keep" month dirs and do `43f run`
	this_month="$(date +%m)"
	for (( i=0; i<6; i++ )); do
		y="$(date +%Y)"
		if (( ( 10#$this_month - $i ) > 0 )); then
			printf -v m "m%02i" $(( 10#$this_month - $i ))
		else
			printf -v m "m%02i" $(( 12 - ( $i - 10#$this_month ) ))
			y="$(( $y - 1 ))"
		fi
		if [ -d "tmp/${y}" ]; then
			touch "tmp/${y}/${m}/${m}_test_file"
		fi
	done
	./43f -N -c tmp/temp.conf run
	
	# they all should have stayed put in the "to keep" month dirs
	success=0
	for (( i=0; i<6; i++ )); do
		y="$(date +%Y)"
		if (( ( 10#$this_month - $i ) > 0 )); then
			printf -v m "m%02i" $(( 10#$this_month - $i ))
		else
			printf -v m "m%02i" $(( 12 - ( $i - 10#$this_month ) ))
			y="$(( $y - 1 ))"
		fi
		if [ -d "tmp/${y}" ]; then
			if [ ! -f "tmp/${y}/${m}/${m}_test_file" ]; then success=1; fi
		fi
	done
	
	return $success
}

it_does_move_files_outside_months_to_keep_dirs() {
	# set up the repository, incl. the previous year's directories
	./43f -N init tmp
	y="$(date +%Y)"
	prev_year="$(( $y - 1 ))"
	mkdir "tmp/${prev_year}"
	for (( i=1; i<=12; i++ )); do
		printf -v m "m%02i" $i
		mkdir "tmp/${prev_year}/${m}"
	done
	for (( i=1; i<=31; i++ )); do
		printf -v d "d%02i" $i
		mkdir "tmp/${prev_year}/${d}"
	done
	
	# create files in all the directories except the "to keep" month dirs and do `43f run`
	this_month="$(date +%m)"
	for (( i=6; i<12; i++ )); do
		y="$(date +%Y)"
		if (( ( 10#$this_month - $i ) > 0 )); then
			printf -v m "m%02i" $(( 10#$this_month - $i ))
		else
			printf -v m "m%02i" $(( 12 - ( $i - 10#$this_month ) ))
			y="$(( $y - 1 ))"
		fi
		if [ -d "tmp/${y}" ]; then
			touch "tmp/${y}/${m}/${m}_test_file"
		fi
	done
	./43f -N -c tmp/temp.conf run
	
	# determine the "to keep" month & year
	keep_year="$(date +%Y)"
	keep_month="$(( 10#$this_month - 6 ))"
	if (( 10#$keep_month < 1 )); then
		keep_month="01"
		keep_prev_year="$(( $keep_year - 1 ))"
		keep_prev_month="m12"
	fi
	keep_month="m${keep_month}"
	
	# they all should've been moved to the appropriate "to keep" month dir
	success=0
	for (( i=6; i<12; i++ )); do
		y="$(date +%Y)"
		if (( ( 10#$this_month - $i ) > 0 )); then
			printf -v m "m%02i" $(( 10#$this_month - $i ))
		else
			printf -v m "m%02i"  $(( 12 - ( $i - 10#$this_month ) ))
			y="$(( $y - 1 ))"
		fi
		if [ -d "tmp/${y}" ]; then
			if (( $y == $keep_year )); then
				if [ ! -f "tmp/${y}/${keep_month}/${m}_test_file" ]; then success=1; fi
			else
				if [ ! -f "tmp/${keep_prev_year}/${keep_prev_month}/${m}_test_file" ]; then success=1; fi
			fi
		fi
	done
	
	return $success
}

it_does_not_delete_directories_inside_years_to_keep_dirs() {
	# set up the repository, incl. the previous years's directories and do `43f run`
	./43f -N init tmp
	for (( i=1; i<3; i++ )); do
		y="$(( $(date +%Y) - $i ))"
		mkdir "tmp/${y}"
		for (( j=1; j<=12; j++ )); do
			printf -v m "m%02i" $j
			mkdir "tmp/${y}/${m}"
		done
		for (( j=1; j<=31; j++ )); do
			printf -v d "d%02i" $j
			mkdir "tmp/${y}/${d}"
		done
	done
	./43f -N -c tmp/temp.conf run
	
	# they all should have been preserved
	success=0
	for (( i=0; i<3; i++ )); do
		y="$(( $(date +%Y) - $i ))"
		for (( j=1; j<=12; j++ )); do
			printf -v m "m%02i" $j
			if [ ! -d "tmp/${y}/${m}" ]; then success=1; fi
		done
		for (( j=1; j<=31; j++ )); do
			printf -v d "d%02i" $j
			if [ ! -d "tmp/${y}/${d}" ]; then success=1; fi
		done
	done
	
	return $success
}

it_does_delete_directories_outside_years_to_keep_dirs() {
	# set up the repository, incl. the previous years's directories (beyond the years to keep) and do `43f run`
	./43f -N init tmp
	for (( i=1; i<6; i++ )); do
		y="$(( $(date +%Y) - $i ))"
		mkdir "tmp/${y}"
		for (( j=1; j<=12; j++ )); do
			printf -v m "m%02i" $j
			mkdir "tmp/${y}/${m}"
		done
		for (( j=1; j<=31; j++ )); do
			printf -v d "d%02i" $j
			mkdir "tmp/${y}/${d}"
		done
	done
	./43f -N -c tmp/temp.conf run
	
	# they all should have been deleted
	success=0
	for (( i=3; i<6; i++ )); do
		y="$(( $(date +%Y) - $i ))"
		for (( j=1; j<=12; j++ )); do
			printf -v m "m%02i" $j
			if [ -d "tmp/${y}/${m}" ]; then success=1; fi
		done
		for (( j=1; j<=31; j++ )); do
			printf -v d "d%02i" $j
			if [ -d "tmp/${y}/${d}" ]; then success=1; fi
		done
	done
	
	return $success
}

it_does_not_consolidate_files_with_different_names() {
	# create files with different names in the same month directory and do `43f run`
	./43f -N init tmp
	y="$(date +%Y)"
	printf -v m "m%02i" "$(( 10#$(date +%m) ))"
	touch "tmp/${y}/${m}/test_file_1"
	touch "tmp/${y}/${m}/some_other_test_file"
	./43f -N -c tmp/temp.conf run
	
	# the test files should've stayed put
	success=0
	if [ ! -f "tmp/${y}/${m}/test_file_1" ]; then success=1; fi
	if [ ! -f "tmp/${y}/${m}/some_other_test_file" ]; then success=1; fi
	
	return $success
}

it_does_consolidate_files_with_same_name_different_date() {
	# create files with the same name but different date stamps in the same month directory and do `43f run`
	./43f -N init tmp
	y="$(date +%Y)"
	m="$(date +%m)"
	for (( i=5; i>0; i-- )); do
		printf -v d "%02i" $i
		touch "tmp/${y}/m${m}/some_test_file.${y}-${m}-${d}.tar.bz2"
	done
	./43f -N -c tmp/temp.conf run
	
	# only the test file with the newest date stamp should have remained, the others should've been deleted
	success=0
	for (( i=5; i>0; i-- )); do
		printf -v d "%02i" $i
		if [ $i -eq 5 ]; then
			if [ ! -f "tmp/${y}/m${m}/some_test_file.${y}-${m}-${d}.tar.bz2" ]; then success=1; fi
		else
			if [ -f "tmp/${y}/m${m}/some_test_file.${y}-${m}-${d}.tar.bz2" ]; then success=1; fi
		fi
	done
	
	return $success
}
