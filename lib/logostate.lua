
----------------------------------------

local function shuffleTable( t )
  for i = #t, 2, -1 do
    local j = math.random(1, i)
    t[i], t[j] = t[j], t[i]
  end
end

----------------------------------------

LogoState = class()

function LogoState:init()
  self.list = {}
  for y = 0, 14 do
    for x = 0, 19 do
      table.insert(self.list, {x=x, y=y, vis=false})
    end
  end
  shuffleTable(self.list)

  self.textVis = false

  self.co = coroutine.create( self.run )
  coroutine.resume(self.co, self)
end

function LogoState:update(dt)
  if coroutine.status(self.co) ~= "dead" then
    local err, mesg = coroutine.resume(self.co, dt)
    if err == false then error(msg) end
  else
    Waygame:popState()
  end
end

function LogoState:wait( secs )
  local dt = 0
  while dt < secs do
    dt = dt + coroutine.yield()
  end
end

-- Coroutine Thread
function LogoState:run()
  local count = 0
  for i = 1, #self.list do
    self.list[i].vis = true
    count = (count + 1) % 25
    if count == 0 then self:wait(1/30) end
  end
  self:wait(0.25)
  self.textVis = true
  self:wait(1.75)
  count = 0
  for i = #self.list, 1, -1 do
    self.list[i].vis = false
    count = (count + 1) % 35
    if count == 0 then self:wait(1/30) end
  end
  self:wait(0.5)
end

function LogoState:draw()
  for _, v in pairs(self.list) do
    if v.vis then
      Graphics.drawTile( v.x*16, v.y*16, 60 )
    end
  end
  if self.textVis then
    Graphics.text( "center", "center", WHITE, "Planet Badness" )
  end
end

