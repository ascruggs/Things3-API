require "cgi"

module ThingsShortcut
  module UrlBuilder
    PARAM_KEY_MAP = {
      "checklist_items" => "checklist-items",
      "list_id" => "list-id",
      "heading_id" => "heading-id",
      "auth_token" => "auth-token",
      "show_quick_entry" => "show-quick-entry",
      "prepend_notes" => "prepend-notes",
      "append_notes" => "append-notes",
      "add_tags" => "add-tags",
      "prepend_checklist_items" => "prepend-checklist-items",
      "append_checklist_items" => "append-checklist-items",
      "area_id" => "area-id",
      "to_dos" => "to-dos",
      "creation_date" => "creation-date",
      "completion_date" => "completion-date"
    }.freeze

    module_function

    def build(command, params = {})
      url = "things:///#{command}"

      return url if params.empty?

      query = params.map do |key, value|
        mapped_key = PARAM_KEY_MAP.fetch(key.to_s, key.to_s.tr("_", "-"))
        "#{CGI.escape(mapped_key)}=#{CGI.escape(value.to_s)}"
      end.join("&")

      "#{url}?#{query}"
    end
  end
end
