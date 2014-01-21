require "MonitorType/Threshold"
require "sys/filesystem"
include Sys

class MonitorType_Drive<MonitorType_Threshold

	def extractParams
		if @params[:path].nil? then
			string = "*** Drive parameter missing, drive\n"
			string = "#{string}*** :drive => <name of the drive to be monitored>"
			raise MonitorTypeParameterMissingError.new(string)
		end
		@path = @params[:path]

		log "#{@process_name}", "result: #{(@process_name =~ /^(.*\[{1}.+\]{1}.*)$|^(\w+)$/) == 0}"

		if @params[:min].nil? then
			string = "*** Min parameter missing, min\n"
			string = "#{string}*** :min => <the minimum amount of free space on the drive to be monitored>"
			raise MonitorTypeParameterMissingError.new(string)
		end

  	log "*** Max value will be ignored, setting to nil" unless @params[:max].nil?
  	@max = nil

		@context_sentence = "Checking that available drive space is greater than min, #{@process_name}"
	end

	def setup
		begin
		#Check that the path exists
		drive = Filesystem.stat(@path)
		rescue=>e
			string = "*** Unable to mount the specifed path\n"
			string = "#{string}*** path: #{path}\n"
      string = "#{string}*** Please fix the error and run again\n"
			raise MonitorTypeExceptionHandled.new("Unable to mount path: #{@path}")
		end
	end

	def getValue
		return ((Filesystem.stat(@path).blocks_available.to_f / Filesystem.stat(@path).blocks.to_f) * 100).round(2)
	end

end

def process(params)
	$a.add(MonitorType_Drive.new(params))
end