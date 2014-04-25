module LineStatus
  class API < Grape::API
    format :json

    # Health check
    get '/' do
      { database: ActiveRecord::Base.connection.active? }
    end

    resource :feedback do

      desc "Retrieve user feedback for a line/direction ID"
      get ':linedir' do
        { status: 'A-Okay' }
      end

      desc "Create/update user feedback for a line/direction ID"
      params do
        requires :linedir, type: String, desc: "PTV Line direction ID.", regexp: /^\d+$/
        requires :udid, type: String, regexp: /^\w{40}$/
        requires :status, type: Integer, desc: "Status enum", values: -> { Feedback.statuses.values }
      end
      post ':linedir' do
        # TODO: Check if status created in the last 30 mins
        Feedback.create!(linedir: params[:linedir], udid: params[:udid], status: params[:status])
      end

    end

    # Make Padrino happy
    class << self
      def app_name; ''; end
      def app_file; ''; end
      def public_folder; ''; end
      def setup_application!; nil; end
    end

  end
end
