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

MODULE Keyboard;	(** non-portable *)	(* pjm *)

(* Tool to help construct keyboard table files for Native Oberon. *)

(* Using this tool to create a new keyboard table:

1. Copy one of the existing keyboard table procedures, e.g. TableUS, and give it a new name, say TableXX.
2. Make an ELSIF entry in FindTable for the new procedure, e.g. ELSIF k = "XX" THEN table := TableXX()
3. Edit the keyboard table in TableXX.  See the comment below for the format.
4. Compile and execute Keyboard.FileFromTable XX KeyXX.Bin to generate the keyboard table file.
5. Execute Keyboard.Table KeyXX.Bin to view the keyboard table.
6. Reboot, hold shift to get the OBL> prompt, and set Keyboard=KeyXX.Bin to test the table.
*)

IMPORT Files, Texts, Oberon, SYSTEM, Viewers, MenuViewers, TextFrames, In;

CONST
	NumLock = 1;  CapsLock = 2;  LAlt = 3;  RAlt = 4;
	LCtrl = 5;  RCtrl = 6;  LShift = 7;  RShift = 8;
	DK = 16;

VAR
	W: Texts.Writer;
	normal: ARRAY 54 OF CHAR;	(* 01H..35H *)
	keytable: POINTER TO ARRAY OF CHAR;

(* Translation table format:  

	table = { scancode unshifted-code shifted-code flags }  0FFX .
	scancode = <scancode byte from keyboard, bit 7 set for "grey" extended keys>
	unshifted-code = <CHAR produced by this scancode, without shift>
	shifted-code = <CHAR produced by this scancode, with shift>
	flags = <bit-mapped flag byte indicating special behaviour>
	
	flag bit	function
		0	01	DeadKey: Set dead key flag according to translated key code (1-7)
		1	02	NumLock: if set, the state of NumLock will reverse the action of shift (for num keypad)
		2	04	CapsLock: if set, the state of CapsLock will reverse the action of shift (for alpha keys)
		3	08	LAlt:  \ the state of these two flags in the table and the current state of the two...
		4	10	RAlt: / ...Alt keys must match exactly, otherwise the search is continued.
		5	20	\
		6	40	 >  dead key number (0-7), must match current dead key flag
		7	80	/
	
	The table is scanned sequentially (speed not critical).  Ctrl/Ctrl-Alt Break & Ctrl-F10
	are always defined and are not in the table.   The control keys are also always defined. *)

(* TableUS - US keyboard translation table (dead keys: ^=1, '=2, `=3, ~=4, "=5) *)

PROCEDURE TableUS(): LONGINT;
CODE {SYSTEM.i386}
	CALL L1
L1:
	POP EAX
	ADD EAX,8
	POP EBP
	RET
		(* alphabet *)
	DB 1EX, "a", "A", 4X,	30X, "b", "B", 4X,	2EX, "c", "C", 4X,	20X, "d", "D", 4X
	DB 12X, "e", "E", 4X,	21X, "f", "F", 4X,	22X, "g", "G", 4X,	23X, "h", "H", 4X
	DB 17X, "i", "I", 4X,	24X, "j", "J", 4X,	25X, "k", "K", 4X,	26X, "l", "L", 4X
	DB 32X, "m", "M", 4X,	31X, "n", "N", 4X,	18X, "o", "O", 4X,	19X, "p", "P", 4X
	DB 10X, "q", "Q", 4X,	13X, "r", "R", 4X,	1FX, "s", "S", 4X,	14X, "t", "T", 4X
	DB 16X, "u", "U", 4X,	2FX, "v", "V", 4X,	11X, "w", "W", 4X,	2DX, "x", "X", 4X
	DB 15X, "y", "Y", 4X,	2CX, "z", "Z", 4X
		(* Oberon accents (LAlt & RAlt) *)
	DB 1EX, "", "", 0CX,	12X, "", 0FFX, 0CX,	18X, "", "", 0CX,	16X, "", "", 0CX
	DB 17X, "", 0FFX, 0CX,	1FX, "", 0FFX, 0CX,	2EX, "", 0FFX, 0CX,	31X, "", 0FFX, 0CX
	DB 1EX, "", "", 14X,	12X, "", 0FFX, 14X,	18X, "", "", 14X,	16X, "", "", 14X
	DB 17X, "", 0FFX, 14X,	1FX, "", 0FFX, 14X,	2EX, "", 0FFX, 14X,	31X, "", 0FFX, 14X
		(* dead keys (LAlt & RAlt) *)
	DB 07X, 0FFX, 1X, 9X,	28X, 2X, 5X, 9X,	29X, 3X, 4X, 9X,
	DB 07X, 0FFX, 1X, 11X,	28X, 2X, 5X, 11X,	29X, 3X, 4X, 11X,
		(* following keys *)
	DB 1EX, "", 0FFX, 20X,	12X, "", 0FFX, 20X,	17X, "", 0FFX, 20X,	18X, "", 0FFX, 20X
	DB 16X, "", 0FFX, 20X,	1EX, "", 0FFX, 60X,	12X, "", 0FFX, 60X,	17X, "", 0FFX, 60X
	DB 18X, "", 0FFX, 60X,	16X, "", 0FFX, 60X,	1EX, "", 0FFX, 40X,	12X, "", 0FFX, 40X
	DB 1EX, "", "", 0A4X,	12X, "", 0FFX, 0A0X,	17X, "", 0FFX, 0A0X,	18X, "", "", 0A4X
	DB 16X, "", "", 0A4X,	31X, "", 0FFX, 80X
		(* numbers at top *)
	DB 0BX, "0", ")", 0X,	02X, "1", "!", 0X,	03X, "2", "@", 0X,	04X, "3", "#", 0X
	DB 05X, "4", "$", 0X,	06X, "5", "%", 0X,	07X, "6", "^", 0X,	08X, "7", "&", 0X
	DB 09X, "8", "*", 0X,	0AX, "9", "(", 0X
		(* symbol keys *)
	DB 28X, "'", 22X, 0X,	33X, ",", "<", 0X,	0CX, "-", "_", 0X,	34X, ".", ">", 0X
	DB 35X, "/", "?", 0X,	27X, ";", ":", 0X,	0DX, "=", "+", 0X,	1AX, "[", "{", 0X
	DB 2BX, "\", "|", 0X,	1BX, "]", "}", 0X,	29X, "`", "~", 0X
		(* control keys *)
	DB 0EX, 7FX, 7FX, 0X	(* backspace *)
	DB 0FX, 09X, 09X, 0X	(* tab *)
	DB 1CX, 0DX, 0DX, 0X	(* enter *)
	DB 39X, 20X, 20X, 0X	(* space *)
	DB 01X, 0FEX, 1BX, 0X	(* esc *)
	 	(* keypad *)
	DB 4FX, 0A9X, "1", 2X	(* end/1 *)
	DB 50X, 0C2X, "2", 2X	(* down/2 *)
	DB 51X, 0A3X, "3", 2X	(* pgdn/3 *)
	DB 4BX, 0C4X, "4", 2X	(* left/4 *)
	DB 4CX, 0FFX, "5", 2X	(* center/5 *)
	DB 4DX, 0C3X, "6", 2X	(* right/6 *)
	DB 47X, 0A8X, "7", 2X	(* home/7 *)
	DB 48X, 0C1X, "8", 2X	(* up/8 *)
	DB 49X, 0A2X, "9", 2X	(* pgup/9 *)
	DB 52X, 0A0X, "0", 2X	(* insert/0 *)
	DB 53X, 0A1X, 2EX, 2X	(* del/. *)
		(* gray keys *)
	DB 4AX, "-", "-", 0X	(* gray - *)
	DB 4EX, "+", "+", 0X	(* gray + *)
	DB 0B5X, "/", "/", 0X	(* gray / *)
	DB 37X, "*", "*", 0X	(* gray * *)
	DB 0D0X, 0C2X, 0C2X, 0X	(* gray down *)
	DB 0CBX, 0C4X, 0C4X, 0X	(* gray left *)
	DB 0CDX, 0C3X, 0C3X, 0X	(* gray right *)
	DB 0C8X, 0C1X, 0C1X, 0X	(* gray up *)
	DB 09CX, 0DX, 0DX, 0X	(* gray enter *)
	DB 0D2X, 0A0X, 0A0X, 0X	(* gray ins *)
	DB 0D3X, 0A1X, 0A1X, 0X	(* gray del *)
	DB 0C9X, 0A2X, 0A2X, 0X	(* gray pgup *)
	DB 0D1X, 0A3X, 0A3X, 0X	(* gray pgdn *)
	DB 0C7X, 0A8X, 0A8X, 0X	(* gray home *)
	DB 0CFX, 0A9X, 0A9X, 0X	(* gray end *)
		(* function keys *)
	DB 3BX, 0A4X, 0FFX, 0X	(* F1 *)
	DB 3CX, 0A5X, 0FFX, 0X	(* F2 *)
	DB 3DX, 1BX, 0FFX, 0X	(* F3 *)
	DB 3EX, 0A7X, 0FFX, 0X	(* F4 *)
	DB 3FX, 0F5X, 0FFX, 0X	(* F5 *)
	DB 40X, 0F6X, 0FFX, 0X	(* F6 *)
	DB 41X, 0F7X, 0FFX, 0X	(* F7 *)
	DB 42X, 0F8X, 0FFX, 0X	(* F8 *)
	DB 43X, 0F9X, 0FFX, 0X	(* F9 *)
	DB 44X, 0FAX, 0FFX, 0X	(* F10 *)
	DB 57X, 0FBX, 0FFX, 0X	(* F11 *)
	DB 58X, 0FCX, 0FFX, 0X	(* F12 *)
	DB 0FFX
END TableUS;

(* TableTR - TR keyboard translation table by fnecati@penta.gyte.edu.tr *)
	
PROCEDURE TableTR(): LONGINT;
CODE {SYSTEM.i386}

  CALL L1
L1:
	POP EAX
	ADD EAX,8
	POP EBP
	RET  
	 	(* alphabet *)
	DB 1EX, "a", "A", 4X,	 30X, "b", "B", 4X,	 2EX, "c", "C", 4X,	    20X, "d", "D", 4X
	DB 12X, "e", "E", 4X,	 21X, "f", "F", 4X,	   22X, "g", "G", 4X,	   23X, "h", "H", 4X
	DB 28X,"i", 0ABX ,4X,         24X, "j", "J", 4X,	    25X, "k", "K", 4X,	   26X, "l", "L", 4X
	DB 32X, "m", "M", 4X,	31X, "n", "N", 4X,	18X, "o", "O", 4X,	  19X, "p", "P", 4X
	DB 10X, "q", "Q", 4X,	13X, "r", "R", 4X,	  1FX, "s", "S", 4X,	   14X, "t", "T", 4X
	DB 16X, "u", "U", 4X, 	2FX, "v", "V", 4X,	  11X, "w", "W", 4X,	2DX, "x", "X", 4X
	DB 15X, "y", "Y", 4X,	  2CX, "z", "Z", 4X

				(* Oberon accents *)

	DB 1EX, "", "", 0CX,	12X, "", 0FFX, 0CX,	18X, "", "", 0CX,	16X, "", "", 0CX
	DB 1FX, "", 0FFX, 0CX,	2EX, "", 0FFX, 0CX,	31X, "", 0FFX, 0CX

		(* numbers at top *)
	DB 0BX, "0", "=", 0X,	02X, "1", "!", 0X,	03X, "2","'" , 0X,	04X, "3", "^", 0X
	DB 05X, "4", "+", 0X,	06X, "5", "%", 0X,	07X, "6", "&", 0X,	08X, "7", "/", 0X
	DB 09X, "8", "(", 0X,	0AX, "9", ")", 0X
	
			(* dead keys (LAlt & RAlt) *)
			
(*	DB 07X, 0FFX, 1X, 9X,	28X, 2X, 5X, 9X,	29X, 3X, 4X, 9X		*)
(*	DB 07X, 0FFX, 1X, 11X,	28X, 2X, 5X, 11X,	29X, 3X, 4X, 11X	*)

	
		(* Turkish symbol keys *)
	DB 34X, "", 0ACX , 4X, (**)      1AX, 0AFX, 0B0X, 4X, (*g,G*)         17X, 0AAX,"I", 4X	(*i,I*)  
	DB 33X, "", "", 4X, (*,*)    27X, 0ADX, 0AEX, 4X, (* s,S *)        1BX, "", "",4X	(*,*)   	(* my codes*)  
	
	DB 29X, 22X,"\", 0X,		0DX, "-", "_", 0X,        35X, ".", ":", 0X
	DB 2BX, ",", ";", 0X,	    56X, "<", ">", 0X,         0CX, "*", "?", 0X
	
		(* AltGr keys *)
	DB 0BX, "}", 0FFX, 10X,	10X, "@", 0FFX, 10X,	04X, "#", 0FFX, 10X,	05X, "$", 0FFX, 10X
	DB 08X, "{", 0FFX, 10X,	09X, "[", 0FFX, 10X,	0AX, "]", 0FFX, 10X,	1BX, "~", 0FFX, 10X
	DB 0DX, "`", 0FFX, 10X,	0CX, "\", 0FFX, 10X,	 56X, "|", 0FFX, 10X
		(* control keys *)
	DB 0EX, 7FX, 7FX, 0X	(* backspace *)
	DB 0FX, 09X, 09X, 0X	(* tab *)
	DB 1CX, 0DX, 0DX, 0X	(* enter *)
	DB 39X, 20X, 20X, 0X	(* space *)
	DB 01X, 1BX, 1BX, 0X	(* esc *)
		(* keypad *)
DB 4FX, 0A9X, "1", 2X	(* end/1 *)
	DB 50X, 0C2X, "2", 2X	(* down/2 *)
	DB 51X, 0A3X, "3", 2X	(* pgdn/3 *)
	DB 4BX, 0C4X, "4", 2X	(* left/4 *)
	DB 4CX, 0FFX, "5", 2X	(* center/5 *)
	DB 4DX, 0C3X, "6", 2X	(* right/6 *)
	DB 47X, 0A8X, "7", 2X	(* home/7 *)
	DB 48X, 0C1X, "8", 2X	(* up/8 *)
	DB 49X, 0A2X, "9", 2X	(* pgup/9 *)
	DB 52X, 0A0X, "0", 2X	(* insert/0 *)
	DB 53X, 0A1X, 2EX, 2X	(* del/. *)
		(* gray keys *)
	DB 4AX, "-", "-", 0X	(* gray - *)
	DB 4EX, "+", "+", 0X	(* gray + *)
	DB 0B5X, "/", "/", 0X	(* gray / *)
	DB 37X, "*", "*", 0X	(* gray * *)
	DB 0D0X, 0C2X, 0C2X, 0X	(* gray down *)
	DB 0CBX, 0C4X, 0C4X, 0X	(* gray left *)
	DB 0CDX, 0C3X, 0C3X, 0X	(* gray right *)
	DB 0C8X, 0C1X, 0C1X, 0X	(* gray up *)
	DB 09CX, 0DX, 0DX, 0X	(* gray enter *)
	DB 0D2X, 0A0X, 0A0X, 0X	(* gray ins *)
	DB 0D3X, 0A1X, 0A1X, 0X	(* gray del *)
	DB 0C9X, 0A2X, 0A2X, 0X	(* gray pgup *)
	DB 0D1X, 0A3X, 0A3X, 0X	(* gray pgdn *)
	DB 0C7X, 0A8X, 0A8X, 0X	(* gray home *)
	DB 0CFX, 0A9X, 0A9X, 0X	(* gray end *)
		(* function keys *)

	DB 3BX, 0A4X, 0FFX, 0X	(* F1 *)
	DB 3CX, 0A5X, 0FFX, 0X	(* F2 *)
	DB 3DX, 1BX, 0FFX, 0X	(* F3 *)
	DB 3EX, 0A7X, 0FFX, 0X	(* F4 *)
	DB 3FX, 0F5X, 0FFX, 0X	(* F5 *)
	DB 40X, 0F6X, 0FFX, 0X	(* F6 *)
	DB 41X, 0F7X, 0FFX, 0X	(* F7 *)
	DB 42X, 0F8X, 0FFX, 0X	(* F8 *)
	DB 43X, 0F9X, 0FFX, 0X	(* F9 *)
	DB 44X, 0FAX, 0FFX, 0X	(* F10 *)
	DB 57X, 0FBX, 0FFX, 0X	(* F11 *)
	DB 58X, 0FCX, 0FFX, 0X	(* F12 *)
	DB 0FFX
 END TableTR;

(* TableNorwegian - Norwegian keyboard translation table *)

PROCEDURE TableNorwegian(): LONGINT;
CODE {SYSTEM.i386}
	CALL L1
L1:
	POP EAX
	ADD EAX,8
	POP EBP
	RET
	 	(* alphabet *)
	DB 1EX, "a", "A", 4X,	30X, "b", "B", 4X,	2EX, "c", "C", 4X,	20X, "d", "D", 4X
	DB 12X, "e", "E", 4X,	21X, "f", "F", 4X,	22X, "g", "G", 4X,	23X, "h", "H", 4X
	DB 17X, "i", "I", 4X,	24X, "j", "J", 4X,	25X, "k", "K", 4X,	26X, "l", "L", 4X
	DB 32X, "m", "M", 4X,	31X, "n", "N", 4X,	18X, "o", "O", 4X,	19X, "p", "P", 4X
	DB 10X, "q", "Q", 4X,	13X, "r", "R", 4X,	1FX, "s", "S", 4X,	14X, "t", "T", 4X
	DB 16X, "u", "U", 4X,	2FX, "v", "V", 4X,	11X, "w", "W", 4X,	2DX, "x", "X", 4X
	DB 15X, "y", "Y", 4X,	2CX, "z", "Z", 4X
		(* Oberon accents (LAlt & RAlt) *)
	DB 1EX, "", "", 0CX,	12X, "", 0FFX, 0CX,	18X, "", "", 0CX,	16X, "", "", 0CX
	DB 17X, "", 0FFX, 0CX,	1FX, "", 0FFX, 0CX,	2EX, "", 0FFX, 0CX,	31X, "", 0FFX, 0CX
	DB 1EX, "", "", 14X,	12X, "", 0FFX, 14X,	18X, "", "", 14X,	16X, "", "", 14X
	DB 17X, "", 0FFX, 14X,	1FX, "", 0FFX, 14X,	2EX, "", 0FFX, 14X,	31X, "", 0FFX, 14X
		(* numbers at top *)
	DB 0BX, "0", "=", 0X,	02X, "1", "!", 0X,	03X, "2", 22X, 0X,	04X, "3", "#", 0X
	DB 05X, "4", 0FFX, 0X,	06X, "5", "%", 0X,	07X, "6", "&", 0X,	08X, "7", "/", 0X
	DB 09X, "8", "(", 0X,	0AX, "9", ")", 0X
		(* symbol keys *)
	DB 28X, 0FFX, 0FFX, 0X,	33X, ",", ";", 0X,	0CX, "+", "?", 0X,	34X, ".", ":", 0X
	DB 35X, "-", "_", 0X,	27X, 0FFX, 0FFX, 0X,	0DX, "\", "`", 0X,	1AX, 0FFX, 0FFX, 0X
	DB 1BX, 0FFX, "^", 0X,	29X, "|", 0FFX, 0X,	5DX, ",", "*", 0X,	61X, "<", ">", 0X
	DB 2BX, ",", "*", 0X,	56X, "<", ">", 0X
		(* AltGr keys *)
	DB 0BX, "}", 0FFX, 10X,	03X, "@", 0FFX, 10X,	04X, 0FFX, 0FFX, 10X,	05X, "$", 0FFX, 10X
	DB 08X, "{", 0FFX, 10X,	09X, "[", 0FFX, 10X,	0AX, "]", 0FFX, 10X,	1BX, "~", 0FFX, 10X
	DB 0DX, "'", 0FFX, 10X
		(* control keys *)
	DB 0EX, 7FX, 7FX, 0X	(* backspace *)
	DB 0FX, 09X, 09X, 0X	(* tab *)
	DB 1CX, 0DX, 0DX, 0X	(* enter *)
	DB 39X, 20X, 20X, 0X	(* space *)
	DB 01X, 0FEX, 1BX, 0X	(* esc *)
		(* keypad *)
	DB 4FX, 0A9X, "1", 2X	(* end/1 *)
	DB 50X, 0C2X, "2", 2X	(* down/2 *)
	DB 51X, 0A3X, "3", 2X	(* pgdn/3 *)
	DB 4BX, 0C4X, "4", 2X	(* left/4 *)
	DB 4CX, 0FFX, "5", 2X	(* center/5 *)
	DB 4DX, 0C3X, "6", 2X	(* right/6 *)
	DB 47X, 0A8X, "7", 2X	(* home/7 *)
	DB 48X, 0C1X, "8", 2X	(* up/8 *)
	DB 49X, 0A2X, "9", 2X	(* pgup/9 *)
	DB 52X, 0A0X, "0", 2X	(* insert/0 *)
	DB 53X, 0A1X, 2EX, 2X	(* del/. *)
		(* gray keys *)
	DB 4AX, "-", "-", 0X	(* gray - *)
	DB 4EX, "+", "+", 0X	(* gray + *)
	DB 0B5X, "/", "/", 0X	(* gray / *)
	DB 37X, "*", "*", 0X	(* gray * *)
	DB 0D0X, 0C2X, 0C2X, 0X	(* gray down *)
	DB 0CBX, 0C4X, 0C4X, 0X	(* gray left *)
	DB 0CDX, 0C3X, 0C3X, 0X	(* gray right *)
	DB 0C8X, 0C1X, 0C1X, 0X	(* gray up *)
	DB 09CX, 0DX, 0DX, 0X	(* gray enter *)
	DB 0D2X, 0A0X, 0A0X, 0X	(* gray ins *)
	DB 0D3X, 0A1X, 0A1X, 0X	(* gray del *)
	DB 0C9X, 0A2X, 0A2X, 0X	(* gray pgup *)
	DB 0D1X, 0A3X, 0A3X, 0X	(* gray pgdn *)
	DB 0C7X, 0A8X, 0A8X, 0X	(* gray home *)
	DB 0CFX, 0A9X, 0A9X, 0X	(* gray end *)
		(* function keys *)
	DB 3BX, 0A4X, 0FFX, 0X	(* F1 *)
	DB 3CX, 0A5X, 0FFX, 0X	(* F2 *)
	DB 3DX, 1BX, 0FFX, 0X	(* F3 *)
	DB 3EX, 0A7X, 0FFX, 0X	(* F4 *)
	DB 3FX, 0F5X, 0FFX, 0X	(* F5 *)
	DB 40X, 0F6X, 0FFX, 0X	(* F6 *)
	DB 41X, 0F7X, 0FFX, 0X	(* F7 *)
	DB 42X, 0F8X, 0FFX, 0X	(* F8 *)
	DB 43X, 0F9X, 0FFX, 0X	(* F9 *)
	DB 44X, 0FAX, 0FFX, 0X	(* F10 *)
	DB 57X, 0FBX, 0FFX, 0X	(* F11 *)
	DB 58X, 0FCX, 0FFX, 0X	(* F12 *)
	DB 0FFX
END TableNorwegian;

(* TableGerman - German keyboard translation table *)

PROCEDURE TableGerman(): LONGINT;
CODE {SYSTEM.i386}
	CALL L1
L1:
	POP EAX
	ADD EAX,8
	POP EBP
	RET
		(* alphabet *)
	DB 1EX, "a", "A", 4X,	30X, "b", "B", 4X,	2EX, "c", "C", 4X,	20X, "d", "D", 4X
	DB 12X, "e", "E", 4X,	21X, "f", "F", 4X,	22X, "g", "G", 4X,	23X, "h", "H", 4X
	DB 17X, "i", "I", 4X,	24X, "j", "J", 4X,	25X, "k", "K", 4X,	26X, "l", "L", 4X
	DB 32X, "m", "M", 4X,	31X, "n", "N", 4X,	18X, "o", "O", 4X,	19X, "p", "P", 4X
	DB 10X, "q", "Q", 4X,	13X, "r", "R", 4X,	1FX, "s", "S", 4X,	14X, "t", "T", 4X
	DB 16X, "u", "U", 4X,	2FX, "v", "V", 4X,	11X, "w", "W", 4X,	2DX, "x", "X", 4X
	DB 15X, "z", "Z", 4X,	2CX, "y", "Y", 4X
		(* Oberon accents (LAlt & RAlt) *)
	DB 1EX, "", "", 0CX,	12X, "", 0FFX, 0CX,	18X, "", "", 0CX,	16X, "", "", 0CX
	DB 17X, "", 0FFX, 0CX,	1FX, "", 0FFX, 0CX,	2EX, "", 0FFX, 0CX,	31X, "", 0FFX, 0CX
	DB 1EX, "", "", 14X,	12X, "", 0FFX, 14X,	18X, "", "", 14X,	16X, "", "", 14X
	DB 17X, "", 0FFX, 14X,	1FX, "", 0FFX, 14X,	2EX, "", 0FFX, 14X,	31X, "", 0FFX, 14X
		(* numbers at top *)
	DB 0BX, "0", "=", 0X,	02X, "1", "!", 0X,	03X, "2", 22X, 0X,	04X, "3", 0FFX, 0X
	DB 05X, "4", "$", 0X,	06X, "5", "%", 0X,	07X, "6", "&", 0X,	08X, "7", "/", 0X
	DB 09X, "8", "(", 0X,	0AX, "9", ")", 0X
		(* symbol keys *)
	DB 28X, "", "", 0X,	33X, ",", ";", 0X,	0CX, "", "?", 0X,	34X, ".", ":", 0X
	DB 35X, "-", "_", 0X,	27X, "", "", 0X,	0DX, "'", "`", 0X,	1AX, "", "", 0X
	DB 2BX, "#", "'", 0X,	1BX, "+", "*", 0X,	29X, "^", 0FFX, 0X,	56X, "<", ">", 0X
		(* AltGr keys *)
	DB 32X, 0FFX, 0FFX, 10X,	10X, "@", 0FFX, 10X,	0BX, "}", 0FFX, 10X,	03X, 0FFX, 0FFX, 10X
	DB 04X, 0FFX, 0FFX, 10X,	08X, "{", 0FFX, 10X,	09X, "[", 0FFX, 10X,	0AX, "]", 0FFX, 10X
	DB 0CX, "\", 0FFX, 10X,	1BX, "~", 0FFX, 10X,	56X, "|", 0FFX, 10X
		(* control keys *)
	DB 0EX, 7FX, 7FX, 0X	(* backspace *)
	DB 0FX, 09X, 09X, 0X	(* tab *)
	DB 1CX, 0DX, 0DX, 0X	(* enter *)
	DB 39X, 20X, 20X, 0X	(* space *)
	DB 01X, 0FEX, 1BX, 0X	(* esc *)
		(* keypad *)
	DB 4FX, 0A9X, "1", 2X	(* end/1 *)
	DB 50X, 0C2X, "2", 2X	(* down/2 *)
	DB 51X, 0A3X, "3", 2X	(* pgdn/3 *)
	DB 4BX, 0C4X, "4", 2X	(* left/4 *)
	DB 4CX, 0FFX, "5", 2X	(* center/5 *)
	DB 4DX, 0C3X, "6", 2X	(* right/6 *)
	DB 47X, 0A8X, "7", 2X	(* home/7 *)
	DB 48X, 0C1X, "8", 2X	(* up/8 *)
	DB 49X, 0A2X, "9", 2X	(* pgup/9 *)
	DB 52X, 0A0X, "0", 2X	(* insert/0 *)
	DB 53X, 0A1X, 2EX, 2X	(* del/. *)
		(* gray keys *)
	DB 4AX, "-", "-", 0X	(* gray - *)
	DB 4EX, "+", "+", 0X	(* gray + *)
	DB 0B5X, "/", "/", 0X	(* gray / *)
	DB 37X, "*", "*", 0X	(* gray * *)
	DB 0D0X, 0C2X, 0C2X, 0X	(* gray down *)
	DB 0CBX, 0C4X, 0C4X, 0X	(* gray left *)
	DB 0CDX, 0C3X, 0C3X, 0X	(* gray right *)
	DB 0C8X, 0C1X, 0C1X, 0X	(* gray up *)
	DB 09CX, 0DX, 0DX, 0X	(* gray enter *)
	DB 0D2X, 0A0X, 0A0X, 0X	(* gray ins *)
	DB 0D3X, 0A1X, 0A1X, 0X	(* gray del *)
	DB 0C9X, 0A2X, 0A2X, 0X	(* gray pgup *)
	DB 0D1X, 0A3X, 0A3X, 0X	(* gray pgdn *)
	DB 0C7X, 0A8X, 0A8X, 0X	(* gray home *)
	DB 0CFX, 0A9X, 0A9X, 0X	(* gray end *)
		(* function keys *)
	DB 3BX, 0A4X, 0FFX, 0X	(* F1 *)
	DB 3CX, 0A5X, 0FFX, 0X	(* F2 *)
	DB 3DX, 1BX, 0FFX, 0X	(* F3 *)
	DB 3EX, 0A7X, 0FFX, 0X	(* F4 *)
	DB 3FX, 0F5X, 0FFX, 0X	(* F5 *)
	DB 40X, 0F6X, 0FFX, 0X	(* F6 *)
	DB 41X, 0F7X, 0FFX, 0X	(* F7 *)
	DB 42X, 0F8X, 0FFX, 0X	(* F8 *)
	DB 43X, 0F9X, 0FFX, 0X	(* F9 *)
	DB 44X, 0FAX, 0FFX, 0X	(* F10 *)
	DB 57X, 0FBX, 0FFX, 0X	(* F11 *)
	DB 58X, 0FCX, 0FFX, 0X	(* F12 *)
	DB 0FFX
END TableGerman;

(* TableSwiss - Swiss keyboard translation table (dead keys: ^=1, '=2, `=3, ~=4, "=5) *)

PROCEDURE TableSwiss(): LONGINT;
CODE {SYSTEM.i386}
	CALL L1
L1:
	POP EAX
	ADD EAX,8
	POP EBP
	RET
		(* alphabet *)
	DB 1EX, "a", "A", 4X,	30X, "b", "B", 4X,	2EX, "c", "C", 4X,	20X, "d", "D", 4X
	DB 12X, "e", "E", 4X,	21X, "f", "F", 4X,	22X, "g", "G", 4X,	23X, "h", "H", 4X
	DB 17X, "i", "I", 4X,	24X, "j", "J", 4X,	25X, "k", "K", 4X,	26X, "l", "L", 4X
	DB 32X, "m", "M", 4X,	31X, "n", "N", 4X,	18X, "o", "O", 4X,	19X, "p", "P", 4X
	DB 10X, "q", "Q", 4X,	13X, "r", "R", 4X,	1FX, "s", "S", 4X,	14X, "t", "T", 4X
	DB 16X, "u", "U", 4X,	2FX, "v", "V", 4X,	11X, "w", "W", 4X,	2DX, "x", "X", 4X
	DB 15X, "z", "Z", 4X,	2CX, "y", "Y", 4X
		(* Oberon accents (LAlt & RAlt) *)
	DB 1EX, "", "", 0CX,	12X, "", 0FFX, 0CX,	18X, "", "", 0CX,	16X, "", "", 0CX
	DB 17X, "", 0FFX, 0CX,	1FX, "", 0FFX, 0CX,	2EX, "", 0FFX, 0CX,	31X, "", 0FFX, 0CX
	DB 1EX, "", "", 14X,	12X, "", 0FFX, 14X,	18X, "", "", 14X,	16X, "", "", 14X
	DB 17X, "", 0FFX, 14X,	1FX, "", 0FFX, 14X,	2EX, "", 0FFX, 14X,	31X, "", 0FFX, 14X
		(* numbers at top *)
	DB 0BX, "0", "=", 0X,	02X, "1", "+", 0X,	03X, "2", 22X, 0X,	04X, "3", "*", 0X
	DB 05X, "4", "", 0X,	06X, "5", "%", 0X,	07X, "6", "&", 0X,	08X, "7", "/", 0X
	DB 09X, "8", "(", 0X,	0AX, "9", ")", 0X
	 	(* symbol keys *)
	DB 28X, "", "", 0X,	33X, ",", ";", 0X,	0CX, "'", "?", 0X,	34X, ".", ":", 0X
	DB 35X, "-", "_", 0X,	27X, "", "", 0X,	0DX, 1X, 3X, 1X,	1AX, "", "", 0X
	DB 2BX, "$", 0FFX, 0X,	1BX, 5X, "!", 1X,	29X, 0FFX, 0FFX, 0X,	56X, "<", ">", 0X
		(* AltGr keys *)
	DB 02X, "|", 0FFX, 10X,	03X, "@", 0FFX, 10X,	04X, "#", 0FFX, 10X,	28X, "{", 0FFX, 10X
	DB 0CX, 2X, 0FFX, 11X,	27X, "", "", 10X,	0DX, 4X, 0FFX, 11X,	1AX, "[", 0FFX, 10X
	DB 56X, "\", 0FFX, 10X,	1BX, "]", 0FFX, 10X,	2BX, "}", 0FFX, 10X,	08X, "|", 0FFX, 10X
		(* dead keys *)
	DB 39X, "^", 0FFX, 20X,	39X, "'", 0FFX, 40X,	39X, "`", 0FFX, 60X,	39X, "~", 0FFX, 80X
	DB 1EX, "", 0FFX, 24X,	1EX, "", 0FFX, 44X,	1EX, "", 0FFX, 64X,	1EX, "", "", 0A4X
	DB 12X, "", 0FFX, 24X,	12X, "", 0FFX, 44X,	12X, "", 0FFX, 64X,	12X, "", 0FFX, 0A4X
	DB 17X, "", 0FFX, 24X,	17X, "", 0FFX, 64X,	17X, "", 0FFX, 0A4X,	31X, "", 0FFX, 84X
	DB 18X, "", 0FFX, 24X,	18X, "", 0FFX, 64X,	18X, "", "", 0A4X
	DB 16X, "", 0FFX, 24X,	16X, "", 0FFX, 64X,	16X, "", "", 0A4X
		(* control keys *)
	DB 0EX, 7FX, 7FX, 0X	(* backspace *)
	DB 0FX, 09X, 09X, 0X	(* tab *)
	DB 1CX, 0DX, 0DX, 0X	(* enter *)
	DB 39X, 20X, 20X, 0X	(* space *)
	DB 01X, 0FEX, 1BX, 0X	(* esc *)
		(* keypad *)
	DB 4FX, 0A9X, "1", 2X	(* end/1 *)
	DB 50X, 0C2X, "2", 2X	(* down/2 *)
	DB 51X, 0A3X, "3", 2X	(* pgdn/3 *)
	DB 4BX, 0C4X, "4", 2X	(* left/4 *)
	DB 4CX, 0FFX, "5", 2X	(* center/5 *)
	DB 4DX, 0C3X, "6", 2X	(* right/6 *)
	DB 47X, 0A8X, "7", 2X	(* home/7 *)
	DB 48X, 0C1X, "8", 2X	(* up/8 *)
	DB 49X, 0A2X, "9", 2X	(* pgup/9 *)
	DB 52X, 0A0X, "0", 2X	(* insert/0 *)
	DB 53X, 0A1X, 2EX, 2X	(* del/. *)
		(* gray keys *)
	DB 4AX, "-", "-", 0X	(* gray - *)
	DB 4EX, "+", "+", 0X	(* gray + *)
	DB 0B5X, "/", "/", 0X	(* gray / *)
	DB 37X, "*", "*", 0X	(* gray * *)
	DB 0D0X, 0C2X, 0C2X, 0X	(* gray down *)
	DB 0CBX, 0C4X, 0C4X, 0X	(* gray left *)
	DB 0CDX, 0C3X, 0C3X, 0X	(* gray right *)
	DB 0C8X, 0C1X, 0C1X, 0X	(* gray up *)
	DB 09CX, 0DX, 0DX, 0X	(* gray enter *)
	DB 0D2X, 0A0X, 0A0X, 0X	(* gray ins *)
	DB 0D3X, 0A1X, 0A1X, 0X	(* gray del *)
	DB 0C9X, 0A2X, 0A2X, 0X	(* gray pgup *)
	DB 0D1X, 0A3X, 0A3X, 0X	(* gray pgdn *)
	DB 0C7X, 0A8X, 0A8X, 0X	(* gray home *)
	DB 0CFX, 0A9X, 0A9X, 0X	(* gray end *)
		(* function keys *)
	DB 3BX, 0A4X, 0FFX, 0X	(* F1 *)
	DB 3CX, 0A5X, 0FFX, 0X	(* F2 *)
	DB 3DX, 1BX, 0FFX, 0X	(* F3 *)
	DB 3EX, 0A7X, 0FFX, 0X	(* F4 *)
	DB 3FX, 0F5X, 0FFX, 0X	(* F5 *)
	DB 40X, 0F6X, 0FFX, 0X	(* F6 *)
	DB 41X, 0F7X, 0FFX, 0X	(* F7 *)
	DB 42X, 0F8X, 0FFX, 0X	(* F8 *)
	DB 43X, 0F9X, 0FFX, 0X	(* F9 *)
	DB 44X, 0FAX, 0FFX, 0X	(* F10 *)
	DB 57X, 0FBX, 0FFX, 0X	(* F11 *)
	DB 58X, 0FCX, 0FFX, 0X	(* F12 *)
	DB 0FFX
END TableSwiss;

(* TableCanadian - Canadian keyboard translation table (dead keys: ^=1, cedilla=2, "=3, '=4) *)

PROCEDURE TableCanadian(): LONGINT;
CODE {SYSTEM.i386}
	CALL L1
L1:
	POP EAX
	ADD EAX,8
	POP EBP
	RET
		(* alphabet *)
	DB 1EX, "a", "A", 4X,	30X, "b", "B", 4X,	2EX, "c", "C", 4X,	20X, "d", "D", 4X
	DB 12X, "e", "E", 4X,	21X, "f", "F", 4X,	22X, "g", "G", 4X,	23X, "h", "H", 4X
	DB 17X, "i", "I", 4X,	24X, "j", "J", 4X,	25X, "k", "K", 4X,	26X, "l", "L", 4X
	DB 32X, "m", "M", 4X,	31X, "n", "N", 4X,	18X, "o", "O", 4X,	19X, "p", "P", 4X
	DB 10X, "q", "Q", 4X,	13X, "r", "R", 4X,	1FX, "s", "S", 4X,	14X, "t", "T", 4X
	DB 16X, "u", "U", 4X,	2FX, "v", "V", 4X,	11X, "w", "W", 4X,	2DX, "x", "X", 4X
	DB 15X, "y", "Y", 4X,	2CX, "z", "Z", 4X
	 	(* Oberon accents (LAlt & RAlt) *)
	DB 1EX, "", "", 0CX,	12X, "", 0FFX, 0CX,	18X, "", "", 0CX,	16X, "", "", 0CX
	DB 17X, "", 0FFX, 0CX,	1FX, "", 0FFX, 0CX,	2EX, "", 0FFX, 0CX,	31X, "", 0FFX, 0CX
	DB 1EX, "", "", 14X,	12X, "", 0FFX, 14X,	18X, "", "", 14X,	16X, "", "", 14X
	DB 17X, "", 0FFX, 14X,	1FX, "", 0FFX, 14X,	2EX, "", 0FFX, 14X,	31X, "", 0FFX, 14X
		(* numbers at top *)
	DB 0BX, "0", ")", 0X,	02X, "1", "!", 0X,	03X, "2", 022X, 0X,	04X, "3", "/", 0X
	DB 05X, "4", "$", 0X,	06X, "5", "%", 0X,	07X, "6", "?", 0X,	08X, "7", "&", 0X
	DB 09X, "8", "*", 0X,	0AX, "9", "(", 0X
		(* symbol keys *)
	DB 28X, 4X, 4X, 1X, 	33X, ",", "'", 0X,	0CX, "-", "_", 0X,	34X, ".", ".", 0X
	DB 35X, "", 0FFX (* E acute accent *), 0X,	27X, ";", ":", 0X,	0DX, "=", "+", 0X
    DB  1AX, 1X, 1X, 1X
	DB 2BX, "<", ">", 0X,	1BX, 2X, 3X, 1X,
    DB	29X, "#", "|", 0X,    56X, 0FFX, 0FFX, 0X (* French quote symbols *)
        (* AltGr keys *)
    DB  03X, "@", 0FFX, 10X,   08X, "|", 0FFX, 10X,   29X, "\", 0FFX, 10X,   028X, "{", 0FFX, 10X,   02BX, "}", 0FFX, 10X
    DB  1AX, "[", 0FFX, 10X,   01BX, "]", 0FFX, 10X,   27X, "~", 0FFX, 10X
        (* dead keys *)
    DB 39X, "^", 0FFX, 20X,   39X, "'", 0FFX, 80X
    DB 1EX, "", 0FFX, 24X,   1EX, "", 0FFX, 64X,   1EX, "", 0FFX, 84X  
    DB 12X, "", 0FFX, 24X,   12X, "", 0FFX, 64X,   12X, "", 0FFX, 84X
    DB 17X, "", 0FFX, 24X,   17X, "", 0FFX, 64X,   17X, "", 0FFX, 84X
    DB 18X, "", 0FFX, 24X,   18X, "", "", 64X,   18X, "", 0FFX, 84X
    DB 16X, "", 0FFX, 24X,   16X, "", "", 64X,   16X, "", 0FFX, 84X
    DB 2EX, "", 0FFX, 44X
		(* control keys *)
	DB 0EX, 7FX, 7FX, 0X	(* backspace *)
	DB 0FX, 09X, 09X, 0X	(* tab *)
	DB 1CX, 0DX, 0DX, 0X	(* enter *)
	DB 39X, 20X, 20X, 0X	(* space *)
	DB 01X, 0FEX, 1BX, 0X	(* esc *)
		(* keypad *)
	DB 4FX, 0A9X, "1", 2X	(* end/1 *)
	DB 50X, 0C2X, "2", 2X	(* down/2 *)
	DB 51X, 0A3X, "3", 2X	(* pgdn/3 *)
	DB 4BX, 0C4X, "4", 2X	(* left/4 *)
	DB 4CX, 0FFX, "5", 2X	(* center/5 *)
	DB 4DX, 0C3X, "6", 2X	(* right/6 *)
	DB 47X, 0A8X, "7", 2X	(* home/7 *)
	DB 48X, 0C1X, "8", 2X	(* up/8 *)
	DB 49X, 0A2X, "9", 2X	(* pgup/9 *)
	DB 52X, 0A0X, "0", 2X	(* insert/0 *)
	DB 53X, 0A1X, 2EX, 2X	(* del/. *)
		(* gray keys *)
	DB 4AX, "-", "-", 0X	(* gray - *)
	DB 4EX, "+", "+", 0X	(* gray + *)
	DB 0B5X, "/", "/", 0X	(* gray / *)
	DB 37X, "*", "*", 0X	(* gray * *)
	DB 0D0X, 0C2X, 0C2X, 0X	(* gray down *)
	DB 0CBX, 0C4X, 0C4X, 0X	(* gray left *)
	DB 0CDX, 0C3X, 0C3X, 0X	(* gray right *)
	DB 0C8X, 0C1X, 0C1X, 0X	(* gray up *)
	DB 09CX, 0DX, 0DX, 0X	(* gray enter *)
	DB 0D2X, 0A0X, 0A0X, 0X	(* gray ins *)
	DB 0D3X, 0A1X, 0A1X, 0X	(* gray del *)
	DB 0C9X, 0A2X, 0A2X, 0X	(* gray pgup *)
	DB 0D1X, 0A3X, 0A3X, 0X	(* gray pgdn *)
	DB 0C7X, 0A8X, 0A8X, 0X	(* gray home *)
	DB 0CFX, 0A9X, 0A9X, 0X	(* gray end *)
		(* function keys *)
	DB 3BX, 0A4X, 0FFX, 0X	(* F1 *)
	DB 3CX, 0A5X, 0FFX, 0X	(* F2 *)
	DB 3DX, 1BX, 0FFX, 0X	(* F3 *)
	DB 3EX, 0A7X, 0FFX, 0X	(* F4 *)
	DB 3FX, 0F5X, 0FFX, 0X	(* F5 *)
	DB 40X, 0F6X, 0FFX, 0X	(* F6 *)
	DB 41X, 0F7X, 0FFX, 0X	(* F7 *)
	DB 42X, 0F8X, 0FFX, 0X	(* F8 *)
	DB 43X, 0F9X, 0FFX, 0X	(* F9 *)
	DB 44X, 0FAX, 0FFX, 0X	(* F10 *)
	DB 57X, 0FBX, 0FFX, 0X	(* F11 *)
	DB 58X, 0FCX, 0FFX, 0X	(* F12 *)
	DB 0FFX
END TableCanadian;

(* TableUnitedKingdom - United Kingdom keyboard translation table *)

PROCEDURE TableUnitedKingdom(): LONGINT;
CODE {SYSTEM.i386}
	CALL L1
L1:
	POP EAX
	ADD EAX,8
	POP EBP
	RET
		(* alphabet *)
	DB 1EX, "a", "A", 4X,	30X, "b", "B", 4X,	2EX, "c", "C", 4X,	20X, "d", "D", 4X
	DB 12X, "e", "E", 4X,	21X, "f", "F", 4X,	22X, "g", "G", 4X,	23X, "h", "H", 4X
	DB 17X, "i", "I", 4X,	24X, "j", "J", 4X,	25X, "k", "K", 4X,	26X, "l", "L", 4X
	DB 32X, "m", "M", 4X,	31X, "n", "N", 4X,	18X, "o", "O", 4X,	19X, "p", "P", 4X
	DB 10X, "q", "Q", 4X,	13X, "r", "R", 4X,	1FX, "s", "S", 4X,	14X, "t", "T", 4X
	DB 16X, "u", "U", 4X,	2FX, "v", "V", 4X,	11X, "w", "W", 4X,	2DX, "x", "X", 4X
	DB 15X, "y", "Y", 4X,	2CX, "z", "Z", 4X
		(* Oberon accents (LAlt & RAlt) *)
	DB 1EX, "", "", 0CX,	12X, "", 0FFX, 0CX,	18X, "", "", 0CX,	16X, "", "", 0CX
	DB 17X, "", 0FFX, 0CX,	1FX, "", 0FFX, 0CX,	2EX, "", 0FFX, 0CX,	31X, "", 0FFX, 0CX
	DB 1EX, "", "", 14X,	12X, "", 0FFX, 14X,	18X, "", "", 14X,	16X, "", "", 14X
	DB 17X, "", 0FFX, 14X,	1FX, "", 0FFX, 14X,	2EX, "", 0FFX, 14X,	31X, "", 0FFX, 14X
		(* numbers at top *)
	DB 0BX, "0", ")", 0X,	02X, "1", "!", 0X,	03X, "2", 22X, 0X,	04X, "3", 0FFX (* pound sterling*), 0X
	DB 05X, "4", "$", 0X,	06X, "5", "%", 0X,	07X, "6", "^", 0X,	08X, "7", "&", 0X
	DB 09X, "8", "*", 0X,	0AX, "9", "(", 0X
		(* symbol keys *)
	DB 28X, "'", "@", 0X,	33X, ",", "<", 0X,	0CX, "-", "_", 0X,	34X, ".", ">", 0X
	DB 35X, "/", "?", 0X,	27X, ";", ":", 0X,	0DX, "=", "+", 0X,	1AX, "[", "{", 0X
	DB 2BX, "#", "~", 0X,	1BX, "]", "}", 0X
	DB 29X, "`", 0FFX (* horizontal line with small downward vertical line at right end *), 0X
	DB 56X,"\","|",0X
		(* control keys *)
	DB 0EX, 7FX, 7FX, 0X	(* backspace *)
	DB 0FX, 09X, 09X, 0X	(* tab *)
	DB 1CX, 0DX, 0DX, 0X	(* enter *)
	DB 39X, 20X, 20X, 0X	(* space *)
	DB 01X, 0FEX, 1BX, 0X	(* esc *)
	 	(* keypad *)
	DB 4FX, 0A9X, "1", 2X	(* end/1 *)
	DB 50X, 0C2X, "2", 2X	(* down/2 *)
	DB 51X, 0A3X, "3", 2X	(* pgdn/3 *)
	DB 4BX, 0C4X, "4", 2X	(* left/4 *)
	DB 4CX, 0FFX, "5", 2X	(* center/5 *)
	DB 4DX, 0C3X, "6", 2X	(* right/6 *)
	DB 47X, 0A8X, "7", 2X	(* home/7 *)
	DB 48X, 0C1X, "8", 2X	(* up/8 *)
	DB 49X, 0A2X, "9", 2X	(* pgup/9 *)
	DB 52X, 0A0X, "0", 2X	(* insert/0 *)
	DB 53X, 0A1X, 2EX, 2X	(* del/. *)
		(* gray keys *)
	DB 4AX, "-", "-", 0X	(* gray - *)
	DB 4EX, "+", "+", 0X	(* gray + *)
	DB 0B5X, "/", "/", 0X	(* gray / *)
	DB 37X, "*", "*", 0X	(* gray * *)
	DB 0D0X, 0C2X, 0C2X, 0X	(* gray down *)
	DB 0CBX, 0C4X, 0C4X, 0X	(* gray left *)
	DB 0CDX, 0C3X, 0C3X, 0X	(* gray right *)
	DB 0C8X, 0C1X, 0C1X, 0X	(* gray up *)
	DB 09CX, 0DX, 0DX, 0X	(* gray enter *)
	DB 0D2X, 0A0X, 0A0X, 0X	(* gray ins *)
	DB 0D3X, 0A1X, 0A1X, 0X	(* gray del *)
	DB 0C9X, 0A2X, 0A2X, 0X	(* gray pgup *)
	DB 0D1X, 0A3X, 0A3X, 0X	(* gray pgdn *)
	DB 0C7X, 0A8X, 0A8X, 0X	(* gray home *)
	DB 0CFX, 0A9X, 0A9X, 0X	(* gray end *)
		(* function keys *)
	DB 3BX, 0A4X, 0FFX, 0X	(* F1 *)
	DB 3CX, 0A5X, 0FFX, 0X	(* F2 *)
	DB 3DX, 1BX, 0FFX, 0X	(* F3 *)
	DB 3EX, 0A7X, 0FFX, 0X	(* F4 *)
	DB 3FX, 0F5X, 0FFX, 0X	(* F5 *)
	DB 40X, 0F6X, 0FFX, 0X	(* F6 *)
	DB 41X, 0F7X, 0FFX, 0X	(* F7 *)
	DB 42X, 0F8X, 0FFX, 0X	(* F8 *)
	DB 43X, 0F9X, 0FFX, 0X	(* F9 *)
	DB 44X, 0FAX, 0FFX, 0X	(* F10 *)
	DB 57X, 0FBX, 0FFX, 0X	(* F11 *)
	DB 58X, 0FCX, 0FFX, 0X	(* F12 *)
	DB 0FFX
END TableUnitedKingdom;

(* TablePL - Polish keyboard translation table *)

PROCEDURE TablePL(): LONGINT;
CODE {SYSTEM.i386}
	CALL L1
L1:
	POP EAX
	ADD EAX,8
	POP EBP
	RET
		(* alphabet *)
	DB 1EX, "a", "A", 4X,	30X, "b", "B", 4X,	2EX, "c", "C", 4X,	20X, "d", "D", 4X
	DB 12X, "e", "E", 4X,	21X, "f", "F", 4X,	22X, "g", "G", 4X,	23X, "h", "H", 4X
	DB 17X, "i", "I", 4X,	24X, "j", "J", 4X,	25X, "k", "K", 4X,	26X, "l", "L", 4X
	DB 32X, "m", "M", 4X,	31X, "n", "N", 4X,	18X, "o", "O", 4X,	19X, "p", "P", 4X
	DB 10X, "q", "Q", 4X,	13X, "r", "R", 4X,	1FX, "s", "S", 4X,	14X, "t", "T", 4X
	DB 16X, "u", "U", 4X,	2FX, "v", "V", 4X,	11X, "w", "W", 4X,	2DX, "x", "X", 4X
	DB 15X, "y", "Y", 4X,	2CX, "z", "Z", 4X
		(* Oberon accents (LAlt & RAlt) *)
	DB 1EX, "", "", 0CX,	2EX, "", "", 0CX,	12X, "", "", 0CX,	26X, "", "", 0CX
	DB 31X, "", "", 0CX,	18X, "", "", 0CX,	1FX, "", "", 0CX,	2DX, "", "", 0CX
	DB 2CX, "", "", 0CX
	DB 1EX, "", "", 014X,	2EX, "", "", 014X,	12X, "", "", 014X,	26X, "", "", 014X
	DB 31X, "", "", 014X,	18X, "", "", 014X,	1FX, "", "", 014X,	2DX, "", "", 014X
	DB 2CX, "", "", 014X
		(* numbers at top *)
	DB 0BX, "0", ")", 0X,	02X, "1", "!", 0X,	03X, "2", "@", 0X,	04X, "3", "#", 0X
	DB 05X, "4", "$", 0X,	06X, "5", "%", 0X,	07X, "6", "^", 0X,	08X, "7", "&", 0X
	DB 09X, "8", "*", 0X,	0AX, "9", "(", 0X
		(* symbol keys *)
	DB 28X, "'", 22X, 0X,	33X, ",", "<", 0X,	0CX, "-", "_", 0X,	34X, ".", ">", 0X
	DB 35X, "/", "?", 0X,	27X, ";", ":", 0X,	0DX, "=", "+", 0X,	1AX, "[", "{", 0X
	DB 2BX, "\", "|", 0X,	1BX, "]", "}", 0X,	29X, "`", "~", 0X,	28X, "", 0FFX, 0CX  (* Polish quotation mark *)
	DB 28X, "", 0FFX, 14X (* Polish quotation mark *)
		(* control keys *)
	DB 0EX, 7FX, 7FX, 0X	(* backspace *)
	DB 0FX, 09X, 09X, 0X	(* tab *)
	DB 1CX, 0DX, 0DX, 0X	(* enter *)
	DB 39X, 20X, 20X, 0X	(* space *)
	DB 01X, 0FEX, 1BX, 0X	(* esc *)
	 	(* keypad *)
	DB 4FX, 0A9X, "1", 2X	(* end/1 *)
	DB 50X, 0C2X, "2", 2X	(* down/2 *)
	DB 51X, 0A3X, "3", 2X	(* pgdn/3 *)
	DB 4BX, 0C4X, "4", 2X	(* left/4 *)
	DB 4CX, 0FFX, "5", 2X	(* center/5 *)
	DB 4DX, 0C3X, "6", 2X	(* right/6 *)
	DB 47X, 0A8X, "7", 2X	(* home/7 *)
	DB 48X, 0C1X, "8", 2X	(* up/8 *)
	DB 49X, 0A2X, "9", 2X	(* pgup/9 *)
	DB 52X, 0A0X, "0", 2X	(* insert/0 *)
	DB 53X, 0A1X, 2EX, 2X	(* del/. *)
		(* gray keys *)
	DB 4AX, "-", "-", 0X	(* gray - *)
	DB 4EX, "+", "+", 0X	(* gray + *)
	DB 0B5X, "/", "/", 0X	(* gray / *)
	DB 37X, "*", "*", 0X	(* gray * *)
	DB 0D0X, 0C2X, 0C2X, 0X	(* gray down *)
	DB 0CBX, 0C4X, 0C4X, 0X	(* gray left *)
	DB 0CDX, 0C3X, 0C3X, 0X	(* gray right *)
	DB 0C8X, 0C1X, 0C1X, 0X	(* gray up *)
	DB 09CX, 0DX, 0DX, 0X	(* gray enter *)
	DB 0D2X, 0A0X, 0A0X, 0X	(* gray ins *)
	DB 0D3X, 0A1X, 0A1X, 0X	(* gray del *)
	DB 0C9X, 0A2X, 0A2X, 0X	(* gray pgup *)
	DB 0D1X, 0A3X, 0A3X, 0X	(* gray pgdn *)
	DB 0C7X, 0A8X, 0A8X, 0X	(* gray home *)
	DB 0CFX, 0A9X, 0A9X, 0X	(* gray end *)
		(* function keys *)
	DB 3BX, 0A4X, 0FFX, 0X	(* F1 *)
	DB 3CX, 0A5X, 0FFX, 0X	(* F2 *)
	DB 3DX, 1BX, 0FFX, 0X	(* F3 *)
	DB 3EX, 0A7X, 0FFX, 0X	(* F4 *)
	DB 3FX, 0F5X, 0FFX, 0X	(* F5 *)
	DB 40X, 0F6X, 0FFX, 0X	(* F6 *)
	DB 41X, 0F7X, 0FFX, 0X	(* F7 *)
	DB 42X, 0F8X, 0FFX, 0X	(* F8 *)
	DB 43X, 0F9X, 0FFX, 0X	(* F9 *)
	DB 44X, 0FAX, 0FFX, 0X	(* F10 *)
	DB 57X, 0FBX, 0FFX, 0X	(* F11 *)
	DB 58X, 0FCX, 0FFX, 0X	(* F12 *)
	DB 0FFX
END TablePL;

(* TableDvorak - Dvorak keyboard translation table (dead keys: ^=1, '=2, `=3, ~=4, "=5) *)

PROCEDURE TableDvorak(): LONGINT;
CODE {SYSTEM.i386}
	CALL L1
L1:
	POP EAX
	ADD EAX,8
	POP EBP
	RET
		(* alphabet *)
	DB 1EX, "a", "A", 4X,	31X, "b", "B", 4X,	17X, "c", "C", 4X,	23X, "d", "D", 4X
	DB 20X, "e", "E", 4X,	15X, "f", "F", 4X,	16X, "g", "G", 4X,	24X, "h", "H", 4X
	DB 22X, "i", "I", 4X,	2EX, "j", "J", 4X,	2FX, "k", "K", 4X,	19X, "l", "L", 4X
	DB 32X, "m", "M", 4X,	26X, "n", "N", 4X,	1FX, "o", "O", 4X,	13X, "p", "P", 4X
	DB 2DX, "q", "Q", 4X,	18X, "r", "R", 4X,	27X, "s", "S", 4X,	25X, "t", "T", 4X
	DB 21X, "u", "U", 4X,	34X, "v", "V", 4X,	33X, "w", "W", 4X,	30X, "x", "X", 4X
	DB 14X, "y", "Y", 4X,	35X, "z", "Z", 4X
		(* Oberon accents (LAlt & RAlt) *)
	DB 1EX, "", "", 0CX,	12X, "", 0FFX, 0CX,	18X, "", "", 0CX,	16X, "", "", 0CX
	DB 17X, "", 0FFX, 0CX,	1FX, "", 0FFX, 0CX,	2EX, "", 0FFX, 0CX,	31X, "", 0FFX, 0CX
	DB 1EX, "", "", 14X,	12X, "", 0FFX, 14X,	18X, "", "", 14X,	16X, "", "", 14X
	DB 17X, "", 0FFX, 14X,	1FX, "", 0FFX, 14X,	2EX, "", 0FFX, 14X,	31X, "", 0FFX, 14X
		(* dead keys (LAlt & RAlt) *)
	DB 07X, 0FFX, 1X, 9X,	28X, 2X, 5X, 9X,	29X, 3X, 4X, 9X,
	DB 07X, 0FFX, 1X, 11X,	28X, 2X, 5X, 11X,	29X, 3X, 4X, 11X,
		(* following keys *)
	DB 1EX, "", 0FFX, 20X,	12X, "", 0FFX, 20X,	17X, "", 0FFX, 20X,	18X, "", 0FFX, 20X
	DB 16X, "", 0FFX, 20X,	1EX, "", 0FFX, 60X,	12X, "", 0FFX, 60X,	17X, "", 0FFX, 60X
	DB 18X, "", 0FFX, 60X,	16X, "", 0FFX, 60X,	1EX, "", 0FFX, 40X,	12X, "", 0FFX, 40X
	DB 1EX, "", "", 0A4X,	12X, "", 0FFX, 0A0X,	17X, "", 0FFX, 0A0X,	18X, "", "", 0A4X
	DB 16X, "", "", 0A4X,	31X, "", 0FFX, 80X
		(* numbers at top *)
	DB 0BX, "0", ")", 0X,	02X, "1", "!", 0X,	03X, "2", "@", 0X,	04X, "3", "#", 0X
	DB 05X, "4", "$", 0X,	06X, "5", "%", 0X,	07X, "6", "^", 0X,	08X, "7", "&", 0X
	DB 09X, "8", "*", 0X,	0AX, "9", "(", 0X
		(* symbol keys *)
	DB 10X, "'", 22X, 0X,	11X, ",", "<", 0X,	28X, "-", "_", 0X,	12X, ".", ">", 0X
	DB 1AX, "/", "?", 0X,	2CX, ";", ":", 0X,	1BX, "=", "+", 0X,	0CX, "[", "{", 0X
	DB 2BX, "\", "|", 0X,	0DX, "]", "}", 0X,	29X, "`", "~", 0X
		(* control keys *)
	DB 0EX, 7FX, 7FX, 0X	(* backspace *)
	DB 0FX, 09X, 09X, 0X	(* tab *)
	DB 1CX, 0DX, 0DX, 0X	(* enter *)
	DB 39X, 20X, 20X, 0X	(* space *)
	DB 01X, 0FEX, 1BX, 0X	(* esc *)
	 	(* keypad *)
	DB 4FX, 0A9X, "1", 2X	(* end/1 *)
	DB 50X, 0C2X, "2", 2X	(* down/2 *)
	DB 51X, 0A3X, "3", 2X	(* pgdn/3 *)
	DB 4BX, 0C4X, "4", 2X	(* left/4 *)
	DB 4CX, 0FFX, "5", 2X	(* center/5 *)
	DB 4DX, 0C3X, "6", 2X	(* right/6 *)
	DB 47X, 0A8X, "7", 2X	(* home/7 *)
	DB 48X, 0C1X, "8", 2X	(* up/8 *)
	DB 49X, 0A2X, "9", 2X	(* pgup/9 *)
	DB 52X, 0A0X, "0", 2X	(* insert/0 *)
	DB 53X, 0A1X, 2EX, 2X	(* del/. *)
		(* gray keys *)
	DB 4AX, "-", "-", 0X	(* gray - *)
	DB 4EX, "+", "+", 0X	(* gray + *)
	DB 0B5X, "/", "/", 0X	(* gray / *)
	DB 37X, "*", "*", 0X	(* gray * *)
	DB 0D0X, 0C2X, 0C2X, 0X	(* gray down *)
	DB 0CBX, 0C4X, 0C4X, 0X	(* gray left *)
	DB 0CDX, 0C3X, 0C3X, 0X	(* gray right *)
	DB 0C8X, 0C1X, 0C1X, 0X	(* gray up *)
	DB 09CX, 0DX, 0DX, 0X	(* gray enter *)
	DB 0D2X, 0A0X, 0A0X, 0X	(* gray ins *)
	DB 0D3X, 0A1X, 0A1X, 0X	(* gray del *)
	DB 0C9X, 0A2X, 0A2X, 0X	(* gray pgup *)
	DB 0D1X, 0A3X, 0A3X, 0X	(* gray pgdn *)
	DB 0C7X, 0A8X, 0A8X, 0X	(* gray home *)
	DB 0CFX, 0A9X, 0A9X, 0X	(* gray end *)
		(* function keys *)
	DB 3BX, 0A4X, 0FFX, 0X	(* F1 *)
	DB 3CX, 0A5X, 0FFX, 0X	(* F2 *)
	DB 3DX, 1BX, 0FFX, 0X	(* F3 *)
	DB 3EX, 0A7X, 0FFX, 0X	(* F4 *)
	DB 3FX, 0F5X, 0FFX, 0X	(* F5 *)
	DB 40X, 0F6X, 0FFX, 0X	(* F6 *)
	DB 41X, 0F7X, 0FFX, 0X	(* F7 *)
	DB 42X, 0F8X, 0FFX, 0X	(* F8 *)
	DB 43X, 0F9X, 0FFX, 0X	(* F9 *)
	DB 44X, 0FAX, 0FFX, 0X	(* F10 *)
	DB 57X, 0FBX, 0FFX, 0X	(* F11 *)
	DB 58X, 0FCX, 0FFX, 0X	(* F12 *)
	DB 0FFX
END TableDvorak;

(* French keyboard translation table "mailto:gmeunier@club-internet.fr" *)

PROCEDURE TableFR(): LONGINT;
CODE {SYSTEM.i386}
	CALL L1
L1:
	POP EAX
	ADD EAX,8
	POP EBP
	RET
		(* alphabet *)
	DB 10X, "a", "A", 4X,	30X, "b", "B", 4X,	2EX, "c", "C", 4X,	20X, "d", "D", 4X
	DB 12X, "e", "E", 4X,	21X, "f", "F", 4X,	22X, "g", "G", 4X,	23X, "h", "H", 4X
	DB 17X, "i", "I", 4X,	24X, "j", "J", 4X,	25X, "k", "K", 4X,	26X, "l", "L", 4X
	DB 27X, "m", "M", 4X,	31X, "n", "N", 4X,	18X, "o", "O", 4X,	19X, "p", "P", 4X
	DB 1EX, "q", "Q", 4X,	13X, "r", "R", 4X,	1FX, "s", "S", 4X,	14X, "t", "T", 4X
	DB 16X, "u", "U", 4X,	2FX, "v", "V", 4X,	2CX, "w", "W", 4X,	2DX, "x", "X", 4X
	DB 15X, "y", "Y", 4X,	11X, "z", "Z", 4X
		(* Oberon accents (LAlt) *)
	DB 10X, "", "", 0CX,	12X, "", 0FFX, 0CX,	18X, "", "", 0CX,	16X, "", "", 0CX
	DB 17X, "", 0FFX, 0CX,	1FX, "", 0FFX, 0CX,	2EX, "", 0FFX, 0CX,	31X, "", 0FFX, 0CX
		(* dead key *)
	DB 1AX, 1X, 5X, 1X,
		(* following keys *)
	DB 10X, "", 0FFX, 20X,	12X, "", 0FFX, 20X,	17X, "", 0FFX, 20X,	18X, "", 0FFX, 20X
	DB 16X, "", 0FFX, 20X,	39X, "^", "^", 20X
	DB 10X, "", "", 0A4X,	12X, "", 0FFX, 0A0X,	17X, "", 0FFX, 0A0X,	18X, "", "", 0A4X
	DB 16X, "", "", 0A4X,
		(* numbers at top *)
	DB 0BX, "", "0", 4X,	02X, "&", "1", 4X,	03X, "", "2", 4X,	04X, 22X, "3", 4X
	DB 05X, "'", "4", 4X,	06X, "(", "5", 4X,	07X, "-", "6", 4X,	08X, "","7", 4X
	DB 09X, "_", "8", 4X,	0AX, "", "9", 4X
	DB 0BX, "@", 0FFX, 10X,	3X, "~", 0FFX, 10X,	4X, "#", 0FFX, 10X,	5X, "{", 0FFX, 10X
	DB 6X, "[", 0FFX, 10X,	7X, "|", 0FFX, 10X,	8X, "`", 0FFX, 10X,	9X, "\", 0FFX, 10X
	DB 0AX, "^", 0FFX, 10X
		(* symbol keys *)
	DB 0CX, ")", 0FFX, 0X,	0CX, "]", 0FFX, 10X,	0DX, "=", "+", 04X,	0DX, "}", 0FFX, 10X
	DB 1BX, "$", 0FFX, 0X,	28X, "", "%", 04X,	2BX, "*", 0FFX, 0X,	32X, ",", "?", 04X
	DB 33X, ";", ".", 04X,	34X, ":", "/", 04X,	35X, "!", 0FFX, 0X,	56X, "<", ">", 04X
			(* control keys *)
	DB 0EX, 7FX, 7FX, 0X	(* backspace *)
	DB 0FX, 09X, 09X, 0X	(* tab *)
	DB 1CX, 0DX, 0DX, 0X	(* enter *)
	DB 39X, 20X, 20X, 0X	(* space *)
	DB 01X, 0FEX, 1BX, 0X	(* esc *)
	 	(* keypad *)
	DB 4FX, 0A9X, "1", 2X	(* end/1 *)
	DB 50X, 0C2X, "2", 2X	(* down/2 *)
	DB 51X, 0A3X, "3", 2X	(* pgdn/3 *)
	DB 4BX, 0C4X, "4", 2X	(* left/4 *)
	DB 4CX, 0FFX, "5", 2X	(* center/5 *)
	DB 4DX, 0C3X, "6", 2X	(* right/6 *)
	DB 47X, 0A8X, "7", 2X	(* home/7 *)
	DB 48X, 0C1X, "8", 2X	(* up/8 *)
	DB 49X, 0A2X, "9", 2X	(* pgup/9 *)
	DB 52X, 0A0X, "0", 2X	(* insert/0 *)
	DB 53X, 0A1X, 2EX, 2X	(* del/. *)
		(* gray keys *)
	DB 4AX, "-", "-", 0X	(* gray - *)
	DB 4EX, "+", "+", 0X	(* gray + *)
	DB 0B5X, "/", "/", 0X	(* gray / *)
	DB 37X, "*", "*", 0X	(* gray * *)
	DB 0D0X, 0C2X, 0C2X, 0X	(* gray down *)
	DB 0CBX, 0C4X, 0C4X, 0X	(* gray left *)
	DB 0CDX, 0C3X, 0C3X, 0X	(* gray right *)
	DB 0C8X, 0C1X, 0C1X, 0X	(* gray up *)
	DB 09CX, 0DX, 0DX, 0X	(* gray enter *)
	DB 0D2X, 0A0X, 0A0X, 0X	(* gray ins *)
	DB 0D3X, 0A1X, 0A1X, 0X	(* gray del *)
	DB 0C9X, 0A2X, 0A2X, 0X	(* gray pgup *)
	DB 0D1X, 0A3X, 0A3X, 0X	(* gray pgdn *)
	DB 0C7X, 0A8X, 0A8X, 0X	(* gray home *)
	DB 0CFX, 0A9X, 0A9X, 0X	(* gray end *)
		(* function keys *)
	DB 3BX, 0A4X, 0FFX, 0X	(* F1 *)
	DB 3CX, 0A5X, 0FFX, 0X	(* F2 *)
	DB 3DX, 1BX, 0FFX, 0X	(* F3 *)
	DB 3EX, 0A7X, 0FFX, 0X	(* F4 *)
	DB 3FX, 0F5X, 0FFX, 0X	(* F5 *)
	DB 40X, 0F6X, 0FFX, 0X	(* F6 *)
	DB 41X, 0F7X, 0FFX, 0X	(* F7 *)
	DB 42X, 0F8X, 0FFX, 0X	(* F8 *)
	DB 43X, 0F9X, 0FFX, 0X	(* F9 *)
	DB 44X, 0FAX, 0FFX, 0X	(* F10 *)
	DB 57X, 0FBX, 0FFX, 0X	(* F11 *)
	DB 58X, 0FCX, 0FFX, 0X	(* F12 *)
	DB 0FFX
END TableFR;

PROCEDURE TableFromFile(name: ARRAY OF CHAR): LONGINT;
VAR f: Files.File;  r: Files.Rider;  len: LONGINT;
BEGIN
	f := Files.Old(name);
	IF f # NIL THEN
		len := Files.Length(f);
		IF len MOD 4 = 0 THEN
			NEW(keytable, len+1);
			Files.Set(r, f, 0);  Files.ReadBytes(r, keytable^, len);
			IF r.res = 0 THEN
				keytable[len] := 0FFX;
				RETURN SYSTEM.ADR(keytable[0])
			END
		END
	END;
	RETURN TableUS()
END TableFromFile;

PROCEDURE HexChar(i: INTEGER): CHAR;
BEGIN
	CASE i OF
		0..9: RETURN CHR(ORD("0")+i)
		|10..15: RETURN CHR(ORD("A")+i-10)
	END
END HexChar;

PROCEDURE KeyName(k: CHAR);
VAR n: ARRAY 11 OF CHAR;  gray: BOOLEAN;
BEGIN
	IF k > 7FX THEN gray := TRUE; k := CHR(ORD(k)-80H)
	ELSE gray := FALSE
	END;
	CASE k OF
		1X: n := "Esc"
		|0EX: n := "Backspace"
		|0FX: n := "Tab"
		|1CX: n := "Enter"
		|1DX: IF gray THEN n := "RCtrl" ELSE n := "LCtrl" END;  gray := FALSE
		|2AX: n := "LShift"
		|36X: n := "RShift"
		|37X: n := "Gray*"
		|38X: IF gray THEN n := "RAlt" ELSE n := "LAlt" END;  gray := FALSE
		|39X: n := "Space"
		|3AX: n := "CapsLock"
		|3BX..43X: n := "Fx";  n[1] := CHR(ORD("1")+ORD(k)-3BH)
		|44X: n := "F10"
		|45X: n := "NumLock"
		|46X: n := "ScrollLock"
		|47X: n := "Home"
		|48X: n := "Up"
		|49X: n := "PgUp"
		|4AX: n := "Gray-"
		|4BX: n := "Left"
		|4CX: n := "Keypad5"
		|4DX: n := "Right"
		|4EX: n := "Gray+"
		|4FX: n := "End"
		|50X: n := "Down"
		|51X: n := "PgDn"
		|52X: n := "Ins"
		|53X: n := "Del"
		|56X: n := "KeyX"	(* additional key on international keyboards *)
		|57X: n := "F11"
		|58X: n := "F12"
		ELSE
			IF (k >= 1X) & (k <= 35X) & (normal[ORD(k)-1] # "!") THEN
				n[0] := normal[ORD(k)-1];  n[1] := 0X
			ELSE
				n[0] := HexChar(ORD(k) DIV 10H);  n[1] := HexChar(ORD(k) MOD 10H);  n[2] := 0X
			END
	END;
	Texts.Write(W, "[");
	IF gray THEN Texts.WriteString(W, "Gray") END;
	Texts.WriteString(W, n);  Texts.Write(W, "]")
END KeyName;

PROCEDURE ^Key(VAR n: LONGINT;  flags: SET;  k: CHAR);

PROCEDURE DeadKey(VAR n: LONGINT;  table, dk: LONGINT);
VAR q, dm: LONGINT;  t: SET;  m, m0, m1: CHAR;  done: BOOLEAN;
BEGIN
	IF dk # 0 THEN
		q := table;  done := FALSE;
		LOOP
			SYSTEM.GET(q, m);
			IF m = 0FFX THEN EXIT END;
			SYSTEM.GET(q+1, m0);  SYSTEM.GET(q+2, m1);
			t := {};  SYSTEM.GET(q+3, SYSTEM.VAL(CHAR, t));
			dm := ASH(SYSTEM.VAL(LONGINT, t) MOD 100H, -5);
			IF 0 IN t THEN
				IF t * {5..7} # {} THEN Texts.WriteString(W, " *RECURSIVE* ") END;
				t := t - {0,5..7} + {DK};	(* strip dead key stuff *)
				IF ORD(m0) = dk THEN Key(n, t, m);  done := TRUE END;
				IF ORD(m1) = dk THEN Key(n, t + {LShift}, m);  done := TRUE END
			END;
			INC(q, 4)
		END;
		IF ~done THEN Texts.WriteString(W, " *UNREACHABLE* ") END
	END
END DeadKey;

PROCEDURE Key(VAR n: LONGINT;  flags: SET;  k: CHAR);
BEGIN
	IF n # 1 THEN Texts.WriteString(W, " | ") END;
	INC(n);
	IF DK IN flags THEN Texts.WriteString(W, "dk ") END;
	IF CapsLock IN flags THEN Texts.WriteString(W, "CapsLock-") END;
	IF NumLock IN flags THEN Texts.WriteString(W, "NumLock-") END;
	IF LCtrl IN flags THEN Texts.WriteString(W, "Ctrl-") END;
	IF LShift IN flags THEN Texts.WriteString(W, "Shift-") END;
	IF flags * {LAlt,RAlt} = {LAlt} THEN Texts.WriteString(W, "LAlt-")
	ELSIF flags * {LAlt,RAlt} = {RAlt} THEN Texts.WriteString(W, "RAlt-")
	ELSIF flags * {LAlt,RAlt} # {} THEN Texts.WriteString(W, "LAlt-RAlt-")
	END;
	KeyName(k)
END Key;

PROCEDURE Code(table: LONGINT;  c: CHAR);
VAR k, k0, k1: CHAR;  s: SET;  n, p, dk: LONGINT;
BEGIN
	n := 1;  p := table;
	IF (c >= 20X) & (c <= 96X) & (c # 7FX) THEN
		Texts.Write(W, 22X);  Texts.Write(W, c);  Texts.Write(W, 22X)
	ELSE
		IF c >= 0A0X THEN Texts.Write(W, "0") END;
		Texts.Write(W, HexChar(ORD(c) DIV 10H));
		Texts.Write(W, HexChar(ORD(c) MOD 10H));
		Texts.Write(W, "X")
	END;
	Texts.WriteString(W, " = ");
	LOOP
		SYSTEM.GET(p, k);
		IF k = 0FFX THEN EXIT END;
		SYSTEM.GET(p+1, k0);  SYSTEM.GET(p+2, k1);
		s := {};  SYSTEM.GET(p+3, SYSTEM.VAL(CHAR, s));
		IF ~(0 IN s) THEN
			dk := ASH(SYSTEM.VAL(LONGINT, s) MOD 100H, -5);
			s := s - {0,5..7};	(* strip dead key stuff *)
			IF k0 = c THEN DeadKey(n, table, dk);  Key(n, s - {CapsLock,NumLock}, k) END;
			IF (k0 = c) & ({CapsLock,NumLock} * s # {}) THEN DeadKey(n, table, dk);  Key(n, s + {LShift}, k) END;
			IF k1 = c THEN DeadKey(n, table, dk);  Key(n, s + {LShift} - {CapsLock,NumLock}, k) END;
			IF (k1 = c) & ({CapsLock,NumLock} * s # {}) THEN DeadKey(n, table, dk);  Key(n, s, k) END;
			IF (((k0 >= 40X) & (k0 <= 5FX)) OR ((k0 >= 61X) & (k0 <= 7AX))) & (CHR(ORD(k0) MOD 32) = c) THEN
				DeadKey(n, table, dk);  Key(n,  s - {CapsLock} + {LCtrl}, k)
			END;
			IF (((k1 >= 40X) & (k1 <= 5FX)) OR ((k1 >= 61X) & (k1 <= 7AX))) & (CHR(ORD(k1) MOD 32) = c) THEN
				DeadKey(n, table, dk);  Key(n, s - {CapsLock} + {LCtrl,LShift}, k)
			END
		END;
		INC(p, 4)
	END;
	IF n = 1 THEN
		Texts.WriteString(W, "Alt-Keypad-[");  Texts.WriteInt(W, ORD(c), 1);
		Texts.Write(W, "]")
	END;
	IF c = 0A4X THEN Texts.WriteString(W, " (Setup)")
	ELSIF c = 0A5X THEN Texts.WriteString(W, " (Neutralise)")
	ELSIF c = 0F5X THEN Texts.WriteString(W, " (Blank)")
	ELSIF c = 0F7X THEN Texts.WriteString(W, " (Palette)")
	ELSIF c = 0F9X THEN Texts.WriteString(W, " (Redraw)")
	ELSIF c = 0FEX THEN Texts.WriteString(W, " (mapped to 0A5X or 1BX)")
	END;
	Texts.WriteLn(W)
END Code;

PROCEDURE FindTable(k: ARRAY OF CHAR): LONGINT;
VAR table, i: LONGINT;
BEGIN
	i := 0;  WHILE (k[i] # 0X) & (k[i] # ".") DO INC(i) END;
	IF k[i] = "." THEN table := TableFromFile(k)
	ELSIF k = "N" THEN table := TableNorwegian()
	ELSIF k = "D" THEN table := TableGerman()
	ELSIF k = "CH" THEN table := TableSwiss()
	ELSIF k = "CA" THEN table := TableCanadian()
	ELSIF k = "UK" THEN table := TableUnitedKingdom()
	ELSIF k = "TR" THEN table := TableTR()
	ELSIF k = "US" THEN table := TableUS()
	ELSIF k =  "PL" THEN table := TablePL() 
	ELSIF k = "DV" THEN table := TableDvorak()
	ELSIF k = "FR" THEN table := TableFR()
	ELSE table := 0
	END;
	RETURN table
END FindTable;

PROCEDURE FileFromTable*;	(* name file *)
VAR k: ARRAY 32 OF CHAR;  table, i: LONGINT;  f: Files.File;  r: Files.Rider;  ch: CHAR;
BEGIN
	In.Open;  In.Name(k);
	IF In.Done THEN
		table := FindTable(k);
		IF table # 0 THEN
			In.Name(k);
			IF In.Done & (table # 0) THEN
				f := Files.New(k);
				IF f # NIL THEN
					Files.Set(r, f, 0);
					i := table;
					LOOP
						SYSTEM.GET(i, ch);
						IF (ch = 0FFX) & ((i-table) MOD 4 = 0) THEN EXIT END;
						Files.Write(r, ch);  INC(i)
					END;
					Files.Register(f);
					Texts.WriteInt(W, i-table, 1);  Texts.WriteString(W, " bytes written.");
					Texts.WriteLn(W);  Texts.Append(Oberon.Log, W.buf)
				END
			END
		END
	END
END FileFromTable;

PROCEDURE Table*;	(* name *)
VAR table, i: LONGINT;  k: ARRAY 32 OF CHAR;  c: INTEGER;  T: Texts.Text;
BEGIN
	In.Open;  In.Name(k);
	IF In.Done THEN
		table := FindTable(k);
		IF table # 0 THEN
			T := TextFrames.Text("");
			Texts.WriteString(W, "The table shows the equivalent US key legends to procedure a character");  Texts.WriteLn(W);
			Texts.WriteString(W, "RAlt = AltGr or AltCar on international keyboards");  Texts.WriteLn(W);  Texts.WriteLn(W);
			FOR c := 0 TO 254 DO Code(table, CHR(c))  END;
			Texts.WriteString(W, "0FFX = Ctrl-F10 | Ctrl-Alt-Del (fixed)");
			Texts.WriteLn(W);  Texts.Append(T, W.buf);
			Oberon.OpenText(k, T, 400, 200)
		END
	END
END Table;

BEGIN
	normal := "!1234567890-=!!QWERTYUIOP[]!!ASDFGHJKL;'`!\ZXCVBNM,./";
	Texts.OpenWriter(W)
END Keyboard.

Keyboard.Table ^ N D CH CA UK US TR PL DV
Keyboard.Table ^ KeyN.Bin KeyD.Bin KeyCH.Bin KeyCA.Bin KeyUK.Bin KeyUS.Bin KeyXX.Bin KeyTR.Bin KeyPL.Bin KeyDV.Bin

Keyboard.FileFromTable US KeyUS.Bin
Keyboard.FileFromTable CH KeyCH.Bin
Keyboard.FileFromTable CA KeyCA.Bin
Keyboard.FileFromTable UK KeyUK.Bin
Keyboard.FileFromTable N KeyN.Bin
Keyboard.FileFromTable D KeyD.Bin
Keyboard.FileFromTable TR KeyTR.Bin
Keyboard.FileFromTable PL KeyPL.Bin
Keyboard.FileFromTable DV KeyDV.Bin
Keyboard.FileFromTable FR KeyFR.Bin

System.Directory Key*.Bin\d
Hex.Open ^

EditKeys.GetKeyCode
