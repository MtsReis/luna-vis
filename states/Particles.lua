class.Particles()

function noteTrack(dt)
  if math.fmod(math.floor(time),5) == 0 then
    luna.adInfo = "----[" .. #tracks .. "]----"
  elseif math.fmod(math.floor(time), 3) == 0 then
    luna.adInfo = luna.adInfo .. "\n"
  end

  for i, q in ipairs(tracks) do
    for j, v in ipairs(q["notes"]) do
      if time >= v["time"] and time - v["time"] <= dt then
          if (instrumentsMap[i] < 6) then
            luna.adInfo = luna.adInfo .. " [" .. v['midi'] .. "] "
            if (instrumentsMap[i] == 1 or instrumentsMap[i] == 5) then
              local angle = instrumentsMap[i] == 5 and v['midi'] or (2*math.pi / highestMidi * v['midi'])
              psystems[instrumentsMap[i]]:setDirection(angle)
            end
            psystems[instrumentsMap[i]]:emit(1)
          end

          v["played"] = time
          v["time"] = 10 ^ 10
      end
    end
  end
end

function Particles:load()
  bdPS = require("particles/bigDots")
  --[[ Glowline ]]
  glowline = {
    src = love.graphics.newImage("assets/images/glowline.png"),
    x = 0,
    y = -400
  }

  json = require "lib/json"
  tremor = 1

  --[[
  1: Guitarra
  2: Baixo
  3: Orgão
  4: Bateria
  5: Especial
  ]]--
  instrumentsMap = {
    2, 2, 4,
    3, 3, 3,
    4, 4,
    1,
    5}

  local f = assert(io.open("midi/d_runni2.json", "rb"))
  midiFile = json:decode(tostring(f:read("*all")))
  f:close()

    tracks = {}
    for i, v in ipairs(midiFile['tracks']) do
        if v['notes'] then
            table.insert(tracks, v)
        end
    end

    lowestMidi = 1000
    highestMidi = 0
    for i, q in ipairs(tracks) do
        for j, v in ipairs(q["notes"]) do
            if v["midi"] > highestMidi then
                highestMidi = v["midi"]
            elseif v["midi"] < lowestMidi then
                lowestMidi = v["midi"]
            end
        end
    end
end

function Particles:close()
end

function Particles:enable()
  canvas = love.graphics.newCanvas(100, 100)

  love.graphics.setCanvas(canvas)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle("fill", 50,50, 50)
  love.graphics.setCanvas()
  canvas:setFilter("linear", "linear")

  psystems = {

  }

  for i = 1, 5 do
    psystems[i] = love.graphics.newParticleSystem(canvas, 500)
    psystems[i]:setDirection(i)
    psystems[i]:setEmissionArea("none", 0, 0, 0, false)
    psystems[i]:setEmissionRate(0)
    psystems[i]:setEmitterLifetime(-1)
    psystems[i]:setInsertMode("top")
    psystems[i]:setLinearAcceleration(0, 0, 0, 0)
    psystems[i]:setLinearDamping(6.6, 8.7)
    psystems[i]:setOffset(50, 50)
    psystems[i]:setParticleLifetime(10, 11 + i)
    psystems[i]:setSizes(0.4)
    psystems[i]:setSizeVariation(0)
    psystems[i]:setSpeed(841, 997)
    psystems[i]:setSpin(0, 0)
    psystems[i]:setSpinVariation(0)
    psystems[i]:setSpread(0.15)
    psystems[i]:setTangentialAcceleration(737, 1400)
  end

  psystems[1]:setColors(1, 1, 1, 1,     0, 0, 0, 0)
  psystems[2]:setColors(.25, 0, 1, 1,   .25, 0, 1, 0)
  psystems[3]:setColors(.5, 0, 1, 1,    .5, 0, 1, 0)
  psystems[4]:setColors(.75, 0, 1, 1,   .75, 0, 1, 0)
  psystems[5]:setColors(0, 0, 0, 1,   0, 0, 0, 0)
  psystems[5]:setTangentialAcceleration(0, 0)
  psystems[5]:setParticleLifetime(4, 5)
end

function Particles:disable()
end

function Particles:update(dt)
  noteTrack(dt)
  local fifthColour = {
    luna.colours[1], luna.colours[2], luna.colours[3], 1,
    luna.colours[1], luna.colours[2], luna.colours[3], 0
  }
  psystems[1]:setColors(unpack(fifthColour))

  for i = 1, #psystems do
    psystems[i]:update(dt)
  end

  glowline.y = glowline.y <= luna.settings.monitorRes.h and glowline.y + dt * 100 or -1600
end

function Particles:draw()
  love.graphics.setCanvas(monitorCanvas)
    love.graphics.setColor(1, 1, 1, 1)
    --[[ Player Background ]]
      love.graphics.draw(playerBg)

      -- Partículas
      for i = #psystems, 1, -1 do
        love.graphics.draw(
          psystems[i],
          luna.settings.monitorRes.w/2,
          luna.settings.monitorRes.h/2, -- Tamanho da barrinha do player
          0,
          luna.settings.video.w / 1366, -- Resolução a qual as partículas foram feitas
          luna.settings.video.h / 768
        )
      end

      --[[ Player Foreground ]]
      love.graphics.draw(playerFg)
      love.graphics.print(player.np, 7 * 4, luna.settings.monitorRes.h - 12 * 4, 0, 2, 1.5)

    love.graphics.setColor(unpack(vis.colours.spectrum))
      -- Desenha spectrum
      vis:spectro_show()

      -- Desenha scanline
      love.graphics.setColor(1, 1, 1, .05)
        love.graphics.draw(glowline.src, glowline.x, glowline.y)
    love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setCanvas()
end

function Particles:keypressed(key)
end
