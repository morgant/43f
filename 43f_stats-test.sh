#!/usr/bin/env roundup

describe "43f stats"

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

# 
# Daily Disk Usage Stats
#

it_does_calculate_disk_usage_stats_daily_minimum() {
	# create daily files of random size (0-99 * block size) and do `43f stats`
	./43f -N init tmp
	block_size="$(stat -f "%k" tmp)"
	unset min
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
		size="$(( $RANDOM % 100 ))"
		if [[ -z "$min" || "$size" -lt "$min" ]]; then
			min="$size"
		fi
		dd if=/dev/zero of="tmp/${y}/${d}/$(( $size * ( $block_size / 1024 ) ))k_test_file" bs=$block_size count=$size > /dev/null
	done
	output="$(./43f -N -c tmp/temp.conf stats | grep Daily -A 4 | grep Minimum)"
	success=$?
	
	# was the calculated minimum the same as our known minimum?
	if [ $success -eq 0 ]; then
		if [[ "$output" =~ Minimum:\ +([0-9]+)(.[0-9]+)?K?B ]]; then
			if (( ( ${BASH_REMATCH[1]} / ( $block_size / 1024 ) ) != $min )); then
				success=1
			fi
		else
			success=1
		fi
	fi
	
	return $success
}

it_does_calculate_disk_usage_stats_daily_median() {
	# create daily files of random size (0-99 * block size) and do `43f stats`
	./43f -N init tmp
	block_size="$(stat -f "%k" tmp)"
	sizes=()
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
		size="$(( $RANDOM % 100 ))"
		sizes+=("$size");
		dd if=/dev/zero of="tmp/${y}/${d}/$(( $size * ( $block_size / 1024 ) ))k_test_file" bs=$block_size count=$size > /dev/null
	done
	output="$(./43f -N -c tmp/temp.conf stats | grep Daily -A 4 | grep Median)"
	success=$?
	
	# sort the file sizes & calculate the median
	IFS=$'\n' sizes=($(sort -n <<<"${sizes[*]}"))
	median="${sizes[3]}"
	
	# was the calculated median the same as our known median?
	if [ $success -eq 0 ]; then
		if [[ "$output" =~ Median:\ +([0-9]+)(.[0-9]+)?K?B ]]; then
			if (( ( ${BASH_REMATCH[1]} / ( $block_size / 1024 ) ) != $median )); then
				success=1
			fi
		else
			success=1
		fi
	fi
	
	return $success
}

it_does_calculate_disk_usage_stats_daily_maximum() {
	# create daily files of random size (0-99 * block size) and do `43f stats`
	./43f -N init tmp
	block_size="$(stat -f "%k" tmp)"
	unset max
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
		size="$(( $RANDOM % 100 ))"
		if [[ -z "$max" || "$size" -gt "$max" ]]; then
			max="$size"
		fi
		dd if=/dev/zero of="tmp/${y}/${d}/$(( $size * ( $block_size / 1024 ) ))k_test_file" bs=$block_size count=$size > /dev/null
	done
	output="$(./43f -N -c tmp/temp.conf stats | grep Daily -A 4 | grep Maximum)"
	success=$?
	
	# was the calculated maximum the same as our known maximum?
	if [ $success -eq 0 ]; then
		if [[ "$output" =~ Maximum:\ +([0-9]+)(.[0-9]+)?K?B ]]; then
			if (( ( ${BASH_REMATCH[1]} / ( $block_size / 1024 ) ) != $max )); then
				success=1
			fi
		else
			success=1
		fi
	fi
	
	return $success
}

it_does_calculate_disk_usage_stats_daily_mean() {
	# create daily files of random size (0-99 * block size) and do `43f stats`
	./43f -N init tmp
	block_size="$(stat -f "%k" tmp)"
	sum=0
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
		size="$(( $RANDOM % 100 ))"
		sum="$(( $sum + $size ))"
		dd if=/dev/zero of="tmp/${y}/${d}/$(( $size * ( $block_size / 1024 ) ))k_test_file" bs=$block_size count=$size > /dev/null
	done
	output="$(./43f -N -c tmp/temp.conf stats | grep Daily -A 4 | grep Average)"
	success=$?
	
	# was the calculated mean the same as our known mean?
	if [ $success -eq 0 ]; then
		if [[ "$output" =~ Average:\ +([0-9]+)(.[0-9]+)?K?B ]]; then
			if (( ( ${BASH_REMATCH[1]} / ( $block_size / 1024 ) ) != ( $sum / 7 ) )); then
				success=1
			fi
		else
			success=1
		fi
	fi
	
	return $success
}

# 
# Monthly Disk Usage Stats
#

it_does_calculate_disk_usage_stats_monthly_minimum() {
	# create monthly files of random size (0-99 * block size) and do `43f stats`
	./43f -N init tmp
	block_size="$(stat -f "%k" tmp)"
	unset min
	this_month="$(date +%m)"
	for (( i=0; i<6; i++ )); do
		y="$(date +%Y)"
		if (( ( 10#$this_month - $i ) > 0 )); then
			printf -v m "m%02i" $(( 10#$this_month - $i ))
		else
			printf -v m "m%02i" $(( 12 - ( $i - 10#$this_month ) ))
			y="$(( $y - 1 ))"
		fi
		size="$(( $RANDOM % 100 ))"
		if [[ -z "$min" || "$size" -lt "$min" ]]; then
			min="$size"
		fi
		dd if=/dev/zero of="tmp/${y}/${m}/$(( $size * ( $block_size / 1024 ) ))k_test_file" bs=$block_size count=$size > /dev/null
	done
	output="$(./43f -N -c tmp/temp.conf stats | grep Monthly -A 4 | grep Minimum)"
	success=$?
	
	# was the calculated minimum the same as our known minimum?
	if [ $success -eq 0 ]; then
		if [[ "$output" =~ Minimum:\ +([0-9]+)(.[0-9]+)?K?B ]]; then
			if (( ( ${BASH_REMATCH[1]} / ( $block_size / 1024 ) ) != $min )); then
				success=1
			fi
		else
			success=1
		fi
	fi
	
	return $success
}

it_does_calculate_disk_usage_stats_monthly_median() {
	# create monthly files of random size (0-99 * block size) and do `43f stats`
	./43f -N init tmp
	block_size="$(stat -f "%k" tmp)"
	sizes=()
	this_month="$(date +%m)"
	for (( i=0; i<6; i++ )); do
		y="$(date +%Y)"
		if (( ( 10#$this_month - $i ) > 0 )); then
			printf -v m "m%02i" $(( 10#$this_month - $i ))
		else
			printf -v m "m%02i" $(( 12 - ( $i - 10#$this_month ) ))
			y="$(( $y - 1 ))"
		fi
		size="$(( $RANDOM % 100 ))"
		sizes+=("$size");
		dd if=/dev/zero of="tmp/${y}/${m}/$(( $size * ( $block_size / 1024 ) ))k_test_file" bs=$block_size count=$size > /dev/null
	done
	output="$(./43f -N -c tmp/temp.conf stats | grep Monthly -A 4 | grep Median)"
	success=$?
	
	# sort the file sizes & calculate the median
	IFS=$'\n' sizes=($(sort -n <<<"${sizes[*]}"))
	median="${sizes[3]}"
	
	# was the calculated median the same as our known median?
	if [ $success -eq 0 ]; then
		if [[ "$output" =~ Median:\ +([0-9]+)(.[0-9]+)?K?B ]]; then
			if (( ( ${BASH_REMATCH[1]} / ( $block_size / 1024 ) ) != $median )); then
				success=1
			fi
		else
			success=1
		fi
	fi
	
	return $success
}

it_does_calculate_disk_usage_stats_monthly_maximum() {
	# create monthly files of random size (0-99 * block size) and do `43f stats`
	./43f -N init tmp
	block_size="$(stat -f "%k" tmp)"
	unset max
	this_month="$(date +%m)"
	for (( i=0; i<6; i++ )); do
		y="$(date +%Y)"
		if (( ( 10#$this_month - $i ) > 0 )); then
			printf -v m "m%02i" $(( 10#$this_month - $i ))
		else
			printf -v m "m%02i" $(( 12 - ( $i - 10#$this_month ) ))
			y="$(( $y - 1 ))"
		fi
		size="$(( $RANDOM % 100 ))"
		if [[ -z "$max" || "$size" -gt "$max" ]]; then
			max="$size"
		fi
		dd if=/dev/zero of="tmp/${y}/${m}/$(( $size * ( $block_size / 1024 ) ))k_test_file" bs=$block_size count=$size > /dev/null
	done
	output="$(./43f -N -c tmp/temp.conf stats | grep Monthly -A 4 | grep Maximum)"
	success=$?
	
	# was the calculated maximum the same as our known maximum?
	if [ $success -eq 0 ]; then
		if [[ "$output" =~ Maximum:\ +([0-9]+)(.[0-9]+)?K?B ]]; then
			if (( ( ${BASH_REMATCH[1]} / ( $block_size / 1024 ) ) != $max )); then
				success=1
			fi
		else
			success=1
		fi
	fi
	
	return $success
}

it_does_calculate_disk_usage_stats_monthly_mean() {
	# create monthly files of random size (0-99 * block size) and do `43f stats`
	./43f -N init tmp
	block_size="$(stat -f "%k" tmp)"
	sum=0
	this_month="$(date +%m)"
	for (( i=0; i<6; i++ )); do
		y="$(date +%Y)"
		if (( ( 10#$this_month - $i ) > 0 )); then
			printf -v m "m%02i" $(( 10#$this_month - $i ))
		else
			printf -v m "m%02i" $(( 12 - ( $i - 10#$this_month ) ))
			y="$(( $y - 1 ))"
		fi
		size="$(( $RANDOM % 100 ))"
		sum="$(( $sum + $size ))"
		dd if=/dev/zero of="tmp/${y}/${m}/$(( $size * ( $block_size / 1024 ) ))k_test_file" bs=$block_size count=$size > /dev/null
	done
	output="$(./43f -N -c tmp/temp.conf stats | grep Monthly -A 4 | grep Average)"
	success=$?
	
	# was the calculated mean the same as our known mean?
	if [ $success -eq 0 ]; then
		if [[ "$output" =~ Average:\ +([0-9]+)(.[0-9]+)?K?B ]]; then
			if (( ( ${BASH_REMATCH[1]} / ( $block_size / 1024 ) ) != ( $sum / 6 ) )); then
				success=1
			fi
		else
			success=1
		fi
	fi
	
	return $success
}

# 
# Annual Disk Usage Stats
#

it_does_calculate_disk_usage_stats_annual_minimum() {
	# create annual files of random size (-99 * block size) and do `43f stats`
	block_size="$(stat -f "%k" tmp)"
	unset min
	for (( i=0; i<3; i++ )); do
		y="$(( $(date +%Y) - $i ))"
		./43f -N init tmp "$y"
		size="$(( $RANDOM % 100 ))"
		if [[ -z "$min" || "$size" -lt "$min" ]]; then
			min="$size"
		fi
		dd if=/dev/zero of="tmp/${y}/$(( $size * ( $block_size / 1024 ) ))k_test_file" bs=$block_size count=$size > /dev/null
	done
	output="$(./43f -N -c tmp/temp.conf stats | grep Annual -A 4 | grep Minimum)"
	success=$?
	
	# was the calculated minimum the same as our known minimum?
	if [ $success -eq 0 ]; then
		if [[ "$output" =~ Minimum:\ +([0-9]+)(.[0-9]+)?K?B ]]; then
			if (( ( ${BASH_REMATCH[1]} / ( $block_size / 1024 ) ) != $min )); then
				success=1
			fi
		else
			success=1
		fi
	fi
	
	return $success
}

it_does_calculate_disk_usage_stats_annual_median() {
	# create annual files of random size (-99 * block size) and do `43f stats`
	block_size="$(stat -f "%k" tmp)"
	sizes=()
	for (( i=0; i<3; i++ )); do
		y="$(( $(date +%Y) - $i ))"
		./43f -N init tmp "$y"
		size="$(( $RANDOM % 100 ))"
		sizes+=("$size")
		dd if=/dev/zero of="tmp/${y}/$(( $size * ( $block_size / 1024 ) ))k_test_file" bs=$block_size count=$size > /dev/null
	done
	output="$(./43f -N -c tmp/temp.conf stats | grep Annual -A 4 | grep Median)"
	success=$?
	
	# sort the file sizes & calculate the median
	IFS=$'\n' sizes=($(sort -n <<<"${sizes[*]}"))
	median="${sizes[1]}"
	
	# was the calculated median the same as our known median?
	if [ $success -eq 0 ]; then
		if [[ "$output" =~ Median:\ +([0-9]+)(.[0-9]+)?K?B ]]; then
			if (( ( ${BASH_REMATCH[1]} / ( $block_size / 1024 ) ) != $median )); then
				success=1
			fi
		else
			success=1
		fi
	fi
	
	return $success
}

it_does_calculate_disk_usage_stats_annual_maximum() {
	# create annual files of random size (-99 * block size) and do `43f stats`
	block_size="$(stat -f "%k" tmp)"
	unset max
	for (( i=0; i<3; i++ )); do
		y="$(( $(date +%Y) - $i ))"
		./43f -N init tmp "$y"
		size="$(( $RANDOM % 100 ))"
		if [[ -z "$max" || "$size" -gt "$max" ]]; then
			max="$size"
		fi
		dd if=/dev/zero of="tmp/${y}/$(( $size * ( $block_size / 1024 ) ))k_test_file" bs=$block_size count=$size > /dev/null
	done
	output="$(./43f -N -c tmp/temp.conf stats | grep Annual -A 4 | grep Maximum)"
	success=$?
	
	# was the calculated minimum the same as our known minimum?
	if [ $success -eq 0 ]; then
		if [[ "$output" =~ Maximum:\ +([0-9]+)(.[0-9]+)?K?B ]]; then
			if (( ( ${BASH_REMATCH[1]} / ( $block_size / 1024 ) ) != $min )); then
				success=1
			fi
		else
			success=1
		fi
	fi
	
	return $success
}

it_does_calculate_disk_usage_stats_annual_mean() {
	# create annual files of random size (-99 * block size) and do `43f stats`
	block_size="$(stat -f "%k" tmp)"
	sum=0
	for (( i=0; i<3; i++ )); do
		y="$(( $(date +%Y) - $i ))"
		./43f -N init tmp "$y"
		size="$(( $RANDOM % 100 ))"
		sum="$(( $sum + $size ))"
		dd if=/dev/zero of="tmp/${y}/$(( $size * ( $block_size / 1024 ) ))k_test_file" bs=$block_size count=$size > /dev/null
	done
	output="$(./43f -N -c tmp/temp.conf stats | grep Annual -A 4 | grep Average)"
	success=$?
	
	# was the calculated minimum the same as our known minimum?
	if [ $success -eq 0 ]; then
		if [[ "$output" =~ Average:\ +([0-9]+)(.[0-9]+)?K?B ]]; then
			if (( ( ${BASH_REMATCH[1]} / ( $block_size / 1024 ) ) != ( $sum / 3 ) )); then
				success=1
			fi
		else
			success=1
		fi
	fi
	
	return $success
}
