Commands for editing text documents

Desktops.OpenDoc ^
	(TextDoc)  (LogDoc)

Gadgets.Insert TextNote ~	insert a text note at the caret
Gadgets.Insert TextGadget ~	insert a text gadget at the caret

TextDocs.Recall	recalls last deleted text

TextDocs.ReplaceAll	replace all occurances of search string

TextGadgets.NewStyle	inserts a style at the caret
TextDocs.Controls *	toggle styles/controls

TextDocs.Show ^ M.P	show source
TextDocs.SearchDiff	search for differences between two selections
TextDocs.SearchDiff \w	as above, but ignore spaces, tabs an line feeds	

TextDocs.SearchColor	searches text from caret position with color 
		specified by recent selection

TextDocs.Clear	clear current text

TextDocs.PrintSetup [\hoff] [\hon] [\poff] [\pon]
		switch header/page numbers on/off
	
TextDocs.ChangeFont Oberon10i.Scn.Fnt
TextDocs.ChangeFont Oberon12.Scn.Fnt
TextDocs.ChangeFont Oberon12b.Scn.Fnt
TextDocs.ChangeFont Oberon14.Scn.Fnt

TextDocs.ChangeOffset 5	TextDocs.ChangeOffset -5
TextDocs.ChangeColor 1	TextDocs.ChangeColor 3

TextDocs.AdjustStyles	set all styles to paper width

TextDocs.ReplaceSystemEditor	make textdocs the default editor

Watson.ShowDef TextDocs	more information

Tips:
- Open a document directly with a middle + right interclick on a document name !

- To shift the selection left or right:
	(1) select text
	(2) set the caret
	(3) press left and right arrows
	
- Insert a style with Ctrl-ENTER (use TextDocs.Controls * to toggle style viewing)

- Style control:
	(a) set a tabulator with Middle+Left interclick underneath the dotted line.
	(b) delete a tabulator by moving it completely out from the dotted line.
	(c) drag the left or right margin on the style
	(d) middle click near the left or right to toggle the "weight" at the end of the style - thereby controlling justification/centering.
