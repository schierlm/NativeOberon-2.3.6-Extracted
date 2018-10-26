(* OBERON System 3, Release 2.3.

Copyright 1999 ETH Zrich Institute for Computer Systems, 
ETH Center, CH-8092 Zrich. e-mail: oberon@inf.ethz.ch.

This module may be used under the conditions of the general Oberon 
System 3 license contract. The full text can be downloaded from

	"ftp://ftp.inf.ethz.ch/pub/software/Oberon/System3/license.txt;A"

Under the license terms stated it is in particular (a) prohibited to modify
the interface of this module in any way that disagrees with the style
or content of the system and (b) requested to provide all conversions
of the source code to another platform with the name OBERON. *)

(*
	OpenDemo2.Mod, jm 03.11.93

	This more extensive example shows how a new document type is created.
	In this case a panel is the primary document type. It modifies the menu
	bar and its icon.
*)

MODULE OpenDemo2;

IMPORT Out, Files, Objects, Gadgets, Panels, Documents, Desktops;

PROCEDURE LoadPanel*(D: Documents.Document);
VAR obj: Objects.Object; main: Gadgets.Frame;
	F: Files.File; R: Files.Rider; name: ARRAY 64 OF CHAR; ch: CHAR;
	tag: INTEGER; len: LONGINT; lib: Objects.Library;
BEGIN
	main := NIL; D.W := 300; D.H := 200;
	
	F := Files.Old(D.name);
	IF F # NIL THEN
		Files.Set(R, F, 0); Files.ReadInt(R, tag);
		IF tag = Documents.Id THEN
			Files.ReadString(R, name); (* skip over tag *)
			Files.ReadInt(R, D.X); Files.ReadInt(R, D.Y); Files.ReadInt(R, D.W); Files.ReadInt(R, D.H);
			Files.Read(R, ch);
			IF ch = Objects.LibBlockId THEN
				NEW(lib); Objects.OpenLibrary(lib); Objects.LoadLibrary(lib, F, Files.Pos(R), len);
				lib.GetObj(lib, 0, obj); (* by default *)
				IF (obj # NIL) & (obj IS Objects.Dummy) THEN
					Out.String("Discarding "); Out.String(obj(Objects.Dummy).GName); Out.Ln
				ELSIF (obj # NIL) & (obj IS Gadgets.Frame) THEN main := obj(Gadgets.Frame)
				END
			END
		END
	END;
	IF main = NIL THEN Panels.NewPanel; main := Objects.NewObj(Gadgets.Frame) END;
	Documents.Init(D, main)
END LoadPanel;

PROCEDURE StorePanel*(D: Documents.Document);
VAR F: Files.File; len: LONGINT; B: Objects.BindMsg; R: Files.Rider; obj: Objects.Object;
BEGIN
	IF D.name # "" THEN
		obj := D.dsc;
		IF obj # NIL THEN 
			NEW(B.lib); Objects.OpenLibrary(B.lib); obj.handle(obj, B);
			
			F := Files.New(D.name);
			Files.Set(R, F, 0); Files.WriteInt(R, Documents.Id); Files.WriteString(R, "OpenDemo2.NewDoc");
			Files.WriteInt(R, D.X); Files.WriteInt(R, D.H); Files.WriteInt(R, D.W); Files.WriteInt(R, D.H);
			Objects.StoreLibrary(B.lib, F, Files.Pos(R), len);
			Files.Register(F);
		END
	END
END StorePanel;

PROCEDURE DocHandle*(D: Objects.Object; VAR M: Objects.ObjMsg);
BEGIN
	WITH D: Documents.Document DO
		IF M IS Objects.AttrMsg THEN
			WITH M: Objects.AttrMsg DO
				IF M.id = Objects.get THEN
					IF M.name = "Gen" THEN M.class := Objects.String; M.s := "OpenDemo2.NewDoc"; M.res := 0
					ELSIF M.name = "Adaptive" THEN M.class := Objects.Bool; M.b := FALSE; M.res := 0
					ELSIF M.name = "Icon" THEN M.class := Objects.String; M.s := "Icons.Panel"; M.res := 0
					ELSE Documents.Handler(D, M)
					END
				ELSE Documents.Handler(D, M)
				END
			END
		ELSIF M IS Objects.LinkMsg THEN
			WITH M: Objects.LinkMsg DO
				IF M.id = Objects.get THEN
					IF (M.name = "SystemMenu") OR (M.name = "UserMenu") OR (M.name = "DeskMenu") THEN
						M.obj := Desktops.NewMenu("Desktops.StoreDoc[Store] System.Time[Time]");
						M.res := 0
					ELSE Documents.Handler(D, M)
					END
				ELSE Documents.Handler(D, M)
				END
			END
		ELSE Documents.Handler(D, M)
		END
	END
END DocHandle;
	
PROCEDURE NewDoc*;
VAR D: Documents.Document;
BEGIN NEW(D); D.Load := LoadPanel; D.Store := StorePanel; D.handle := DocHandle;
	D.W := 250; D.H := 200;
	Objects.NewObj := D
END NewDoc;

(* Opening under program control *)

PROCEDURE ShowGadget(name: ARRAY OF CHAR);
VAR D: Documents.Document;
BEGIN
	NewDoc; (* create a new document *)
	D := Objects.NewObj(Documents.Document);
	
	COPY(name, D.name);
	D.Load(D);
	
	Desktops.ShowDoc(D)
END ShowGadget;

PROCEDURE Do*;
BEGIN ShowGadget("Test.Panel");
END Do;

END OpenDemo2.Do
