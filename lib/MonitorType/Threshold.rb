
#A base class for checking a number against a min and/or max value
class MonitorType_Threshold<MonitorType

    #See super method for generic description
	def initialize( params )
        @min = params[:min] ||= 0
        @max = params[:max]
		super( params )
	end

    #Provides the means to check a value against thresholds
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
