The Compress tool allows you to compress multiple files into the same archive using the LZSS compression technique (Note that the file format is not compatible with the UNIX utility of the same name). The archive is portable among all Oberon platforms. Compress files with an .Arc extension can be opened directly with Desktops.OpenDoc.

Compress.Directory Archive.Arc	Display a list of all entries in 
Compress.Directory \d Archive.Arc	an archive. If option "d" is
Compress.Directory ^	used additional information
Compress.Directory \d ^	on contents is given. If option
	"s" is used the output is sorted
	by filename.

Compress.Add Archive.Arc file1 file2 ... ~	Add files to an archive, if the 
Compress.Add Archive.Arc ^	archive not already exists, 
	create a new one.

Compress.Extract Archive.Arc file1 file2 ... ~	Unpack selected files from an Compress.Extract Archive.Arc ^	archive.

Compress.ExtractAll Archive1.Arc ... ~	Unpack all files from the archives.

Compress.Delete Archive.Arc file1 file2 ... ~	Delete selected files from an Compress.Delete Archive.Arc ^	archive.

Compress.Open Archive.Arc file ~	Unpack a document from an Compress.Open Archive.Arc ^	archive and open it. No file is
	written to disk.


