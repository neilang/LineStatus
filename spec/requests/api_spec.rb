require 'spec_helper'

describe LineStatus::API, request: true do

  it "the API health check passes" do
    get "/api/"
    last_response.should be_successful
    results = JSON.parse(last_response.body)
    results['database'].should be_true
  end

  it "can look up feedback for a line" do
    get "/api/feedback/1234"
    last_response.should be_successful
  end

  it "can post feedback for a line" do
    post "/api/feedback/1234"
    last_response.should be_successful
  end
end
