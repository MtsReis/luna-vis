-- Include all states
require("states/StartSequence")
require("states/Visualizer")

-- Include required modules
require("modules/mInputVerify")
require("modules/mPersistence")
luna = require("modules/mLuna")

if tablex.find(arg, "-debug") then
	luna.debugMode = true
	require("lib/lovedebug")
end

function love.load()
	-- Debug Mode
	if luna.debugMode then
		require("states/Debug")
		addState(DebugMode, "Debug", 10)
		enableState("Debug")
	end

	-- Add the game states for future use
	addState(StartSequence, "StartSequence")
  addState(Visualizer, "Visualizer")

	-- Load the player .cfg files
	Persistence:loadSettings()
	Persistence:loadControls()

	-- Update video with the players settings
	luna:updateVideo()

  -- Initial game state
	enableState("Visualizer")
end

function love.update(dt)
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
