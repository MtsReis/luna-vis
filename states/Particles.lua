class.Particles()
function Particles:load()
  bdPS = require("particles/bigDots")
  notes = require("particles/notes")
  shape = require("modules/mShape")
  GoL = require("modules/mGoL")
  
  --[[ Glowline ]]
  glowline = {
    src = love.graphics.newImage("assets/images/glowline.png"),
    x = 0,
    y = -400
  }
  
  speaker = love.graphics.newImage("assets/images/speaker.png")
  gol = GoL(luna.settings.monitorRes.w, luna.settings.monitorRes.h, 20)
  golBg = GoL(luna.settings.monitorRes.w, luna.settings.monitorRes.h, 10)
end

function Particles:close()
end

function Particles:enable()
  psystems = {{},{}}


  --[[ PARTICLES 1]]
  for i = 1, 4 do
    psystems[1][i] = bdPS:clone()
    psystems[1][i]:setParticleLifetime(10, 11 + i)
    psystems[1][i]:setDirection(2*math.pi/4 * i)
    psystems[1][i]:setSpread(.15)
  end

  psystems[1][1]:setColors(1, 1, 1, 1,     0, 0, 0, 0)
  psystems[1][2]:setColors(.25, 0, 1, 1,   .25, 0, 1, 0)
  psystems[1][3]:setColors(.5, 0, 1, 1,    .5, 0, 1, 0)
  psystems[1][4]:setColors(.75, 0, 1, 1,   .75, 0, 1, 0)

  bdPS:setColors(0, 0, 0, 1,   0, 0, 0, 0)
  bdPS:setTangentialAcceleration(0, 0)
  bdPS:setParticleLifetime(4, 5)
  
  gol:setPos(28,10)
  gol:setPos(29,11)
  gol:setPos(30,10)
  gol:setPos(30,11)
  gol:setPos(30,12)
  
  gol:setPos(21,23)
  gol:setPos(22,22)
  gol:setPos(23,22)
  gol:setPos(24,22)
  gol:setPos(21,24)
  
  golBg:setPos(48,60)
  golBg:setPos(49,61)
  golBg:setPos(52,60)
  golBg:setPos(52,61)
  golBg:setPos(50,60)
  golBg:setPos(51,60)
  golBg:setPos(51,62)
  
  golBg:setPos(47,60)
  golBg:setPos(48,61)
  golBg:setPos(51,60)
  golBg:setPos(51,61)
  golBg:setPos(49,60)
  golBg:setPos(50,60)
  golBg:setPos(50,62)
  
  golBg:setPos(62,73)
  golBg:setPos(62,72)
  golBg:setPos(62,72)
  golBg:setPos(62,72)
  golBg:setPos(61,72)
  
  golBg:setPos(108,50)
  golBg:setPos(109,51)
  golBg:setPos(110,50)
  golBg:setPos(110,51)
  golBg:setPos(110,52)
end

function Particles:disable()
end

function Particles:update(dt)
  if (monitorStage == 1) then
    local fifthColour = {
      luna.colours[1], luna.colours[2], luna.colours[3], 1,
      luna.colours[1], luna.colours[2], luna.colours[3], 0
    }

    --[[ PARTICLES 1]]
    if (monitorP == 1) then
      psystems[1][1]:setColors(unpack(fifthColour))

      for i = 1, #psystems[1] do
        psystems[1][i]:setDirection((2*math.pi/4 * i) - time)
        if (math.fmod(math.floor(time), 10) == 0) then
          psystems[1][i]:setEmissionRate(math.random(1, 8))
        end
        psystems[1][i]:update(dt)
      end
    end
  end
  
  if (monitorStage == 2) then
    shape.lineWidth = shape.lineWidth + dt * .1
    
    if (shape.rotate.x) then
      shape.speed.x = math.floor(math.sin(time)) == 0 and math.random(-1, 1) * .1 or shape.speed.x
    end
    shape.rotate.x = math.floor(math.sin(time)) == -1 and true or false
    
    if (shape.rotate.y) then
      shape.speed.y = math.floor(math.cos(time)) == 0 and math.random(-1, 1) * .1 or shape.speed.y
    end
    shape.rotate.y = math.floor(math.cos(time)) == -1 and true or false

    shape.speed.z = math.sin(time * .1) * .05
    shape:update(dt)
  end
  
  if (monitorStage == 3) then
    gol:update(dt)
    golBg:update(dt)
  end
  
  for i, v in ipairs(notes) do
    if (beat.frame) then
      v.system:emit(math.random(0, 1))
    end
    v.system:update(dt)
  end
  
  if (beat.frame) then -- Garante uma nota por batida
    notes[math.random(1, #notes)].system:emit(1)
  end
  
  bdPS:update(dt)

  glowline.y = glowline.y <= luna.settings.monitorRes.h and glowline.y + dt * 100 or -1600
end

function Particles:draw()
  love.graphics.setCanvas(monitorCanvas)
    love.graphics.setColor(1, 1, 1, 1)
    --[[ Player Background ]]
      love.graphics.draw(playerBg)

      -- Partículas      
      --[[ EFEITOS ]]
      if (monitorTransition > 0) then
        love.graphics.setColor(1, 1, 1, monitorTransition)
        
        if (monitorTransition < .5) then
          love.graphics.setColor(1, 1, 1, math.sin(monitorTransition*100) * monitorTransition)
        end
      end
      --[[ PARTICLES 1 ]]
      if (monitorStage == 1) then
        --[[ PARTICLES 1]]
        if (monitorP == 1) then
          love.graphics.draw(
            bdPS,
              luna.settings.monitorRes.w/2,
              luna.settings.monitorRes.h/2, -- Tamanho da barrinha do player
              0,
              luna.settings.video.w / 1366, -- Resolução a qual as partículas foram feitas
              luna.settings.video.h / 768
          )

          for i = #psystems[1], 1, -1 do
            love.graphics.draw(
              psystems[1][i],
              luna.settings.monitorRes.w/2,
              luna.settings.monitorRes.h/2, -- Tamanho da barrinha do player
              0,
              luna.settings.video.w / 1366, -- Resolução a qual as partículas foram feitas
              luna.settings.video.h / 768
            )
          end
        end
      end
      
      if (monitorStage == 2) then
        shape:draw()
      end
      
      if (monitorStage == 3) then
        local cr, cg, cb, ca = love.graphics.getColor()
        love.graphics.setColor(cr * .5, cg * .5, cb * .5, ca)
          golBg:draw()
        love.graphics.setColor(cr, cg, cb, ca)
        gol:draw()
      end

      --[[ BATIDA ]]
      love.graphics.setColor(1, 1, 1, beat.intensity-.6)
        love.graphics.setBlendMode("add")
          love.graphics.draw(
            speaker,
            luna.settings.monitorRes.w - 176,
            luna.settings.monitorRes.h - 120,
            0,
            1.5, 1.5)
          
          for i, v in ipairs(notes) do
            love.graphics.draw(
              v.system,
              luna.settings.monitorRes.w - 168,
              luna.settings.monitorRes.h - 112,
              0,
              1, 1)
          end
        love.graphics.setBlendMode("alpha")
      love.graphics.setColor(1, 1, 1, 1)

      --[[ Player Foreground ]]
      love.graphics.draw(playerFg)
      -- Now Player
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
