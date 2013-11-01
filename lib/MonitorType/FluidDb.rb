require "FluidDb"
require "MonitorType/Threshold"

#A database class for checking a single number against a threshold.
# For example,
#  get the max timestamp from a table as a date.
#  subtract this from now
#  => check that the number is not greater than 2

class MonitorType_FluidDb<MonitorType_Threshold
    
    #Create the connection to the db, and get the value
    #This ensures that all params are correct.
	def sanitise
        begin
            @fluidDb = FluidDb.Db( @uri )
            rescue Exception=>e
            puts "*** FluidDb encountered an error while connecting to the db"
            puts "*** Error: #{e.message}"
            puts "*** uri: #{@uri}"
            puts "*** Please fix the error and run again"
            abort()
        end

        begin
        value = @fluidDb.queryForValue( @sql, [] )
        rescue Exception=>e
            puts "*** FluidDb encountered an error while running the sql"
            puts "*** sql: #{@sql}"
            puts "*** Please fix the query and run again"
            abort()
        end
        @params[:fluidDb] = @fluidDb
	end
    
    #Constructor: Extract parameters
    #
    # @param [String] uri Connection string to db
    # @param [String] sql SQL statement to gather a single value
	def initialize( params )
		super( params )
        if params[:uri].nil? then
            puts "*** FluidDb parameter missing, uri"
            puts "*** :uri => <uri pointing to db to be monitored>"
            abort
        end
        begin
            @uri = URI.parse( params[:uri] )
        rescue URI::InvalidURIError=>e
            puts "*** FluidDb encountered an error while parsing the uri"
            puts "*** uri: #{params[:uri]}"
            puts "*** Please fix the uri and run again"
            abort()
        end
        
        if params[:sql].nil? then
            puts "*** FluidDb parameter missing, sql"
            puts "*** :sql => <sql statement, producing a single column, single row which yeidls a number>"
            abort
        end
        @sql = params[:sql]

        @context_sentence = "Checking result of sql query, #{@sql}"

		self.sanitise
        rescue MonitorTypeExceptionHandled => e
        puts e.message
        abort()
	end
    
	def getValue
        return @fluidDb.queryForValue( @sql, [] )
	end
end

def fluiddb( params )
    $a.add( MonitorType_FluidDb.new( params ) )
end

