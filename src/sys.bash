.sys.cpu()
{
	local prev post prev_data post_data prev_sums post_sums diff_totl

	if [ $# -gt 0 ]; then
		echo "${FUNCNAME[0]}"
		echo '└─ Print usage for each and all CPU cores'

		[[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
	fi

	prev=$(grep -E ^cpu[0-9]+ /proc/stat)
	sleep 2.5s
	post=$(grep -E ^cpu[0-9]+ /proc/stat)

	for ((i = 0; i < $(wc -l <<< "$post"); ++i)); do
		prev_data=($(grep cpu${i} <<< "$prev" | cut -d ' ' -f 2-))
		post_data=($(grep cpu${i} <<< "$post" | cut -d ' ' -f 2-))

		prev_sums=$(bc <<< $(tr ' ' '+' <<< "${prev_data[*]}"))
		post_sums=$(bc <<< $(tr ' ' '+' <<< "${post_data[*]}"))

		diff_totl=$[prev_sums - post_sums]

		printf "CPU ${i}: %.1f%%\n" \
		"$(bc <<< "scale=2; (100 * (${diff_totl} - ${prev_data[3]} + ${post_data[3]})  / ${diff_totl})")"
	done
}

.sys.memory()
{
	local meminfo memtotl memfree memavlb

	if [ $# -gt 0 ]; then
		echo "${FUNCNAME[0]}"
		echo '└─ Print memory usage information'

		[[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
	fi

	meminfo=$(</proc/meminfo)
	memtotl=$(grep MemTotal     <<< "$meminfo" | grep -oE '[0-9]+')
	memfree=$(grep MemFree      <<< "$meminfo" | grep -oE '[0-9]+')
	memavlb=$(grep MemAvailable <<< "$meminfo" | grep -oE '[0-9]+')

	echo "    Total : $(bc <<< "${memtotl} / 1024") Mb"
	echo "     Used : $(bc <<< "(${memtotl} - ${memfree}) / 1024") Mb"
	echo "     Free : $(bc <<< "${memfree} / 1024") Mb"
	echo "Available : $(bc <<< "${memavlb} / 1024") Mb"
}

.sys.power()
{
	local stt cap

	if [ $# -gt 0 ]; then
		echo "${FUNCNAME[0]}"
		echo '└─ Print power information'

		[[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
	fi

	for bat in $(ls -d /sys/class/power_supply/BAT*); do
		stt=$(<${bat}/status)
		cap=$(<${bat}/capacity)

		echo "$(basename "$bat") : ${cap}% (${stt})"
	done
}

.sys.temperature()
{
	local tzn=0 ttz=0 avg=0

	if [ $# -gt 0 ]; then
		echo "${FUNCNAME[0]}"
		echo '└─ Print temperature information'

		[[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
	fi

	for zone in $(ls -d /sys/class/thermal/thermal_zone*); do
		tzn=$[tzn + 1]
		ttz=$(cat "${zone}/temp")
		avg=$[avg + ttz]

		echo "Zone $[tzn - 1] : $(bc <<< "${ttz} / 1000") °C"
	done

	echo "Zone * : $(bc <<< "${avg} / ${tzn} / 1000") °C"
}
