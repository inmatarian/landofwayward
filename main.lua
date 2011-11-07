
require "lib/init"

function love.run()

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
        Waygame:shutdown()
        love.audio.stop()
        return
      end
    end

    love.timer.sleep(1)
    love.graphics.present()
  end
end

