TextPopups

This utility displays simple popup menus in TextDocs when clicking outside the text.  The contents of the menus can be edited and are stored in the file "TextPopups.Text"

TextPopups.Install	Activate popup menus
TextPopups.Remove	Deactivate popup menus

This is an example of a menu description:

[Mod]	<= applies for files with suffix .Mod
Compiler.Compile *
Compiler.Compile */s
Compiler.Compile */f	<= commands that can be executed
Decoder.Decode ^
Analyzer.Analyze *
--------------------
<5 Recent Files>	<= include a list with the 5 recent files, you can also replace 5 by any other number.
--------------------		These files can be opened directly by selecting the appropriate menu item.
<Procedures>	<= include a list of all procedures declared in the text file.
--------------------		You can jump to the corresponding text position by selecting a menu item.
<Types>	<= include a list of all types declared in the text file.
		You can jump to the corresponding text position by selecting a menu item.
[Text]	<= applies for files with suffix .Text
TextDocs.SearchDiff /w
--------------------
<5 Recent Files>

