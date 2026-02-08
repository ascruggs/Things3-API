module ThingsShortcut
  module Navigation
    BUILT_IN_IDS = %w[
      inbox today anytime upcoming someday logbook
      tomorrow deadlines repeating all-projects logged-projects
    ].freeze

    module_function

    def show(params)
      unless params[:id] || params[:query] || params[:filter]
        raise ValidationError, "id, query, or filter is required"
      end

      url = UrlBuilder.build("show", params)
      ThingsShortcut.runner.execute(url)
      params
    end

    def search(query)
      raise ValidationError, "query is required" unless query && !query.empty?

      url = UrlBuilder.build("search", query: query)
      ThingsShortcut.runner.execute(url)
      { query: query }
    end
  end
end
