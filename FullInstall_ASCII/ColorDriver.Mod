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

MODULE ColorDriver;
IMPORT Display;

TYPE
	ColorMsg* = RECORD (Display.FrameMsg)
		col*: INTEGER
	END;

VAR Color: INTEGER;

PROCEDURE NextCol*;
VAR M: ColorMsg;
BEGIN
	Color := (Color + 1) MOD 4;
	M.F := NIL; M.col := Color; Display.Broadcast(M)
END NextCol;

BEGIN Color := 1
END ColorDriver.

ColorDriver.NextCol

The color could also be controlled by a background task by replacing the ColorDriver module by:

MODULE ColorDriver;
IMPORT Display, Input, Modules, Oberon;
TYPE
	ColorMsg* = RECORD (Display.FrameMsg)
		col*: INTEGER
	END;
VAR Color: INTEGER; task : Oberon.Task;

PROCEDURE ColorTask(me: Oberon.Task);
VAR M: ColorMsg;
BEGIN
	Color := (Color + 1) MOD 4;
	M.F := NIL; M.col := Color; Display.Broadcast(M);
	me.time := Input.Time() + Input.TimeUnit * 3
END ColorTask;

PROCEDURE Cleanup;
BEGIN
	Oberon.Remove(task)
END Cleanup;

BEGIN
	Color := 1;
	NEW(task); task.handle := ColorTask; task.safe := TRUE; Oberon.Install(task);
	Modules.InstallTermHandler(Cleanup)
END ColorDriver.
