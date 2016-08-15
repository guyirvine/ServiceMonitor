require 'monitor_type'

# A base class for checking a number against a min and/or max value
class MonitorTypeThreshold < MonitorType
  # See super method for generic description
  def initialize(params)
    @min = params[:min] ||= 0
    @max = params[:max]
    super(params)
  end

  # Get the context dependent value which is to be checked
  def derived_value
    fail 'Method needs to be overridden'
  end

  def process
    if @block.nil?
      value = derived_value
    else
      value = @block.call(@params)
      string = "value: #{value}\n"
      puts string
    end

    check(value)
  end

  # Provides the means to check a value against thresholds
  def check(value)
    context_sentence = @context_sentence.nil? ? '' : "#{@context_sentence}\n"
    url = @url.nil? ? '' : "\n\n#{@url}\n"

    value = value.to_i

    alert("#{context_sentence}Minimum threshold exceeded. " \
          "Minimum: #{@min}, " \
          "Actual: #{value}#{url}") if !@min.nil? && value < @min

    alert("#{context_sentence}Maximum threshold exceeded. " \
          "Maximum: #{@max}, " \
          "Actual: #{value}#{url}") if !@max.nil? && value > @max
  end
end
