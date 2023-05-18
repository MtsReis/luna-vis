class.DebugMode()

function DebugMode:load()
	-- Include debug libraries
	lovebird = require("lib/lovebird")
	fpsGraph = require "lib/FPSGraph"

	-- Create informative graph
	Info1 = fpsGraph.createGraph(0, 60)
	Info2 = fpsGraph.createGraph(0, 90)
	Info3 = fpsGraph.createGraph(0, 120)
	fpsInfo = fpsGraph.createGraph()
	memoryInfo = fpsGraph.createGraph(0, 30)

	-- Engine settings for Debug Mode
	_DebugInterface.DrawOnTop = true
	log.level = "trace"

	log.info("Debug Mode [ON]")
end

function DebugMode:close()
end

function DebugMode:enable()
end

function DebugMode:disable()
	log.info("Debug Mode [OFF]")
end

function DebugMode:update(dt)
	lovebird.update(dt)

	fpsGraph.updateFPS(fpsInfo, dt)
	fpsGraph.updateMem(memoryInfo, dt)
  
  fpsGraph.updateGraph(Info1, luna.colours[1] * 255, "Red: " .. math.floor(luna.colours[1] * 255) .. " - (" .. luna.colourTarget .. ")", dt)
  fpsGraph.updateGraph(Info2, luna.colours[2] * 255, "Green: " .. math.floor(luna.colours[2] * 255), dt)
  fpsGraph.updateGraph(Info3, luna.colours[3] * 255, "Blue: " .. math.floor(luna.colours[3] * 255), dt)

	if (not luna.debugMode) then
		disableState("Debug")
	end
end

function DebugMode:draw()
	love.graphics.setColor(255, 0, 0, 255)
	fpsGraph.drawGraphs({fpsInfo})
	love.graphics.setColor(10, 200, 255, 255)
	fpsGraph.drawGraphs({memoryInfo})
	love.graphics.setColor(255, 0, 0, 255)
	fpsGraph.drawGraphs({Info1})
	love.graphics.setColor(0, 255, 0, 255)
	fpsGraph.drawGraphs({Info2})
	love.graphics.setColor(0, 0, 255, 255)
	fpsGraph.drawGraphs({Info3})
end

function DebugMode:keypressed(key)
	if key == "console" then
			_DebugInterface.openConsole()
	end
end
