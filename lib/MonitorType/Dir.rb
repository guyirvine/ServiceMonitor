require "MonitorType/Threshold"

class MonitorType_Dir<MonitorType_Threshold
    
	def sanitise
        inputDir = Dir.new( @path )
		@path = inputDir.path
        if !File.writable?( @path ) then
            puts "*** Warning. Directory is not writable, #{@path}."
            puts "*** Warning. Make the directory, #{@path}, writable and try again."
        end

        rescue Errno::ENOENT => e
        string = "***** Directory does not exist, #{@path}.\n"
        string = "#{string}***** Create the directory, #{@path}, and try again.\n"
        string = "#{string}***** eg, mkdir #{@path}"
        raise MonitorTypeExceptionHandled.new(string)
        rescue Errno::ENOTDIR => e
        string = "***** The specified path does not point to a directory, #{@path}.\n"
        string = "#{string}***** Either repoint path to a directory, or remove, #{@path}, and create it as a directory.\n"
        string = "#{string}***** eg, rm #{@path} && mkdir #{@path}"
        raise MonitorTypeExceptionHandled.new(string)
	end

	def initialize( name, path, params )
		super( name, params )
		@path = path
		self.sanitise
    rescue MonitorTypeExceptionHandled => e
        puts e.message
        abort()
	end

	def process
		number_of_files = Dir.glob( "#{@path}/*" ).length
		self.check( number_of_files, "Checking number of files in, #{@path}" )
	end
end

def dir( name, path, params )
    $a.add( MonitorType_Dir.new( name, path, params ) )
end

