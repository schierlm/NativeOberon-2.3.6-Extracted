Get a quick start with Gfx:

What is Gfx?
A set of modules (also known as a library) for rendering
two-dimensional graphics using high-level operations.

Note: This release of Gfx1.30 will only compile on Oberon System 3
release 2.3.4 or later.

Install Documentation
Compress.Extract Gfx130.Arc GfxHowto.html GfxOverview.html ~

Installation
	Compress.Extract Gfx130.Arc
		GfxMatrix.Mod GfxMaps.Mod GfxPictures.Mod GfxPaths.Mod
		GfxRegions.Mod GfxFonts0.Mod GfxFonts.Mod Gfx.Mod
		GfxRaster.Mod GfxPrinter.Mod GfxBuffer.Mod GfxDisplay.Mod
		GfxPS.Mod GfxProlog.ps
	~
	Native -> Builder.Compile GfxFonts0.Mod\s ~
	Windows -> Builder.Compile \D=WIN GfxFonts0.Mod\s ~
	Builder.Compile \s
		GfxMatrix.Mod GfxMaps.Mod\N GfxPictures.Mod\N GfxPaths.Mod
		GfxRegions.Mod GfxFonts.Mod\N Gfx.Mod GfxRaster.Mod
		GfxPrinter.Mod GfxBuffer.Mod GfxDisplay.Mod\N GfxPS.Mod
	~
	Native -> add the following lines to Oberon.Text:
		ImageFormats = {
			Pict = GfxPictures.Install
		}
	Windows -> System.Set ImageFormats Pict := GfxPictures.Install ~

Sample Code
	Compress.Extract Gfx130.Arc GfxTest.Mod GfxDemo.Mod ~
	Builder.Compile GfxTest.Mod\s GfxDemo.Mod\s ~

TrueType Font Support
If you're using the OType package for Oberon, TrueType fonts may
be incorporated into Gfx by following the following steps:

	Compress.Extract Gfx130.Arc GfxOType.Mod ~
	Compiler.Compile GfxOType.Mod\s ~

	Native -> add the following lines to Oberon.Text:
		FontFormats = {
			TTF = GfxOType.Install
		}
	
	Windows -> System.Set FontFormats TTF := GfxOType.Install ~

Change History
1.30 (21.4.1999)
- GfxFonts.Open now expects point size in addition to matrix
- font matrix contains transform from default display coordinates
- unified GfxFonts0
- support for TrueColor and TransferBlock in GfxDisplay
- more optimized blend procedures in GfxMaps
- added GfxMaps.InitBuf
- bugfix in GfxMaps.Transform: incorrect overlay of temporary maps
- bugfix in GfxRaster.Rect: incorrect use of GfxRegions.AddPoint with Clip
- made GfxSetDashArray guarantee that (len=0) or (period#0)
- fix in GfxRaster.DashLineTo: didn't always start next dash
- bugfix in GfxFonts.WFGetWidth (dy = dx)

1.20 (10.3.1999)
- GfxPens no longer part of Gfx (has been integrated into LeoPens)
- dash pattern in Gfx separated in two arrays for on/off lengths

1.11 (8.3.1999)
- GfxMaps.Copy now handles overlapping rectangles
- GfxPens no longer part of Gfx release (incorporated into Leonardo)

1.1b (4.3.1999)
- handle Display.Depth() > 8 in GfxMaps.InitDisplayPalette
- fixed wrong matrix in GfxFonts.InitDefault
- Native.GfxFonts0 made more robust when dealing with metric only fonts
- addition of GfxPaths.Split
- GfxMaps are now derived from Objects.Object

1.02b (20.1.1999)
- bugfix in GfxPens.CopyRef (stamp not copied)
- bugfix in GfxRaster (wrong calculation of devWidth)

1.0b (15.12.1998)
- no further changes in design expected
