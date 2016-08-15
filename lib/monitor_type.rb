require 'parse-cron'
# This is provided for reporting purposes.
# It essentially indicates if an error case was expected
#
# The idea is to provide clear direction to the user to fix the error, but
# not stop all monitors in case of a production issue.
class MonitorTypeExceptionHandled < StandardError
end

class MonitorTypeParameterMissingError < MonitorTypeExceptionHandled
end

class MonitorTypeMustHaveNameError < MonitorTypeParameterMissingError
end

class MonitorTypeMustHaveSenderEmailAddressForEmailAlertError < MonitorTypeParameterMissingError
end

# Base class for Monitors
#
# Given that this is a DSL, it extracts named parameters from a hash in order
# to provide more precise reporting of errors, without spewing syntax errors
# at a user
class MonitorType
  # Check that all required parameters have been passed in
  # Make sure that any errors encountered are reported in a way that
  # fixing the error is made easier
  def initialize(params)
    if params[:name].nil?
      string = '*** Monitor parameter missing, name' \
               '*** :name => <name of monitor>'
      fail MonitorTypeMustHaveNameError, string
    end
    @params = params
    @block = params[:block] unless params[:block].nil?
    @name = params[:name]
    @email = params[:email]
    @url = params[:url] unless params[:url].nil?

    if !@email.nil?
      # Sender email address from ENV allows for a single sender across all alerts
      # Checking params before ENV allows a particular entry to be different
      if params[:email_sender].nil?
        if ENV['EMAIL_SENDER'].nil?
          string = '*** Alert parameter missing, email_sender' \
                    '*** An email recipient has been specified for monitor, ' \
                    "#{@name}, but no email sender has been specified" \
                    '*** :email_sender => <email of sender>' \
                    '*** or, a catch all environment variable' \
                    '*** EMAIL_SENDER=<email of sender>'

          fail MonitorTypeMustHaveSenderEmailAddressForEmailAlertError, string
        else
          @sender_email = ENV['EMAIL_SENDER']
        end
      else
        @sender_email = params[:admin_email]
      end
    end

    cron_string = params[:cron] || '0 1 * * *'
    @cron = CronParser.new(cron_string)
    @next = Time.now - 1

    log "Loaded Monitor, #{@name}."
  end

  # Overload this method if any parameters should be checked in context
  def extract_params
  end

  # Overload this method if any parameters should be checked in context
  def setup
  end

  # Overload this method if any parameters should be checked in context
  def teardown
  end

  # Check if the monitor has tripped
  def process
    fail 'Method needs to be overridden'
  end

  # An extention of the main run loop.
  # Each monitor is responsible for knowing when it should run, so this function
  # is called pretty much continuosuly.
  def run
    return unless Time.now > @next

    @next = @cron.next(Time.now)
    log "Monitor, #{@name}, next run time, #{@next}"
    extract_params
    setup
    process
    teardown
  rescue MonitorTypeExceptionHandled => e
    alert(e.message)
  end

  # Called when a monitor has been tripped
  #
  # @param [String] string A description of the trip that occurred
  def alert(string)
    body = "#{@name} tripped.\n#{string}"
    puts '*** '
    if !@email.nil?
      AlertEmail.new(@sender_email, @email, body).send
      puts "Emailed, #{@email}"
    else
      puts body
    end
  end
end
