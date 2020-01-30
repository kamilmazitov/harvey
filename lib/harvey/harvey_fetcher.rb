require 'harvesting'

module Harvey
  class HarveyProjectFetcher

    def initialize
      @client = Harvesting::Client.new
    end

    def get_emails(missings_id)
      users = @client.users
      emails = []
      users.each do |user|
        missings_id.each do |missing_id|
          if missing_id == user.attributes["id"]
            emails << user.attributes["email"]
          end
        end
      end
      return emails
    end

    def get_sending_users_id
      time_entries = @client.time_entries
      time_entries.each_with_object([]) do |entry, senders_id|
        if last_week?(entry.attributes["spent_date"])
          senders_id << entry.attributes["user"]["id"]
        end
      end
    end

    def get_users_id
      users = @client.users
      users.each_with_object([]) do |user, users_id|
        users_id << user.attributes["id"]
      end
    end

    def get_missing_users_id(senders_id, users_id)
      missings_id = users_id - senders_id
    end

  private

    def last_week?(date)
      if Time.now.to_i - Time.parse(date).to_i < 604800
        true
      else
        false
      end
    end

  end
end
