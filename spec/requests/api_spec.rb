require 'spec_helper'

describe LineStatus::API, request: true do

  it "the API health check passes" do
    get "/api/"
    last_response.should be_successful
    results = JSON.parse(last_response.body)
    results['database'].should be_true
  end

  it "can look up feedback for a line"

  it "can post feedback for a line"

end
