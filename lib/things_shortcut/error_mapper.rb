module ThingsShortcut
  module ErrorMapper
    MAPPING = {
      ThingsScript::NotRunningError => ThingsShortcut::NotRunningError,
      ThingsScript::NotFoundError   => ThingsShortcut::NotFoundError,
      ThingsScript::ExecutionError  => ThingsShortcut::ExecutionError,
      ThingsScript::ParseError      => ThingsShortcut::ParseError,
      ThingsScript::ValidationError => ThingsShortcut::ValidationError
    }.freeze

    module_function

    def wrap
      yield
    rescue ThingsScript::Error => e
      mapped = MAPPING[e.class]
      raise mapped ? mapped.new(e.message) : ThingsShortcut::Error.new(e.message)
    end
  end
end
