require 'FluidDb'
require 'monitor_type/threshold'

# A database class for checking a single number against a threshold.
# For example,
#  get the max timestamp from a table as a date.
#  subtract this from now
#  => check that the number is not greater than 2
class MonitorTypeFluidDb < MonitorTypeThreshold
  # Extract parameters
  #
  # @param [String] uri Connection string to db
  # @param [String] sql SQL statement to gather a single value
  def extract_params
    if @params[:uri].nil?
      string = "*** FluidDb parameter missing, uri\n" \
               "*** :uri => <uri pointing to db to be monitored>"
      fail MonitorTypeParameterMissingError, string
    end
    begin
      @uri = URI.parse(@params[:uri])
    rescue URI::InvalidURIError
      string = '*** FluidDb encountered an error while parsing the uri' \
               "*** uri: #{@params[:uri]}" \
               "*** Please fix the uri and run again"
      raise MonitorTypeParameterMissingError, string
    end

    if @params[:sql].nil?
      string = '*** FluidDb parameter missing, sql' \
               "*** :sql => <sql statement, producing a single " \
               'column, single row which yeidls a number>'
      fail MonitorTypeParameterMissingError, string
    end
    @sql = @params[:sql]
    @context_sentence = "Checking result of sql query, #{@sql}"
  end

  # Create the connection to the db, and get the value
  # This ensures that all params are correct.
  def setup
    begin
      @fluid_db = FluidDb.Db(@uri)
    rescue StandardError => e
      string = "*** FluidDb encountered an error while connecting to the db\n" \
               "*** Error: #{e.message}\n" \
               "*** uri: #{@uri}\n" \
               "*** Please fix the error and run again\n"
      raise MonitorTypeExceptionHandled, string
    end

    @params[:fluidDb] = @fluid_db
  end

  def derived_value
    @fluid_db.queryForValue(@sql, [])
  rescue StandardError
    string = "*** FluidDb encountered an error while running the sql\n" \
             "*** sql: #{@sql}\n" \
             "*** Please fix the query and run again\n"
    raise MonitorTypeExceptionHandled, string
  end

  def teardown
    @fluid_db.close
  end
end

def fluiddb(params)
  $a.add(MonitorTypeFluidDb.new(params))
end
