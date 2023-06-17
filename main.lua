-- Include all states
require("states/StartSequence")
require("states/Visualizer")
require("states/Particles")
require("states/Background")
require("states/Lights")

-- Include required modules
require("modules/mInputVerify")
require("modules/mPersistence")
luna = require("modules/mLuna")
messenger = require("modules/mMessenger")

if tablex.find(arg, "-debug") then
	luna.debugMode = true
end

function love.load()
  math.randomseed(os.time())
  time = 0
  minute = 1
  beat = {
    intensity = 1,
    frame = false,
    counter = 0,
    stages = {
        {0, 109.7},
        {133.5, 175.7},
        {192, 202},
        {236, 256}
    }
  }

  stages = {
    {0, 110},
    {95, 175},
    {168, 210},
    {203, 262},
    {257, 502}
  }
  
  stageIII = {
    steps = { 7.7, 1.5, 12.5, 7, 0 },
    step = 1,
    timer = 8,
    saturation = 1
  }

  stage = 1
  stageIntensity = 1
  monitorStage = 1
  monitorStageC = 0
  monitorTransition = 0
  monitorMaxTime = 19
  monitorP = 1

	-- Debug Mode
	if luna.debugMode then
		require("states/Debug")
		addState(DebugMode, "Debug", 10)
		enableState("Debug")
	end

  luna.colours = {0, 0, 0, 0}
  luna.adInfo = ""

	-- Load the player .cfg files
	Persistence:loadSettings()
	Persistence:loadControls()

	-- Add the game states for future use
	addState(Background, "Background")
	addState(StartSequence, "StartSequence")
  addState(Visualizer, "Visualizer")
  addState(Particles, "Particles")
  addState(Lights, "Lights")

	-- Update video with the players settings
	luna:updateVideo()

  finalScene = love.graphics.newCanvas(luna.settings.video.w, luna.settings.video.h)
  love.graphics.setCanvas(finalScene)
  love.graphics.clear(0, 0, 0, 1)
  love.graphics.setCanvas()

  enableState("Background")
  enableState("StartSequence")
  enableState("Lights")
end

function love.update(dt)
  beat.frame = false
  beat.intensity = 1
  beat.counter = beat.counter + dt
  time = time + dt
  minute = time > 0 and math.ceil((time + 38)/60) or 1
  monitorStageC = monitorStageC + dt
  
  if (monitorStageC >= monitorMaxTime) then
    monitorStage = monitorStage < 3 and monitorStage + 1 or 1
    monitorStageC = 0
  elseif (monitorStageC >= monitorMaxTime - 1) then
    monitorTransition = monitorMaxTime - monitorStageC
  else
    monitorTransition = 0
  end
  
  if (beat.counter >= .5) then
    beat.counter = beat.counter - .5
    beat.frame = true
  end
  
  for i, v in ipairs(beat.stages) do -- Atualiza intensity e frame se estiver dentro de um stage
    if (time > v[1] and time < v[2]) then
      beat.intensity = 3 - math.pow(4, math.fmod(time, .5))      
      break
    else
      beat.intensity = beat.intensity > 0 and beat.intensity - dt or 0
    end
    
    if (i == #beat.stages) then -- Se verificou todos os stages e não deu break, não é frame vlido
      beat.frame = false
    end
  end

  -- Gerencia stage III
  if (stage == 3 and #stageIII.steps >= stageIII.step + 1) then
    stageIII.timer = stageIII.timer - dt
    
    if (stageIII.timer <= 0) then
      stageIII.step = stageIII.step + 1
      stageIII.timer = stageIII.steps[stageIII.step]
    end
  end

  -- Altera stage
  if time < stages[1][2] then
    stage = 1
  elseif time < stages[2][2] then
    if (stage ~= 2) then
      love.graphics.setCanvas(finalScene)
        love.graphics.clear(0, 0, 0, 1)
        love.graphics.clear(0, 0, 0, 0)
      love.graphics.setCanvas(frame)
        love.graphics.clear(0, 0, 0, 1)
      love.graphics.setCanvas(postShader)
        love.graphics.clear(0, 0, 0, 1)
      love.graphics.setCanvas()
    end

    stage = 2
  elseif time < stages[3][2] then
    stage = 3
  elseif time < stages[4][2] then
    stage = 4
  end

  -- Verifica fim da exibição
  if minute > 5 or minute < 1 then
    minute = 1
    love.event.quit()
  end

  -- Calcula intensidade do stage de acordo com periodo de transição
  if stage < #stages then
    if (time >= stages[stage+1][1]) then
      local timeRange = stages[stage+1][1] - stages[stage][2]
      stageIntensity = timeRange ~= 0 and (time - stages[stage][2]) / timeRange or stageIntensity
    else
      stageIntensity = 1
    end
  end
  
  messenger:update(dt)

	InputVerify:update(dt)
	lovelyMoon.update(dt)
end

function love.draw()
	lovelyMoon.draw()
end

function love.keypressed(key, scancode)
	InputVerify:keypressed(scancode)
end

function love.keyreleased(key, scancode)
	InputVerify:keyreleased(scancode)
end

function love.mousepressed(x, y, button)
	lovelyMoon.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	lovelyMoon.mousereleased(x, y, button)
end

function love.quit()
	Persistence:saveINI() -- luna.settings -> settings.cfg
	Persistence:saveINI(InputVerify.commandList, 'controls.cfg', false)
	return false
end
