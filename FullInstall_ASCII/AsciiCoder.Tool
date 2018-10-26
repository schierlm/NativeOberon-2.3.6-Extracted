AsciiCoder can be used to encode and decode any text (including gadgets) visible on screen as well as to encode and decode arbitrary files. The code is fully ascii and can be used for mailing. The coded texts and files are always represented as text in a viewer. Hence, the CodeFiles, CodeText, and DecodeText commands can not do any damage to other data. Of course, DecodeFiles will overwrite existing files of the same name, but .Bak files are created.

AsciiCoder.CodeText *	encodes text of marked viewer
AsciiCoder.CodeText @	encodes most recent selected text
AsciiCoder.DecodeText @	decodes from beginning of the most
	recent selection as text

AsciiCoder.CodeFiles ^	encodes all files of the list beginning at
	the most recent selection
AsciiCoder.CodeFiles ~	encodes all files of the list
AsciiCoder.DecodeFiles @	decodes from beginning of the most
	recent selection and writes to files. The
	file names have to preceed the code.

Insertion of an '%' between the command name and the first parameter turns on compression, respectively expansion, of the coded data:

AsciiCoder.CodeText % *
AsciiCoder.CodeText % @
AsciiCoder.DecodeText % @
AsciiCoder.CodeFiles % ^
AsciiCoder.CodeFiles % ~
AsciiCoder.DecodeFiles % @

