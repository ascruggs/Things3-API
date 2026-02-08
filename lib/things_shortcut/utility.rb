module ThingsShortcut
  module Utility
    module_function

    def version
      url = UrlBuilder.build("version")
      ThingsShortcut.runner.execute(url)
      {}
    end

    def json_import(data, reveal: nil)
      params = {}
      params[:data] = data.is_a?(String) ? data : data.to_json
      params[:auth_token] = ThingsShortcut.auth_token if ThingsShortcut.auth_token
      params[:reveal] = reveal unless reveal.nil?

      url = UrlBuilder.build("json", params)
      ThingsShortcut.runner.execute(url)
      params.except(:auth_token)
    end

  end
end
