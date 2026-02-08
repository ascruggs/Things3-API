module ThingsScript
  module ScriptBuilder
    HELPERS = <<~APPLESCRIPT
      on jsonEscape(str)
        if str is missing value then return "null"
        set str to textReplace(str, "\\\\", "\\\\\\\\")
        set str to textReplace(str, "\\"", "\\\\\\"")
        set str to textReplace(str, return, "\\\\n")
        set str to textReplace(str, linefeed, "\\\\n")
        set str to textReplace(str, tab, "\\\\t")
        return str
      end jsonEscape

      on textReplace(theText, searchString, replacementString)
        set AppleScript's text item delimiters to searchString
        set theItems to every text item of theText
        set AppleScript's text item delimiters to replacementString
        set theText to theItems as text
        set AppleScript's text item delimiters to ""
        return theText
      end textReplace

      on dateToISO(d)
        if d is missing value then return "null"
        set y to year of d
        set m to zeroPad(month of d as integer)
        set dy to zeroPad(day of d)
        set h to zeroPad(hours of d)
        set mi to zeroPad(minutes of d)
        set s to zeroPad(seconds of d)
        return "\\"" & y & "-" & m & "-" & dy & "T" & h & ":" & mi & ":" & s & "\\""
      end dateToISO

      on zeroPad(n)
        if n < 10 then return "0" & n
        return n as text
      end zeroPad

    APPLESCRIPT

    module_function

    def wrap_tell(body)
      "tell application \"Things3\"\n#{body}\nend tell"
    end

    def with_helpers(body)
      "#{HELPERS}\n#{wrap_tell(body)}"
    end

    def sanitize(str)
      str.to_s.gsub("\\", "\\\\\\\\").gsub('"', '\\"')
    end

    def todo_to_json_expr(var)
      <<~APPLESCRIPT.strip
        set tid to id of #{var}
        set tname to my jsonEscape(name of #{var})
        set rawStatus to status of #{var}
        if rawStatus is open then
          set tstatus to "open"
        else if rawStatus is completed then
          set tstatus to "completed"
        else if rawStatus is canceled then
          set tstatus to "canceled"
        else
          set tstatus to "open"
        end if
        set tnotes to my jsonEscape(notes of #{var})
        set ttags to tag names of #{var}
        set j to "{\\"id\\":\\"" & tid & "\\",\\"name\\":\\"" & tname & "\\",\\"status\\":\\"" & tstatus & "\\""
        if tnotes is not "null" and tnotes is not "" then set j to j & ",\\"notes\\":\\"" & tnotes & "\\""
        if ttags is not "" then set j to j & ",\\"tag_names\\":\\"" & my jsonEscape(ttags) & "\\""
        try
          set j to j & ",\\"due_date\\":" & my dateToISO(due date of #{var})
        end try
        try
          set j to j & ",\\"completion_date\\":" & my dateToISO(completion date of #{var})
        end try
        set j to j & ",\\"creation_date\\":" & my dateToISO(creation date of #{var})
        set j to j & ",\\"modification_date\\":" & my dateToISO(modification date of #{var})
        try
          set j to j & ",\\"cancellation_date\\":" & my dateToISO(cancellation date of #{var})
        end try
        try
          set j to j & ",\\"activation_date\\":" & my dateToISO(activation date of #{var})
        end try
        try
          set cname to my jsonEscape(name of contact of #{var})
          if cname is not "null" then set j to j & ",\\"contact\\":\\"" & cname & "\\""
        end try
        try
          set pname to my jsonEscape(name of project of #{var})
          if pname is not "null" then set j to j & ",\\"project\\":\\"" & pname & "\\""
        end try
        try
          set aname to my jsonEscape(name of area of #{var})
          if aname is not "null" then set j to j & ",\\"area\\":\\"" & aname & "\\""
        end try
        set j to j & "}"
      APPLESCRIPT
    end

    def project_to_json_expr(var)
      <<~APPLESCRIPT.strip
        set pid to id of #{var}
        set pname to my jsonEscape(name of #{var})
        set rawStatus to status of #{var}
        if rawStatus is open then
          set pstatus to "open"
        else if rawStatus is completed then
          set pstatus to "completed"
        else if rawStatus is canceled then
          set pstatus to "canceled"
        else
          set pstatus to "open"
        end if
        set pnotes to my jsonEscape(notes of #{var})
        set ptags to tag names of #{var}
        set j to "{\\"id\\":\\"" & pid & "\\",\\"name\\":\\"" & pname & "\\",\\"status\\":\\"" & pstatus & "\\""
        if pnotes is not "null" and pnotes is not "" then set j to j & ",\\"notes\\":\\"" & pnotes & "\\""
        if ptags is not "" then set j to j & ",\\"tag_names\\":\\"" & my jsonEscape(ptags) & "\\""
        try
          set j to j & ",\\"due_date\\":" & my dateToISO(due date of #{var})
        end try
        try
          set j to j & ",\\"completion_date\\":" & my dateToISO(completion date of #{var})
        end try
        set j to j & ",\\"creation_date\\":" & my dateToISO(creation date of #{var})
        set j to j & ",\\"modification_date\\":" & my dateToISO(modification date of #{var})
        try
          set j to j & ",\\"cancellation_date\\":" & my dateToISO(cancellation date of #{var})
        end try
        try
          set j to j & ",\\"activation_date\\":" & my dateToISO(activation date of #{var})
        end try
        try
          set cname to my jsonEscape(name of contact of #{var})
          if cname is not "null" then set j to j & ",\\"contact\\":\\"" & cname & "\\""
        end try
        try
          set aname to my jsonEscape(name of area of #{var})
          if aname is not "null" then set j to j & ",\\"area\\":\\"" & aname & "\\""
        end try
        set j to j & "}"
      APPLESCRIPT
    end

    def area_to_json_expr(var)
      <<~APPLESCRIPT.strip
        set aid to id of #{var}
        set aname to my jsonEscape(name of #{var})
        set atags to tag names of #{var}
        set j to "{\\"id\\":\\"" & aid & "\\",\\"name\\":\\"" & aname & "\\""
        if atags is not "" then set j to j & ",\\"tag_names\\":\\"" & my jsonEscape(atags) & "\\""
        set acol to collapsed of #{var}
        if acol then
          set j to j & ",\\"collapsed\\":true"
        else
          set j to j & ",\\"collapsed\\":false"
        end if
        set j to j & "}"
      APPLESCRIPT
    end
  end
end
