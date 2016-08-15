def log(string, verbose = false)
  return if ENV['TESTING'] == 'true'

  if !ENV['VERBOSE'].nil? || verbose == false
    type = verbose ? 'VERB' : 'INFO'
    timestamp = Time.new.strftime('%Y-%m-%d %H:%M:%S')
    puts "[#{type}] #{timestamp} :: #{string}"
  end
end
