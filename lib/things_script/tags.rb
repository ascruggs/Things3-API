module ThingsScript
  module Tags
    module_function

    def all
      script = ScriptBuilder.with_helpers(<<~APPLESCRIPT)
        set tagList to tags
        set output to "["
        repeat with i from 1 to count of tagList
          set t to item i of tagList
          set tid to name of t
          set tname to my jsonEscape(name of t)
          set j to "{\\"name\\":\\"" & tname & "\\""
          try
            set ptag to my jsonEscape(name of parent tag of t)
            if ptag is not "null" then set j to j & ",\\"parent_tag\\":\\"" & ptag & "\\""
          end try
          set j to j & "}"
          if i > 1 then set output to output & ","
          set output to output & j
        end repeat
        set output to output & "]"
      APPLESCRIPT
      ResponseParser.parse_array(ThingsScript.runner.execute(script))
    end

    def create(name, parent_tag: nil)
      props = "name:\"#{ScriptBuilder.sanitize(name)}\""
      if parent_tag
        props += ", parent tag:tag \"#{ScriptBuilder.sanitize(parent_tag)}\""
      end
      script = ScriptBuilder.wrap_tell("make new tag with properties {#{props}}")
      ThingsScript.runner.execute(script)
      { name: name, parent_tag: parent_tag }.compact
    end

    def delete(name)
      script = ScriptBuilder.wrap_tell("delete tag \"#{ScriptBuilder.sanitize(name)}\"")
      ThingsScript.runner.execute(script)
      true
    rescue ExecutionError => e
      raise NotFoundError, "Tag not found: #{name}" if e.message.include?("Can't get tag")
      raise
    end
  end
end
