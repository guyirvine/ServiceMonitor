
class MonitorManager
    def initialize
        @list = Array.new
    end
    
    def add( monitor )
        @list.push monitor
    end
    
    #The main run loop
    def run
		while true do
            @list.each do |m|
                begin
                    m.sanitise
                    m.run
                    rescue MonitorTypeExceptionHandled => e
                    m.alert( e.message )
                end
            end
            sleep 0.2
		end
        
        rescue Interrupt => e
        puts "Exiting on request ..."

        rescue Exception => e
        puts e.class.name
        puts "*** This is really unexpected."
        messageLoop = false
        puts "Message: " + e.message
        puts e.backtrace
    end
end

