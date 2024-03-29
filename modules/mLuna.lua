local Luna = class()

-- Default settings
local videoW, videoH = love.window.getDesktopDimensions()
Luna.settings = {
	sound = {
		_tweakable = {"sVolume", "mVolume"},
		sVolume = 70,
		mVolume = 80,
	},

	video = {
		_tweakable = {"w", "h", "vsync", "fullscreen"},
		w = videoW,
		h = videoH,
		vsync = true,
		fullscreen = true
	},

  monitorRes = {
    w = 1360,
    h = 1020
  },
  
  misc = {
    _tweakable = {"showMouse"},
    showMouse = true
  }
}
Luna.colours = {0, 0, 0, 1}
Luna.colourTarget = math.random(1,7)

-- Update video settings with the values that player defined
function Luna:updateVideo()
	love.window.setMode(self.settings.video.w, self.settings.video.h, {
		fullscreen = self.settings.video.fullscreen,
		vsync = self.settings.video.vsync
	})

  love.mouse.setVisible( self.settings.misc.showMouse )
end

return Luna
