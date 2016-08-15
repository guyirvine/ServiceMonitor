require 'minitest/autorun'
require './lib/monitor_type/dir.rb'
require 'helper_functions'

# TestMonitorTypeDir
class TestMonitorTypeDir < MonitorTypeDir
  attr_reader :alert_string

  def alert(string)
    @alert_string = "#{@name} tripped.\n#{string}"
  end
end

# MonitorTypeDirTest
class MonitorTypeDirTest < Minitest::Test
  def setup
    @path = '/tmp/servicemonitor'
    `rm -Rf #{@path}`
    `mkdir #{@path}`
  end

  def test_no_dir
    `rm -Rf #{@path}`
    test = TestMonitorTypeDir.new(:name => 'dirTest',
                                    :path => @path,
                                    :max => 2)
    test.run
    assert_equal "dirTest tripped.\n***** Directory does not exist, /tmp/servicemonitor.\n***** Create the directory, /tmp/servicemonitor, and try again.\n***** eg, mkdir /tmp/servicemonitor", test.alert_string
  end

  def test_no_min_zero_files
    test = TestMonitorTypeDir.new(:name=>'dirTest', :path=>@path, :max=>2)
    test.run

    assert_equal true, test.alert_string.nil?
  end

  def test_min_1_files_0
    test = TestMonitorTypeDir.new(:name=>'dirTest',
                                    :path=>@path,
                                    :max=>2,
                                    :min=>1)
    test.run

    assert_equal "dirTest tripped.\nChecking number of files in, /tmp/servicemonitor\nMinimum threshold exceeded. Minimum: 1, Actual: 0", test.alert_string
  end

  def test_min_1_files_1
    IO.write("#{@path}/1.txt", 1)
    test = TestMonitorTypeDir.new(:name=>'dirTest',
                                    :path=>@path,
                                    :max=>2,
                                    :min=>1)
    test.run
    assert_equal true, test.alert_string.nil?
  end

  def test_max_2_files_3
    IO.write("#{@path}/1.txt", 1)
    IO.write("#{@path}/2.txt", 2)
    IO.write("#{@path}/3.txt", 3)
    test = TestMonitorTypeDir.new(:name=>'dirTest',
                                    :path=>@path,
                                    :max=>2,
                                    :min=>1)
    test.run
    assert_equal "dirTest tripped.\nChecking number of files in, /tmp/servicemonitor\nMaximum threshold exceeded. Maximum: 2, Actual: 3", test.alert_string
  end
end
