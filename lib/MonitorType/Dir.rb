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
        puts "***** Directory does not exist, #{@path}."
        puts "***** Create the directory, #{@path}, and try again."
        puts "***** eg, mkdir #{@path}"
        abort();
        rescue Errno::ENOTDIR => e
        puts "***** The specified path does not point to a directory, #{@path}."
        puts "***** Either repoint path to a directory, or remove, #{@path}, and create it as a directory."
        puts "***** eg, rm #{@path} && mkdir #{@path}"
        abort();
	end
    
	def initialize( path, params )
		super( params )
		@path = path
		self.sanitise
	end
    
	def run
		number_of_files = Dir.glob( "#{@path}/*" ).length
		self.check( number_of_files )
	end
end

def dir( path, params )
    $a.add( MonitorType_Dir.new( path, params ) )
end

