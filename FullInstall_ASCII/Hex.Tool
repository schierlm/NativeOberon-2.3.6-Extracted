Hex.Open ^	Opens a file in a new document

Hex.Search ^	Searchs a pattern in the marked document
Hex.Locate ^	Sets the caret in the marked document


Hex-Dump Utility for Oberon (ps Oct. 96)
__________________________________________________________________

Abstract
Hex is a tool to inspect arbitrary files. Hex displays the file in three columns: absolute address of a byte (position in file), hexadecimal dump and ASCII dump. Editing is possible both, in hexadecimal and ASCII dump. Press the insert key to change editing mode (repalce/insert). A box caret indicates replace mode, insert mode is represented by the standard text caret. The caret is set with a click of the left mouse button. Cursor keys as well as home, end, page-up and page-down keys can be used to navigate through the file. Changes to a file must be made permanent with Store. To interpret a sequence of bytes in a specific format, press the middle mouse button on the first byte of the sequence. A popup list shows all possible formats. The result is written to the System.Log.

Keyboard
	Delete 	delete byte at current caret position (works in in
		insert mode only).
	Backspace	delete byte to the left of the caret (works in
		inset mode only).
	Enter	flip caret between hex and ASCII dump.
	Cursor keys	navigate through the file
	Page-Up/Down	scroll one page
	Home	scroll to top of file
	End	scroll to end of file
	Tab	move by 4 bytes (use Shift to move back)
	Insert	toggle between replace and insert mode

Mouse
	Left	set caret
	Middle	interpret sequence of bytes

Byte formats
	LONGINT (LSB)	interprets 4 bytes as little endian integer value
	INTEGER (LSB)	interprets 2 bytes as little endian integer value
	SHORTINT	interprets byte as integer value
	NUM	interprets bytes as oberon number
	REAL	interprets 4 bytes as real value
	LONGREAL	interprets 8 bytes as real value
	SET	interprets 4 bytes as oberon set
	ADDR	interprets 4 bytes as rel. address
		result := cur. pos + value + 4
	LONGINT (LSB)	interprets 4 bytes as big endian integer value
	INTEGER (LSB)	interprets 2 bytes as big endian integer value

Menubar
	Store 	writes an edited file back to disk and performs
		a backup copy of the old file (extension ".Bak").
	Search 	searches for the pattern found in the most 
		recent selection and positions the cursor at the
		beginnig of the next occurrence of the pattern
		in the file. The search begins at the current
		cursor position or at the beginning of the file if
		no cursor is visible.

Search patterns
	string	sequence of characters
	hexstream	sequence of hexdigits starting with '#h'
	bitstream	sequence of '0'/'1' starting with '#b'
