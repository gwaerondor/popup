_addon.name = "popup"
_addon.author = "gwaeron"
_addon.version = "0.0.1"
_addon.language = "English"
_addon.command = "popup"

config = require("config")
texts = require("texts")
lib = require("lib")
line = require("line")

debug = false
local textLine

event = function(...)
   local args = T{...}
   local command
   lib:dbg("Full command: " .. table.concat(args, " "))
   if args[1] then
      command = args[1]
   end
   table.remove(args, 1)
   remainder = table.concat(args, " ")
   lib:dbg("Command: " .. command .. (remainder == "" and "" or "\nRemainder: " .. remainder))
   if command == "display" then
      lib:dbg("Displaying message: " .. remainder)
      textLine:displayMessage(remainder)
   elseif command == "hide" then
      textLine:fadeOut()
   elseif command == "msg" then
      windower.send_command("popup display " .. table.concat(args, " ") .. "; wait " .. textLine:getDisplayTime() .. "; popup hide")
   else
      print("Unknown command: " .. args[1])
   end
end

windower.register_event("load", function() textLine = line:init() end)

windower.register_event("addon command", event)
