
class MonitorManager
        def initialize
                @list = Array.new
        end

        def add( monitor )
                @list.push monitor
        end

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
		sleep 0.5
		end
        end
end

