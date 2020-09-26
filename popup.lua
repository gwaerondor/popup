_addon.name = "popup"
_addon.author = "gwaeron"
_addon.version = "0.0.1"
_addon.language = "English"
_addon.command = "popup"

config = require("config")
texts = require("texts")

debug = true

windowerSettings = windower.get_windower_settings()

text = {}
text.y = "40%"
text.x = 0
text.visible = true
text.font = "Arial"
text.size = 25
text.red = 255
text.green = 255
text.blue = 193
text.bg = {}
text.bg.visible = true
text.bg.alpha = 150
text.bg.color = {}
text.bg.color.red = 20
text.bg.color.blue = 20
text.bg.color.green = 20
text.fadeInTime = 0.05
text.fadeOutTime = 0.25

local lastUpdate
local container

function setMessage(message)
   container:text(message)
   coroutine.schedule(center, 0.02)
end

function fadeIn()
   if text.fadeInTime > 0 then
      local ratio, currentAlpha = 0, 0
      local startTime = os.clock()
      while currentAlpha < 255 do
         ratio = (os.clock() - startTime) / text.fadeInTime
         if ratio > 0.99 then currentAlpha = 255 else currentAlpha = 255 * ratio end
         setAlpha(container, currentAlpha)
      end
   else
      setAlpha(container, 255)
   end
end

function fadeOut()
   if text.fadeOutTime > 0 then
      local ratio, currentAlpha = 1.0, container:alpha()
      local startTime = os.clock()
      while currentAlpha > 0 do
         ratio = 1 - (os.clock() - startTime) / text.fadeOutTime
         if ratio < 0.01 then currentAlpha = 0 else currentAlpha = 255 * ratio end
         setAlpha(container, currentAlpha)
      end
   else
      setAlpha(container, 0)
   end
end

function setAlpha(box, alpha)
   container:bg_alpha(alpha)
   container:alpha(alpha)
end

function center()
   local xRes = windowerSettings.x_res
   local xResUi = windowerSettings.ui_x_res
   local scale = xRes / xResUi
   local width, _ = container:extents()
   dbg("Width: " .. tostring(width))
   local xPos = math.floor(xRes/2 - width/2 * scale)
   dbg("X position: " .. tostring(xPos))
   container:pos(xPos, ensureCoord(text.y))
end

function ensureCoord(y)
   if type(y) == "string" then
      return calculatePercentage(y)
   else
      return y
   end
end

function calculatePercentage(yPercentage)
   if string.sub(yPercentage, -1, -1) == "%" then
      print("calculating ratio")
      local ratio = tonumber(string.sub(yPercentage, 0, -2)) / 100
      return windowerSettings.y_res * ratio
   else
      print("Error: Y position must be a string percentage value or an integer absolute value")
   end
end

event = function(...)
   local args = T{...}
   local command
   dbg("Full command: " .. table.concat(args, " "))
   if args[1] then
      command = args[1]
   end
   table.remove(args, 1)
   remainder = table.concat(args, " ")
   dbg("Command: " .. command .. (remainder == "" and "" or "\nRemainder: " .. remainder))
   if command == "display" then
      print("Displaying message: " .. remainder)
      setMessage(remainder)
      coroutine.schedule(fadeIn, 0.05)
   elseif command == "hide" then
      fadeOut()
   elseif command == "msg" then
      windower.send_command("popup display " .. table.concat(args, " ") .. "; wait 2; popup hide")
   else
      print("Unknown command: " .. args[1])
   end
end

function init(box)
   box = texts.new(text)
   box:size(text.size)
   box:color(text.red, text.green, text.blue)
   yPos = ensureCoord(text.y)
   box:pos(0, yPos)
   box:alpha(0)
   box:bg_alpha(0)
   box:show()
   return box
end

function dbg(msg)
   if debug then print(msg) end
end

windower.register_event("addon command", event)
windower.register_event("load", function() container = init(container) end)
