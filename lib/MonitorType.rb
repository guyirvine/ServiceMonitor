
class MonitorType
    
    def initialize( params )
		@email = params[:email]
	end
    
    def run
        raise "Method needs to be overridden"
    end
    
	def alert( string )
		if !@email.nil? then
			Alert_Email.new( @email, string ).Send
            puts "Emailed, @email, Body, #{string}"
            else
            puts "*** Alert, no alert destination specified. Body, #{string}"
		end
	end
    
end
