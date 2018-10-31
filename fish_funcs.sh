function string_split

	set -l options 'n/nth=' 'm/max=' 'r/right' 'q/quiet' 'w/whitespace' 'h/help'
	argparse -n string_split $options -- $argv
	or return
   
	if set -q _flag_help
		echo "usage: \$ <commands> | string_split <column_number>"
		echo "Example:"
		echo "\$ echo 'a, b, c, d' | string_split ', ' 3 # returns c"
		return
	end
	
	set -l separator $argv
	set -l max_switch
	
	if set -q _flag_max
		set max_switch --max
	end
	
	cat /dev/stdin | while read -l line

		if set -q _flag_whitespace
			set line ( echo $line | string replace --all --regex '[\s]+' ' ' -- )
			# if -w / --whitespace switch is passed, the separator is ignored and replaced with space
			set separator ' '
		end

		if set -q _flag_nth
			
			if echo $line | string match -q -e $separator
			
				set -l split_array ( echo $line | string split $max_switch $_flag_max $_flag_right $_flag_quiet $separator --)
				echo $split_array[$_flag_nth]
			end
		else
			echo $line | string split $max_switch $_flag_max $_flag_right $_flag_quiet $separator --
		end
	end
end
