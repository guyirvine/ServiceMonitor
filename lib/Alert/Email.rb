require 'net/smtp'
require 'Alert'

# Email alert class
# Uses localhost for sending email - Probably need to change this in the future.
class AlertEmail
  def initialize(sender, destination, body)
    @sender = sender
    @body = body

    @smtp_address = ENV['smtp_address'].nil? ? 'localhost' : ENV['smtp_address']
    @smtp_port = ENV['smtp_port'].nil? ? 25 : ENV['smtp_port']

    @destination = destination
    if destination.is_a? Array
      @destination_fmt = "<#{destination.join('>,<')}>"
    else
      @destination_fmt = destination
    end
  end

  def send
    message = <<MESSAGE_END
From: #{ENV['APP_NAME']} #{@sender}
To: #{@destination_fmt}
Subject: #{ENV['APP_NAME']} Alert

#{@body}
.
MESSAGE_END

  Net::SMTP.start(@smtp_address,@smtp_port) do |smtp|
    smtp.send_message message, @sender, @destination
  end

  rescue Errno::ECONNREFUSED
    puts "*** Conection refused while attempting to connect to SMTP server\n" \
         "*** Recipient, #{@destination}. Body,\n" \
         "*** #{@body}\n"
  end
end
