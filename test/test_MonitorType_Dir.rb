require 'minitest/autorun'
require './lib/monitor_type/dir'
require 'helper_functions'

# MonitorTypeDirTest
class MonitorTypeDirTest < Minitest::Test
  def test_must_have_path
    TestMonitorType.new(:name=>'Bob', :path=>'/tmp').extract_params
    exception_raised = false
    begin
      MonitorTypeDir.new( :name=>'Bob' ).extract_params
    rescue MonitorTypeParameterMissingError
      exception_raised = true
    end

    assert_equal true, exception_raised
  end
end
