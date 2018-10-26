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

MODULE TestComplex;	(** non-portable *)	(* pjm *)

IMPORT ComplexMath, Out;

PROCEDURE OutComplex(a: ComplexMath.Complex);
BEGIN
	Out.LongReal(ComplexMath.Re(a), 12);
	Out.LongReal(ComplexMath.Im(a), 12);
END OutComplex;

PROCEDURE Test*;
VAR a, b, c, d, e: ComplexMath.Complex;
BEGIN
	a := ComplexMath.Gen(1.0, 2.0);
	b := ComplexMath.Gen(2.0, 3.0);
	OutComplex(a + b);  Out.Ln;
	OutComplex(a * b);  Out.Ln;
	OutComplex(a + (-b));  Out.Ln;
	OutComplex(a - b);  Out.Ln;
	OutComplex(~a);  Out.Ln;
	e := a + b * b + ~(-a) - b;
	OutComplex(e);  Out.Ln;
	c := b*b;  c := a + c;  d := -a;  d := ~d;  c := c + d;  c := c - b;
	OutComplex(c);  Out.Ln;
	IF e = c THEN Out.String("ok") ELSE Out.String("error") END
END Test;

END TestComplex.

TestComplex.Test

System.Free TestComplex ComplexMath ~
