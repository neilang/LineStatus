module LineStatus
  class API < Grape::API
    format :json

    # Health check
    get '/' do
      { database: ActiveRecord::Base.connection.active? }
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
