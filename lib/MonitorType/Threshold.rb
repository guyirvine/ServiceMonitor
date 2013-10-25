
class MonitorType_Threshold<MonitorType

	def initialize( name, params )
        @min = params[:min] ||= 0
        @max = params[:max]
		super( name, params )
	end

	def check( value, context_sentence )
        value = value.to_i
        if !@min.nil? && value < @min then
            self.alert( "#{context_sentence}\nMinimum threshold exceeded. Minimum: #{@min}, Actual: #{value}" )
        end
        if !@max.nil? && value > @max then
            self.alert( "#{context_sentence}\nMaximum threshold exceeded. Maximum: #{@max}, Actual: #{value}" )
        end
        
	end
end
