-- Translate Löve inputs into valid engine commands
class.InputVerify()

InputVerify.commandList = {
	keyboard = {
		["`"] = "console",
    ["i"] = "nextTrack",
    ["u"] = "prevTrack",
    ["y"] = "nextVis",
    ["s"] = "screenshot"
	}
}

InputVerify.holdingKeys = {}

function InputVerify:keypressed(key)
	if self.commandList.keyboard[key] ~= nil then
		self.holdingKeys[key] = self.commandList.keyboard[key]
		lovelyMoon.keypressed(self.commandList.keyboard[key])
	end
end

function InputVerify:keyreleased(key)
	if self.commandList.keyboard[key] ~= nil then
		self.holdingKeys[key] = nil
		lovelyMoon.keyreleased(self.commandList.keyboard[key])
	end
end

function InputVerify:update(key)
	for key, command in pairs(self.holdingKeys) do
		lovelyMoon.keyhold(command)
	end
end
