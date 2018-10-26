This tool is used to install the basic Oberon system files on your computer.
There are four options, of which you can choose one:

   1. Create a new Oberon partition.  Do this if you do not have an Oberon 
   partition yet, and if the disk has space for a new primary partition.

   2. Update an existing Oberon partition.  Do this if you have an old Oberon 
   partition or logical drive.  The system files will be overwritten by new 
   versions, and for *.Text, *.Tool and *.Mod files, a *.Bak file will be created.

   3. Overwrite a partition or logical drive.  Do this if you want to install Oberon 
   in an existing partition or logical drive belonging to another operating 
   system.  Warning: Oberon will overwrite the partition, and it will no longer 
   be usable by the other operating system!

   4. Install to a file on a FAT16 partition.  For backward compatability.

--------------------------------------------------------------

Execute the following command first, and then go to the relevant option 
below and execute the commands there in sequence.

Partition.Show ~  Display a numbered list of partitions and logical drives.
Free space for a primary partition is indicated with *free*.

--------------------------------------------------------------

OPTION 1: Create a new Oberon partition

Partition.Create <num> <size-Mb> ~  Create a new Oberon primary partition. 
Replace <num> with the number of some *free* space, and <size-Mb> with 
the new partition size in megabytes.  This will automatically be rounded.

Continue below at OPTION 2.

--------------------------------------------------------------

OPTION 2: Update an existing Oberon partition

Partition.Check ~  Check for bad sectors in the partition.  This can be skipped 
if you know the disk is ok.  If this fails, a different part of the disk must be used.

Install.InitBootLoader ~  Initialize a new Oberon boot loader.

Install.ReadInstallDiskette BasicSystem ~  Copy in the system files.

Installation done.  Close this text and return to Install.Tool to open the 
configuration tool.

--------------------------------------------------------------

OPTION 3: Overwrite a partition or logical drive

Partition.ChangeType <num> <from> <to> ~  Change a partition or logical 
drive type.  This will destroy the existing partition and overwrite it with
Oberon!  Replace <num> with the partition number from the list, and
<from> with the current decimal partition type from the list.  Replace <to> 
with decimal 79, which is the Oberon partition type.

Install.InitBootLoader ~  Initialize a new Oberon boot loader.

Install.InitFileSystem ~  "Format" the Oberon file system.

Continue above at OPTION 2.

--------------------------------------------------------------

OPTION 4: Install to a file on a FAT16 partition

Config.FAT "c:/native/native.dsk" ~  Install to a host file, which must 
already exist on a FAT16 partition.  The utility extend.exe can be used to 
create a suitable host file under DOS, OS/2 or Windows.

Installation done.  Close this text and return to Install.Tool to open the 
configuration tool and create a boot diskette.
