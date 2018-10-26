Picture format conversion

PictConverters.GIFToPict Clown.gif => ClownG.Pict ~
PictConverters.JPEGToPict Clown.jpg => ClownJ.Pict ~
PictConverters.XBMToPict Clown.xbm => ClownX.Pict ~
PictConverters.BMPToPict Clown.bmp => ClownB.Pict ~
PictConverters.AnyToPict Clown.any => ClownA.Pict ~

PictConverters.PictToGIF Clown.Pict => Clown.gif ~

PS.PictToPost Clown.Pict \re 0.9 ~
Desktops.OpenDoc Clown.ps

PS.PictToPost name ["\rae"][adjust] ~ 
	Options:
		r = run length encoding
		e = EPS
		a = A3
		adjust = scaling factor
