require "../spec_helper"

describe Chartmuseum::Client do
  describe ".initialize" do
    it "should initilize client" do
      Chartmuseum::Client.new(CHARTMUSEUM_ENDPOINT, CHARTMUSEUM_USERNAME, CHARTMUSEUM_PASSWORD).should be_a Chartmuseum::Client
    end
  end

  describe ".available?" do
    it "should return true if service works" do
      stub_get("/health", "health")
      client.available?.should be_true
    end
  end
end
