Builder provides a convenient front-end to the Oberon compiler.  The Builder determines a compile sequence automatically by parsing a list of Oberon modules.  You must specify all the modules you want to compile.

Builder.Compile *	compile the marked text
Builder.Compile \s ^ ~	specify compile options at the beginning
Builder.Compile \sx names ~	compile the list of files, after sorting

Builder.Free names ~	free modules in the correct sequence
Builder.InsertHierarchy names ~	inserts a list of icons in order

Builder.MarkErrors ^	inserts error markers into the marked text
	Start of error list must be selected.
Builder.ClearErrors *	removes all error markers
	(also done automatically before Compile)

Builder.NextError	advance to the next error marker at caret

"names" is a list of module filenames
