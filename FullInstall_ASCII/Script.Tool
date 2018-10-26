Script.Open ^	ScriptGuide.Text
Script.Store ~

Script.Recall					undo last deletion

Script.ChangeOffset <offset>		+/- percent of font height
Script.ChangeColor <colorcode>
Script.ChangeFont <fontname>

Script.Print Default * [options]
Script.Print LPT1 *
	\h								header
	\p[a][t] [num]		page numbers
	\c num						copies

Script.Search
Script.Replace
Script.ReplaceAll
-----------------------------------
Script.NewStyle					new style at caret
Script.GetStyle ^
Script.SetStyle ^
	adjust block	adjust left	adjust right	adjust center	format mode

	break before	break normal			page break
	line Oberon12.Scn.Fnt	line 60		line spacing
	grid on	grid off

		left n ~						left margin	unit 1/10 mm
		width n ~					paragraph width
		tabs {n} ~					tabulator stops
		
Fonts------------------------------

Oberon8	Courier8

Oberon10b	Oberon10i	Courier10

Oberon12	Oberon12i	Oberon14	Oberon14i

Chars-------------------------------

															

-----------------------------------
