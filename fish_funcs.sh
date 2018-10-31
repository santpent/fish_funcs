
function string_split

	set -l options 'n/nth=' 'm/max=' 'r/right' 'q/quiet' 'w/whitespace'
	argparse -n string_split $options -- $argv
	or return
   
	# usage: <commands> | string_split <column_number>
	# ls -l | get_column 5
	# can use fish array index slicing, eg 2..4, 3..-1. Can't omit indexes.
	
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
			
			# need option here to ignore lines in which the separator is not found
			
			if echo $line | string match -q -e $separator
			
				set -l split_array ( echo $line | string split $max_switch $_flag_max $_flag_right $_flag_quiet $separator --)
				echo $split_array[$_flag_nth]
			
			end
			
		else
			echo $line | string split $max_switch $_flag_max $_flag_right $_flag_quiet $separator --
		end
		
	end
end
