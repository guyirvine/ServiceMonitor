
#A base class for checking a number against a min and/or max value
class MonitorType_Threshold<MonitorType

    #See super method for generic description
	def initialize( params )
        @min = params[:min] ||= 0
        @max = params[:max]
		super( params )
	end

    #Get the context dependent value which is to be checked
    def getValue
        raise "Method needs to be overridden"
    end

    def process
        if @block.nil? then
            value = self.getValue
            else
            value = @block.call( @params )
            string = "value: #{value}\n"
            puts string
        end

        self.check( value )
    end

    #Provides the means to check a value against thresholds
	def check( value )
        context_sentence = ""
        if !@context_sentence.nil? then
            context_sentence = "#{@context_sentence}\n"
        end

        value = value.to_i
        if !@min.nil? && value < @min then
            self.alert( "#{context_sentence}Minimum threshold exceeded. Minimum: #{@min}, Actual: #{value}" )
        end
        if !@max.nil? && value > @max then
            self.alert( "#{context_sentence}Maximum threshold exceeded. Maximum: #{@max}, Actual: #{value}" )
        end
        
	end
end
