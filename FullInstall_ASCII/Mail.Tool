[ Network | Mail | News | FTP | Gopher | Finger | HTTP | HyperDocs ]

NetSystem.SetUser pop:<username>@<server> ~	Set mail password.
Desktops.OpenDoc Mail.Panel	Open Mail panel.

Mail.Mono *	Change the font of the marked.
	viewer into Courier10.
Mail.CutLines [width] *	Break all lines in the marked viewer
	after a maximum of width characters.
	The default width is 80.

Mail.Collect	Remove deleted messages.

Mail.Send * | ^ | {textfile} ~	Mail text (remember To: & Subject:).

EditTools.OpenAscii MailMessages	Open raw mail file.

Mail Recipient Syntax
	Recipients = RecipientsLine { RecipientsLine } .
	RecipientsLine = ( "To:" | "Cc:" | "BCc:" ) Recipient { "," Recipient } .
	Recipient = { Comment } MailAdr .

Mail Query Syntax
	Query = TQuery { "OR" TQuery } .
	Query = SQuery { "&" SQuery } .
	SQuery = StringQ | DateQ | TimeQ | FlagQ .
	StringQ = ( "from" | "subject" | "text" | "topic" ) ( "=" | "#" ) String .
	FlagQ = "read" | "unread" .
	DateQ =  "date" ( "=" | "#" | "<" | ">" | ">=" | "<=") ( "today" | Date ) .
	TimeQ =  "time" ( "=" | "#" | "<" | ">" | ">=" | "<=") ( "now" | Time ) .
	Date = Day "." Month "." Year .
	Time = Hour ":" Minute [ ":" Second ] .

Using Topics
	You may define a maximum of 32 different topics in Oberon.Text to
	classify your mail.  See Topic0-Topic31 in the NetSystem section.
	The selected mail message(s) can be flagged with a topic using the 
	Set button, and a flag may be cleared using the Clear button.
	The Query button generates a topic-based query.  Note that the 
	topic is simply a flag, and the message is only stored once!  A single
	message may be flagged with multiple topics.
