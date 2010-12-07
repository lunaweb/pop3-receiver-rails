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

  def body
    @mail.unquoted_body
  end
  
  def subject
    @mail.subject
  end
  
  def attachments
    return [] unless @mail.has_attachments?
    
    @mail.parts.collect do |part|
      if filename = part_filename(part)
        {
          :filename => filename,
          :content_type => part.content_type,
          :content => part.body
        }
      end
    end.compact
  end
  
  private
  
  def part_filename(part)
    file_name = (part['content-location'] &&
      part['content-location'].body) ||
      part.sub_header('content-type', 'name') ||
      part.sub_header('content-disposition', 'filename')
  end
  
end