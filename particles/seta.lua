local seta = love.graphics.newImage("assets/images/arrow.png")
seta:setFilter("linear", "linear")

local bgPs = love.graphics.newParticleSystem(seta, 336)
bgPs:setColors(
  .46, 0, 1, 0,
  .07, .07, 1, 1,
  .40, 0, 1, .5,
  .45, 0, 1, 0,
  .0, .40, 1, .5,
  .0, .40, 1, 0
)
bgPs:setDirection(0)
bgPs:setEmissionArea("none", 0, 0, 0, false)
bgPs:setEmissionRate(20)
bgPs:setEmitterLifetime(-1)
bgPs:setInsertMode("random")
bgPs:setLinearAcceleration(-4.13, -2.5, 4.13, 2.5)
bgPs:setLinearDamping(0, 0)
bgPs:setOffset(50, 25.5)
bgPs:setParticleLifetime(1.8, 16)
bgPs:setRadialAcceleration(0, 0)
bgPs:setRelativeRotation(true)
bgPs:setRotation(0, 0)
bgPs:setSizes(0.05, 0.56)
bgPs:setSizeVariation(1)
bgPs:setSpeed(0.51, 81.02)
bgPs:setSpin(0, 0)
bgPs:setSpinVariation(0)
bgPs:setSpread(6.29)
bgPs:setTangentialAcceleration(0, 0)
  
return bgPs