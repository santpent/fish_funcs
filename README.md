
# Fish functions

Some functions for fish shell.

---
<a name="funced2"></a>
### funced2

Trying to improve Fish's built in `funced` function editor, which

- Doesn't open at the relevant line number in a script.
- Edits the function using a temporary file, not the script in which the function is defined. When you save the function, its saved only to memory, not to your script. If you reload your script, the changes are lost.


#### Usage

```
funced2 [--editor <editor name>] <function name>
```
#### Example

Lets suppose you have a file called `~/.config/fish/myscript.fish` containing lots of functions. You want to edit `myfunc` which is down on line 267.
```
funced2 --editor kate myfunc
```
This will then open myscript.fish, at line 267, in kate.
When you are finished editing, you then save the file, and reload it in fish, to affect the changes. You can setup a function or alias to do this
```
function rs # reload sources
	source ~/.config/fish/myscript.fish
end
	
```
Then if you are repeatedly editing a function, its very quick to work with: 
```
rs; myfunc
```

It currently accounts for vi, vim, emacs, kate, geany, notepadqq, scite, atom, sublime text. The text editor / IDE must be able to accept a line number by command line.

---
<a name="string_split"></a>
### string_split

A drop in replacement for fish shell's `string split`. It adds two switches:

`-n / --nth:` returns specific column(s) from split. This can also take advantage of fish's array slicing syntax `2..4, 2..-1` etc.

`-w` / `--whitespace`: reduce combined whitespace into a single space, useful for processing tabulated output.


#### Usage

```
<commands> | string_split [-w] [-n <column_number>] <separator>
```


#### Examples

Using `-n / --nth:`
```
echo 'a b c d' | string_split -n 3 ' ' # returns 'c'
echo 'a b c d' | string_split -n -1 ' ' # returns 'd'
```
Using `-w / --whitespace:`

```
ls -l | tail -4 | string_split -w -n 8 # Show the 8th column
ls -l | tail -4 | string_split -w -n 6..8 # Show columns 6 through 8
ls -l | tail -4 | string_split -w -n 6..-1 # Show the 6th column to the end

netstat -antp | grep '^tcp' | string_split -w -n 4 # show the 'Local Address' column from netstat

dpkg --list | grep linux-image | string_split -w -n 2 # show installed kernels

ip addr | grep inet | string_split -w -n 3 # show active ip addresses
```
---
<a name="string_find"></a>
### string_find

A find command for fish shell's `string`.

`-k / --keywords` returns the search result along with the search terms
#### Usage

```
<commands> | string_find [-w] [-n <column_number>] <separator>
```

#### Examples
```
echo 'Lorem ipsum dolor sit amet' | string_find 'sit' # returns ' amet'
echo 'Lorem ipsum dolor sit amet' | string_find 'ipsum' 'sit' # returns ' dolor '
echo 'Lorem ipsum dolor sit amet' | string_find 'ipsum' 'sit' -k # returns 'ipsum dolor sit'
```

	
