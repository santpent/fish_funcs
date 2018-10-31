

### string_split

A drop in replacement for fish shell's `string split`. It adds two switches:

`-n / --nth:` returns specific column(s) from split. This can also take advantage of fish's array slicing syntax `2..4, 2..-1` etc.

`-w` / `--whitespace`: reduce combined whitespace into a single space, useful for processing tabulated output.


## usage

```
<commands> | string_split [-w] [-n <column_number>] <separator>
```


## Examples

Using `-n / --nth:`
```
$ echo 'a b c d' | string_split -n 3 ' ' # returns 'c'
$ echo 'a b c d' | string_split -n -1 ' ' # returns 'd'
```
Using -w / --whitespace:

```
$ ls -l | tail -4 | string_split -w -n 8 # Show the 8th column
$ ls -l | tail -4 | string_split -w -n 6..8 # Show columns 6 through 8
$ ls -l | tail -4 | string_split -w -n 6..-1 # Show the 6th column to the end

$ netstat -antp | grep '^tcp' | string_split -w -n 4 # show the 'Local Address' column from netstat

$ dpkg --list | grep linux-image | string_split -w -n 2 # show installed kernels

$ ip addr | grep inet | string_split -w -n 3 # show active ip addresses
```

### string_find

A find command for fish shell's `string`.

## usage

```
<commands> | string_find [-w] [-n <column_number>] <separator>
```

echo 'Lorem ipsum dolor sit amet' | string_find 'ipsum' 'sit' # returns ' dolor '
echo 'Lorem ipsum dolor sit amet' | string_find 'ipsum' 'sit' -k # returns 'ipsum dolor sit'
	

	
