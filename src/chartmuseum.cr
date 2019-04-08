require "./chartmuseum/**"

module Chartmuseum
  # Alias for Chartmuseum::Client.new
  def self.client(endpoint : String, username : String? = nil, password : String? = nil) : Client
    Client.new(endpoint, username, password)
  end
end
