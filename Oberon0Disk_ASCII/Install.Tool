Oberon_0 is a small ramdisk-based system 
for installing, updating and configuring the
real Oberon system on your machine.  For 
an introductory text, move the mouse 
cursor to Edit.Open below and click the
middle button or press Ctrl on the keyboard.
  Edit.Open Introduction.Text

1. Select one of the disk drivers below by 
executing the appropriate blue command:
  Config.Disk Standard ATA/EIDE
  Config.Disk Standard IDE (old)
  Config.Disk Adaptec 1520 SCSI
  Config.Disk NCR 810 SCSI
  Config.Disk Adaptec AIC7xxx (beta)

2. To install a new Oberon system, open the 
following tool and continue reading there:
  Edit.Open InstallFiles.Tool

3. To configure the installed Oberon system,
continue in the following tool:
  Edit.Open Configure.Tool

For more information, see install.txt or 
http://www.oberon.ethz.ch/native/

The appendices below are not used during
normal installation.

Appendix A: Reactivate previous OS
To reactivate the previous operating system,
use the commands below, replacing <num>
with the relevant partition number.
Partition.Show
Partition.Activate <num> ~

If this does not work, boot the other OS 
from a diskette, and use its "fdisk" tool 
(or equivalent) to reactivate it.

Appendix B: Recovering filesystem
If Native Oberon does not boot any more,
because of a damaged file directory:
!Scavenger.Scan	scan disk to rebuild dir
!Scavenger.WriteDirectory	write new dir
!Scavenger.Display	optional file display

Appendix C: Sending an error report
If an unexpected Trap occurs, you can send 
the trap text to the author.  Move the mouse 
cursor into the Trap viewer and press F1 to 
mark it.  Then execute the command:  
ET.StoreAscii * to store the text in a file.  
Put a DOS-formatted diskette in the boot 
drive and execute:  Backup.WriteFiles Trap ~
Send an explanation of the problem to 
muller@inf.ethz.ch, and attach the Trap file.

Appendix D: Expert commands
Config.Manual on  manual mode
Config.NumLock on  boot with NumLock
Install.PutFiles ~  copy to disk
Install.GetFiles ~  copy from disk
Install.Directory  list files on disk
!Install.Unsafe  enable the next command
Install.InitFileSystem  overwrite file system
Partition.Delete <num> <type>
Partition.Verbose on  display more info
Partition.ChangeType <num> <frm> <to>
System.ShowModules  System.Watch
System.ShowCommands ^  System.State ^
Backup.Directory  !Backup.Format\H
Backup.ReadFiles ^  Backup.WriteFiles ^
!Config.Options Keyboard
!Config.Options Disk
!Config.Options Display
System.OpenKernelLog Kernel log
