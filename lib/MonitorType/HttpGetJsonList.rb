require "restclient"
require "MonitorType/Threshold"

#An http class for checking the length of a json list.
# For example,
#  Get the list of outstandinig errors
#  => check that the number is not greater than 2

class MonitorType_HttpGetJsonList<MonitorType_Threshold

    #Extract parameters
    #
    # @param [String] uri Connection string to db
    # @param [String] sql SQL statement to gather a single value
	def extractParams
        if @params[:uri].nil? then
            string = "*** HttpGetJsonList parameter missing, uri\n"
            string = "#{string}*** :uri => <uri pointing to url to be monitored>"
            raise MonitorTypeParameterMissingError.new(string)
        end

        begin
            @uri = URI.parse( @params[:uri] )
            rescue URI::InvalidURIError=>e
            string = "*** HttpGetJsonList encountered an error while parsing the uri"
            string = "#{string}*** uri: #{@params[:uri]}"
            string = "#{string}*** Please fix the uri and run again"
            raise MonitorTypeParameterMissingError.new(string)
        end

				url = "#{@uri.scheme}://#{@uri.host}#{@uri.path}"
        @context_sentence = "Checking size of json list returned from, #{url}"

	end

	def getValue
        begin
            content = RestClient.get( @uri.to_s )
						list = JSON.parse( content )
						raise MonitorTypeExceptionHandled.new( "Expected type, Array - Actual type, #{list.class.name}") unless list.class.name == "Array"
						return list.length

						rescue MonitorTypeExceptionHandled=>e
							raise e

            rescue Exception=>e
            string = "*** HttpGetJsonList encountered an error while running the HTTP Get\n"
            string = "#{string}*** uri: #{@uri}\n"
            string = "#{string}*** Please fix the query and run again\n"

            raise MonitorTypeExceptionHandled.new(string)
        end
	end
end

def httpgetjsonlist( params )
    $a.add( MonitorType_HttpGetJsonList.new( params ) )
end
