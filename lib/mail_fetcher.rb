require 'net/pop'

class MailFetcher
  
  def initialize(receiver)
    @receiver = receiver.new
    @config = YAML.load(IO.read("#{::Rails.root.to_s}/config/mail_fetcher.yml"))
  end
  
  def receive
    # http://www.ruby-doc.org/core/classes/Net/POP3.html
    pop = Net::POP3.new(@config[::Rails.env]['server'])
    pop.enable_ssl(OpenSSL::SSL::VERIFY_NONE) if @config[::Rails.env]['ssl']
    pop.start(@config[::Rails.env]['username'], @config[::Rails.env]['password'])
    
    unless pop.mails.empty?
      pop.each_mail do |mail|
        @receiver.mail= mail
        @receiver.receive
      end
    end
    
    pop.finish
  end
  
end