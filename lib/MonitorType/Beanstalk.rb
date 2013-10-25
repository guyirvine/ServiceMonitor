require "beanstalk-client"
require "MonitorType/Threshold"

class MonitorType_Beanstalk<MonitorType_Threshold
    
	def sanitise
        @beanstalk = Beanstalk::Pool.new([@connection_string])
	end
    
	def initialize( params )
		super( params )
        @connection_string = params[:beanstalk] || "localhost:11300"
        if params[:queue].nil? then
            puts "*** Beanstalk parameter missing, queue"
            puts "*** :queue => <queue name>"
            abort
        end
        @queue = params[:queue]
		self.sanitise
        rescue MonitorTypeExceptionHandled => e
        puts e.message
        abort()
	end
    
	def process
        count = 0
        begin
        tubeStats = @beanstalk.stats_tube(@queue)
        count = tubeStats["current-jobs-ready"]
        rescue Beanstalk::NotFoundError=>e
        end

		self.check( count, "Checking number of jobs in queue, #{@queue}" )
	end
end

def beanstalk( params )
    $a.add( MonitorType_Beanstalk.new( params ) )
end

