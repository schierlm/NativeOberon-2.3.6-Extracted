Script.Open DrawGuide.Text

Draw.Open ^  Elektra.Graph TTL0.Graph TTL1.Graph
Draw.Print LPT1 *	Draw.Print LPT1 ~
Draw.Store 

Rectangles.Make	Rectangles.SetShade 1
Curves.MakeLine	Curves.MakeCircle	Curves.MakeEllipse
Splines.MakeOpen	Splines.MakeClosed

System.SetFont Oberon10.Scn.Fnt
System.SetFont Oberon8.Scn.Fnt
System.SetFont Elektra.Scn.Fnt
Draw.SetWidth 2
Draw.ChangeFont Oberon8.Scn.Fnt
Draw.ChangeFont Elektra.Scn.Fnt
Draw.ChangeWidth 2

Draw.Macro TTL0 N00
Draw.OpenMacro {to caret}	Draw.MakeMacro Lib Mac
Draw.LoadLibrary Lib.Lib	Draw.StoreLibrary Lib.Lib

Script.Open Draw