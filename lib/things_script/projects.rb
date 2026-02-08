module ThingsScript
  module Projects
    module_function

    def all
      script = ScriptBuilder.with_helpers(<<~APPLESCRIPT)
        set projList to projects
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
    end

    def find(id)
      script = ScriptBuilder.with_helpers(<<~APPLESCRIPT)
        set p to project id "#{ScriptBuilder.sanitize(id)}"
        #{ScriptBuilder.project_to_json_expr("p")}
      APPLESCRIPT
      result = ThingsScript.runner.execute(script)
      ResponseParser.parse(result) || raise(NotFoundError, "Project not found: #{id}")
    rescue ExecutionError => e
      raise NotFoundError, "Project not found: #{id}" if e.message.include?("Can't get project")
      raise
    end

    def todos(id)
      Todos.in_project(id)
    end

    def create(params)
      props = build_properties(params)
      body = "set newProj to make new project with properties {#{props}}\n"
      body += ScriptBuilder.project_to_json_expr("newProj")
      script = ScriptBuilder.with_helpers(body)
      ResponseParser.parse(ThingsScript.runner.execute(script))
    end

    def update(id, params)
      safe_id = ScriptBuilder.sanitize(id)
      lines = []
      lines << "set p to project id \"#{safe_id}\""
      lines << "set name of p to \"#{ScriptBuilder.sanitize(params[:name])}\"" if params[:name]
      lines << "set notes of p to \"#{ScriptBuilder.sanitize(params[:notes])}\"" if params[:notes]
      lines << "set tag names of p to \"#{ScriptBuilder.sanitize(params[:tag_names])}\"" if params[:tag_names]
      if params[:due_date]
        lines << "set due date of p to date \"#{ScriptBuilder.sanitize(params[:due_date])}\""
      end
      lines << ScriptBuilder.project_to_json_expr("p")
      script = ScriptBuilder.with_helpers(lines.join("\n"))
      ResponseParser.parse(ThingsScript.runner.execute(script))
    rescue ExecutionError => e
      raise NotFoundError, "Project not found: #{id}" if e.message.include?("Can't get project")
      raise
    end

    def delete(id)
      script = ScriptBuilder.wrap_tell("delete project id \"#{ScriptBuilder.sanitize(id)}\"")
      ThingsScript.runner.execute(script)
      true
    rescue ExecutionError => e
      raise NotFoundError, "Project not found: #{id}" if e.message.include?("Can't get project")
      raise
    end

    def complete(id)
      script = ScriptBuilder.wrap_tell(
        "set status of project id \"#{ScriptBuilder.sanitize(id)}\" to completed"
      )
      ThingsScript.runner.execute(script)
      true
    rescue ExecutionError => e
      raise NotFoundError, "Project not found: #{id}" if e.message.include?("Can't get project")
      raise
    end

    def show(id)
      script = ScriptBuilder.wrap_tell("show project id \"#{ScriptBuilder.sanitize(id)}\"")
      ThingsScript.runner.execute(script)
      true
    rescue ExecutionError => e
      raise NotFoundError, "Project not found: #{id}" if e.message.include?("Can't get project")
      raise
    end

    def build_properties(params)
      props = []
      props << "name:\"#{ScriptBuilder.sanitize(params[:name])}\"" if params[:name]
      props << "notes:\"#{ScriptBuilder.sanitize(params[:notes])}\"" if params[:notes]
      props << "tag names:\"#{ScriptBuilder.sanitize(params[:tag_names])}\"" if params[:tag_names]
      props << "due date:date \"#{ScriptBuilder.sanitize(params[:due_date])}\"" if params[:due_date]
      props.join(", ")
    end
    private_class_method :build_properties
  end
end
