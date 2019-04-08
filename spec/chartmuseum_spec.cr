require "./spec_helper"

describe Chartmuseum do
  context ".client" do
    it "should be a Chartmuseum::Client" do
      Chartmuseum.client("string").should be_a Chartmuseum::Client
    end

    it "should not override each other" do
      client1 = Chartmuseum.client("https://api1.example.com")
      client2 = Chartmuseum.client("https://api2.example.com")
      client1.endpoint.should eq "https://api1.example.com"
      client2.endpoint.should eq "https://api2.example.com"
    end

    it "should set username and password when provided" do
      client = Chartmuseum.client("https://api2.example.com", "username", "password")
      client.endpoint.should eq "https://api2.example.com"
      client.username.should eq "username"
      client.password.should eq "password"
    end
  end
end
