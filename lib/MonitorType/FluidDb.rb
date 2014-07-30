require "FluidDb"
require "MonitorType/Threshold"

#A database class for checking a single number against a threshold.
# For example,
#  get the max timestamp from a table as a date.
#  subtract this from now
#  => check that the number is not greater than 2

class MonitorType_FluidDb<MonitorType_Threshold

    #Extract parameters
    #
    # @param [String] uri Connection string to db
    # @param [String] sql SQL statement to gather a single value
	def extractParams
        if @params[:uri].nil? then
            string = "*** FluidDb parameter missing, uri\n"
            string = "#{string}*** :uri => <uri pointing to db to be monitored>"
            raise MonitorTypeParameterMissingError.new(string)
        end
        begin
            @uri = URI.parse( @params[:uri] )
            rescue URI::InvalidURIError=>e
            string = "*** FluidDb encountered an error while parsing the uri"
            string = "#{string}*** uri: #{@params[:uri]}"
            string = "#{string}*** Please fix the uri and run again"
            raise MonitorTypeParameterMissingError.new(string)
        end

        if @params[:sql].nil? then
            string = "*** FluidDb parameter missing, sql"
            string = "#{string}*** :sql => <sql statement, producing a single column, single row which yeidls a number>"
            raise MonitorTypeParameterMissingError.new(string)
        end
        @sql = @params[:sql]

        @context_sentence = "Checking result of sql query, #{@sql}"

	end

    #Create the connection to the db, and get the value
    #This ensures that all params are correct.
	def setup

        begin
            @fluidDb = FluidDb.Db( @uri )
            rescue Exception=>e
            string = "*** FluidDb encountered an error while connecting to the db\n"
            string = "#{string}*** Error: #{e.message}\n"
            string = "#{string}*** uri: #{@uri}\n"
            string = "#{string}*** Please fix the error and run again\n"
            raise MonitorTypeExceptionHandled.new(string)
        end

        @params[:fluidDb] = @fluidDb
	end

	def getValue
        begin
            return @fluidDb.queryForValue( @sql, [] )
            rescue Exception=>e
            string = "*** FluidDb encountered an error while running the sql\n"
            string = "#{string}*** sql: #{@sql}\n"
            string = "#{string}*** Please fix the query and run again\n"
            raise MonitorTypeExceptionHandled.new(string)
        end
	end
end

def fluiddb( params )
    $a.add( MonitorType_FluidDb.new( params ) )
end

