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

---