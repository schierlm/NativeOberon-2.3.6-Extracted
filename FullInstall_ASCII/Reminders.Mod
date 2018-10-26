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

MODULE Reminders; (* jm 1.11.95 *)

(** Example of an object attached to a document. The object remembers
a message that is displayed in the log when the document is opened. *)

IMPORT Attributes, Documents, Files, Gadgets, Oberon, Objects, Out;

TYPE
	Reminder* = POINTER TO ReminderDesc;
	ReminderDesc* = RECORD (Gadgets.ObjDesc)
		msg*: ARRAY 128 OF CHAR
	END;

PROCEDURE Copy*(VAR M: Objects.CopyMsg; from, to: Reminder);
BEGIN
	Gadgets.CopyObject(M, from, to);
	to.msg := from.msg
END Copy;

PROCEDURE Handler* (obj: Objects.Object; VAR M: Objects.ObjMsg);
	VAR obj0: Reminder;
BEGIN
	WITH obj: Reminder DO
		IF M IS Objects.AttrMsg THEN
			WITH M: Objects.AttrMsg DO
				IF (M.id = Objects.get) & (M.name = "Gen") THEN
					M.class := Objects.String; COPY("Reminders.New", M.s); M.res := 0
				ELSE Gadgets.objecthandle(obj, M)
				END
			END
		ELSIF M IS Objects.CopyMsg THEN
			WITH M: Objects.CopyMsg DO
				IF M.stamp = obj.stamp THEN M.obj := obj.dlink	(* copy msg arrives again *)
				ELSE (* first time copy message arrives *)
					NEW(obj0); obj.stamp := M.stamp; obj.dlink := obj0; Copy(M, obj, obj0);
					M.obj := obj0
				END
			END
		ELSIF M IS Objects.FileMsg THEN
			WITH M: Objects.FileMsg DO
				IF M.id = Objects.store THEN Files.WriteString(M.R, obj.msg)
				ELSIF M.id = Objects.load THEN Files.ReadString(M.R, obj.msg)
				END;
				Gadgets.objecthandle(obj, M)
			END
		ELSIF M IS Gadgets.CmdMsg THEN (* executed when the document is opened *)
			WITH M: Gadgets.CmdMsg DO
				IF M.cmd = "PREPARE" THEN
					Out.String("Reminder: "); Out.String(obj.msg); Out.Ln
				ELSE Gadgets.objecthandle(obj, M)
				END
			END
		ELSE Gadgets.objecthandle(obj, M)
		END
	END
END Handler;

PROCEDURE Init* (obj: Reminder; msg: ARRAY OF CHAR);
BEGIN obj.handle := Handler; COPY(msg, obj.msg)
END Init;

PROCEDURE New*;
	VAR obj: Reminder;
BEGIN NEW(obj); Init(obj, ""); Objects.NewObj := obj
END New;

(** Attach a reminder to a document. *)
PROCEDURE Attach*;
	VAR D: Documents.Document; R: Attributes.Reader; ch: CHAR; obj: Reminder;
			s: ARRAY 128 OF CHAR; i: INTEGER; M: Objects.LinkMsg;
BEGIN
	D := Documents.MarkedDoc();
	IF D # NIL THEN
		Attributes.OpenReader(R, Oberon.Par.text, Oberon.Par.pos);
		Attributes.Read(R, ch);
		i := 0;
		WHILE ~R.eot & (ch # "~") & (i < LEN(s) - 1) DO
			s[i] := ch; INC(i);
			Attributes.Read(R, ch)
		END;
		s[i] := 0X;
		NEW(obj); Init(obj, s);
		M.id := Objects.set; M.name := "Reminder"; M.obj := obj; M.res := -1;
		D.handle(D, M);
		IF M.res >= 0 THEN Out.String("  done") ELSE Out.String("  failed") END; Out.Ln
	END
END Attach;

END Reminders.

Reminders.Attach ^ ~			Meeting on Thursday ~
												The Align button does not work ~