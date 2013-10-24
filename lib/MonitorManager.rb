
class MonitorManager
        def initialize
                @list = Array.new
        end

        def add( monitor )
                @list.push monitor
        end

        def run
                @list.each do |m|
                    begin
                        m.sanitise
                        m.run
                    rescue MonitorTypeExceptionHandled => e
                        m.alert( )
                    end
                end
        end
end

