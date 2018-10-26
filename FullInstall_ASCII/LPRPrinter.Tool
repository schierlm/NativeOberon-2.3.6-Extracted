LPRPrinter - Printing on a remote (LPR) printer.

LPRPrinter.BannerPage off 	Switch banner page on or off, default is on.

LPRPrinter.MailBack on	If on then the printer deamon send you a mail
	when the printer job has finished. Default is off.

LPRPrinter.ShowJobs queue@host	List all waiting jobs on queue.

LPRPrinter.RemoveJob queue@host [ nr ]	Remove job nr from queue. If no number is given all
	jobs are removed.

LPRPrinter.PrintPSFile queue@host [ "\" options ] ps-file
	Print the postscript file on the given queue.

LPRPrinter.Install	Install the LPRPrinter as system printer.

To install the LPRPrinter as default printer, set Printer.Default to LPRPrinter.Install in Oberon.Text .
Once the printer is installed, use a normal print command with queue@host as parameter, e.g.
Desktops.PrintDoc queue@host *	Edit.Print queue@host *
If queue or host contain non-alpha characters, quote "queue@host".

Please report any problems with LPRPrinter to: "mailto:zeller@inf.ethz.ch"

