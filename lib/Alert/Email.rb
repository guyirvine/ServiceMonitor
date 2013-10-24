require "net/smtp"
require "Alert"

class Alert_Email
	def initialize( destination, body )
		@destination = destination
		@body = body
	end

	def Send

message = <<MESSAGE_END
From: Agrimetrics <girvine@lic.co.nz>
To: #{@destination}
Subject: Agrimetrics Alert

#{@body}
.
MESSAGE_END

Net::SMTP.start('localhost') do |smtp|
  smtp.send_message message, 'girvine@lic.co.nz',
                             @destination
end

rescue Errno::ECONNREFUSED => e
    puts "*** Conection refused while attempting to connect to SMTP server"
    puts "*** Recipient, #{@destination}. Body,"
    puts "*** #{@body}"
	end
end

