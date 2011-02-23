class EmailMessage < ActiveRecord::Base

  # == Relationships ========================================================
  
  has_many :posts

  # == Class Methods ========================================================

  def self.create_from_pop3
    last_message_number = EmailMessage.maximum(:number).to_i
    msg_count = 0

    puts "Connecting to #{OPEN_PORCH_POP3['host']} ..."
    Net::POP.enable_ssl(OpenSSL::SSL::VERIFY_NONE) if OPEN_PORCH_POP3['enable_ssl']
    Net::POP3.start(OPEN_PORCH_POP3['host'], OPEN_PORCH_POP3['port'], OPEN_PORCH_POP3['username'], OPEN_PORCH_POP3['password']) do |pop|
      puts "Found #{pop.n_mails} messages on the server"
      puts "Last saved message: #{last_message_number}"
      unless pop.mails.empty?
        pop.mails.each do |m|
          next if (m.number <= last_message_number)
          print "\tSaving message ##{m.number} (#{"%.1f" % (m.length/1024.to_f)} KB) ... "
          
          begin
            email_message = EmailMessage.create(
              :number => m.number,
              :content => m.pop,
              :size => m.length,
              :parsed => false
            )
            print 'ok'
            if email_message.parse
              msg_count += 1
            end
          rescue ActiveRecord::StatementInvalid => e
            puts
            puts "========> ERROR saving message ##{m.number}"
            puts e.message
          end

          break if msg_count >= 10
        end
        puts "\tCopied #{msg_count} new messages from the server."
      end
    end
    puts "Done!"
  rescue SocketError => e
    puts "ERROR: Could not connect to #{OPEN_PORCH_POP3['host']} - #{e.message}"
  end
  
  # == Instance Methods ========================================================

  def parse
    return true if self.parsed?
    
    print "\tParsing message:"
    mail = Mail.new(self.content)
    
    # Parse the body of the message
    if mail.multipart?
      if mail.text_part
        body = mail.text_part.body
      else
        body = mail.parts[0].body
      end
    else
      body = mail.body
    end

    # Find the user
    user = User.where(:email => mail.from).first
    if user.blank?
      print "\tUser: Could not find user with email #{mail.from}"
      puts
      return false
    end
    print "\tUser: #{user.id}"
    
    # Find the area
    if mail.to.nil?
      print "\tArea: recipient is empty. Skipping."
      puts
    end
    slug = Mail::Address.new(mail.to.first).local
    area = Area.where(:slug => slug).first
    if area.blank?
      print "\tArea: Could not find area with slug #{slug}"
      puts
      return false
    end
    print "\tArea: #{area.name}"
    
    print "\tCreating post ... "
    area.posts.create(
      :user_id => user.id,
      :email_message_id => self.id,
      :title => mail.subject,
      :content => Iconv.conv("UTF-8//TRANSLIT//IGNORE", 'UTF-8', body.to_s + ' ')[0..-2]
    )
    
    self.update_attribute(:parsed, true)
    puts 'ok'
    return true
  end
end
