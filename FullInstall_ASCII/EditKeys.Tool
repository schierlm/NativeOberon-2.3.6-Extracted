Keyboard macros

EditKeys.Definitions ^	
EditKeys.Read EditKeys.Text ~
EditKeys.Reset
EditKeys.GetKeyCode

EditKeys.Definitions opens a viewer and lists all current macro definitions. A selection or a command parameter can be used to restrict the list to definitions with a certain prefix. EditKeys.Read takes a list of files and reads in macro definitions contained therein. If errors are detected, all definitions are deleted. For prototyping macros, it is also possible to have "@" or ":=" as an argument for EditKeys.Read, where @ causes the current selection to be read in, while := takes the text following. (Warning: in both cases the text is parsed to its end.)
Upon module load time, the standard macro definition file "EditKeys.Text" is read in. Also, if a macro "INSTALL" is defined, it is invoked. EditKeys.Reset deletes all current macro definitions, resetting the hotkey to its default.
EditKeys.GetKeyCode helps to find out the codes of certain keys. Within a text supporting macro keys, entering the hot key causes expansion of the macro entered to the left. To avoid ambiguouties, the longest matching macro name is taken. A macro may have zero or more arguments supplied by the user. If no corresponding definition of a macro is found, a second try is made with the standard macro name "OTHERWISE". (EditKeys.Reset defines "OTHERWISE" to write the default hotkey, i.e. "\".). The hotkey for Native Oberon System 3 is INSERT on the numeric keypad.


Syntax of macro definition files for EditKeys.
	MacroFile = [HotKeyDef] {MacroDef}.
	HotKeyDef = '\' KeyName.	-- sets the macro expansion hot key (default is \)
	MacroDef = MacroName '(' { MacroName | TextStretch | Command} ')'.
	MacroName = KeyName
		|   <graphic character except '#"()\^'>  { <graphic character except '()'>  }.
	TextStretch = '"' <formatted text, not containing '"'> '"'.
	KeyName = '#' <hex number>.
	(Comments and arbitrary white space are allowed between any two terminals. Comments may be nested.)

Syntax of macro invocations.
	MacroInvocation = {Argument ":"} MacroName HotKey.
	Argument = { <arbitrary graphic character except : and " > } | TextStretch.
	HotKey = INSERT.  (*can be defined in EditKeys.Text*)

Built-in functions.
	Text stretches are pushed on a parameter stack when processed.
	Built-in functions may pop parameter(s) from that stack.

	^0	pops a parameter and causes textual insertion.
	^1	pops a parameter and inserts the corresponding ascii character.
	^2	pops a parameter which must be a font name; presets the named font.
	^3	pops a parameter which must be an integer; presets the vertical offset (in 1/64th of font height).
	^4	pops a parameter and tries to call it as an Oberon command.
	^A	pops a parameter which must be an integer; pushs the nth (0 is leftmost one) macro argument
	^B	pops a parameter which must be a macro name; invokes the named macro
	^C	pops a parameter and appends it to the parameters used when calling an Oberon command

	^5	keeps the font that would have been used w/o macro; presets this font.
	^6	picks the font that would have been used w/o macro; forces whole macro to this font.
	^7	presets the caret position.
	^8	indents the next line according to the last line's indentation.
	^9	avoids deletion of the macro, neither inserts characters written by the macro.

Remarks.
	When reading in a macro that has been read in before, the new definition replaces the old one.
	Cyclic definitions can be constructed this way; a try to process such a definition is prevented.
