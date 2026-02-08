module ThingsScript
  module Todos
    module_function

    def all
      script = ScriptBuilder.with_helpers(<<~APPLESCRIPT)
        set todoList to to dos
        set output to "["
        repeat with i from 1 to count of todoList
          set t to item i of todoList
          #{ScriptBuilder.todo_to_json_expr("t")}
          if i > 1 then set output to output & ","
          set output to output & j
        end repeat
        set output to output & "]"
      APPLESCRIPT
      ResponseParser.parse_array(ThingsScript.runner.execute(script))
    end

    def find(id)
      script = ScriptBuilder.with_helpers(<<~APPLESCRIPT)
        set t to to do id "#{ScriptBuilder.sanitize(id)}"
        #{ScriptBuilder.todo_to_json_expr("t")}
      APPLESCRIPT
      result = ThingsScript.runner.execute(script)
      ResponseParser.parse(result) || raise(NotFoundError, "To-do not found: #{id}")
    rescue ExecutionError => e
      raise NotFoundError, "To-do not found: #{id}" if e.message.include?("Can't get to do")
      raise
    end

    def in_list(list_name)
      script = ScriptBuilder.with_helpers(<<~APPLESCRIPT)
        set todoList to to dos of list "#{ScriptBuilder.sanitize(list_name)}"
        set output to "["
        repeat with i from 1 to count of todoList
          set t to item i of todoList
          #{ScriptBuilder.todo_to_json_expr("t")}
          if i > 1 then set output to output & ","
          set output to output & j
        end repeat
        set output to output & "]"
      APPLESCRIPT
      ResponseParser.parse_array(ThingsScript.runner.execute(script))
    end

    def in_project(project_id)
      script = ScriptBuilder.with_helpers(<<~APPLESCRIPT)
        set todoList to to dos of project id "#{ScriptBuilder.sanitize(project_id)}"
        set output to "["
        repeat with i from 1 to count of todoList
          set t to item i of todoList
          #{ScriptBuilder.todo_to_json_expr("t")}
          if i > 1 then set output to output & ","
          set output to output & j
        end repeat
        set output to output & "]"
      APPLESCRIPT
      ResponseParser.parse_array(ThingsScript.runner.execute(script))
    end

    def in_area(area_id)
      script = ScriptBuilder.with_helpers(<<~APPLESCRIPT)
        set todoList to to dos of area id "#{ScriptBuilder.sanitize(area_id)}"
        set output to "["
        repeat with i from 1 to count of todoList
          set t to item i of todoList
          #{ScriptBuilder.todo_to_json_expr("t")}
          if i > 1 then set output to output & ","
          set output to output & j
        end repeat
        set output to output & "]"
      APPLESCRIPT
      ResponseParser.parse_array(ThingsScript.runner.execute(script))
    end

    def selected
      script = ScriptBuilder.with_helpers(<<~APPLESCRIPT)
        set todoList to selected to dos
        set output to "["
        repeat with i from 1 to count of todoList
          set t to item i of todoList
          #{ScriptBuilder.todo_to_json_expr("t")}
          if i > 1 then set output to output & ","
          set output to output & j
        end repeat
        set output to output & "]"
      APPLESCRIPT
      ResponseParser.parse_array(ThingsScript.runner.execute(script))
    end

    def create(params)
      props = build_properties(params)
      body = "set newTodo to make new to do with properties {#{props}}\n"
      if params[:list]
        body += "move newTodo to list \"#{ScriptBuilder.sanitize(params[:list])}\"\n"
      end
      body += "#{ScriptBuilder.todo_to_json_expr('newTodo')}"
      script = ScriptBuilder.with_helpers(body)
      ResponseParser.parse(ThingsScript.runner.execute(script))
    end

    def update(id, params)
      safe_id = ScriptBuilder.sanitize(id)
      lines = []
      lines << "set t to to do id \"#{safe_id}\""
      lines << "set name of t to \"#{ScriptBuilder.sanitize(params[:name])}\"" if params[:name]
      lines << "set notes of t to \"#{ScriptBuilder.sanitize(params[:notes])}\"" if params[:notes]
      lines << "set tag names of t to \"#{ScriptBuilder.sanitize(params[:tag_names])}\"" if params[:tag_names]
      if params[:due_date]
        lines << "set due date of t to date \"#{ScriptBuilder.sanitize(params[:due_date])}\""
      end
      lines << ScriptBuilder.todo_to_json_expr("t")
      script = ScriptBuilder.with_helpers(lines.join("\n"))
      ResponseParser.parse(ThingsScript.runner.execute(script))
    rescue ExecutionError => e
      raise NotFoundError, "To-do not found: #{id}" if e.message.include?("Can't get to do")
      raise
    end

    def delete(id)
      script = ScriptBuilder.wrap_tell("delete to do id \"#{ScriptBuilder.sanitize(id)}\"")
      ThingsScript.runner.execute(script)
      true
    rescue ExecutionError => e
      raise NotFoundError, "To-do not found: #{id}" if e.message.include?("Can't get to do")
      raise
    end

    def move(id, target_list:)
      script = ScriptBuilder.wrap_tell(
        "move to do id \"#{ScriptBuilder.sanitize(id)}\" to list \"#{ScriptBuilder.sanitize(target_list)}\""
      )
      ThingsScript.runner.execute(script)
      true
    rescue ExecutionError => e
      raise NotFoundError, "To-do not found: #{id}" if e.message.include?("Can't get to do")
      raise
    end

    def schedule(id, date_string)
      script = ScriptBuilder.wrap_tell(
        "schedule to do id \"#{ScriptBuilder.sanitize(id)}\" for date \"#{ScriptBuilder.sanitize(date_string)}\""
      )
      ThingsScript.runner.execute(script)
      true
    rescue ExecutionError => e
      raise NotFoundError, "To-do not found: #{id}" if e.message.include?("Can't get to do")
      raise
    end

    def complete(id)
      script = ScriptBuilder.wrap_tell(
        "set status of to do id \"#{ScriptBuilder.sanitize(id)}\" to completed"
      )
      ThingsScript.runner.execute(script)
      true
    rescue ExecutionError => e
      raise NotFoundError, "To-do not found: #{id}" if e.message.include?("Can't get to do")
      raise
    end

    def cancel(id)
      script = ScriptBuilder.wrap_tell(
        "set status of to do id \"#{ScriptBuilder.sanitize(id)}\" to canceled"
      )
      ThingsScript.runner.execute(script)
      true
    rescue ExecutionError => e
      raise NotFoundError, "To-do not found: #{id}" if e.message.include?("Can't get to do")
      raise
    end

    def show(id)
      script = ScriptBuilder.wrap_tell("show to do id \"#{ScriptBuilder.sanitize(id)}\"")
      ThingsScript.runner.execute(script)
      true
    rescue ExecutionError => e
      raise NotFoundError, "To-do not found: #{id}" if e.message.include?("Can't get to do")
      raise
    end

    def edit(id)
      script = ScriptBuilder.wrap_tell("edit to do id \"#{ScriptBuilder.sanitize(id)}\"")
      ThingsScript.runner.execute(script)
      true
    rescue ExecutionError => e
      raise NotFoundError, "To-do not found: #{id}" if e.message.include?("Can't get to do")
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
