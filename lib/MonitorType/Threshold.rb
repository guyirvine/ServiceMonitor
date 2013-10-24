
class MonitorType_Threshold<MonitorType

	def initialize( params )
                @min = params[:min] ||= 0
                @max = params[:max]
		super( params )
	end

	def check( value )
                if !@min.nil? && value < @min then
                        self.alert( "MIN" )
                end
                if !@max.nil? && value > @max then
                        self.alert( "MAX" )
                end

	end
end
