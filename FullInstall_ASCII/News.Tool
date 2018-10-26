[ Network | Mail | News | FTP | Gopher | Finger | HTTP | HyperDocs ]

Desktops.OpenDoc ^ 	Show an article overview
	"news:comp.lang.oberon"  "news:comp.lang.modula2"
	"news:comp.lang.oberon@40"	Show last 40 articles
	"news:comp.lang.oberon@40\n"	Show last 40 articles, new only

News.ShowAllGroups	Show all newsgroups
News.ShowNewGroups	Show new groups since last access

News.SubscribedGroups	List subscribed groups
News.SubGroup ^	Subscribe a group
News.UnsubGroup ^	Unsubscribe a group

News.CatchUp ^	Mark all articles in a group as read.
News.StoreInitText	Store information on read articles and 		subscribed groups

News.Reply *	Compose a minimal followup article for 		the marked article (full text visible)

News.Send iso *	Send an article
		ascii : text/plain, us-ascii
		iso : text/plain, iso 8bit
		oberon : text/plain with application/oberondoc attachment
		ooberon : only application/oberondoc
		<no mime> :
				- Simple Text without different colors or fonts
					no Umlaute -> ascii
					Umlaute -> iso
				- Text without objects, but with different colors or fonts -> oberon
				- Text with objects -> ooberon
					
Minimal Article:
-------------
Newsgroups: 
Subject: 
