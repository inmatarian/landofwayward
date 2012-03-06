
Animator = class()
Animator.FREEZE = "freeze"

local weakInstanceTable = setmetatable({}, {_mode="k"})

function Animator.updateAll(dt)
  for k, _ in pairs(weakInstanceTable) do
    k:update(dt)
  end
end

function Animator:init( frames, pattern )
  weakInstanceTable[self]=true

  self.frames = frames or {}
  if pattern then
    self.pattern = pattern
  elseif frames["default"] then
    self.pattern = "default"
  end
  self.index = 1
  self.clock = 0
end

function Animator:addPattern( name, pattern )
  self.frames[name] = pattern
end

function Animator:setPattern( name )
  if self.pattern ~= name then
    self.pattern = name
    self.index = 1
    self.clock = 0
  end
end

function Animator:resetPattern( name )
  self.pattern = nil
  self:setPattern(name)
end

function Animator:tryPattern( name )
  if self.frames[name] then self:setPattern(name) end
end

function Animator:update(dt)
  if not self.pattern then return end
  self.clock = self.clock + dt
  local length = self.frames[self.pattern][self.index][2]
  if length == self.FREEZE then return end
  while self.clock >= length do
    self.clock = self.clock - length
    self.index = self.index + 1
    if self.index > #self.frames[self.pattern] then
      self.index = 1
    end
  end
end

function Animator:current()
  if not self.pattern then return 0 end
  return self.frames[self.pattern][self.index][1]
end

