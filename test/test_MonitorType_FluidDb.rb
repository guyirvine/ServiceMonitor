require 'test/unit'
require './lib/MonitorType/FluidDb.rb'
require "helper_functions"


class MonitorTypeFluidDbTest < Test::Unit::TestCase
    
	def test_MustHaveUri
        test = Test_MonitorType.new( :name=>'Bob', :uri=>'pgsql://localhost/db', :sql=>'SELECT count(*) FROM table' ).extractParams
        
        exception_raised = false
        begin
            test = MonitorType_FluidDb.new( :name=>'Bob', :sql=>'SELECT count(*) FROM table' ).extractParams
            rescue MonitorTypeParameterMissingError=>e
            exception_raised = true
        end
        
		assert_equal true, exception_raised
	end
    
	def test_MustHaveSql
        test = Test_MonitorType.new( :name=>'Bob', :uri=>'pgsql://localhost/db', :sql=>'SELECT count(*) FROM table' ).extractParams
        
        exception_raised = false
        begin
            test = MonitorType_FluidDb.new( :name=>'Bob', :uri=>'pgsql://localhost/db' ).extractParams
            rescue MonitorTypeParameterMissingError=>e
            exception_raised = true
        end
        
		assert_equal true, exception_raised
	end
    
end
