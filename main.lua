
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

local waygame

function love.load()
  Runaway.init()
  waygame = Wayward()
end

function love.keypressed(k, u)
  waygame:keypressed(k, u)
end

function love.keyreleased(k, u)
  waygame:keyreleased(k, u)
end

function love.focus(f)
  waygame:focus(f)
end

function love.quit()
  waygame:shutdown()
end

function love.draw()
  waygame:draw()
end

function love.update(dt)
  if dt > 0.1 then dt = 0.1 end
  waygame:update(dt)
end

