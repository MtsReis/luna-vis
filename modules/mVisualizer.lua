local gr = love.graphics
local Visualizer = class()

local Size = 612
local AMPLIFY = 2

-- Default settings
Visualizer.colours = {
  grid = {55, 155, 155, 256},
  spectrum = {0, 1, 0, 256},
  target = 1
}
Visualizer.spectrum = nil
Visualizer.line = true
Visualizer.fr = 8

Visualizer.screen = luna.settings.video
Visualizer.scale = { x = math.ceil(6*Visualizer.screen.w/Size), y = 900 }
Visualizer.win = { x=0, y=0, w=Visualizer.screen.w, h=Visualizer.screen.h }

Visualizer.vertices = {}

function Visualizer:pickColour(dt)
  local rgb = self.colours.spectrum
  local target = self.colours.target
  local nextTarget = true
  local rate = 0.1
  
  for k = 3, 1, -1 do
    local key = math.pow(2, k-1)
    local lastTarget = target

    target = target - key

    if (target >= 0) then -- Cor permitida
      if (rgb[k] < 1) then
        rgb[k] = rgb[k] + dt * rate
        nextTarget = false
      end
    else -- Cor não inclusa
      if (rgb[k] > 0) then
        rgb[k] = rgb[k] - dt * rate
        nextTarget = false
      end
    end
    
    target = target < 0 and lastTarget or target -- Reseta target inicial se esta subtr remove td
  end
  
  self.colours.spectrum = rgb

  if (nextTarget) then
    self.colours.target = self.colours.target < 7 and self.colours.target + 1 or 1
  end
  
  luna.colours = rgb
  luna.colourTarget = self.colours.target
end

function Visualizer:updateVertices()
  self.vertices = {}
  local freqCutoff = #self.spectrum/self.fr/1.31

  for i = 1, #self.spectrum/self.fr do
		local freq  = self.spectrum[i]:abs()

		if self.scale.y*freq > self.win.h/2 then self.scale.y = (self.win.h/2)/freq end
		if self.line then
			--gr.rectangle('fill',
      --  self.win.w*math.log(i)/6+self.win.x,
      --  self.screen.h - AMPLIFY * freq*math.log(i) - self.win.y,
      --  2,
      --  AMPLIFY * freq*math.log(i)
      --)
      self.fr=2
      if (i < freqCutoff) then
        local vertexCoord = {x = AMPLIFY * freq*math.log(i), y = self.win.h/freqCutoff*i}
        table.insert(self.vertices, vertexCoord)
      --[[else
        local vertexCoord = {self.screen.w - AMPLIFY * freq*math.log(i), self.win.h/freqCutoff*(i - freqCutoff),}
        table.insert(self.vertices, vertexCoord)]]
      end
    end
  end
end

function Visualizer:spectro_show()
  gr.setColor(unpack(self.colours.spectrum))

  for i = 1, #self.vertices do
    if self.line and self.vertices[i+1] then
      gr.line(
        self.vertices[i].x,
        self.vertices[i].y,
        self.vertices[i+1].x,
        self.vertices[i+1].y
      )
    end
  end
end

return Visualizer
