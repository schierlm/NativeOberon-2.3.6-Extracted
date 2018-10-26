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

MODULE Simulator; (*JG 10.10.93*)
  IMPORT Display, Gadgets, Attributes, Diagrams;

  VAR seed: LONGINT;

  PROCEDURE Random (): REAL;
    CONST a = 16807; m = 2147483647; q = m DIV a; r = m MOD a;
  BEGIN seed := a*(seed MOD q) - r*(seed DIV q);
    IF seed <= 0 THEN seed := seed + m END;
    RETURN seed * (1.0/m)
  END Random;

  PROCEDURE Start*;
    VAR a, b, r, x: LONGREAL; t, T: LONGINT; limited: BOOLEAN;
      N: Diagrams.UpdateMsg;
  BEGIN
    Attributes.GetBool(Gadgets.FindObj(Gadgets.context, "Loss"), "Value", limited);
    Attributes.GetLongReal(Gadgets.FindObj(Gadgets.context, "Mean"), "Value", x); b := 1/x;
    Attributes.GetInt(Gadgets.FindObj(Gadgets.context, "Period"), "Value", T);
    Attributes.GetLongReal(Gadgets.FindObj(Gadgets.context, "Load"), "Value", x); a := x/100 * b;
    N.F := NIL; N.n := 0; t := 0;
    REPEAT INC(t); r := Random ();
      IF r < a THEN INC(N.n)
        ELSIF (N.n > 0) & (r > 1-b) THEN DEC(N.n)
      END;
      Display.Broadcast(N);
      IF limited & (N.res > 0) THEN DEC(N.n) END
    UNTIL t >= T
  END Start;

BEGIN seed := 1235
END Simulator.
