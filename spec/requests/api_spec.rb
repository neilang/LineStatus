require 'spec_helper'
require 'securerandom'

describe LineStatus::API, request: true do

  let!(:udid){ SecureRandom.hex(40)[0,40] }
  let!(:linedir){ '1234' }
  let!(:status){ 0 }

  describe "health check" do
    it "the API health check passes" do
      get "/api/"
      last_response.should be_successful

      results = JSON.parse(last_response.body)
      results['database'].should be_true
    end
  end

  describe "requesting feedback" do

    it "can look up feedback for a line" do
      get "/api/feedback/#{linedir}"
      last_response.should be_successful
    end

    it "there is a default status for a line" do
      get "/api/feedback/999"

      data = JSON.parse(last_response.body)
      expect(data['status']).to eq('No reported issues.')
    end

    it "on considers recent updates" do
      Feedback.create(udid: udid, linedir: '999', updated_at: 31.minutes.ago, status: 2)
      get "/api/feedback/999"

      data = JSON.parse(last_response.body)
      expect(data['status']).to eq('No reported issues.')
    end

    context "on time" do

      before(:each) do
        Feedback.where(linedir: linedir).delete_all
      end

      it "a single reported status is noted" do
        Feedback.create(udid: udid, linedir: linedir, status: Feedback.statuses['on_time'])
        get "/api/feedback/#{linedir}"

        data = JSON.parse(last_response.body)
        expect(data['status']).to eq('1 user has reported this service is running on time.')
      end

      it "multiple users reported issue is noted" do
        3.times {
          Feedback.create(udid: udid, linedir: linedir, status: Feedback.statuses['on_time'])
        }

        get "/api/feedback/#{linedir}"
        data = JSON.parse(last_response.body)
        expect(data['status']).to match(/\d users have reported this service is running on time./)
      end

    end

    context "late" do
      before(:each) do
        Feedback.where(linedir: linedir).delete_all
      end

      it "a single reported late issue is noted" do
        Feedback.create(udid: udid, linedir: linedir, status: Feedback.statuses['late'])
        get "/api/feedback/#{linedir}"

        data = JSON.parse(last_response.body)
        expect(data['status']).to eq('1 user has reported this service is running a few minutes late.')
      end

      it "multiple reported late issue is noted" do
        2.times {
          Feedback.create(udid: udid, linedir: linedir, status: Feedback.statuses['late'])
        }

        get "/api/feedback/#{linedir}"
        data = JSON.parse(last_response.body)
        expect(data['status']).to match(/\d users have reported this service is running a few minutes late./)
      end
    end

    context "very late" do
      before(:each) do
        Feedback.where(linedir: linedir).delete_all
      end

      it "a single reported very late issue is noted" do
        Feedback.create(udid: udid, linedir: linedir, status: Feedback.statuses['very_late'])
        get "/api/feedback/#{linedir}"

        data = JSON.parse(last_response.body)
        expect(data['status']).to eq('1 user has reported this service is running a VERY late.')
      end

      it "multiple reported very late issue is noted" do
        2.times {
          Feedback.create(udid: udid, linedir: linedir, status: Feedback.statuses['very_late'])
        }

        get "/api/feedback/#{linedir}"
        data = JSON.parse(last_response.body)
        expect(data['status']).to match(/\d users have reported this service is running a VERY late./)
      end
    end

    context "cancelled" do
      before(:each) do
        Feedback.where(linedir: linedir).delete_all
      end

      it "a single reported cancelled issue is noted" do
        Feedback.create(udid: udid, linedir: linedir, status: Feedback.statuses['cancelled'])
        get "/api/feedback/#{linedir}"

        data = JSON.parse(last_response.body)
        expect(data['status']).to eq('1 user has reported this service is CANCELLED.')
      end

      it "multiple reported cancelled issue is noted" do
        2.times {
          Feedback.create(udid: udid, linedir: linedir, status: Feedback.statuses['cancelled'])
        }

        get "/api/feedback/#{linedir}"
        data = JSON.parse(last_response.body)
        expect(data['status']).to match(/\d users have reported this service is CANCELLED./)
      end
    end

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

    it "will create a new record for same UDID/linedir after 30 mins" do
      Feedback.create(udid: udid, linedir: linedir, updated_at: 31.minutes.ago, status: 1)
      expect {
        post "/api/feedback/#{linedir}", { udid: udid, status: 0 }
      }.to change{Feedback.count}.by(1)
    end

    it "will update an existing record for same UDID/linedir before 30 mins" do
      Feedback.create(udid: udid, linedir: linedir, updated_at: 5.minutes.ago, status: 1)
      expect {
        post "/api/feedback/#{linedir}", { udid: udid, status: 0 }
      }.to change{Feedback.count}.by(0)
    end

  end


end
