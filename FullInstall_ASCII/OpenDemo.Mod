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
	OpenDemo.Mod, jm 03.11.93

	This is a example program for opening your own panel documents from
	program control. Note that only panels and their extensions can be
	handled here. Using any other gadget class will cause a trap.
	Note that the menubar is fixed. Your panel will be able
	to save itself and can be reloaded again from disk exactly as
	it was created.
	
	If you need to change certain attributes of your panel,
	for example the icon used, or the menu bar required, 
	please inspect the files OpenDemo2.Mod and 
	DocumentSkeleton.Mod 
*)

MODULE OpenDemo;

IMPORT
	Objects, Gadgets, PanelDocs, Documents, Desktops;
	
PROCEDURE ShowGadget(name: ARRAY OF CHAR; main: Gadgets.Frame);
VAR D: Documents.Document;
BEGIN
	PanelDocs.NewDoc; (* create a new document *)
	D := Objects.NewObj(Documents.Document);
	
	COPY(name, D.name); 
	Documents.Init(D, main);
	
	Desktops.ShowDoc(D)
END ShowGadget;

PROCEDURE Do*;
VAR P: Objects.Object;
BEGIN
	P := Gadgets.CreateObject("Panels.NewPanel");
	
	ShowGadget("Test.Panel", P(Gadgets.Frame))
END Do;


(* Second example *)

PROCEDURE Open*;
VAR D: Documents.Document;
BEGIN
	D := Documents.Open("Desktops.Tool");
	IF D # NIL THEN Desktops.ShowDoc(D) END
END Open;

END OpenDemo.

OpenDemo.Do
OpenDemo.Open