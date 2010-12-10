pop3_receiver
=============

---

Installation
------------

git clone git://github.com/lunaweb/pop3-receiver-rails.git vendor/plugins/pop3_receiver

---

Utilisation
-----------

	class MyReceiver < MailReceiver
	
		def receive
			# do what I want
		end
	
	end
	
	fetcher = MailFetcher.new(MyReceiver)
	fetch.receive

méthodes accessibles

* attachments : tableau des pièces jointes sous la forme [{:filename => ..., :content_type => ..., :content => ...}, {...}]
* body : corps du mail (html sinon texte)
* date : date du mail
* delete : suppression du mail sur le serveur pop
* from : expéditeur du mail
* subject : sujet du mail
* to : destinataire du mail
* unique_id : identifiant unique du mail

---