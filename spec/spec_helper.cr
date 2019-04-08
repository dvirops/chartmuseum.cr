require "spec"
require "webmock"
require "../src/chartmuseum"

CHARTMUSEUM_ENDPOINT = "https://charts.example.com"
CHARTMUSEUM_USERNAME = "username"
CHARTMUSEUM_PASSWORD = "password"

def client
  Chartmuseum.client(CHARTMUSEUM_ENDPOINT, CHARTMUSEUM_USERNAME, CHARTMUSEUM_PASSWORD)
end

def load_fixture(name : String?)
  return "" unless name
  File.read_lines(File.dirname(__FILE__) + "/fixtures/#{name}.json").join("\n")
end

# GET
def stub_get(path, fixture, params = nil, response_headers = {} of String => String, status = 200)
  query = "?#{HTTP::Params.encode(params)}" if params

  response_headers.merge!({"Content-Type" => "application/json"})
  WebMock.stub(:get, "#{client.endpoint}#{path}#{query}")
    .with(headers: {"Authorization" => "Basic " + Base64.encode(client.username.to_s + ":" + client.password.to_s).chomp})
    .to_return(status: status, body: load_fixture(fixture), headers: response_headers)
end
