require "beanstalk-client"
require "MonitorType/Threshold"

#A Beanstalk class for checking how many msgs are in a Queue
class MonitorType_Beanstalk<MonitorType_Threshold
    
    #Extract parameters
    #
    # @param [String] beanstalk Optional connection string. Default to local
    # @param [String] queue Name of queue to monitor
	def extractParams()
        @connection_string = @params[:beanstalk] || "localhost:11300"
        
        if @params[:queue].nil? then
            string = "*** Beanstalk parameter missing, queue\n"
            string = "#{string}*** :queue => <queue name>"
            raise MonitorTypeExceptionHandled.new(string)
        end
        @queue = @params[:queue]
        
        @context_sentence = "Checking number of jobs in queue, #{@queue}"
        
	end
    
    def setup
        @beanstalk = Beanstalk::Pool.new([@connection_string])
    end
    
    
	def getValue
        count = 0
        begin
            tubeStats = @beanstalk.stats_tube(@queue)
            count = tubeStats["current-jobs-ready"]
            rescue Beanstalk::NotFoundError=>e
        end
        
		return count
	end
end

def beanstalk( params )
    $a.add( MonitorType_Beanstalk.new( params ) )
end

