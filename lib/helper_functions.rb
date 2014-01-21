def log( string, verbose=false )
    return if ENV["TESTING"]=="true"
    
    type = verbose ? "VERB" : "INFO"
	if !ENV["VERBOSE"].nil? || verbose==false then
        timestamp = Time.new.strftime( "%Y-%m-%d %H:%M:%S" )
        puts "[#{type}] #{timestamp} :: #{string}"
    end
end


