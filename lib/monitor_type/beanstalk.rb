require 'monitor_type/threshold'

# A Beanstalk class for checking how many msgs are in a Queue
class MonitorTypeBeanstalk < MonitorTypeThreshold
  # Extract parameters
  #
  # @param [String] beanstalk Optional connection string. Default to local
  # @param [String] queue Name of queue to monitor
  def extract_params
    @connection_string = @params[:beanstalk] || 'localhost:11300'

    if @params[:queue].nil?
      string = "*** Beanstalk parameter missing, queue\n" \
               '*** :queue => <queue name>'
      fail MonitorTypeParameterMissingError, string
    end
    @queue = @params[:queue]

    @context_sentence = "Checking number of jobs in queue, #{@queue}"
  end

  def setup
    @beanstalk = Beanstalk::Pool.new([@connection_string])
  end

  def derived_value
    tube_stats = @beanstalk.stats_tube(@queue)
    tube_stats['current-jobs-ready']
  rescue Beanstalk::NotFoundError
    0
  end
end

def beanstalk(params)
  require 'beanstalk-client'
  $a.add(MonitorTypeBeanstalk.new(params))
end
