local LG = love.graphics

local image1 = LG.newImage("assets/images/lineGradient.png")
image1:setFilter("linear", "linear")

local ps = love.graphics.newParticleSystem(image1, 185)
ps:setColors(
  1, 0, 0, 1,

  0, 1, 0, 1,

  0, 0, 1, 1,
  
  1, 1, 1, 0
)
ps:setEmissionArea("uniform", 400, 400, 0, false)
ps:setEmissionRate(50)
ps:setEmitterLifetime(-1)
ps:setInsertMode("top")
ps:setLinearAcceleration(15, -12, -250, 24)
ps:setOffset(50, 2)
ps:setParticleLifetime(3, 4)

return ps
