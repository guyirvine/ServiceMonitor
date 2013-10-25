require "FluidDb"
require "MonitorType/Threshold"

class MonitorType_FluidDb<MonitorType_Threshold
    
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
	end
    
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
		self.sanitise
        rescue MonitorTypeExceptionHandled => e
        puts e.message
        abort()
	end
    
	def process
        value = @fluidDb.queryForValue( @sql, [] )
        
		self.check( value, "Checking result of sql query, #{@sql}" )
	end
end

def fluiddb( params )
    $a.add( MonitorType_FluidDb.new( params ) )
end

