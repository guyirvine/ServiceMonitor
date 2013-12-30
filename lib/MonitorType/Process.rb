require "MonitorType/Threshold"

#A class for checking if a Process is running in Unix based systems
class MonitorType_Process<MonitorType_Threshold

	def sanitise
		#Ensure that the process name contains a single character surrounded by square brackets
		@process_name = @process_name.insert(0,'[').insert(2,']') unless @process_name =~ /^.*\[.+\].*/
	end

	def initialize(params)
		super(params)

		if params[:process_name].nil? then
			puts "*** Process Name parameter missing, process_name"
			puts "*** :process_name => <name of the process to be monitored>"
			abort
		end
		@process_name = params[:process_name]

		puts "#{@process_name}", "result: #{(@process_name =~ /^(.*\[{1}.+\]{1}.*)$|^(\w+)$/) == 0}"

		unless (@process_name =~ /^(.*\[{1}.+\]{1}.*)$|^(\w+)$/) == 0 then
			puts "*** Process Name parameter doest not match the required pattern, #{@process_name}"
			puts "*** :process_name => <plain string, or a string with one or more characters enclosed in square brackets, i.e. 'foo', '[f]oo' or '[foo]'>"
			abort
		end

		puts "*** Min value will be ignored, setting to 1" unless (params[:min].nil? || params[:min] == 0)
		@min = 1

		puts "*** Max value will be ignored, setting to nil" unless params[:max].nil?
		@max = nil

		@context_sentence = "Checking that process is running, #{@process_name}"

		self.sanitise
	rescue MonitorTypeExceptionHandled => e
		puts e.message
		abort
	end

	def getValue
		return `ps aux | grep #{@process_name}`.length
	end

end

def process(params)
	$a.add(MonitorType_Process.new(params))
end
