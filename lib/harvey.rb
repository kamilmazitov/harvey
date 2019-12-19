require_relative "harvey/harvey_project_fetcher"

module Harvey
  class Base

    def create_message_forgotten_employees
      projects_id = harvey_project_fetcher.get_project_params("id")
    end


    private

    def harvey_project_fetcher
      HarveyProjectFetcher.new(
        ENV.fetch("HARVEST_ACCESS_TOKEN"),
        ENV.fetch("HARVEST_ACCOUNT_ID")
      )
    end
  end
end
