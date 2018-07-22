#!/bin/bash

#
# This is a command line help function, We only take take care of the input files
# and the output file, echo option provide a callback function let caller to get
# input or output file.
#

#
# Proto Type:
# my_getopt  <option_arrary_name> <array_size> <none_option_callback> <cmdline_arg>
#
# Return:
#    0 -- success
#    1 -- failure

function my_getopt()
{
	local o_array=$1
	local size=$2
	local noption_handle=$3
	local cmd_string=$4
	declare -a cmd_array

	# transfer the cmdline into an array
	for cmd in $cmd_string
	do
		cmd_array=("${cmd_array[@]}" "$cmd")
	done

	# the first one is command itselft, just skip it
	for((i = 1; i < ${#cmd_array[@]}; ++i))
	do
		cmd=${cmd_array[$i]}

		# if the cmd is not start with '-', then this is not an option.
		# treat it as none option cmd
		if [ "${cmd:0:1}" != "-" ]; then
			eval ${noption_handle} ${cmd}
			continue
		fi

		# this cmd is a option, then visit the option table
		# and decide how to handle this option
		for ((o=0; o < ${size}; ++o))
		do
			if eval test "$cmd" == \${$o_array$o[0]}; then
				break
			fi
		done

		if [ $o -eq $size ]; then
			echo "Invalid option $cmd" 1>&2
			exit 1
		fi

		otype=$(eval echo \${$o_array$o[1]})
		pair=$(eval echo \${$o_array$o[2]})
		ohandle=$(eval echo \${$o_array$o[3]})

		case $otype in
			ARG)
				i=$((i+1))
				eval $ohandle ${cmd_array[$i]}
				;;
			OPTION)
				ni=$((i+1))
				next=${cmd_array[$ni]}
				if [ ${next:0:1} != "-" ]; then
					i=$((i+1))
					eval $ohandle $next
				fi
				;;
			NOARG)
				eval $ohandle
				;;
			PAIR)
				i=$((i+1))
				while [ $pair != ${cmd_array[$i]} ]
				do
					eval $ohandle ${cmd_array[$i]}
					i=$((i+1))
				done
				;;
			*)
				echo "Error option type $cmd" 1>&2

		esac

	done
}
