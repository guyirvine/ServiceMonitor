require "FluidDb"
require "MonitorType/Threshold"

class MonitorType_FluidDb<MonitorType_Threshold
    
	def sanitise
        @fluidDb = FluidDb.Db( @uri )
	end
    
	def initialize( name, uri, sql, params )
		super( name, params )
        @uri = URI.parse( uri )
        @sql = sql
		self.sanitise
        rescue MonitorTypeExceptionHandled => e
        puts e.message
        abort()
	end
    
	def process
        value = @fluidDb.queryForValue( @sql, [] )
        
		self.check( value.to_i, "Checking result of sql query, @{sql}" )
	end
end

def fluiddb( name, uri, sql, params )
    $a.add( MonitorType_FluidDb.new( name, uri, sql, params ) )
end

