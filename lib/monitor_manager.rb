# Monitor Manager
class MonitorManager
  def initialize
    @list = []
  end

  def add(monitor)
    @list.push monitor
  end

  # The main run loop
  def run
    Kernel.loop do
      @list.each do |m|
        begin
          m.run
        rescue MonitorTypeExceptionHandled => e
          m.alert(e.message)
        end
      end
      sleep 0.2
    end

  rescue Interrupt
    string = "Exiting on request ...\n"
    puts string

  rescue StandardError => e
    puts '*** This is really unexpected.'
    puts e.class.name
    puts "Message: #{e.message}"
    puts e.backtrace
  end
end
