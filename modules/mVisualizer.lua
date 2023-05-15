local gr = love.graphics
local Visualizer = class()

local Size = 1024

-- Default settings
Visualizer.colours = {
  grid = {55, 155, 155, 256},
  spectrum = {0, 1, 0, 256},
  target = 1
}
Visualizer.spectrum = nil
Visualizer.line = false
Visualizer.fr = 8

Visualizer.screen = luna.settings.video
Visualizer.scale = { x = math.ceil(6*Visualizer.screen.w/Size), y = 900 }
Visualizer.win = { x=(Visualizer.screen.w-Visualizer.scale.x*Size/8)/2, y=Visualizer.screen.h/10, w=Visualizer.scale.x*Size/8, h=Visualizer.screen.h-Visualizer.screen.h/5 }

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
    else -- Cor não incluída
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
  
  fpsGraph.updateGraph(Info1, rgb[1] * 255, "Red: " .. math.floor(rgb[1] * 255) .. " - (" .. self.colours.target .. ")", dt)
  fpsGraph.updateGraph(Info2, rgb[2] * 255, "Green: " .. math.floor(rgb[2] * 255), dt)
  fpsGraph.updateGraph(Info3, rgb[3] * 255, "Blue: " .. math.floor(rgb[3] * 255), dt)
end

function Visualizer:drawGrid(np)
  gr.setColor(unpack(self.colours.grid))
	gr.rectangle( 'line', self.win.x, self.win.y, self.win.w, self.win.h )
	gr.print(np, self.win.x, self.win.h + self.win.y + 20)
  
  local st = 4000/176.4	-- magic numbers
	for i=1,5 do x = self.scale.x * i * st + self.win.x gr.line( x, self.win.y, x, self.win.y + self.win.h ) end
  
  gr.setColor(unpack(self.colours.spectrum))
end

function Visualizer:spectro_show()
	for i = 1, #self.spectrum/self.fr do
		local freq  = self.spectrum[i]:abs()
		local freq2 = self.spectrum[i+1]:abs()
		if self.scale.y*freq > self.win.h/2 then self.scale.y = (self.win.h/2)/freq end
		if self.line then
			gr.rectangle('fill',self.win.w*math.log(i)/6.3+self.win.x, self.screen.h-2*self.scale.y*freq-self.win.y,  2, 2*self.scale.y*freq)
			self.fr=2
			gr.line( self.win.w*math.log(i)/6.3+self.win.x, self.screen.h-2*self.scale.y*freq-self.win.y,self.win.w*math.log(i+1)/6.3+self.win.x,self.screen.h-2*self.scale.y*freq2-self.win.y )
    else
			self.fr=8
			gr.ellipse( 'line', i* self.scale.x+self.win.x, self.screen.h/2,  self.scale.x/6, -self.scale.y*freq )
			--gr.ellipse( 'line', 100*math.log(i)+win.x, screen.h/2,  2, -scale.y*freq )
    end
  end
end

return Visualizer
