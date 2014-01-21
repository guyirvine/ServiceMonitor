require 'test/unit'
require './lib/MonitorType/Dir.rb'
require "helper_functions"


class Test_MonitorType_Dir<MonitorType_Dir
    attr_reader :alert_string
    
	def alert( string )
        @alert_string = "#{@name} tripped.\n#{string}"
        
    end
end

class MonitorTypeDirTest < Test::Unit::TestCase
    
    def setup
        @path = "/tmp/servicemonitor"
        `rm -Rf #{@path}`
        `mkdir #{@path}`
    end
    
    def test_NoDir
        `rm -Rf #{@path}`
        test = Test_MonitorType_Dir.new( :name=>'dirTest', :path=>@path, :max=>2 )

        test.run
        
        assert_equal "dirTest tripped.\n***** Directory does not exist, /tmp/servicemonitor.\n***** Create the directory, /tmp/servicemonitor, and try again.\n***** eg, mkdir /tmp/servicemonitor", test.alert_string
        
    end
    
    
    def test_NoMinZeroFiles
        test = Test_MonitorType_Dir.new( :name=>'dirTest', :path=>@path, :max=>2 )
        
        test.run
        
        assert_equal true, test.alert_string.nil?
        
	end
    
    def test_Min1Files0
        test = Test_MonitorType_Dir.new( :name=>'dirTest', :path=>@path, :max=>2, :min=>1 )
        
        test.run
        
        assert_equal "dirTest tripped.\nChecking number of files in, /tmp/servicemonitor\nMinimum threshold exceeded. Minimum: 1, Actual: 0", test.alert_string
        
    end
    
    def test_Min1Files1
        IO.write( "#{@path}/1.txt", 1 )
        test = Test_MonitorType_Dir.new( :name=>'dirTest', :path=>@path, :max=>2, :min=>1 )
        
        test.run
        
        assert_equal true, test.alert_string.nil?
        
    end
    
    def test_Max2Files3
        IO.write( "#{@path}/1.txt", 1 )
        IO.write( "#{@path}/2.txt", 2 )
        IO.write( "#{@path}/3.txt", 3 )
        test = Test_MonitorType_Dir.new( :name=>'dirTest', :path=>@path, :max=>2, :min=>1 )
        
        test.run
        
        assert_equal "dirTest tripped.\nChecking number of files in, /tmp/servicemonitor\nMaximum threshold exceeded. Maximum: 2, Actual: 3", test.alert_string
        
    end
    
end
