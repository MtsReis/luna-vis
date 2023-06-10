local Messenger = class()

-- Default settings
local monitorMessage = require('assets/message')
local lastLB = 0
local maxLB = 90
local maxCharsPerLine = 300
local messageLen = string.len(monitorMessage)
local messageIndex = 1
local timer = {
  char = {max = .05, c = 0},
  line = {max = .8, c = 0},
  reset = {max = 4, c = 0}
}

local function messageLeft()
  return messageIndex < messageLen
end

local function addLB()
  luna.adInfo = luna.adInfo .. "\n"
  lastLB = #luna.adInfo
end
  
local function resetMessage()
  -- Reinicia transmissão
  if (not messageLeft()) then
    messageIndex = 1
    timer.reset.c = 0
  end

  local header = messageIndex <= 1 and "INITIATING TRANSMISSION" or messageIndex
  luna.adInfo = "----[" .. header .. "]----\n"
  lastLB = #luna.adInfo
end

function Messenger:print()
  local _, lbCount = string.gsub(luna.adInfo, "\n", "")
  if (lbCount < maxLB and messageLeft()) then
    
    for i = 1, maxCharsPerLine/6 do
      local dieSides = math.sin(lbCount * math.pi / (maxLB-1)) * 100
      if (math.random(1, dieSides) == 1 and messageLeft()) then -- Chances seguindo padrão senoidal invertido
        local _, lbCount = string.gsub(luna.adInfo, "\n", "")

        local byteInfo = ""
        luna.adInfo = luna.adInfo .. " [" .. monitorMessage:sub(messageIndex, messageIndex):byte() .. "] "
        messageIndex = messageIndex + 1
      
        local lineCharCount = #luna.adInfo - lastLB

        if (lineCharCount >= maxCharsPerLine) then
          luna.adInfo = luna.adInfo .. "\n"
          lastLB = #luna.adInfo
        end
      elseif (luna.adInfo:sub(-1) ~= " " and math.random(1, 30) == 1 and lbCount > 1 and lbCount < maxLB) then
          luna.adInfo = luna.adInfo .. "\n"
          lastLB = #luna.adInfo
      end
    end
    
    luna.adInfo = luna.adInfo .. "\n"
    lastLB = #luna.adInfo
  end
end

function Messenger:update(dt)
  -- Atualiza timers
  for k, v in pairs(timer) do
    timer[k].c = v.c + dt
  end

  if (timer.line.c > timer.line.max) then
    addLB()
    timer.line.c = 0
  end
  
  if (timer.char.c > timer.char.max) then
    self.print()
    timer.char.c = 0
  end

  if (timer.reset.c > timer.reset.max) then
    resetMessage()
    timer.reset.c = 0
  end
end

return Messenger
