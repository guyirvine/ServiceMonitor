require 'test/unit'
require './lib/MonitorType.rb'
require "helper_functions"


class Test_MonitorType<MonitorType
    
    attr_reader :params, :block, :name, :email, :sender_email, :cron, :next
  
    def process
    end
  
end

class MonitorTypeTest < Test::Unit::TestCase
    
	def test_MonitorTypeMustHaveAName
        test = Test_MonitorType.new( :name=>'Bob' )
        
        exception_raised = false
        begin
            test = Test_MonitorType.new( :name2=>'Bob' )
            rescue MonitorTypeMustHaveNameError=>e
            exception_raised = true
        end
        
		assert_equal true, exception_raised
	end
    
    def test_MonitorTypeMustHaveSenderEmailAddressForEmailAlert
        test = Test_MonitorType.new( :name=>'name', :email=>'email', :email_sender=>'email_sender' )
        
        exception_raised = false
        begin
            test = Test_MonitorType.new( :name=>'name', :email=>'email', :email_sender2=>'email_sender' )
            rescue MonitorTypeMustHaveSenderEmailAddressForEmailAlertError=>e
            exception_raised = true
        end
        
        assert_equal true, exception_raised
    end
    
    
    def test_DefaultCron
        test = Test_MonitorType.new( :name=>'name' )
        
        test.run
        
        #check that next is 1am the next morning.

#        exception_raised = false
#        begin
#            test = Test_MonitorType.new( :name=>'name', :email=>'email', :email_sender2=>'email_sender' )
#            rescue MonitorTypeMustHaveSenderEmailAddressForEmailAlertError=>e
#            exception_raised = true
#        end

#        assert_equal true, exception_raised
    end
    
    
end
