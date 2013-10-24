
class MonitorManager
        def initialize
                @list = Array.new
        end

        def add( monitor )
                @list.push monitor
        end

        def run
                @list.each do |m|
                        m.run
                end
        end
end

