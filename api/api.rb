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
      post ':linedir' do
        { status: 'Updated' }
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
