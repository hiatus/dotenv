.datetime.filename.date()
{
	local fmt='%d_%m_%Y'

	if ! [[ "$1" =~ ^(dm[yY]?|md[yY]?)?$ ]]; then
		echo "${FUNCNAME[0]} [format]?"
		echo -e '├─ Print the current date in a filename-friendly [format]'
		echo -e '└─ Formats: dm, md, dmy, mdy, dmY, mdY'

		[[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
	fi

	if   [ "$1" = 'dm'  ]; then fmt='%d_%m'
	elif [ "$1" = 'md'  ]; then fmt='%m_%d'
	elif [ "$1" = 'dmy' ]; then fmt='%d_%m_%y'
	elif [ "$1" = 'mdy' ]; then fmt='%m_%d_%y'
	elif [ "$1" = 'dmY' ]; then fmt='%d_%m_%Y'
	elif [ "$1" = 'mdY' ]; then fmt='%m_%d_%Y'
	fi
	
	date "+${fmt}"
}

.datetime.filename.time()
{
	local fmt='%H_%M_%S'

	if ! [[ "$1" =~ ^(hm(s)?)?$ ]]; then
		echo "${FUNCNAME[0]} [format]?"
		echo -e '├─ Print the current time in a filename-friendly [format]'
		echo -e '└─ Formats: hm, hms'

		[[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
	fi

	[ "$1" = 'hm' ] && fmt='%H_%M'

	date "+${fmt}"

}

.datetime.filename.datetime()
{
	local fmt_date='%d_%m_%Y'
	local fmt_time='%H_%M_%S'

	if ! [[ "$1" =~ ^(dm[yY]?|md[yY]?)?$ && "$2" =~ ^(hm(s)?)?$ ]]; then
		echo "${FUNCNAME[0]} [date format]? [time format]?"
		echo -e '├─ Print the current date and time in a filename-friendly format'
		echo -e '├─ Time formats: hm, hms'
		echo -e '└─ Date formats: dm, md, dmy, mdy, dmY, mdY'

		[[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
	fi

	if   [ "$1" = 'dm'  ]; then fmt_date='%d_%m'
	elif [ "$1" = 'md'  ]; then fmt_date='%m_%d'
	elif [ "$1" = 'dmy' ]; then fmt_date='%d_%m_%y'
	elif [ "$1" = 'mdy' ]; then fmt_date='%m_%d_%y'
	elif [ "$1" = 'dmY' ]; then fmt_date='%d_%m_%Y'
	elif [ "$1" = 'mdY' ]; then fmt_date='%m_%d_%Y'
	fi

	[ "$2" = 'hm' ] && fmt_time='%H_%M'

	date "+${fmt_date}-${fmt_time}"
}
