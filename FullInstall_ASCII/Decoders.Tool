Decoding tools - UUDecoder, Base64, BinHex, Rot13, Tar, etc.

UUDecoder decodes uuencoded text.

UUDecoder.Decode @	decodes from the selection
UUDecoder.Decode ^	decodes files listed in the selection
UUDecoder.Decode ~	decodes files listed
UUDecoder.Decode "begin" ... ~	decodes parameter-text

Base64 decodes or encodes base64 text.

Base64.Decode file ^	decodes from the selection to file
Base64.Decode file ~ ...	decodes the parameter text to file
Base64.Encode file ~	encode file

BinHex decodes BinHex encoded files.

BinHex.Decode file ^	decodes from the selection to file
BinHex.Decode file binhex	decodes from binhex to file
BinHex.Decode file ...	decodes from the parameter text to file

Rot13 decodes or encodes rot13 text.

Rot13.Decode ^	decode/encode selection in-place

Tar unpacks archives in uncompressed tar format.

Desktops.OpenDoc file.tar	display a list of tar file entries

QuotedPrintable decodes quoted-printable encoded files.

QuotedPrintable.DecodeText file ^	from selection to file
QuotedPrintable.DecodeText file qfile	from qfile to file
QuotedPrintable.DecodeText file ...	from parameter text to file
	(with character translation)
QuotedPrintable.DecodeFile file ^	from selection to file
QuotedPrintable.DecodeFile file qfile	from qfile to file
QuotedPrintable.DecodeFile file ...	from parameter text to file
	(without character translation)
