BootLinker - static linker for the Oberon inner core

EBNF notation for linker parameters:
commandsyntax = "BootLinker.Link" Output-file {option} linkspec terminator
option = "\new" qualident |	(* default Kernel.NewRec *)
				"\sysnew" qualident |	(* default Kernel.NewSys *)
				"\newarr" qualident |	(* default Kernel.NewArr *)
				"\newsysarr" qualident |	(* default Kernel.NewSysArr *)
				"\heapcopyarr" qualident |	(* default Kernel.HeapCopyArr *)
				"\list" qualident|	(* default Kernel.modules *)
				"\refs"
				"\command" qualident |
qualident = identifier "." identifier
linkspec = "\integrate" Link-address	Module {Module} 
terminator = "~" | EOT
identifier = letter {letter | digit}

Options:
\new, \sysnew, \newsysarr and \newarr : the names of the procedures that must be linked to
	the NEW and SYSTEM.NEW calls of the Oberon language for allocating pointers to records,
	arrays and open arrays.
\heapcopyarr : the procedure that must be linked for copying dynamic arrays.
\list : if the Oberon garbage collector is linked together with the application,
	this option must be used to tell the linker the name of the garbage
	collector module and the variable that points to the module list, so that the module list
	needed by the garbage collector can be initialized correctly by the linker.
\command : the name of a command that must be executed after the
	initialization code of all the modules has been executed. If this option is
	used, the initialization code of the last module does not have to be the
	main program.
\refs : instructs the linker to include the reference block of each Oberon
	module as part of the image

Examples: 
BootLinker.Link MyImage
	\new Kernel.NewRec \sysnew Kernel.NewSys \newarr Kernel.NewArr
	\list Kernel.modules
	\command MyModule.Go
	\integrate 400000H Kernel MyModule ~
BootLinker.Link Temp.bin \refs \integrate 1000H 
	Kernel Disk PCI ATADisk FileDir Files Modules ~

Notes:
- if the linker reports that it cannot patch a call to one of the NEW procedures, then the error is
	one of the following: an allocation procedure was not supplied for this call, or a procedure that
	does not exist was specified, or the call to that procedure happens before the memory
	management module will have been initialized at run-time (i.e. an implicit cyclic import).
	In the latter case, changing the linking sequence of modules may help.	
- the BootLinker.Find command can be used to locate the source location of a run-time error:
	BootLinker.Find logfile "^" - finds the module and the offset in the code of the Oberon statement
		where the error occurred; selection points to the value of the EIP register at the time of the error and
		must be a hexadecimal number. The offset can be used as parameter for the Oberon compiler
		together with the \f option, to find the location of the statement in the program text.
		logfile is the link log produced by the linker (.Link extension of image-file)
	Example: BootLinker.Find MyImage.Link ^	(select the hex value of EIP)

dVdW
