Sort.Sort *	Sort marked viewer
Sort.Sort ^	selection
Sort.Sort Test.Text	file
Sort.Sort *\r	in reverse order
Sort.Sort *\e	include empty lines ({TAB | SPACE} CR)
Sort.Sort *\u	don't keep duplicates (unique lines only)
Sort.Sort *\eu	all of the above


Sorts CR terminated lines and displays them in a separate viewer Sorted.Text.

Syntax:
	Sort.Sort ("^" | "*" | <name>) ["/" {c}]	where c IN {"r", "e", "u"}

Limitations:
	Max line length: 256 (including CR)
	Max lines: 2000
	Exceeding the limits results in a trap.
	Objects appear as characters and are not kept in the text.
	Fonts and other attributes are not kept.
	