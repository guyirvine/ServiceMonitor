
class MonitorTypeExceptionHandled<StandardError
end

class MonitorType
    
    def initialize( name, params )
        @name = name
		@email = params[:email]
	end
    
    #Overload this method if any parameters should be checked
    def sanitise
    end
    
    def process
        raise "Method needs to be overridden"
    end
    
    def run
        self.sanitise
        self.process
        rescue MonitorTypeExceptionHandled => e
        m.alert( e.message )
    end


	def alert( string )
        body = "#{@name} tripped.\n#{string}"
        
		if !@email.nil? then
			Alert_Email.new( @email, body ).Send
            puts "Emailed, @email, Body, #{body}"
            else
            puts body
		end
	end
    
end
