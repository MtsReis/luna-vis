-- Include some necessary libs
require 'lib/pl'
require 'lib/luafft'
require("lib/stateManager")
require("lib/lovelyMoon")
lip = require 'lib/LIP'
moonshine = require 'lib/moonshine'
tiny = require("lib/tiny")
log = require("lib/log")
pd = pretty.dump
pw = pretty.write
stringx.import()

-- Luna specific config
log.level = "error"

function love.conf(t)
	t.identity = "luna"
	t.version = "11.1"
	t.window.title = "Luna Engine"
	t.externalstorage = true
end
