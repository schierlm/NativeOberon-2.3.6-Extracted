[ Network | Mail | News | FTP | Gopher | Finger | HTTP | HyperDocs ]

Desktops.OpenDoc "ftp://host/"	Anonymous ftp to host.

NetSystem.SetUser ftp:user@host ~	Set password for private ftp.
Desktops.OpenDoc "ftp://user@host"	Private ftp to user at host.

Command interface to FTP

NetSystem.SetUser ftp:user@host ~	Set password for private ftp.
FTP.Open ^  ftp.inf.ethz.ch user@host	Log in to the selected ftp server.
FTP.Close	End the current session.

FTP.Dir	List the current directory.
FTP.CompactDir	List the current directory
	in a more compact form.

FTP.CurDir	Display the current
	directory path.

FTP.ChangeDir ^  pub  ".."  "/pub"	Change to anonther directory.

FTP.GetFiles  =>  ~	Copy binary-files from the server.
FTP.GetTexts  => ~	Copy text-files from the server.

FTP.PutFiles =>  ~	Copy binary-files to the server.
FTP.PutTexts  =>  ~	Copy text-files to the server.

!FTP.MakeDir ^	Create a directory on the server.
!FTP.RmDir ^	Remove a directory on the server.
!FTP.DeleteFiles ^	Delete files on the server.

FTP.OpenLog	Open log for FTP
