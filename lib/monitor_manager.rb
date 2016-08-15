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

  rescue StandardError
    string = "#{e.class.name}\n" \
             "*** This is really unexpected.\n" \
             "Message: #{e.message}\n" \
             "#{e.backtrace}\n"
    puts string
  end
end
