require 'harvesting'

module Harvey
  class HarveyProjectFetcher
    attr_reader :client

    def initialize(access_token, account_id)
      @client = Harvesting::Client.new(access_token: access_token, account_id: account_id)
    end


    def get_project_users(project_id)
      project_users = @client.user_assignments(opts = { project_id: project_id })
      project_users.entries.each_with_object([]) do |entry, project_users_names|
        project_users_names << entry.attributes["user"]["name"]
      end

    end

    def get_project_users_sending_time_entries_last_week(project_id)
      project_time_entries = @client.time_entries(opts = { project_id: project_id })
      project_time_entries.each_with_object([]) do |time_entry, project_users_sending_time_entries_last_week|
        current_day = Time.now.day.to_i
        spent_day = time_entry.attributes["spent_date"][9..10].to_i
        if current_day - spent_day > 7 or current_day - spent_day < 0
          project_users_sending_time_entries_last_week << time_entry.attributes["user"]["name"]
        end
      end
    end



    def get_forgotten_users(projects_id)

        projects_id.each_with_object([]) do |project_id, forgotten_users|
          project_users_names = get_project_users(project_id)
          prjoect_users_sending_time_entries_last_week = get_project_users_sending_time_entries_last_week(project_id).uniq
          project["name"] = get_projects_params("name")
          project["users"] = project_users_names - project_users_sending_time_entries_last_week
          forgotten_users << project
        end
      end
    end


    def get_projects_params(param)
      @client.projects.each_with_object([]) do |project, projects_id|
        projects_id << project.attributes[param]
      end
    end
  end
end
