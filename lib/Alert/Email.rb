require "net/smtp"
require "Alert"

#Email alert class
#Uses localhost for sending email - Probably need to change this in the future.
class Alert_Email
	def initialize( sender, destination, body )
		@sender = sender
		@body = body
        
        if destination.is_a? Array then
            @destination = "<#{destination.join( ">,<" )}>"
        else
            @destination = destination
        end
	end

	def Send
message = <<MESSAGE_END
From: #{ENV['APP_NAME']} #{@sender}
To: #{@destination}
Subject: #{ENV['APP_NAME']} Alert

#{@body}
.
MESSAGE_END

Net::SMTP.start('localhost') do |smtp|
  smtp.send_message message, @sender,
                             @destination
end

rescue Errno::ECONNREFUSED => e
    string = "*** Conection refused while attempting to connect to SMTP server\n"
    string = "#{string}*** Recipient, #{@destination}. Body,\n"
    string = "#{string}*** #{@body}\n"
    puts string
	end
end

