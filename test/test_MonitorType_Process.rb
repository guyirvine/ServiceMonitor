require 'minitest/autorun'
require './lib/monitor_type/process'
require 'helper_functions'

# MonitorTypeProcessTest
class MonitorTypeProcessTest < Minitest::Test
  def test_must_have_process_name
    TestMonitorType.new(:name=>'Bob',
                        :process_name=>"test",
                        :email=>['rfrench@driven-monkey.com'],
                        :email_sender=>['rfrench@driven-monkey.com'])
                        .extract_params

    exception_raised = false
    begin
      MonitorTypeProcess.new(:name=>'Bob',
                              :email=>['rfrench@driven-monkey.com'],
                              :email_sender=>['rfrench@driven-monkey.com'])
                              .extract_params
    rescue MonitorTypeParameterMissingError
      exception_raised = true
    end

    assert_equal true, exception_raised
  end

  def test_must_be_valid_process_name
    TestMonitorType.new(:name=>'Bob',
                         :process_name=>"test",
                         :email=>['rfrench@driven-monkey.com'],
                         :email_sender=>['rfrench@driven-monkey.com'])
                         .extract_params

    exception_raised = false
    begin
      MonitorTypeProcess.new(:name=>'Bob',
                             :process_name=>"#test",
                             :email=>['rfrench@driven-monkey.com'],
                             :email_sender=>['rfrench@driven-monkey.com'])
                             .extract_params
    rescue InvalidProcessNameError
      exception_raised = true
    end

    assert_equal true, exception_raised
  end
end
