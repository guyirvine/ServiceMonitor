# Base class / Interface for implementing alert types
class Alert
  def send(_destination, _body)
    fail 'Method needs to be overridden'
  end
end
