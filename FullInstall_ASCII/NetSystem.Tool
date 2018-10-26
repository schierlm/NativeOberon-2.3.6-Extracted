Basic Networking Tools

For configuration, see:
Script.Open System.Text (section 4c)

Dial-up networking startup (PPP or SLIP)
NetSystem.Start	start net system
NetSystem.SetUser dialup:<username>@DIAL ~	set dial-in password
	set <username>, enter PPP or SLIP link password
Dialer.Dial DIAL device0 ~	(dial in)
Dialer.State DIAL device0 ~	(show dialer state)
NetSystem.Show	show netsystem state

Dial-up networking hangup (PPP or SLIP)
NetSystem.Stop and Dialer.Hangup DIAL ~	hang up
PPPMain.StopInst	PPP only
NetSystem.ClearUser	Clear passwords

Simple Mailer
NetSystem.SetUser pop:<username>@<smtpserver> ~	set mail password
TextMail.Directory  TextMail.Send *

Simple Telnet
Telnet.Open ^  www.oberon.ethz.ch 21 ~

Simple FTP
NetSystem.SetUser ftp:user@host ~
FTP.Open ^  ftp.inf.ethz.ch user@host  FTP.Close
FTP.Dir  FTP.CompactDir  FTP.CurDir
FTP.ChangeDir ^  pub  ".."  "/pub"
FTP.GetFiles  =>  ~  FTP.GetTexts  => ~
FTP.PutFiles =>  ~  FTP.PutTexts  =>  ~
!FTP.MakeDir ^  !FTP.RmDir ^  !FTP.DeleteFiles ^
FTP.OpenLog

LPR Printer Client
System.Open LPRPrinter.Tool

Programming examples
UDPExample.Mod TCPExample.Mod

PPP debugging commands (beta version only)
PPPMain.Stats  PPPMain.StartInst PPPMain.StopInst
System.State NetSystem  System.State PPPDebug
PPPTest.ShowLog  PPPTest.ShowLogHex
Telnet.Open somehost.localdomain someport
