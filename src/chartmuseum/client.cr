require "./client/**"
require "halite"
require "json"
require "base64"

module Chartmuseum
  # Chartmuseum API Client wrapper
  #
  # See the [Chartmuseum Offical API Document](https://chartmuseum.com/docs/) for more details.
  class Client
    # The endpoint of Chartmuseum
    property endpoint

    # The username (for basic authentication) of Chartmuseum
    property username

    # The password (for basic authentication) of Chartmuseum
    property password

    # :nodoc:
    enum ErrorType
      JsonError
      NonJsonError
    end

    # Create a new client
    #
    # ```
    # Chartmuseum::Client.new("<endpoint>", "<username>", "<password>")
    # ```
    def initialize(@endpoint : String, @username : String | Nil, @password : String | Nil)
    end

    {% for verb in %w(get) %}
      # Return a Halite::Response by sending a {{verb.id.upcase}} method http request
      #
      # ```
      # client.{{ verb.id }}("/path", params: {
      #   first_name: "foo",
      #   last_name:  "bar"
      # })
      # ```
      def {{ verb.id }}(uri : String, headers : (Hash(String, _) | NamedTuple)? = nil, params : (Hash(String, _) | NamedTuple)? = nil) : Halite::Response
        headers = headers ? default_headers.merge(headers) : default_headers
        response = Halite.{{verb.id}}(build_url(uri), headers: headers, params: params)
        validate(response)
        response
      end
    {% end %}

    # Return a `Bool` status by chartmuseum service
    #
    # - Return `Bool`
    #
    # ```
    # client.available? # => true
    # ```
    def available?
      get("/health")
      true
    rescue Halite::Exception::ConnectionError
      false
    end

    # Validate http response status code and content type
    #
    # Raise an exception if status code >= 400
    #
    # - **400**: `Error::BadRequest`
    # - **401**: `Error::Unauthorized`
    # - **403**: `Error::Forbidden`
    # - **404**: `Error::NotFound`
    # - **405**: `Error::MethodNotAllowed`
    # - **409**: `Error::Conflict`
    # - **422**: `Error::Unprocessable`
    # - **500**: `Error::InternalServerError`
    # - **502**: `Error::BadGateway`
    # - **503**: `Error::ServiceUnavailable`
    private def validate(response : Halite::Response)
      case response.status_code
      when 400 then raise Error::BadRequest.new(response)
      when 401 then raise Error::Unauthorized.new(response)
      when 403 then raise Error::Forbidden.new(response)
      when 404 then raise Error::NotFound.new(response)
      when 405 then raise Error::MethodNotAllowed.new(response)
      when 409 then raise Error::Conflict.new(response)
      when 422 then raise Error::Unprocessable.new(response)
      when 500 then raise Error::InternalServerError.new(response)
      when 502 then raise Error::BadGateway.new(response)
      when 503 then raise Error::ServiceUnavailable.new(response)
      when 507 then raise Error::InsufficientStorage.new(response)
      end
    end

    # Set a default Auth(Basic Authentication) header
    private def default_headers : Hash(String, String)
      Hash(String, String).new.tap do |obj|
        if @username && @password
          obj["Authorization"] = "Basic " + Base64.encode(username.to_s + ":" + password.to_s).chomp
        end

        obj["Accept"] = "application/json"
        obj["User-Agent"] = "Chartmuseum.cr v#{VERSION}"
      end
    end

    # Return a full url string from built with base domain and url path
    private def build_url(uri)
      File.join(@endpoint, uri)
    end

    include Chart
  end
end
