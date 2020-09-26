local line = {}
line.__index = line

windowerSettings = windower.get_windower_settings()

config = {}
config.y = "40%"
config.x = 0
config.visible = true
config.font = "Arial"
config.size = 25
config.red = 255
config.green = 255
config.blue = 193
config.background = {}
config.background.visible = true
config.background.alpha = 100
config.background.color = {}
config.background.color.red = 20
config.background.color.blue = 20
config.background.color.green = 20
config.fadeInTime = 0.05
config.fadeOutTime = 0.25

function line:init()
   lib:dbg("Initiating, alpha is now " .. config.background.alpha)
   local object = {}
   setmetatable(object, line)
   local text = texts.new(config)
   text:size(config.size)
   text:color(config.red, config.green, config.blue)
   local bgColor = config.background.color
   text:bg_color(bgColor.red, bgColor.green, bgColor.blue)
   local yPos = ensureCoord(config.y)
   text:pos(0, yPos)
   text:alpha(0)
   text:bg_alpha(0)
   text:show()
   object.text = text
   object.config = config
   return object
end

function line:setColor(color, container)
   container = self.text
   container:color(color.red, color.green, color.blue)
end

function line:setBgColor(color)
   container = self.text
   container:bg_color(color.red, color.green, color.blue)
end

function line:displayMessage(message)
   self:setMessage(message)
   coroutine.schedule(function() self:fadeIn() end, 0.05)
end

function line:setMessage(message)
   container = self.text
   container:text(" " .. message .. " ")
   coroutine.schedule(function() self:center() end, 0.02)
end

function line:center()
   lib:dbg("centering")
   local xRes = windowerSettings.x_res
   local xResUi = windowerSettings.ui_x_res
   local scale = xRes / xResUi
   local width, _ = self.text:extents()
   lib:dbg("Width: " .. tostring(width))
   local xPos = math.floor(xRes/2 - width/2 * scale)
   lib:dbg("X position: " .. tostring(xPos))
   container = self.text
   container:pos(xPos, container:pos_y())
end

function line:setAlpha(alpha)
   container = self.text
   container:bg_alpha(alpha)
   container:alpha(alpha)
end

function line:fadeIn()
   container = self.text
   if self.config.fadeInTime > 0 then
      local ratio, currentAlpha = 0, 0
      local startTime = os.clock()
      while currentAlpha < 255 do
         coroutine.sleep(0.002)
         ratio = (os.clock() - startTime) / self.config.fadeInTime
         if ratio > 0.99 then currentAlpha = 255 else currentAlpha = 255 * ratio end
         container:alpha(currentAlpha)
         container:bg_alpha(config.background.alpha * ratio)
      end
   end
   container:alpha(255)
   container:bg_alpha(config.background.alpha)
end

function line:fadeOut()
   container = self.text
   if self.config.fadeOutTime > 0 then
      local ratio, currentAlpha = 1.0, container:alpha()
      local startTime = os.clock()
      while currentAlpha > 0 do
         coroutine.sleep(0.002)
         ratio = 1 - (os.clock() - startTime) / self.config.fadeOutTime
         if ratio < 0.01 then currentAlpha = 0 else currentAlpha = 255 * ratio end
         container:alpha(currentAlpha)
         container:bg_alpha(self.config.background.alpha * ratio)
      end
   end
   container:alpha(0)
   container:bg_alpha(0)
end

function ensureCoord(y)
   lib:dbg("Ensuring coordinate")
   if type(y) == "string" then
      return calculatePercentage(y)
   else
      return y
   end
end

function calculatePercentage(yPercentage)
   lib:dbg("Calculating percentage")
   if string.sub(yPercentage, -1, -1) == "%" then
      lib:dbg("calculating ratio")
      local ratio = tonumber(string.sub(yPercentage, 0, -2)) / 100
      return windowerSettings.y_res * ratio
   else
      print("Error: Y position must be a string percentage value or an integer absolute value")
   end
end

return line
