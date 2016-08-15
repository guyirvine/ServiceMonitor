require 'monitor_type/threshold'

# A directory class for checking how many files are in a directory
class MonitorTypeDir < MonitorTypeThreshold
  # Extract parameters
  #
  # @param [String] path Path to directory to check
  def extract_params
    if @params[:path].nil?
      string = "*** Dir parameter missing, path\n" \
               '*** :path => <path to directory to be monitored>'
      fail MonitorTypeParameterMissingError, string
    end
    @path = @params[:path]

    @context_sentence = "Checking number of files in, #{@path}"
  end

  def setup
    input_dir = Dir.new(@path)
    @path = input_dir.path
    @params[:dir] = input_dir

  rescue Errno::ENOENT
    str = "***** Directory does not exist, #{@path}.\n" \
          "***** Create the directory, #{@path}, and try again.\n" \
          "***** eg, mkdir #{@path}"
    raise MonitorTypeExceptionHandled, str
  rescue Errno::ENOTDIR
    str = '***** The specified path does not point to a ' \
          "directory, #{@path}.\n" \
          '***** Either repoint path to a directory, ' \
          "or remove, #{@path}, and create it as a directory.\n" \
          "***** eg, rm #{@path} && mkdir #{@path}"
    raise MonitorTypeExceptionHandled, str
  end

  def derived_value
    Dir.glob("#{@path}/*").length
  end
end

def dir(params)
  $a.add(MonitorTypeDir.new(params))
end
