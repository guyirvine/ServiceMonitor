require "beanstalk-client"
require "MonitorType/Threshold"

class MonitorType_Beanstalk<MonitorType_Threshold
    
	def sanitise
        @beanstalk = Beanstalk::Pool.new([@connection_string])
	end
    
	def initialize( name, queue, params )
		super( name, params )
        @connection_string = params[:beanstalk] || "localhost:11300"
        @queue = queue
		self.sanitise
        rescue MonitorTypeExceptionHandled => e
        puts e.message
        abort()
	end
    
	def process
        tubeStats = @beanstalk.stats_tube(@queue)

		self.check( tubeStats["current-jobs-ready"], "Checking number of jobs in queue, #{@queue}" )
	end
end

def beanstalk( name, queue, params )
    $a.add( MonitorType_Beanstalk.new( name, queue, params ) )
end

