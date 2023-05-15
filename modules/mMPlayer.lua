local Player = class()

-- Default settings
Player.files = love.filesystem.getDirectoryItems('music')
Player.sel = 1
Player.np = Player.files[Player.sel]
Player.soundData = love.sound.newSoundData('music/'..Player.np)
Player.sound = love.audio.newSource(Player.soundData)

function Player:playMusic()
  self.np = self.files[self.sel]
	self.soundData = love.sound.newSoundData('music/'..self.np)
	self.sound = love.audio.newSource(self.soundData)
  self.sound:setVolume(luna.settings.sound.mVolume)

	self.sound:play()
end

function Player:next()
	self.sel = self.sel < #self.files and self.sel+1 or 1
  self.sound:stop()
  self:playMusic()
end

function Player:prev()
	self.sel = self.sel > 1 and self.sel-1 or #self.files
  self.sound:stop()
  self:playMusic()
end

return Player
