require 'minitest/autorun'
require './lib/monitor_type'
require 'helper_functions'

# TestMonitorType
class TestMonitorType < MonitorType
  attr_reader :params, :block, :name, :email, :sender_email, :cron, :next

  def process
  end
end

class MonitorTypeTest < Minitest::Test
  def test_monitor_type_must_have_a_name
    TestMonitorType.new(:name=>'Bob')
    exception_raised = false
    begin
      TestMonitorType.new(:name2=>'Bob')
    rescue MonitorTypeMustHaveNameError
      exception_raised = true
    end

    assert_equal true, exception_raised
  end

  def test_monitor_type_must_have_sender_email_address_for_email_alert
    TestMonitorType.new(:name=>'name',
                        :email=>'email',
                        :email_sender=>'email_sender')

    exception_raised = false
    begin
      TestMonitorType.new(:name=>'name',
                           :email=>'email',
                           :email_sender2=>'email_sender')
    rescue MonitorTypeMustHaveSenderEmailAddressForEmailAlertError
      exception_raised = true
    end

    assert_equal true, exception_raised
  end

  def test_default_cron
    test = TestMonitorType.new(:name=>'name')
    test.run

    # check that next is 1am the next morning.

    #        exception_raised = false
    #        begin
    #            test = TestMonitorType.new( :name=>'name', :email=>'email',
    #           :email_sender2=>'email_sender' )
    #         rescue MonitorTypeMustHaveSenderEmailAddressForEmailAlertError=>e
    #            exception_raised = true
    #        end

    #        assert_equal true, exception_raised
    end
end
