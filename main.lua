
----------------------------------------
-- Class loader

Origin = {}

function Origin.__index( t, k )
  local f = k:lower()
  if love.filesystem.isFile(f..".lua") then
    print( "Require", f )
    require( f )
    return rawget(_G, k)
  elseif love.filesystem.isFile("lib/"..f..".lua") then
    print( "Require lib", f )
    require( "lib/"..f )
    return rawget(_G, k)
  end
end

----------------------------------------

function love.run()

  setmetatable( _G, Origin )

  local love = love
  local dt = 0
  local eventTrans = {
    kp = "keypressed",
    kr = "keyreleased",
    q = "quit",
    f = "focus"
  }

  local game = Wayward()

  while true do
    love.timer.step()
    dt = love.timer.getDelta()
    if dt > 0.1 then dt = 0.1 end

    game:update(dt)

    love.graphics.clear()
    game:draw()

    for event, a, b, c in love.event.poll() do
      local evname = eventTrans[event]
      local ret
      if evname and game[evname] then ret = game[evname](game, a, b, c) end
      if evname == "quit" and not ret then
        love.audio.stop()
        return
      end
    end

    love.timer.sleep(1)
    love.graphics.present()
  end
end

