module ThingsScript
  module Lists
    NAMES = %w[Inbox Today Anytime Upcoming Someday Logbook Trash].freeze

    module_function

    def all
      NAMES.map { |name| { name: name } }
    end
  end
end
