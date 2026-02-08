module ThingsScript
  module Areas
    module_function

    def all
      script = ScriptBuilder.with_helpers(<<~APPLESCRIPT)
        set areaList to areas
        set output to "["
        repeat with i from 1 to count of areaList
          set a to item i of areaList
          #{ScriptBuilder.area_to_json_expr("a")}
          if i > 1 then set output to output & ","
          set output to output & j
        end repeat
        set output to output & "]"
      APPLESCRIPT
      ResponseParser.parse_array(ThingsScript.runner.execute(script))
    end

    def find(id)
      script = ScriptBuilder.with_helpers(<<~APPLESCRIPT)
        set a to area id "#{ScriptBuilder.sanitize(id)}"
        #{ScriptBuilder.area_to_json_expr("a")}
      APPLESCRIPT
      result = ThingsScript.runner.execute(script)
      ResponseParser.parse(result) || raise(NotFoundError, "Area not found: #{id}")
    rescue ExecutionError => e
      raise NotFoundError, "Area not found: #{id}" if e.message.include?("Can't get area")
      raise
    end

    def todos(id)
      Todos.in_area(id)
    end

    def projects(id)
      script = ScriptBuilder.with_helpers(<<~APPLESCRIPT)
        set projList to projects of area id "#{ScriptBuilder.sanitize(id)}"
        set output to "["
        repeat with i from 1 to count of projList
          set p to item i of projList
          #{ScriptBuilder.project_to_json_expr("p")}
          if i > 1 then set output to output & ","
          set output to output & j
        end repeat
        set output to output & "]"
      APPLESCRIPT
      ResponseParser.parse_array(ThingsScript.runner.execute(script))
    rescue ExecutionError => e
      raise NotFoundError, "Area not found: #{id}" if e.message.include?("Can't get area")
      raise
    end

    def create(params)
      props = []
      props << "name:\"#{ScriptBuilder.sanitize(params[:name])}\"" if params[:name]
      props << "tag names:\"#{ScriptBuilder.sanitize(params[:tag_names])}\"" if params[:tag_names]
      body = "set newArea to make new area with properties {#{props.join(', ')}}\n"
      body += ScriptBuilder.area_to_json_expr("newArea")
      script = ScriptBuilder.with_helpers(body)
      ResponseParser.parse(ThingsScript.runner.execute(script))
    end

    def update(id, params)
      safe_id = ScriptBuilder.sanitize(id)
      lines = []
      lines << "set a to area id \"#{safe_id}\""
      lines << "set name of a to \"#{ScriptBuilder.sanitize(params[:name])}\"" if params[:name]
      lines << "set tag names of a to \"#{ScriptBuilder.sanitize(params[:tag_names])}\"" if params[:tag_names]
      lines << ScriptBuilder.area_to_json_expr("a")
      script = ScriptBuilder.with_helpers(lines.join("\n"))
      ResponseParser.parse(ThingsScript.runner.execute(script))
    rescue ExecutionError => e
      raise NotFoundError, "Area not found: #{id}" if e.message.include?("Can't get area")
      raise
    end

    def delete(id)
      script = ScriptBuilder.wrap_tell("delete area id \"#{ScriptBuilder.sanitize(id)}\"")
      ThingsScript.runner.execute(script)
      true
    rescue ExecutionError => e
      raise NotFoundError, "Area not found: #{id}" if e.message.include?("Can't get area")
      raise
    end

    def show(id)
      script = ScriptBuilder.wrap_tell("show area id \"#{ScriptBuilder.sanitize(id)}\"")
      ThingsScript.runner.execute(script)
      true
    rescue ExecutionError => e
      raise NotFoundError, "Area not found: #{id}" if e.message.include?("Can't get area")
      raise
    end
  end
end
