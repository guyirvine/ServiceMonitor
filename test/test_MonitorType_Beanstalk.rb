require 'minitest/autorun'
require './lib/monitor_type/beanstalk'
require 'helper_functions'

# MonitorTypeBeanstalkTest
class MonitorTypeBeanstalkTest < Minitest::Test
  def test_must_have_queue
    TestMonitorType.new(:name=>'Bob', :queue=>'tmp').extract_params
    exception_raised = false
    begin
      MonitorTypeBeanstalk.new(:name=>'Bob').extract_params
    rescue MonitorTypeParameterMissingError
      exception_raised = true
    end

    assert_equal true, exception_raised
  end
end
