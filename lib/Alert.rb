#Base class / Interface for implementing alert types
class Alert
    
	def Send( destination, body )
        raise "Method needs to be overridden"
	end
end
