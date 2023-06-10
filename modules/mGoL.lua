local GoL = class()

function GoL:_init(w, h, s)
  self.world = {}
  self.w = w/s
  self.h = h/s
  self.xOffset = 40
  self.yOffset = 40
  self.timer = 0
  self.intervals = .4
  
  self.scale = s

  for i = 1, w do
    local row = {}
    for j = 1, h do
      row[j] = 0
    end
    self.world[i] = row
  end
end

function GoL:setPos(x,y)
  self.world[x][y] = 1
end

function GoL:unsetPos(x,y)
  self.world[x][y] = 0
end

function GoL:nextGen()
  local X = tablex.deepcopy(self.world)
  for i = 1, self.w do
    for j = 1, self.h do
      local s = 0
      for p = i-1,i+1 do
        for q = j-1,j+1 do
          if p > 0 and p <= self.w and q > 0 and q <= self.h then
            s = s + self.world[p][q]
          end
        end
      end
      s = s - self.world[i][j]
      if s == 3 or (s+self.world[i][j]) == 3 then
        X[i][j] = 1
      else
        X[i][j] = 0
      end
    end
  end
  
  self.world = tablex.deepcopy(X)
end


function GoL:update(dt)
  self.timer = self.timer + dt
  
  if (self.timer >= self.intervals) then
    self:nextGen()
    self.timer = self.timer - self.intervals
  end
end

function GoL:draw()
  for i = 1, self.w do
    for j = 1, self.h do
      if (self.world[i][j] == 1) then
        love.graphics.rectangle(
          "fill",
          i * (self.scale) + self.xOffset, j * (self.scale) + self.yOffset,
          self.scale, self.scale
        )
      end
    end
  end
end

return GoL
