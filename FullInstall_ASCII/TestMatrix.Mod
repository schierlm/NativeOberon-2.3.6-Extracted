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

MODULE TestMatrix;	(** non-portable *)	(* pjm *)

IMPORT MatrixMath, Out;

PROCEDURE Print(m: MatrixMath.Matrix);
VAR i, j: LONGINT;
BEGIN
	FOR i := 0 TO LEN(m, 0)-1 DO
		FOR j := 0 TO LEN(m, 1)-1 DO
			Out.LongReal(m[i,j], 8)
		END;
		Out.Ln
	END
END Print;

PROCEDURE Test*;
VAR a, b, c: MatrixMath.Matrix;
BEGIN
	NEW(a, 3, 3);
	a[0,0] := 1;  a[0,1] := 3;  a[0,2] := -4;
	a[1,0] := 1;  a[1,1] := 1;  a[1,2] := -2;
	a[2,0] := -1;  a[2,1] := -2;  a[2,2] := 5;
	NEW(b, 3, 3);
	b[0,0] := 8;  b[0,1] := 3;  b[0,2] := 0;
	b[1,0] := 3;  b[1,1] := 10;  b[1,2] := 2;
	b[2,0] := 0;  b[2,1] := 2;  b[2,2] := 6;
	NEW(c, 3, 3);
	c[0,0] := 2;  c[0,1] := 0;  c[0,2] := 0;
	c[1,0] := 0;  c[1,1] := 2;  c[1,2] := 0;
	c[2,0] := 0;  c[2,1] := 0;  c[2,2] := 2;
	Print(a);  Out.Ln;
	Print(b);  Out.Ln;
	Print(c);  Out.Ln;
	Print(a+b*c);  Out.Ln
END Test;

END TestMatrix.

TestMatrix.Test

System.Free TestMatrix MatrixMath ~
