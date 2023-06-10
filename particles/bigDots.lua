local LG        = love.graphics

local image1 = LG.newImage("assets/images/circle.png")
image1:setFilter("linear", "linear")

local ps = LG.newParticleSystem(image1, 75)
ps:setColors(1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0.5, 1, 1, 1, 0)
ps:setDirection(-1.5707963705063)
ps:setEmissionArea("none", 0, 0, 0, false)
ps:setEmissionRate(2)
ps:setEmitterLifetime(-1)
ps:setInsertMode("top")
ps:setLinearAcceleration(0, 0, 0, 0)
ps:setLinearDamping(6.6880340576172, 8.7474613189697)
ps:setOffset(50, 50)
ps:setParticleLifetime(10.207310676575, 11.73007774353)
ps:setRadialAcceleration(0, 0)
ps:setRelativeRotation(false)
ps:setRotation(0, 0)
ps:setSizes(0.40000000596046, 0.63178646564484)
ps:setSizeVariation(0.49201276898384)
ps:setSpeed(841.26611328125, 997.07049560547)
ps:setSpin(0, 0)
ps:setSpinVariation(0)
ps:setSpread(math.pi*2)
ps:setTangentialAcceleration(737.47821044922, 1494.4522705078)

return ps
