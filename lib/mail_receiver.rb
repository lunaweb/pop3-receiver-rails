require 'tmail'

class MailReceiver
  
  def mail=(mail)
    # http://www.ruby-doc.org/core/classes/Net/POPMail.html
    @popmail = mail
    
    # http://tmail.rubyforge.org/reference/index.html#mail
    @mail = TMail::Mail.parse(mail.pop)
  end
  
  def receive
  end
  
  def delete
    @popmail.delete
  end
  
  def unique_id
    @popmail.unique_id
  end

  def from
    @mail.from
  end

  def to
    @mail.to
  end

  def date
    @mail.date
  end
  
  def body
    @mail.body_html || @mail.body_text
  end

  def subject
    @mail.subject
  end
  
  def attachments
    atts = []
    @mail.parts.collect do |part|
      if part.multipart?
        part.parts.each do |sub_part|
          atts.push get_attachment(sub_part)
        end
      else
        atts.push get_attachment(part)
      end
    end
    atts.compact
  end
  
  private
  
  def get_attachment(part)
    if filename = part_filename(part)
      {
        :filename => filename,
        :content_type => part.content_type,
        :content => part.body
      }
    end
  end
  
  def part_filename(part)
    file_name = (part['content-location'] &&
      part['content-location'].body) ||
      part.sub_header('content-type', 'name') ||
      part.sub_header('content-disposition', 'filename')
  end
  
end

# http://rdoc.info/github/wildbit/postmark-gem/master/TMail/Mail
module TMail
  
  class Mail

    def body_html
      result = nil
      if multipart?
        parts.each do |part|
          if part.multipart?
            part.parts.each do |sub_part|
              result = sub_part.unquoted_body if sub_part.content_type =~ /html/i
            end
          elsif !attachment?(part)
            result = part.unquoted_body if part.content_type =~ /html/i
          end
        end
      else
        result = unquoted_body if content_type =~ /html/i
      end
      result
    end
    
    def body_text
      result = unquoted_body
      if multipart?
        parts.each do |part|
          if part.multipart?
            part.parts.each do |sub_part|
              result = sub_part.unquoted_body if sub_part.content_type =~ /plain/i
            end
          elsif !attachment?(part)
            result = part.unquoted_body if part.content_type =~ /plain/i
          end
        end
      else
        result = unquoted_body if content_type =~ /plain/i
      end
      result
    end
    
  end
  
end