require 'restclient'
require 'monitor_type/threshold'

# An http class for checking the length of a json list.
# For example,
#  Get the list of outstandinig errors
#  => check that the number is not greater than 2
class MonitorTypeHttpGetJsonList < MonitorTypeThreshold
  # Extract parameters
  #
  # @param [String] uri Connection string to db
  # @param [String] sql SQL statement to gather a single value
  def extract_params
    if @params[:uri].nil?
      string = "*** HttpGetJsonList parameter missing, uri\n" \
               '*** :uri => <uri pointing to url to be monitored>'
      fail MonitorTypeParameterMissingError, string
    end

    begin
      @uri = URI.parse(@params[:uri])
    rescue URI::InvalidURIError
      str = '*** HttpGetJsonList encountered an error while parsing the uri' \
            "*** uri: #{@params[:uri]}" \
            '*** Please fix the uri and run again'
      raise MonitorTypeParameterMissingError, str
    end

    url = "#{@uri.scheme}://#{@uri.host}#{@uri.path}"
    @context_sentence = "Checking size of json list returned from, #{url}"
  end

  def derived_value
    content = RestClient.get(@uri.to_s)
    list = JSON.parse(content)
    str = "Expected type, Array - Actual type, #{list.class.name}"
    fail MonitorTypeExceptionHandled, str unless list.class.name == 'Array'
    list.length
  rescue MonitorTypeExceptionHandled
    raise e

  rescue StandardError
    string = '*** HttpGetJsonList encountered an error while running the ' \
             'HTTP Get\n' \
             "*** uri: #{@uri}\n" \
              "*** Please fix the query and run again\n"
    raise MonitorTypeExceptionHandled, string
  end
end

def httpgetjsonlist(params)
  $a.add(MonitorTypeHttpGetJsonList.new(params))
end
