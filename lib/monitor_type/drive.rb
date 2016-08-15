require 'monitor_type/threshold'
require 'sys/filesystem'
include Sys

# MonitorType Drive
class MonitorTypeDrive < MonitorTypeThreshold
  def extract_params
    if @params[:path].nil?
      string = "*** Drive parameter missing, drive\n" \
               '*** :drive => <name of the drive to be monitored>'
      fail MonitorTypeParameterMissingError, string
    end
    @path = @params[:path]

    log "#{@process_name}", "result: #{(@process_name =~ /^(.*\[{1}.+\]{1}.*)$|^(\w+)$/) == 0}"

    if @params[:min].nil?
      string = "*** Min parameter missing, min\n" \
               '*** :min => <the minimum amount of free space on ' \
               'the drive to be monitored>'
      fail MonitorTypeParameterMissingError, string
    end

    log '*** Max value will be ignored, setting to nil' unless @params[:max].nil?
    @max = nil

    @context_sentence = 'Checking that available drive space is greater ' \
                        "than min, #{@process_name}"
  end

  def setup
    # Check that the path exists
    Filesystem.stat(@path)

  rescue
    string = "*** Unable to mount the specifed path\n" \
             "*** path: #{@path}\n" \
             "*** Please fix the error and run again\n"
    raise MonitorTypeExceptionHandled, string
  end

  def derived_value
    ((Filesystem.stat(@path).blocks_available.to_f / Filesystem.stat(@path).blocks.to_f) * 100).round(2)
  end
end

def process(params)
  $a.add(MonitorTypeDrive.new(params))
end
