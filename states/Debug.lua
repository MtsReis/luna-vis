class.DebugMode()

function DebugMode:load()
  local pc = {
    w = luna.settings.monitorRes.w/100,
    h = luna.settings.monitorRes.h/100
  }
	-- Include debug libraries
	--lovebird = require("lib/lovebird")
	fpsGraph = require "lib/FPSGraph"

	-- Create informative graph
	Info1 = fpsGraph.createGraph(5*pc.w, 74*pc.h)
	Info2 = fpsGraph.createGraph(5*pc.w, 78*pc.h)
	Info3 = fpsGraph.createGraph(5*pc.w, 82*pc.h)
  Info4 = fpsGraph.createGraph(0, 10*pc.h)
	fpsInfo = fpsGraph.createGraph(5*pc.w, 66*pc.h)
	memoryInfo = fpsGraph.createGraph(5*pc.w, 70*pc.h)

	-- Engine settings for Debug Mode
	log.level = "trace"
end

function DebugMode:close()
end

function DebugMode:enable()
end

function DebugMode:disable()
	log.info("Debug Mode [OFF]")
end

function DebugMode:update(dt)
	fpsGraph.updateFPS(fpsInfo, dt)
	fpsGraph.updateMem(memoryInfo, dt)
  
  fpsGraph.updateGraph(Info1, luna.colours[1] * 255, "Red: " .. math.floor(luna.colours[1] * 255) .. " - (" .. luna.colourTarget .. ")", dt)
  fpsGraph.updateGraph(Info2, luna.colours[2] * 255, "Green: " .. math.floor(luna.colours[2] * 255), dt)
  fpsGraph.updateGraph(Info3, luna.colours[3] * 255, "Blue: " .. math.floor(luna.colours[3] * 255), dt)
  fpsGraph.updateGraph(Info4, 1, luna.adInfo, dt)

	if (not luna.debugMode) then
		disableState("Debug")
	end
end

function DebugMode:draw()
  love.graphics.setCanvas(monitorCanvas)

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
  love.graphics.setColor(1, 1, 1, 0)
	fpsGraph.drawGraphs({Info4})

  love.graphics.setCanvas()
end

function DebugMode:keypressed(key)
	if key == "console" then
			_DebugInterface.openConsole()
	end
end
