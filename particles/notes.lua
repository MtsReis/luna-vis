--[[
module = {
	x=emitterPositionX, y=emitterPositionY,
	[1] = {
		system=particleSystem1,
		kickStartSteps=steps1, kickStartDt=dt1, emitAtStart=count1,
		blendMode=blendMode1, shader=shader1,
		texturePreset=preset1, texturePath=path1,
		shaderPath=path1, shaderFilename=filename1,
		x=emitterOffsetX, y=emitterOffsetY
	},
	[2] = {
		system=particleSystem2,
		...
	},
	...
}
]]
local LG        = love.graphics
local particles = {x=0, y=0}

local image1 = LG.newImage("assets/images/note1.png")
image1:setFilter("linear", "linear")
local image2 = LG.newImage("assets/images/note2.png")
image2:setFilter("linear", "linear")
local image3 = LG.newImage("assets/images/note3.png")
image3:setFilter("linear", "linear")

local ps = LG.newParticleSystem(image1, 5)
ps:setColors(1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0.5, 1, 1, 1, 0)
ps:setDirection(-2.35)
ps:setEmissionArea("none", 0, 0, 0, false)
ps:setEmissionRate(0)
ps:setEmitterLifetime(-1)
ps:setInsertMode("random")
ps:setLinearAcceleration(0, 0, 0, 0)
ps:setLinearDamping(1, 3.4)
ps:setOffset(16, 16)
ps:setParticleLifetime(1, 1)
ps:setRadialAcceleration(0, -50)
ps:setRelativeRotation(false)
ps:setRotation(0.82, -0.52)
ps:setSizes(0.40, 0.85)
ps:setSizeVariation(0)
ps:setSpeed(100, 150)
ps:setSpin(0, 0)
ps:setSpinVariation(0)
ps:setSpread(1.65)
ps:setTangentialAcceleration(0, -140)
table.insert(particles, {system=ps, kickStartSteps=0, kickStartDt=0, emitAtStart=3, blendMode="add", shader=nil, texturePath="note1.png", texturePreset="", shaderPath="", shaderFilename="", x=0, y=0})

local ps = LG.newParticleSystem(image2, 5)
ps:setColors(1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0.50, 1, 1, 1, 0)
ps:setDirection(-2.35)
ps:setEmissionArea("none", 0, 0, 0, false)
ps:setEmissionRate(0)
ps:setEmitterLifetime(-1)
ps:setInsertMode("random")
ps:setLinearAcceleration(0, 0, 0, 0)
ps:setLinearDamping(1, 3.40)
ps:setOffset(16, 16)
ps:setParticleLifetime(1, 1)
ps:setRadialAcceleration(0, -50)
ps:setRelativeRotation(false)
ps:setRotation(0.82, -0.52)
ps:setSizes(0.25, 0.85)
ps:setSizeVariation(0.50)
ps:setSpeed(100, 150)
ps:setSpin(0, 0)
ps:setSpinVariation(0)
ps:setSpread(1.65)
ps:setTangentialAcceleration(0, -140)
table.insert(particles, {system=ps, kickStartSteps=0, kickStartDt=0, emitAtStart=3, blendMode="add", shader=nil, texturePath="note2.png", texturePreset="", shaderPath="", shaderFilename="", x=0, y=0})

local ps = LG.newParticleSystem(image3, 5)
ps:setColors(1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0.50, 1, 1, 1, 0)
ps:setDirection(-2.35)
ps:setEmissionArea("none", 0, 0, 0, false)
ps:setEmissionRate(0)
ps:setEmitterLifetime(-1)
ps:setInsertMode("random")
ps:setLinearAcceleration(0, 0, 0, 0)
ps:setLinearDamping(1, 3.40)
ps:setOffset(16, 18)
ps:setParticleLifetime(1, 1)
ps:setRadialAcceleration(0, -50)
ps:setRelativeRotation(false)
ps:setRotation(0.82, -0.52)
ps:setSizes(0.25, 0.45)
ps:setSizeVariation(0.50)
ps:setSpeed(100, 150)
ps:setSpin(0, 0)
ps:setSpinVariation(0)
ps:setSpread(1.65)
ps:setTangentialAcceleration(0, -140)
table.insert(particles, {system=ps, kickStartSteps=0, kickStartDt=0, emitAtStart=3, blendMode="add", shader=nil, texturePath="note3.png", texturePreset="", shaderPath="", shaderFilename="", x=0, y=0})

return particles
