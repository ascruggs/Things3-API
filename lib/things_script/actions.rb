module ThingsScript
  module Actions
    module_function

    def empty_trash
      script = ScriptBuilder.wrap_tell("empty trash")
      ThingsScript.runner.execute(script)
      true
    end

    def log_completed
      script = ScriptBuilder.wrap_tell("log completed now")
      ThingsScript.runner.execute(script)
      true
    end

    def quick_entry(params = {})
      if params[:name] || params[:notes]
        props = []
        props << "name:\"#{ScriptBuilder.sanitize(params[:name])}\"" if params[:name]
        props << "notes:\"#{ScriptBuilder.sanitize(params[:notes])}\"" if params[:notes]
        script = ScriptBuilder.wrap_tell("show quick entry panel with properties {#{props.join(', ')}}")
      elsif params[:autofill]
        script = ScriptBuilder.wrap_tell("show quick entry panel with autofill yes")
      else
        script = ScriptBuilder.wrap_tell("show quick entry panel")
      end
      ThingsScript.runner.execute(script)
      true
    end
  end
end
