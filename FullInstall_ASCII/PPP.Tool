$VCS   1, Edgar.Schwarz@z.zgs.de, 28 Feb 99, 22:58:17 $
Welcome 
Version 1.0.0 28.02.1999 by Edgar.Schwarz@z.zgs.de.
For setting up PPP you should read System.Text first. If you then have probems you can use this document for additional information. If you have any comments or proposals for this document just send me a mail.

What is PPP 
PPP means 'Point to Point Protocol' and is basically a specification how two computers can communicate and exchange data. It also specifies how the peers can negotiate certain parameters. Maximum packet size, compression techniqes and so on.
ThePPP packet provides services PPPHDLC.SendPacket and PPPHDLC.ReceivePacket which the can be used e.g. by TCP/IP.
This implementation is configured to communicate with a COM port. In principle it's also possible to use Ethernet, ISDN or whatelse. It's just
necessary to change the interface to the hardware.
PPP is described in RFC (Request for Comment. These are Standards really, just the name is a little misleading) 1584.
Also of interest is RFC 1172 on IPCP (PPP Internet Protocol Control Protocol) and RFC 1334 on PPP Authentication Protocols.

What does PPP do 
First I will give you a sketch, which parties are involved if you are connected
with less detail on the ISP side.
	ISP																					YOU
	---																				   ---
	Apache																 HTML, Mail, ftp
		TCP/IP															TCP/IP
	 																	a device
	 	  PPP													PPP
	 	  						                               serial interface
	 	          modem							modem
	 	                           phone line
Now HTML is using TCP/IP. No need to configure anything.
TCP/IP uses a device. If nuff said Device0 is default.
Now you have to tell PPP which device and which serial interface
it should use (set it in Oberon.Text:NetSystem).
Finally you have to configure setting up your modem connection
to your ISP and starting PPP when done (set it in Oberon.Text:<ISP name>).

Using PPP 
In Oberon.Text you can define profiles for ISPs. My ISP is "StZ".
- setup
Setting stuff like described in System.Text. Also see chapter 'My setup' below.
- initialisation
> NetSystem.Start
> NetSystem.SetUser dialup:z974hzb@StZ ~  set password for user "z974hzb"
- connect
> Dialer.Dial StZ device0 ~ 
After the modem is connected and the script is finished you get a 'IPCP is finally up' in System.Log. Now you can access the WWW.
If you don't get the 'IPCP is finally up' then see below.
- disconnect
> PPPMain.StopInst 
	
Some more information in case of problems
My setup in Oberon.Text 
NetSystem = {
	Hosts = { 
		Domain = { "zgs.de", "" }
		DNS0 = { "dns0", "195.145.135.1" }
		DNS1 = { "dns1", "195.145.135.2" }

		Device0 = {"PPPMain.InstPPP", "COM1"}
		
		Route0 = {
			Device = "Device0"
			Mode = ""	{* "arp" for LAN, "" for PPP or SLIP *}
		}
	}
	SMTP = "zmail.zgs.de"	{* outgoing mail server *}
	POP = "zmail.zgs.de"	{* incoming mail server *}
	NNTP = "znews.zgs.de"	{* news server *}
	POPMode = "POP3"	{* POP3 or APOP *}

	EMail = "Edgar.Schwarz@z.zgs.de"	{* your return address *}
	MailSignature = "Mail.Sig.Text"	{* appended to every outgoing mail *}
	NewsSignature = "News.Sig.Text"{* appended to every outgoing news *}

	ProxyDomain = "zgs.de" {* optional *}
	HTTPProxy = "zproxy.zgs.de:8080"

	NewsThreading = Yes	{* Newsreader keeps message threads together? *}
	NewsFont = Courier10.Scn.Fnt	{* Font for news articles *}

	HTMLImages = No	{* Download WWW images with background task? *}
	KeepURLs = Yes
	KeepCache = Yes      {* only valid if KeepURLs = Yes *}

}
{* profile for my ISP (Stuttgarter Zeitung) *}
StZ = {
	Init = { COM1 38400 }	{* modem port and speed *}
	Dial = {
		"ATZ" 
		10 "OK" 
		"ATD 07111324300" 
		60 "CONNECT" 
		10 "Login:" 
		USER
		20 "word:" 
		PASSWORD
		20 "PPP Mode." 
		CALL PPPMain.StartInst
	}

In case your provider uses PAP(Password Authentication Protocol)  you should set the PAP parameters and try the following dial script. Your provider probably uses PAP or CHAP (not yet supported) if you don't receive anything like 'Login' or 'Password'.

DIAL = {
	Init = { COM1 38400 }	{* modem port and speed *}
	PAPName = { "<username>" }	{* if using PAP only *}
	PAPPassword = { "<password>" }	{* if using PAP only *}
	Dial = {
		"ATZ" 
		10 "OK" 
		"ATD 07111324300" 
		60 "CONNECT" 
		CALL PPPMain.StartInst
	}
}

Some more or less common problems already encountered 
- A provider has a buggy PPP server which sends want to configure illegal configuration options. I changed my code to tolerate this bug.
- Be sure you don't have a typo somewhere in your configuration. Here I remember   a case where somebody couldn't connect to his mailbox because of an error in his email address.
- A modem was setup in echo mode on power on so my PPP module tried to talk to itself without much success.
- If you get somthing like 'deviceX pending' check whether your settings in Oberon.Text:NetSystem are looking good.
	
Points to keep in mind
- If you change your dial script you can just redial.
- If you change something in your NetSystem configuration it's probably best to reboot.

How to debug 
- PPPTest.LogOn to turn logging on
- If it doesn't go through to 'Calling [PPPMain.StartInst]' you have already
problem with dialing. Check your dial script.
If you don't have an idea send me a step by step descripton of what you did, your setup for NetSystem and dialing from Oberon.Text and the partial log you got in System.Log.
- If you get 'Calling [PPPMain.StartInst]' but not 'IPCP is finally ready. Device opened.'
Then you have a problem in PPP setup. This can be errors in the DNS entry, your provider has problems at the moment (this also happens :-) ), your provider wants CHAP (I only support PAP at the moment), problems with modem configuration or much more. So in this case you can do a PPPTest.ShowLog which gives you the PPP log.
You can try to understand it yourself (If you read the RFCs :-) ) or send it to Edgar.Schwarz@z.zgs.de together with the information in the first case.

The log I get in System.Log with Dialer.Dial StZ device0 ~ 

Dial script started
Sending [ATZ]
Waiting 10s for [OK] {ATZ||OK}
Sending [ATD 07111324300]
Waiting 60s for [CONNECT] {|ATD 07111324300||CONNECT}
Waiting 10s for [Login:] { 38400||*** POP Stuttgart 1 ***|||Login:}
Sending USER [z974hzb]
Waiting 20s for [word:] { z974hzb|Password:}
Sending PASSWORD [***]
Waiting 20s for [PPP Mode.] { |    Entering PPP Mode.}
Calling [PPPMain.StartInst]
End of script
IPCP is finally ready. Device opened.

A PPP  log I got 

Starting receiving-loop
Pustekuchen, macht Devicepolling
FSM.LowerUp
protocol: LCP  -  channel: PPP
state: Initial

FSM.Open
protocol: LCP  -  channel: PPP
state: Closed

reset CI
FSM.SendConfReq
protocol: LCP  -  channel: PPP
id:    1    state: Closed

LCP.AddCI
protocol: LCP  -  channel: PPP
MRU AsyncMap 

FSM.SendData
protocol: LCP  -  channel: PPP
code: ConfReq
state: Closed
id:    1
0101000E 010405DC 02060000 0000

11:06:46SendPacket: len =    20
FF03C021 0101000E 010405DC 02060000 
00004F35 
11:06:46CheckPacket: len=   55
0D0A2020 20204950 20616464 72657373 
20697320 3139352E 3134352E 3133322E 
3136350D 0A202020 204D5455 20697320 
31353234 2E0D0A
Checksum failure11:06:46CheckPacket: len=   37
FF03C021 0101001F 010405F4 0206000A 
00000702 08021104 05F41309 0300C07B 
8056F048 BA
FSM.Input
new Input
protocol: LCP  -  channel: PPP
state: ReqSent

0101001F 010405F4 0206000A 00000702 
08021104 05F41309 0300C07B 8056F0

FSM.ReceiveConfigureRequest
protocol: LCP  -  channel: PPP
id:    1

RejPCCompRejACCompRejLCPConf17RejLCPConf19FSM.SendData
protocol: LCP  -  channel: PPP
code: ConfRej
state: ReqSent
id:    1
04010015 07020802 110405F4 13090300 
C07B8056 F0

11:06:46SendPacket: len =    27
FF03C021 04010015 07020802 110405F4 
13090300 C07B8056 F03A1C
11:06:46CheckPacket: len=    0

11:06:46CheckPacket: len=   20
FF03C021 0201000E 010405DC 02060000 
000071B6 
FSM.Input
new Input
protocol: LCP  -  channel: PPP
state: ReqSent

0201000E 010405DC 02060000 0000

FSM.ReceiveConfAck
protocol: LCP  -  channel: PPP
id:    1

11:06:46CheckPacket: len=    0

11:06:46CheckPacket: len=   20
FF03C021 0102000E 010405F4 0206000A 
0000ADF5 
FSM.Input
new Input
protocol: LCP  -  channel: PPP
state: AckRcvd

0102000E 010405F4 0206000A 0000

FSM.ReceiveConfigureRequest
protocol: LCP  -  channel: PPP
id:    2

FSM.SendData
protocol: LCP  -  channel: PPP
code: ConfAck
state: AckRcvd
id:    2
0202000E 010405F4 0206000A 0000

11:06:46SendPacket: len =    20
FF03C021 0202000E 010405F4 0206000A 
00009376 
LCP is finally ready!!
FSM.LowerUp
protocol: IPCP  -  channel: PPP
state: Initial

FSM.Open
protocol: IPCP  -  channel: PPP
state: Closed

FSM.SendConfReq
protocol: IPCP  -  channel: PPP
id:    1    state: Closed


FSM.SendData
protocol: IPCP  -  channel: PPP
code: ConfReq
state: Closed
id:    1
0101000A 03060000 0000

11:06:46SendPacket: len =    16
FF038021 0101000A 03060000 00001328 

11:06:47CheckPacket: len=    0

11:06:47CheckPacket: len=   22
FF038021 01010010 0206002D 0F010306 
C391877B 0C58
FSM.Input
new Input
protocol: IPCP  -  channel: PPP
state: ReqSent

01010010 0206002D 0F010306 C391877B 


FSM.ReceiveConfigureRequest
protocol: IPCP  -  channel: PPP
id:    1

FSM.SendData
protocol: IPCP  -  channel: PPP
code: ConfRej
state: ReqSent
id:    1
0401000A 0206002D 0F01

11:06:47SendPacket: len =    16
FF038021 0401000A 0206002D 0F0186DE 

11:06:47CheckPacket: len=    0

11:06:47CheckPacket: len=   16
FF0380FD 0101000A 11060001 0103CEDF 

11:06:47CheckPacket: len=    0

11:06:47CheckPacket: len=   16
FF038021 0301000A 0306C391 84A5E7A4 

FSM.Input
new Input
protocol: IPCP  -  channel: PPP
state: ReqSent

0301000A 0306C391 84A5

FSM.ReceiveConfigureNak/Reject
protocol: IPCP  -  channel: PPP
id:    1

FSM.SendConfReq
protocol: IPCP  -  channel: PPP
id:    2    state: ReqSent


FSM.SendData
protocol: IPCP  -  channel: PPP
code: ConfReq
state: ReqSent
id:    2
0102000A 0306C391 84A5

11:06:47SendPacket: len =    16
FF038021 0102000A 0306C391 84A5AE2A 

11:06:47CheckPacket: len=    0

11:06:47CheckPacket: len=   16
FF038021 0102000A 0306C391 877B353F 

FSM.Input
new Input
protocol: IPCP  -  channel: PPP
state: ReqSent

0102000A 0306C391 877B

FSM.ReceiveConfigureRequest
protocol: IPCP  -  channel: PPP
id:    2

FSM.SendData
protocol: IPCP  -  channel: PPP
code: ConfAck
state: ReqSent
id:    2
0202000A 0306C391 877B

11:06:47SendPacket: len =    16
FF038021 0202000A 0306C391 877B5C4B 

11:06:47CheckPacket: len=    0

11:06:47CheckPacket: len=   16
FF038021 0202000A 0306C391 84A5C75E 

FSM.Input
new Input
protocol: IPCP  -  channel: PPP
state: AckSent

0202000A 0306C391 84A5

FSM.ReceiveConfAck
protocol: IPCP  -  channel: PPP
id:    2

OurAddress = C39184A5
HisAddress = C391877B
IPCP is finally ready!!

Now the lower layers are up and PPP is running.
If there are still problems these probably come
from the upper protocols which also can be
diagnosed by having a look at the PPP packets.

Some concluding remarks
- In doubt send more information than you think relevant. Sometimes there is an error in an unexpected place.
- Also send me errors and proposals for this document. PPP installation should be as painless as possible for a user.

Regards, Edgar Schwarz