require 'parse-cron'

#This is provided for reporting purposes.
# If this is raised on startup, the process will fail, and stop running.
# If this is raised after startup, the process will report, but keep running.
#
#The idea is to provide clear direction to the user to fix the error, but
# not stop all monitors in case of a production issue.
class MonitorTypeExceptionHandled<StandardError
end

#Base class for Monitors
#
#Given that this is a DSL, it extracts named parameters from a hash in order to provide
#more precise reporting of errors, without spewing syntax errors at a user
class MonitorType
    
    #Check that all required parameters have been passed in
    #Make sure that any errors encountered are reported in a way that
    # fixing the error is made easier
    def initialize( params )
        if params[:name].nil? then
            puts "*** Monitor parameter missing, name"
            puts "*** :name => <name of monitor>"
            abort
        end
        @name = params[:name]
        @email = params[:email]
        
        cron_string = params[:cron] || "0 1 * * *"
        @cron = CronParser.new(cron_string)
        @next = Time.now - 1
        
        log "Loaded Monitor, #{@name}."
    end
    
    #Overload this method if any parameters should be checked in context
    def sanitise
    end
    
    #Check if the monitor has tripped
    def process
        raise "Method needs to be overridden"
    end
    
    #An extention of the main run loop.
    #Each monitor is responsible for knowing when it should run, so this function
    #is called pretty much continuosuly.
    #
    def run
        if Time.now > @next then
            begin
                @next = @cron.next( Time.now )
                log "Monitor, #{@name}, next run time, #{@next}"
                self.sanitise
                self.process
                rescue MonitorTypeExceptionHandled => e
                m.alert( e.message )
            end
        end
    end
    
    #Called when a monitor has been tripped
    #
    # @param [String] string A description of the trip that occurred
	def alert( string )
        body = "#{@name} tripped.\n#{string}"
        puts "*** "
		if !@email.nil? then
			Alert_Email.new( @email, body ).Send
            puts "Emailed, @email, Body, #{body}"
            else
            puts body
		end
	end
    
end
