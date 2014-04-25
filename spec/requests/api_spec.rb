require 'spec_helper'
require 'securerandom'

describe LineStatus::API, request: true do

  let(:udid){ SecureRandom.hex(40)[0,40] }
  let(:linedir){ '1234' }
  let(:status){ 0 }

  it "the API health check passes" do
    get "/api/"
    last_response.should be_successful
    results = JSON.parse(last_response.body)
    results['database'].should be_true
  end

  it "can look up feedback for a line" do
    get "/api/feedback/#{linedir}"
    last_response.should be_successful
  end

  describe "posting feedback" do

    it "can post feedback for a line" do
      post "/api/feedback/#{linedir}", { udid: udid, status: status }
      last_response.should be_successful
    end

    it "won't accept non-numeric ids" do
      post "/api/feedback/hello", { udid: udid, status: status }
      last_response.should_not be_successful
    end

    it "won't accept invalid statuses" do
      post "/api/feedback/#{linedir}", { udid: udid, status: 999 }
      last_response.should_not be_successful
    end

  end


end
