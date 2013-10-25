require 'parse-cron'

class MonitorTypeExceptionHandled<StandardError
end

class MonitorType
    
    def initialize( name, params )
        @name = name
        @email = params[:email]
        
        cron_string = params[:cron] || "0 1 * * *"
        @cron = CronParser.new(cron_string)
        @next = Time.now - 1
        
        log "Loaded Monitor, #{@name}."
    end
    
    #Overload this method if any parameters should be checked
    def sanitise
    end
    
    def process
        raise "Method needs to be overridden"
    end
    
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
