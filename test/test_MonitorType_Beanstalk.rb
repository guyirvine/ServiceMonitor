require 'test/unit'
require './lib/MonitorType/Beanstalk.rb'
require "helper_functions"


class MonitorTypeBeanstalkTest < Test::Unit::TestCase
    
	def test_MustHaveQueue
        test = Test_MonitorType.new( :name=>'Bob', :queue=>'tmp' ).extractParams

        exception_raised = false
        begin
            test = MonitorType_Beanstalk.new( :name=>'Bob' ).extractParams
            rescue MonitorTypeParameterMissingError=>e
            exception_raised = true
        end
        
		assert_equal true, exception_raised
	end
    
    
end
