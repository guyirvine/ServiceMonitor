require 'test/unit'
require './lib/MonitorType/Dir.rb'
require "helper_functions"


class MonitorTypeDirTest < Test::Unit::TestCase
    
	def test_MustHavePath
        test = Test_MonitorType.new( :name=>'Bob', :path=>'/tmp' ).extractParams
        
        exception_raised = false
        begin
            test = MonitorType_Dir.new( :name=>'Bob' ).extractParams
            rescue MonitorTypeParameterMissingError=>e
            exception_raised = true
        end
        
		assert_equal true, exception_raised
	end
    
    
end
