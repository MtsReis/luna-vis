local gr = love.graphics
local Shape = class()

Shape.color = {1, 1, 1, 1}
Shape.lineWidth = 3
Shape.lineSize = 2
Shape.size = luna.settings.monitorRes.w/8
Shape.pos = {
  x = luna.settings.monitorRes.w/2,
  y = luna.settings.monitorRes.h/2,
  z = 0
}
Shape.rotate = {
  x = false,
  y = false,
  z = true,
  r = true
}
Shape.speed = {
  x = 0,
  y = 0,
  z = 0
}

local vertices = {
  {
    x = Shape.pos.x - Shape.size, 
    y = Shape.pos.y - Shape.size,
    z = Shape.pos.z - Shape.size
  },
  {
    x = Shape.pos.x + Shape.size, 
    y = Shape.pos.y - Shape.size, 
    z = Shape.pos.z - Shape.size
  },
  {
    x = Shape.pos.x + Shape.size, 
    y = Shape.pos.y + Shape.size, 
    z = Shape.pos.z - Shape.size
  },
  {
    x = Shape.pos.x - Shape.size, 
    y = Shape.pos.y + Shape.size, 
    z = Shape.pos.z - Shape.size
  },
  {
    x = Shape.pos.x - Shape.size, 
    y = Shape.pos.y - Shape.size, 
    z = Shape.pos.z + Shape.size
  },
  {
    x = Shape.pos.x + Shape.size, 
    y = Shape.pos.y - Shape.size, 
    z = Shape.pos.z + Shape.size
  },
  {
    x = Shape.pos.x + Shape.size, 
    y = Shape.pos.y + Shape.size, 
    z = Shape.pos.z + Shape.size
  },
  {
    x = Shape.pos.x - Shape.size, 
    y = Shape.pos.y + Shape.size, 
    z = Shape.pos.z + Shape.size
  }
}

local edges = {
    {1, 2}, {2, 3}, {3, 4}, {4, 1}, -- back face
    {5, 6}, {6, 7}, {7, 8}, {8, 5}, -- front face
    {1, 5}, {2, 6}, {3, 7}, {4, 8} -- connecting sides
};

local iR = {
  w = 700,
  h = 700,
  a = 0
}

local oR = {
  w = 1000,
  h = 1000,
  a = 0
}

function Shape:update(dt)
  local angle = 0

  if (self.rotate.x) then
    -- rotate the cube along the x axis
    angle = dt * self.speed.x * math.pi * 2;
    for i, v in ipairs(vertices) do
      local dy = v.y - Shape.pos.y;
      local dz = v.z - Shape.pos.z;
      local y = dy * math.cos(angle) - dz * math.sin(angle);
      local z = dy * math.sin(angle) + dz * math.cos(angle);
      vertices[i].y = y + Shape.pos.y;
      vertices[i].z = z + Shape.pos.z;
    end

    if (self.rotate.r) then
      iR.a = iR.a - dt
    else
      self.rotate.r = math.random(1, 200) == 1 and true or false
    end
  end

  if (self.rotate.y) then
    -- rotate the cube along the y axis
    angle = dt * self.speed.y * math.pi * 2;
    for i, v in ipairs(vertices) do
      local dx = v.x - Shape.pos.x;
      local dz = v.z - Shape.pos.z;
      local x = dz * math.sin(angle) + dx * math.cos(angle);
      local z = dz * math.cos(angle) - dx * math.sin(angle);
      vertices[i].x = x + Shape.pos.x;
      vertices[i].z = z + Shape.pos.z;
    end

    if (self.rotate.r) then
      oR.a = oR.a + dt
    else
      self.rotate.r = math.random(1, 200) == 1 and true or false
    end
  end

  if (self.rotate.z) then
    -- rotate the cube along the z axis
    angle = dt * self.speed.z * math.pi * 2;
    for i, v in ipairs(vertices) do
      local dx = v.x - Shape.pos.x;
      local dy = v.y - Shape.pos.y;
      local x = dx * math.cos(angle) - dy * math.sin(angle);
      local y = dx * math.sin(angle) + dy * math.cos(angle);
      vertices[i].x = x + Shape.pos.x;
      vertices[i].y = y + Shape.pos.y;
    end
  end
  
  if (not self.rotate.x and not self.rotate.y) then
    self.rotate.r = false
  end
end

function Shape:draw()
  love.graphics.setLineWidth(self.lineWidth)
  for _, edge in ipairs(edges) do
    love.graphics.line(
      vertices[edge[1]].x, vertices[edge[1]].y,
      vertices[edge[2]].x, vertices[edge[2]].y
    )
  end
  
  love.graphics.translate(luna.settings.monitorRes.w/2, luna.settings.monitorRes.h/2)
  love.graphics.rotate(iR.a)
    love.graphics.rectangle("line", -iR.w/2, -iR.h/2, iR.w, iR.h)
    love.graphics.setLineWidth(1)
  love.graphics.origin()
  
  love.graphics.setLineWidth(self.lineWidth/2)
  love.graphics.translate(luna.settings.monitorRes.w/2, luna.settings.monitorRes.h/2)
  love.graphics.rotate(oR.a)
    love.graphics.rectangle("line", -oR.w/2, -oR.h/2, oR.w, oR.h)
    love.graphics.setLineWidth(1)
  love.graphics.origin()
end

return Shape
