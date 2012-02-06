
require "lib/init"

local Runaway = {}

function Runaway.init()
  Runaway.reset()
  -- debug.sethook( Runaway.hook, "l" )
end

function Runaway.reset()
  Runaway.lines = 0
  Runaway.warning = 1000000
end

function Runaway.hook( event )
  if event == "line" then Runaway.lines = Runaway.lines + 1 end
  if Runaway.lines >= Runaway.warning then
    print( "Script running away, executed:", debuglines )
    Runaway.warning = Runaway.warning * 5
  end
  if Runaway.lines >= 1000000 then
    error( "Runaway script" )
  end
end

------------------------------------------------------------

function love.run()
  Runaway.init()

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
    Runaway.reset()
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
        Waygame:shutdown()
        love.audio.stop()
        return
      end
    end

    love.timer.sleep(1)
    love.graphics.present()
  end
end

