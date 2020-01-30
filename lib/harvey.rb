require 'slack/incoming/webhooks'
require_relative 'harvey/harvey_fetcher.rb'

module Harvey
  class Base

    def get_emails
      fetcher = HarveyProjectFetcher.new
      senders_id = fetcher.get_sending_users_id
      users_id = fetcher.get_users_id
      missings_id = fetcher.get_missing_users_id(senders_id, users_id)
      emails = fetcher.get_emails(missings_id)
    end

    def notify_slack
      slack = Slack::Incoming::Webhooks.new ENV.fetch("WEBHOOK_URL")
      if get_emails.empty?
        slack.post("Well done! Everybody sent timesheet to Harvest at this week.")
      else
        get_emails.each do |email|
          slack.post(email)
        end
      end
    end
  end
end
