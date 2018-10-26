MODULE TestTransferBlock;	(* pjm *)

IMPORT Display, Files, In, Out, Input;

CONST
	Width = 512;
	Height = 512;

VAR
	transbuf: POINTER TO ARRAY OF CHAR;
	seed: LONGINT;

PROCEDURE Supported(): BOOLEAN;
BEGIN
	IF Display.TransferFormat(0) = Display.unknown THEN
		Out.String("TransferBlock not supported by driver");  Out.Ln;
		RETURN FALSE
	ELSE
		RETURN TRUE
	END
END Supported;

(*
PROCEDURE Set*;	(* unfinished *)
VAR buf: ARRAY 512 OF CHAR;  i: LONGINT;
BEGIN
	CASE Display.TransferFormat(0) OF
		Display.index8:
			FOR i := 0 TO 255 DO buf[i] := CHR(i) END;
			Display.TransferBlock(buf, 0, 16, 100, 100, 16, 16, Display.set);
			Display.TransferBlock(buf, 256-16, -16, 120, 100, 16, 16, Display.set)
		|Display.color555, Display.color565, Display.color664:
			FOR i := 0 TO 511 DO buf[i] := CHR(i MOD 256) END;
			Display.TransferBlock(buf, 0, 32, 100, 100, 16, 16, Display.set);
			Display.TransferBlock(buf, 512-32, -32, 120, 100, 16, 16, Display.set)
		|Display.color8888:
			FOR i := 0 TO 511 DO buf[i] := CHR(i MOD 256) END;
			Display.TransferBlock(buf, 0, 64, 100, 100, 16, 8, Display.set);
			Display.TransferBlock(buf, 512-64, -64, 120, 100, 16, 8, Display.set)
	END
END Set;
*)

PROCEDURE Copy*;
VAR buf: ARRAY 65536 OF CHAR;  i, j, pix: LONGINT;
BEGIN
	IF Supported() THEN
		pix := Display.TransferFormat(0) DIV 8;
		Display.TransferBlock(buf, 0, 128*pix, 0, 0, 128, 128, Display.get);
		(*Display.SetClip(100, 100, 300, 300);*)
		FOR i := 0 TO 5 DO
			FOR j := 0 TO 5 DO
				Display.TransferBlock(buf, 0, 128*pix, i*128, j*128, 128, 128, Display.set)
			END
		END
	END
END Copy;

PROCEDURE Random (N: LONGINT): LONGINT;
BEGIN
	seed := (seed + 773) * 13 MOD 9999991; 
	RETURN SHORT (seed MOD N)
END Random;

PROCEDURE HSVtoRGB(H, S, V: REAL; VAR R, G, B: REAL);
VAR
	f, p, q, t: REAL;
	i: LONGINT;
BEGIN
	IF S = 0 THEN R := V; G := V; B := V
	ELSE
		IF H = 360 THEN H := 0 END;
		H := H/60;
		i := ENTIER(H);
		f := H - i;
		p := V*(1 - S);
		q := V*(1 - (S*f));
		t := V*(1 - S*(1-f));
		CASE i MOD 6 OF
			0: R := V; G := t; B := p
		| 1: R := q; G := V; B := p
		| 2: R := p; G := V; B := t
		| 3: R := p; G := q; B := V
		| 4: R := t; G := p; B := V
		| 5: R := V; G := p; B := q
		END
	END
END HSVtoRGB;

PROCEDURE InitParams(VAR pix, rw, gw, bw, rs, gs: LONGINT);
BEGIN
	pix := Display.TransferFormat(0) DIV 8;
	CASE Display.TransferFormat(0) OF
		Display.index8: rw := 3;  gw := 3;  bw := 2
		|Display.color555: rw := 5;  gw := 5;  bw := 5
		|Display.color565: rw := 5;  gw := 6;  bw := 5
		|Display.color664: rw := 6;  gw := 6;  bw := 4
		|Display.color888, Display.color8888: rw := 8;  gw := 8;  bw := 8
	END;
	gs := bw;  rs := bw+gw
END InitParams;

PROCEDURE InitRowbow;
CONST C = 240;
VAR pix, x, y, ofs, col, rw, gw, bw, rm, gm, bm, rs, gs: LONGINT;  R, G, B, s, v: REAL;
BEGIN
	InitParams(pix, rw, gw, bw, rs, gs);
	rm := ASH(1, rw);  gm := ASH(1, gw);  bm := ASH(1, bw);
	IF transbuf = NIL THEN NEW(transbuf, Width*Height*pix) END;
	FOR y := 0 TO Height-1 DO
		FOR x := 0 TO Width-1 DO
			IF x < C THEN v := x/C ELSE v := 0.9999999 END;
			IF x  > 512-C THEN s := (512-x)/C ELSE s := 0.9999999 END;
			HSVtoRGB(y/512*360, s, v, R, G, B);
			col := ASH(ENTIER(R*rm), rs) + ASH(ENTIER(G*gm), gs) + ENTIER(B*bm);
			ofs := (y*Width + x)*pix;  transbuf[ofs] := CHR(col);
			IF pix > 1 THEN
				transbuf[ofs+1] := CHR(ASH(col, -8));
				IF pix > 2 THEN transbuf[ofs+2] := CHR(ASH(col, -16)) END
			END
		END
	END
END InitRowbow;

PROCEDURE Flow*;	(* press F9 to end *)
CONST Step = Width;
VAR x, y, dx, dy, w, h, ofs, pix: LONGINT;
BEGIN
	IF Supported() THEN
		pix := Display.TransferFormat(0) DIV 8;  ASSERT(pix # 0);
		IF transbuf = NIL THEN InitRowbow END;
		In.Open;  In.LongInt(w);  In.LongInt(h);
		IF In.Done THEN
			ofs := 0;
			dx := 10;  dy := 10;  x := 0;  y := 0;
			WHILE Input.Available() = 0 DO
				Display.TransferBlock(transbuf^, ofs*pix, w*pix, x, y, w, h, Display.set);
				IF (x + w + dx > Display.Width) OR (x + dx < 0) THEN dx := -dx END;
				IF (y + h + dy > Display.Height) OR (y + dy < 0) THEN dy := -dy END;
				INC(x, dx);  INC(y, dy);  INC(ofs, Step);
				IF ofs+w*h >= Width*Height THEN ofs := 0 END;
				CASE Random(6) OF
					0: INC(dx, Random(2)*2-1)
					|1: INC(dy, Random(2)*2-1)
					ELSE
				END;
				IF dx > 15 THEN dx := 15
				ELSIF dx < -15 THEN dx := -15
				ELSIF dy = 0 THEN dy := Random(2)*2-1
				END;
				IF dy > 15 THEN dy := 15
				ELSIF dy < -15 THEN dy := -15
				ELSIF dy = 0 THEN dy := Random(2)*2-1
				END
			END
		END
	END
END Flow;

PROCEDURE Image*;	(* file.bmp *)
CONST HdrSize = 54;
VAR
	f: Files.File;  r: Files.Rider;  w, h, i, ofs: LONGINT;  name: ARRAY 32 OF CHAR;
	buf: POINTER TO ARRAY OF CHAR;  pix, rw, gw, bw, rs, gs, col: LONGINT;  rb, gb, bb: CHAR;
BEGIN
	IF Supported() THEN
		InitParams(pix, rw, gw, bw, rs, gs);
		In.Open;  In.Name(name);
		IF In.Done THEN
			f := Files.Old(name);
			IF f # NIL THEN
				Files.Set(r, f, 18);
				Files.ReadLInt(r, w);  Files.ReadLInt(r, h);
				NEW(buf, pix*w*h);
				Files.Set(r, f, HdrSize);
				FOR i := 0 TO w*h-1 DO
					Files.Read(r, bb);  Files.Read(r, gb);  Files.Read(r, rb);
					col := ASH(ASH(ASH(ORD(rb), rw), -8), rs) + 
							ASH(ASH(ASH(ORD(gb), gw), -8), gs) +
							ASH(ASH(ORD(bb), bw), -8);
					ofs := pix*i;  buf[ofs] := CHR(col);
					IF pix > 1 THEN
						buf[ofs+1] := CHR(ASH(col, -8));
						IF pix > 2 THEN buf[ofs+2] := CHR(ASH(col, -16)) END
					END
				END;
				Files.Close(f);
				Display.TransferBlock(buf^, 0, pix*w, 10, 10, w, h, Display.set)
			END
		END
	END
END Image;

BEGIN
	seed := 8872365;
	transbuf := NIL
END TestTransferBlock.

> djpeg -bmp -outfile file.bmp file.jpg 

TestTransferBlock.Image ^ bigsur2.bmp marina.bmp gruppe5.bmp gruppe.bmp 

TestTransferBlock.Set
TestTransferBlock.Copy

TestTransferBlock.Flow 16 16
TestTransferBlock.Flow 96 96
TestTransferBlock.Flow 256 256
TestTransferBlock.Flow 512 512
TestTransferBlock.Flow 16 256
TestTransferBlock.Flow 16 512
TestTransferBlock.Flow 1 512
TestTransferBlock.Flow 7 17
