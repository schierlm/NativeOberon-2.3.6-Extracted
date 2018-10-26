MODULE GfxDemo;	(** eos  **)

	(**
		Sample frame type for rendering onto a graphics context.
		Most importantly, it shows how a display context can be set up to render to the visible area of a frame
	**)
	
	IMPORT
		Files, Display, Objects, Oberon, Display3, Gadgets, GfxMatrix, GfxMaps, GfxRegions, Gfx, GfxDisplay;
		
	
	CONST
		Sqrt3 = 1.7320508;	(* sqrt(3) *)
		
	
	TYPE
		(** graphics frame **)
		Frame* = POINTER TO FrameDesc;
		FrameDesc* = RECORD (Gadgets.FrameDesc)	
			fgCol*, bgCol*: Gfx.Color;	(** colors used **)
			maxIter*: INTEGER;	(** number of iterations **)
		END;
		
	
	VAR
		Ctxt: GfxDisplay.Context;	(* shared context for rendering to the screen *)
		ClipReg: GfxRegions.Region;	(* shared region for calculating clip region from mask *)
		
	
	(* append a Koch curve to the current path *)
	PROCEDURE DrawKoch (ctxt: Gfx.Context; iter: LONGINT);
		VAR ctm: GfxMatrix.Matrix;
	BEGIN
		IF iter = 0 THEN
			(* no more subdivisions allowed => append line to current path *)
			Gfx.LineTo(ctxt, 1, 0)
		ELSE
			(* save the current transformation matrix *)
			ctm := ctxt.ctm;
			
			(* scale the current coordinate system down and draw the first part *)
			Gfx.Scale(ctxt, 1/3, 1/3);
			DrawKoch(ctxt, iter-1);
			
			(* translate to end of first part and rotate by 60 degrees *)
			Gfx.Translate(ctxt, 1, 0);
			Gfx.Rotate(ctxt, Sqrt3/2, 1/2);
			DrawKoch(ctxt, iter-1);
			
			(* translate and rotate by -120 degrees *)
			Gfx.Translate(ctxt, 1, 0);
			Gfx.Rotate(ctxt, -Sqrt3/2, -1/2);
			DrawKoch(ctxt, iter-1);
			
			(* translate and rotate back by 60 degrees *)
			Gfx.Translate(ctxt, 1, 0);
			Gfx.Rotate(ctxt, Sqrt3/2, 1/2);
			DrawKoch(ctxt, iter-1);
			
			(* restore current transformation matrix *)
			Gfx.SetCTM(ctxt, ctm)
		END
	END DrawKoch;
	
	(* add a single rectangle to the global clip region *)
	PROCEDURE AddMaskRect (x, y, w, h: INTEGER);
	BEGIN
		GfxRegions.AddRect(ClipReg, x, y, x + w, y + h)
	END AddMaskRect;
	
	(* restore frame within given region *)
	PROCEDURE RestoreFrame (frame: Frame; x, y, w, h, fx, fy: INTEGER; mask: Display3.Mask);
		VAR llx, lly, urx, ury: REAL; border, i: LONGINT;
	BEGIN
		(* remove marks from area where we will draw *)
		INC(x, fx); INC(y, fy);
		Oberon.RemoveMarks(x, y, w, h);
		
		(* calculate and set the clip region *)
		GfxRegions.Clear(ClipReg);
		Display3.EnumRect(mask, mask.X, mask.Y, mask.W, mask.H, AddMaskRect);
		GfxRegions.IntersectRect(ClipReg, x, y, x + w, y + h);
		GfxDisplay.SetClipRegion(Ctxt, ClipReg);
		
		(* establish default coordinate system: origin is at frame's lower left corner *)
		GfxDisplay.SetCoordinates(Ctxt, fx, fy, 1);
		
		(* reset the context *)
		Gfx.Reset(Ctxt);
		
		(* restore background unless frame is transparent *)
		IF ~(Gadgets.transparent IN frame.state) THEN
			Gfx.GetClipRect(Ctxt, llx, lly, urx, ury);
			Gfx.SetFillColor(Ctxt, frame.bgCol);
			Gfx.DrawRect(Ctxt, llx, lly, urx, ury, {Gfx.Fill})
		END;
		
		(* set stroke parameters *)
		Gfx.SetStrokeColor(Ctxt, frame.fgCol);
		Gfx.SetLineWidth(Ctxt, frame.W/(50 * frame.maxIter));
		
		(* start current path, freezing stroke parameters *)
		Gfx.Begin(Ctxt, {Gfx.Stroke});
		
		(* establish coordinate system for the Koch curve *)
		border := frame.W DIV 5;
		Gfx.Translate(Ctxt, border, frame.H - 1.5*border);
		Gfx.Scale(Ctxt, 3*border, 3*border);
		
		(* start a subpath, supplying direction of last line *)
		Gfx.Enter(Ctxt, 0, 0, -1/2, Sqrt3/2);
		
		(* append three Koch curves, rotating after each, resulting in a snowflake *)
		FOR i := 1 TO 3 DO
			DrawKoch(Ctxt, frame.maxIter);
			Gfx.Translate(Ctxt, 1, 0);
			Gfx.Rotate(Ctxt, -Sqrt3/2, -1/2)	(* rotate by -120 degrees *)
		END;
		
		(* close current path, supplying direction of first line *)
		Gfx.Exit(Ctxt, 1, 0);
		Gfx.End(Ctxt);
		
		(* superimpose selection pattern if appropriate *)
		IF Gadgets.selected IN frame.state THEN
			Display3.FillPattern(mask, Display3.white, Display3.selectpat, fx, fy, x, y, w, h, Display3.paint)
		END
	END RestoreFrame;
	
	PROCEDURE HandleFrame* (obj: Objects.Object; VAR msg: Objects.ObjMsg);
		VAR frame, copy: Frame; fx, fy: INTEGER; mask: Display3.Mask; ver: LONGINT; ch: CHAR;
	BEGIN
		frame := obj(Frame);
		IF msg IS Display.FrameMsg THEN
			WITH msg: Display.FrameMsg DO
				IF (msg.F = NIL) OR (msg.F = frame) THEN
					IF msg IS Display.DisplayMsg THEN
						WITH msg: Display.DisplayMsg DO
							IF msg.device = Display.screen THEN
								fx := msg.x + frame.X; fy := msg.y + frame.Y;
								IF (msg.id = Display.full) OR (msg.F = NIL) THEN
									Gadgets.MakeMask(frame, fx, fy, msg.dlink, mask);
									RestoreFrame(frame, 0, 0, frame.W, frame.H, fx, fy, mask)
								ELSIF msg.id = Display.area THEN
									Gadgets.MakeMask(frame, fx, fy, msg.dlink, mask);
									Display3.AdjustMask(mask, fx + msg.u, fy + frame.H - 1 + msg.v, msg.w, msg.h);
									RestoreFrame(frame, msg.u, msg.v + frame.H - 1, msg.w, msg.h, fx, fy, mask)
								END
							END
						END
					ELSE
						Gadgets.framehandle(frame, msg)
					END
				END
			END
		ELSIF msg IS Objects.AttrMsg THEN
			WITH msg: Objects.AttrMsg DO
				IF msg.id = Objects.get THEN
					IF msg.name = "Gen" THEN
						msg.class := Objects.String; msg.s := "GfxDemo.NewFrame"; msg.res := 0
					ELSIF msg.name = "Iterations" THEN
						msg.class := Objects.Int; msg.i := frame.maxIter; msg.res := 0
					ELSIF msg.name = "StrokeColor" THEN
						msg.class := Objects.Int; msg.res := 0;
						msg.i := GfxMaps.BestIndex(GfxMaps.DisplayPal, frame.fgCol.r, frame.fgCol.g, frame.fgCol.b)
					ELSIF msg.name = "BackColor" THEN
						msg.class := Objects.Int; msg.res := 0;
						msg.i := GfxMaps.BestIndex(GfxMaps.DisplayPal, frame.bgCol.r, frame.bgCol.g, frame.bgCol.b)
					ELSE
						Gadgets.framehandle(frame, msg)
					END
				ELSIF msg.id = Objects.set THEN
					IF (msg.name = "Iterations") & (msg.class = Objects.Int) & (0 <= msg.i) & (msg.i < 6) THEN
						frame.maxIter := SHORT(msg.i); msg.res := 0
					ELSIF (msg.name = "StrokeColor") & (msg.class = Objects.Int) & (0 <= msg.i) & (msg.i < 256) THEN
						Display.GetColor(SHORT(msg.i), frame.fgCol.r, frame.fgCol.g, frame.fgCol.b);
						msg.res := 0
					ELSIF (msg.name = "BackColor") & (msg.class = Objects.Int) & (0 <= msg.i) & (msg.i < 256) THEN
						Display.GetColor(SHORT(msg.i), frame.bgCol.r, frame.bgCol.g, frame.bgCol.b);
						msg.res := 0
					ELSE
						Gadgets.framehandle(frame, msg)
					END
				ELSIF msg.id = Objects.enum THEN
					msg.Enum("Iterations"); msg.Enum("StrokeColor"); msg.Enum("BackColor");
					Gadgets.framehandle(frame, msg)
				END
			END
		ELSIF msg IS Objects.CopyMsg THEN
			WITH msg: Objects.CopyMsg DO
				IF msg.stamp # frame.stamp THEN
					NEW(copy); frame.dlink := copy; frame.stamp := msg.stamp;
					Gadgets.CopyFrame(msg, frame, copy);
					copy.fgCol := frame.fgCol; copy.bgCol := frame.bgCol; copy.maxIter := frame.maxIter
				END;
				msg.obj := frame.dlink
			END
		ELSIF msg IS Objects.FileMsg THEN
			WITH msg: Objects.FileMsg DO
				Gadgets.framehandle(frame, msg);
				IF msg.id = Objects.store THEN
					Files.WriteNum(msg.R, 1);
					Files.WriteInt(msg.R, frame.maxIter);
					Files.Write(msg.R, CHR(frame.fgCol.r)); Files.Write(msg.R, CHR(frame.fgCol.g));
					Files.Write(msg.R, CHR(frame.fgCol.b));
					Files.Write(msg.R, CHR(frame.bgCol.r)); Files.Write(msg.R, CHR(frame.bgCol.g));
					Files.Write(msg.R, CHR(frame.bgCol.b))
				ELSIF msg.id = Objects.load THEN
					Files.ReadNum(msg.R, ver);
					IF ver >= 1 THEN
						Files.ReadInt(msg.R, frame.maxIter);
						Files.Read(msg.R, ch); frame.fgCol.r := ORD(ch);
						Files.Read(msg.R, ch); frame.fgCol.g := ORD(ch);
						Files.Read(msg.R, ch); frame.fgCol.b := ORD(ch);
						Files.Read(msg.R, ch); frame.bgCol.r := ORD(ch);
						Files.Read(msg.R, ch); frame.bgCol.g := ORD(ch);
						Files.Read(msg.R, ch); frame.bgCol.b := ORD(ch)
					END
				END
			END
		ELSE
			Gadgets.framehandle(frame, msg)
		END
	END HandleFrame;
	
	PROCEDURE InitFrame* (frame: Frame; fgCol, bgCol: Gfx.Color; maxIter: INTEGER);
	BEGIN
		frame.handle := HandleFrame; frame.W := 300; frame.H := 300;
		frame.fgCol := fgCol; frame.bgCol := bgCol; frame.maxIter := maxIter
	END InitFrame;
	
	PROCEDURE NewFrame*;
		VAR frame: Frame;
	BEGIN
		NEW(frame); InitFrame(frame, Gfx.Black, Gfx.White, 3);
		Objects.NewObj := frame
	END NewFrame;
	

BEGIN
	NEW(ClipReg); GfxRegions.Init(ClipReg, GfxRegions.Winding);
	NEW(Ctxt); GfxDisplay.Init(Ctxt, Display.ColLeft, 0, Display.Width, Display.Height)
END GfxDemo.

System.Free GfxDemo ~

Gadgets.Insert GfxDemo.NewFrame ~

