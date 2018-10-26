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

MODULE ComplexMath;	(** non-portable *)	(* pjm *)

(* Note: Operator overloading is an experimental feature 
available in Native Oberon only *)

TYPE
	Complex* = RECORD
		r, i: LONGREAL
	END;

PROCEDURE Gen*(real, imag: LONGREAL): Complex;
VAR t: Complex;
BEGIN
	t.r := real;  t.i := imag;
	RETURN t
END Gen;

PROCEDURE "-"*(a: Complex): Complex;
BEGIN
	a.r := -a.r;
	a.i := -a.i;
	RETURN a
END "-";

PROCEDURE "+"*(a, b: Complex): Complex;
VAR t: Complex;
BEGIN
	t.r := a.r + b.r;
	t.i := a.i + b.i;
	RETURN t
END "+";

PROCEDURE "-"*(a, b: Complex): Complex;
BEGIN
	RETURN a + (-b)
END "-";

PROCEDURE "*"*(a, b: Complex): Complex;
VAR t: Complex;
BEGIN
	t.r := a.r * b.r - a.i * b.i;
	t.i := a.r * b.i + b.r * a.i;
	RETURN t
END "*";

PROCEDURE "~" *(a: Complex): Complex;
VAR t: Complex;  x: LONGREAL;
BEGIN
	x := a.r * a.r + a.i * a.i;
	t.r := a.r / x;
	t.i := -a.i / x;
	RETURN t
END "~";

PROCEDURE "="*(a, b: Complex): BOOLEAN;
BEGIN
	RETURN (a.r = b.r) & (a.i = b.i)
END "=";

PROCEDURE Re*(a: Complex): LONGREAL;
BEGIN
	RETURN a.r
END Re;

PROCEDURE Im*(a: Complex): LONGREAL;
BEGIN
	RETURN a.i
END Im;

END ComplexMath.
