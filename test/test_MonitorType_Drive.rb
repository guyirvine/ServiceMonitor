require 'test/unit'
require './lib/MonitorType/Drive.rb'
require "helper_functions"


class MonitorTypeDriveTest < Test::Unit::TestCase

	def test_MustHavePath
        test = Test_MonitorType.new( :name=>'Bob', :path=>'/', :min=>'80' ).extractParams

        exception_raised = false
        begin
            test = MonitorType_Drive.new( :name=>'Bob', :min=>'80' ).extractParams
            rescue MonitorTypeParameterMissingError=>e
            exception_raised = true
        end

		assert_equal true, exception_raised
	end

    def test_MustHaveValidPath
        test = Test_MonitorType.new( :name=>'Bob', :path=>'/sdfsdf', :min=>'80' ).extractParams

        exception_raised = false
        begin
            test = MonitorType_Drive.new( :name=>'Bob', :path=>'/asdasd', :min=>'80' ).extractParams
            rescue MonitorTypeExceptionHandled=>e
            exception_raised = true
        end

        assert_equal true, exception_raised
    end

    def test_MustHaveMin
        test = Test_MonitorType.new( :name=>'Bob', :path=>'/', :min=>'80' ).extractParams

        exception_raised = false
        begin
            test = MonitorType_Drive.new( :name=>'Bob', :path=>'/' ).extractParams
            rescue MonitorTypeParameterMissingError=>e
            exception_raised = true
        end

        assert_equal true, exception_raised
    end
end
