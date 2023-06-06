local LG        = love.graphics

local image1 = LG.newImage("assets/images/lineGradient.png")
image1:setFilter("linear", "linear")


local ps = love.graphics.newParticleSystem(image1, 185)
ps:setColors(
  1, 0, 0, 1,

  0, 1, 0, 1,

  0, 0, 1, 1,
  
  1, 1, 1, 0
)
ps:setDirection(0)
ps:setEmissionArea("uniform", 400, 400, 0, false)
ps:setEmissionRate(80)
ps:setEmitterLifetime(-1)
ps:setInsertMode("top")
ps:setLinearAcceleration(15, -12, -250, 24)
ps:setLinearDamping(0, 0)
ps:setOffset(50, 2)
ps:setParticleLifetime(3, 4)
ps:setRadialAcceleration(0, 0)
ps:setRelativeRotation(false)
ps:setRotation(0, 0)
ps:setSizes(0.80000001192093)
ps:setSizeVariation(0)
ps:setSpeed(0, 0)
ps:setSpin(0, 0)
ps:setSpinVariation(0)
ps:setSpread(0)
ps:setTangentialAcceleration(0, 0)
-- At draw time:
-- love.graphics.setBlendMode("add")
-- love.graphics.draw(ps, 450-200, 18+0)


return ps
