Find/Replace Regular Expressions

RX.Search
RX.Replace
RX.ReplaceAll

RX.SetSearch ...
RX.SetReplace ...

RX.SetSearch {i | "." | "/"} X0 ".Mod" 
RX.SetReplace X0 ".Mod => " X0 ".Mod"


Search and Replace Commands

RX.SetSearch [option] RegExpr
Sets RegExpr as the current search pattern. 
The end of RegExpr is determined by the end of the command line.
Up to ten factors can be marked as subexpressions.

	RegExpr		= term { "|" term }.
	term			= extdfactor { extdfactor }.
	extdfactor	= factor [ subexprid ].
	factor		= "(" RegExpr ")" | "[" RegExpr "]" | "{ RegExpr "}"
						| ["~"] ( """ literal """ | shorthand )
						| """ literal { literal } """.
	subexprid	= "X" digit.
	shorthand	= "A" | "a" | "b" | "c" | "d" | "h" | "i" | "l" | "o"
						| "t" | "w".
	option		= "\c".

Predefined character classes and their meaning :
	A		: "A" - "Z"
	a		: "a" - "z"
	b		: "0" - "1"
	c		:  carriage return
	d		: "0" - "9"
	h		: "0" - "9" or "A" - "F"
	l		: character classes A or a
	i		: character classes l or d
	o		: "0" - "7"
	t		: tab
	w	: tab, carriage return or blank
	
Option c ignores the case of the letters

RX.SetReplace {""" literal {literal} """ | subexprid | "t" | "c"}
Defines the current replace pattern as a sequence of strings,
subexpressions, tabulator or carriage return characters.

RX.Search
Searches the current search pattern in the focused text. Searching is 
started at the position of the caret. If the caret doesn't exist in the 
focused text, searching starts at the beginning. The command searches 
for the longuest pattern, matching the regular expression ( the same 
rule is applied to subexpressions ).

RX.Replace
Replaces a found regular expression by the current replace pattern and 
searches for the next occurence of the current search pattern.

RX.ReplaceAll
Repeats RX.Replace until the end of text.


The Grep Command

RX.Grep ( filename | "*" ) [option] RegExpr
Searches in the file filename or the marked text for the regular expression
RegExpr. The output will be diplayed in a seperate text viewer.

	option	= "\" { "c" | "i" }.

Options :

	c	: Ignores the case of the letters
	i	: Invert the search and displays only the lines that do not match



Examples

indent (non empty) lines by one tab
	RX.SetSearch (~c {~c} c) X0
	RX.SetReplace t X0

display all procedure headers
	RX.Grep Example.Mod "PROCEDURE"

generate the parameters for a System.CopyFiles or System.RenameFiles
command from a directory listing
	RX.SetSearch ( i {i|"."} ) X0 ".Txt"
	RX.SetReplace X0 ".Txt => " X0 ".Text"

replace occurrences of identifier "next" with "prev"
	RX.SetSearch (~i{~i}) X0 "next" (~i{~i}) X1
	RX.SetReplace X0 "prev" X1
