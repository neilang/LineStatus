module LineStatus
  class API < Grape::API
    format :json
    version 'v1', using: :path

    # Health check
    get '/' do
      { database: ActiveRecord::Base.connection.active? }
    end

    helpers do

      def pluralize_sentence(count, single, multiple, postfix)
        "#{count} #{(count > 1 ? multiple : single)} #{postfix}".strip
      end

      def summary_with_count(status=nil, count=1)
        msg = case status
        when Feedback.statuses['on_time']
          'running on time'
        when Feedback.statuses['early']
          'running ahead of time'
        when Feedback.statuses['late']
          'running a few minutes late'
        when Feedback.statuses['very_late']
          'running a VERY late'
        when Feedback.statuses['cancelled']
          'CANCELLED'
        else
          '..'
        end
        pluralize_sentence count, 'user has', 'users have', "reported this service is #{msg}."
      end

      def group_by_freqency(array)
        array.inject(Hash.new){|h,k| h[k]||=0; h[k]+=1; h}
      end

      def status_summary(status_ids)
        return 'No reported issues.' unless status_ids.size > 0
        sentences = group_by_freqency(status_ids).sort_by {|k,v| v}.reverse.map do |status, count|
          summary_with_count(status, count)
        end
        return sentences.join(' ')
      end

      def most_frequent_status(status_ids)
        return 'on time' unless status_ids.size > 0
        top_status = group_by_freqency(status_ids).max_by { |a,b| b }.first
        Feedback.statuses.key(top_status) || 'on time'
      end

      def line_status(line)
        status_ids = Feedback.where(linedir: line).pluck(:status)
        frequent   = most_frequent_status(status_ids).to_s.gsub(/_/, ' ')
        {
          summary: status_summary(status_ids),
          status:  frequent
        }
      end

    end

    resource :feedback do

      desc "Retrieve user feedback for a line/direction ID"
      params do
        requires :linedir, type: String,  desc: "PTV Line direction ID.", regexp: /^\d+$/
      end
      get ':linedir' do
        line_status(params[:linedir])
      end

      desc "Create/update user feedback for a line/direction ID"
      params do
        requires :linedir, type: String,  desc: "PTV Line direction ID.", regexp: /^\d+$/
        requires :udid,    type: String,  desc: "Device UDID",            regexp: /^\w{40}$/
        requires :status,  type: Integer, desc: "Status enum",            values: -> { Feedback.statuses.values }
      end
      post ':linedir' do
        feedback = Feedback.find_or_create_by!(udid: params[:udid], linedir: params[:linedir])
        feedback.update_attribute(:status, params[:status])
        line_status(params[:linedir])
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
