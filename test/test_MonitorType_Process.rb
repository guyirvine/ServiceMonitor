require 'test/unit'
require './lib/MonitorType/Process.rb'
require "helper_functions"


class MonitorTypeProcessTest < Test::Unit::TestCase

	def test_MustHaveProcessName
        test = Test_MonitorType.new( :name=>'Bob', :process_name=>"test", :email=>['rfrench@driven-monkey.com'], :email_sender=>['rfrench@driven-monkey.com'] ).extractParams

        exception_raised = false
        begin
            test = MonitorType_Process.new( :name=>'Bob', :email=>['rfrench@driven-monkey.com'], :email_sender=>['rfrench@driven-monkey.com'] ).extractParams
            rescue MonitorTypeParameterMissingError=>e
            exception_raised = true
        end

		assert_equal true, exception_raised
	end

    def test_MustBeValidProcessName
        test = Test_MonitorType.new( :name=>'Bob', :process_name=>"test", :email=>['rfrench@driven-monkey.com'], :email_sender=>['rfrench@driven-monkey.com'] ).extractParams

        exception_raised = false
        begin
            test = MonitorType_Process.new( :name=>'Bob', :process_name=>"#test", :email=>['rfrench@driven-monkey.com'], :email_sender=>['rfrench@driven-monkey.com'] ).extractParams
            rescue InvalidProcessNameError=>e
            exception_raised = true
        end

        assert_equal true, exception_raised
    end

end
