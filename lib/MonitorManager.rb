
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
                    m.run
                    rescue MonitorTypeExceptionHandled => e
                    m.alert( e.message )
                end
            end
            sleep 0.2
		end
        
        rescue Interrupt => e
        string = "Exiting on request ...\n"
        puts string

        rescue Exception => e
        string = "#{e.class.name}\n"
        string = "#{string}*** This is really unexpected.\n"
        string = "#{string}Message: #{e.message}\n"
        string = "#{string}e.backtrace\n"
        puts string
    end
end

