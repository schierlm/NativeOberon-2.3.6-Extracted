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

MODULE MatrixMath;	(** non-portable *)	(* pjm *)

(* Note: Operator overloading and dynamic array values are 
an experimental feature available in Native Oberon only *)

TYPE
	Matrix* = ARRAY *,* OF LONGREAL;
	
PROCEDURE "+"*(a, b: Matrix): Matrix;
VAR i, j: LONGINT;  temp: LONGREAL;  c: Matrix;
BEGIN
	ASSERT(LEN(a, 0) = LEN(b, 0));
	ASSERT(LEN(a, 1) = LEN(b, 1));
	NEW(c, LEN(a, 0), LEN(a, 1));
	FOR i := 0 TO LEN(a, 0)-1 DO
		FOR j := 0 TO LEN(a, 1)-1 DO
			temp := b[i,j] + a[i,j];
			c[i,j] := temp
		END
	END;
	RETURN c
END "+";

PROCEDURE "*"*(a, b: Matrix): Matrix;
VAR i, j, k: LONGINT;  c: Matrix;  sum: LONGREAL;
BEGIN
	ASSERT(LEN(a, 1) = LEN(b, 0));
	NEW(c, LEN(a, 0), LEN(b, 1));
	FOR i := 0 TO LEN(a, 0)-1 DO
		FOR j := 0 TO LEN(a, 1)-1 DO
			sum := 0;
			FOR k := 0 TO LEN(a, 1)-1 DO
				sum := sum + a[i, k] * b[k, j]
			END;
			c[i, j] := sum
		END
	END;
	RETURN c
END "*";

END MatrixMath.
