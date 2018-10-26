The Backup tool reads and writes diskettes in Oberon or DOS format.

Backup.SetDriveA  Backup.SetDriveB
Backup.Directory
Backup.ReadFiles ^  Backup.WriteFiles ^
Backup.ReadAll  Backup.DeleteFiles ^

!Backup.Format\H    1.44M low-level format
!Backup.Format\D    720K low-level format
!Backup.InitOberon ~	Initialize Oberon format (720K only)
!Backup.InitOberon Label	Initialize extended Oberon format
!Backup.InitDOS Label	Initialize DOS format

File names must start with an alphabetical character.
Only 720K and 1.44M media are supported.
Subdirectories and not supported.
Files may be renamed during ReadFiles/WriteFiles
by specifying sourcename => destname.

DOS File System Access Commands

DOS.Directory ^ "a:/" "c:/" "c:/*.bat"	show directory of dos drive
DOS.CopyFrom dir {file} ~	copy files from dos drive
DOS.CopyTo dir {file} ~	copy files to dos drive
DOS.Copy {from => to} ~	copy files from/to dos drive
DOS.Delete {file} ~	delete files on dos drive
DOS.Rename {from => to} ~	rename files on a dos drive

Names containing non-alphanumeric characters must be quoted with "".
