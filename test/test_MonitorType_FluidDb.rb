require 'minitest/autorun'
require './lib/monitor_type/fluiddb'
require 'helper_functions'

# MonitorTypeFluidDbTest
class MonitorTypeFluidDbTest < Minitest::Test
  def test_must_have_uri
    TestMonitorType.new(:name=>'Bob',
                        :uri=>'pgsql://localhost/db',
                        :sql=>'SELECT count(*) FROM table').extract_params

    exception_raised = false
    begin
      MonitorTypeFluidDb.new(:name=>'Bob',
                             :sql=>'SELECT count(*) FROM table').extract_params
    rescue MonitorTypeParameterMissingError
      exception_raised = true
    end

    assert_equal true, exception_raised
  end

  def test_must_have_sql
    TestMonitorType.new(:name=>'Bob',
                        :uri=>'pgsql://localhost/db',
                        :sql=>'SELECT count(*) FROM table').extract_params

    exception_raised = false
    begin
      MonitorTypeFluidDb.new(:name=>'Bob',
                             :uri=>'pgsql://localhost/db' ).extract_params
    rescue MonitorTypeParameterMissingError
      exception_raised = true
    end

    assert_equal true, exception_raised
  end
end
