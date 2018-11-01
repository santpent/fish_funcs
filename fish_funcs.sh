
function string_split

	set -l options 'n/nth=' 'm/max=' 'r/right' 'q/quiet' 'w/whitespace' 'h/help'
	argparse -n string_split $options -- $argv
	or return
   
	if set -q _flag_help
		echo "Usage: same as fish string split, with added switches"
		echo "-n / --nth: returns specific column(s) from split."
		echo "-w / --whitespace: reduce combined whitespace into a single space, useful for processing tabulated output."
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


function string_find
	
	set -l options 't/terms'
	argparse -n string_find $options -- $argv
	
	set -l find_from $argv[1]
	
	if test -n "$argv[2]"
		set find_to $argv[2]
	end
	
	cat /dev/stdin | while read -l line
	
		if echo $line | string match --quiet --entire "$find_from" --
			
			set found (echo $line | string split --max 1 $find_from --)[2]

			if test -n "$find_to"
				set found (echo $found | string split --max 1 $find_to --)[1]
			end
			
			if set -q _flag_terms
				echo "$find_from$found$find_to"
			else
				echo $found
			end
		end
	end
end



function funced2 --wraps functions

	set -l options 'e/editor='
	argparse -n funced2 $options -- $argv
	
	set -l editor
	if set -q _flag_editor
		set editor $_flag_editor
	else
		set editor fish
	end
	
	if not which $editor >/dev/null # account for $editor not found
		funced --editor $editor $argv
		return
	end

	if not functions $argv >/dev/null # account for function not found
		funced --editor $editor $argv
		return
	end
	
	set -l defined ( functions $argv | grep '^# Defined in' | string split '# Defined in ' -- )[2]
	
	set -l defined ( echo $defined | string split ' @ line ')

	set -l filename $defined[1]
	set -l line_no $defined[2]
	
	switch $editor
		case vi vim emacs
			eval $editor +$line_no $filename &
		case kate geany notepadqq
			eval $editor --line $line_no $filename &
			# notepadqq --line $line_no $filename &
			# notepadqq $filename --line $line_no  &
		case scite
			eval $editor -open $filename -goto:$line_no & # note: this wipes the current scite session
		case atom subl
			eval $editor $filename:$line_no & # sublime text
		case gedit
			eval $editor $filename &
		case '*'
			funced --editor $editor $filename
	end
end
