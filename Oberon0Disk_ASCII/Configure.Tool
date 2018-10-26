This tool is used to configure an installed Oberon system and make it 
bootable.  It consists of two parts:

   1. The appropriate device drivers and configuration options are selected.
   2. The configuration is stored in the partition or on a boot diskette.

--------------------------------------------------------------

PART 1: Device drivers and configuration options

Execute one command in each subsection to select the specified driver.
If you activate more than one command in a section, the last one is binding.

(a) Display driver

Config.Display Standard VGA
Config.Display Vesa 2.0
Config.Display ATI Mach64
Config.Display ATI Mach32
Config.Display 3Dlabs Permedia 2
Config.Display S3 Trio64
Config.Display S3 Aurora64
Config.Display S3 805 OEM
Config.Display S3 805 Vesa
Config.Display S3 924 OEM
Config.Display S3 924 Vesa
Config.Display Tseng ET4000
Config.Display Tseng ET4000 Vesa Hicolor
Config.Display Tseng W32
Config.Display Tseng VGA 72Hz
Config.Display Cirrus Logic GD543x
Config.Display Cirrus Logic GD542x
Config.Display Cirrus Logic GD542x Vesa
Config.Display Trident 9xxx Vesa
Config.Display Video7 Mirage

(b) Keyboard driver

Config.Keyboard United States
Config.Keyboard United Kingdom
Config.Keyboard Swiss German
Config.Keyboard German
Config.Keyboard Canadian
Config.Keyboard Norwegian
Config.Keyboard Turkish
Config.Keyboard Polish
Config.Keyboard Dvorak
Config.Keyboard French

(c) Disk cache size

The default cache size is 200k.  To change it, use the following command:
Config.DiskCache 1024k

(d) Esc key function

By default the Esc key is the same as Neutralize, for backward compatability.
If you want Esc to generate an ASCII ESC character (e.g. for Telnet to Unix):
Config.EscNeutralize off

(e) Font conversion

By default the Syntax font is converted to the Oberon font when loading 
documents, for backward compatability.  To keep the Syntax fonts intact:
Config.FontConversion off

(f) Color / Monochrome

By default the basic Oberon system uses color.  For a monochrome system:
Config.Color off

--------------------------------------------------------------

PART 2: Store the configuration and make Oberon bootable

Use one of the four alternatives here to store the configuration and make 
Oberon bootable (for a FAT-hosted installation, you must use option 3):

OPTION 1: Boot Oberon via boot manager

If you have a 3rd-party boot manager installed, for example PartitionMagic, 
Windows NT BootManager or Linux LILO, execute the command below and 
then reboot and run the boot manager configuration program to add the
Oberon partition to the boot menu.
Config.BootPartition menu ~

OPTION 2: Boot Oberon directly

With this option the PC will start up directly into Oberon.  To use another 
operating system, boot it from a diskette, or reactivate its partition with the 
Partition.Tool in Oberon.
Config.BootPartition direct ~

OPTION 3: Boot Oberon via diskette

This option can be used to boot any Oberon installation.  An Oberon boot
diskette is created, which will start up Oberon from the hard disk when it
is booted.  Insert a 1.44Mb diskette in the boot drive and execute:
Backup.Format\H (only necessary if diskette not already formatted)
Config.BootDiskette ~

OPTION 4: Boot Oberon via DOS or MS-DOS mode in Windows

This option can be used to boot any Oberon installation from DOS using the
command: noboot native.bin native.par
Config.Generate Native.Par ~
DOS.CopyTo "c:/native/" noboot.exe Native.Bin Native.Par ~

--------------------------------------------------------------

Congratulations!  Once you have completed PART 2, your basic installation 
is complete and you can reboot to test Oberon.  Start by opening the 
introductory text presented, which contains further configuration options.

System.Reboot
