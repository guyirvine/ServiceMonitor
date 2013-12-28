require "MonitorType/Threshold"

#A directory class for checking how many files are in a directory
class MonitorType_Dir<MonitorType_Threshold
    
    #Extract parameters
    #
    # @param [String] path Path to directory to check
    def extractParams()
        if @params[:path].nil? then
            string = "*** Dir parameter missing, path\n"
            string = "#{string}*** :path => <path to directory to be monitored>"
            raise MonitorTypeExceptionHandled.new(string)
        end
        @path = @params[:path]
        
        @context_sentence = "Checking number of files in, #{@path}"
        
    end
    
    
	def setup
        inputDir = Dir.new( @path )
		@path = inputDir.path
        if !File.writable?( @path ) then
            string = "*** Warning. Directory is not writable, #{@path}.\n"
            string = "#{string}*** Warning. Make the directory, #{@path}, writable and try again.\n"
            puts string
        end
        
        @params[:dir] = inputDir
        
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
    
	def getValue
		return Dir.glob( "#{@path}/*" ).length
	end
end

def dir( params )
    $a.add( MonitorType_Dir.new( params ) )
end

