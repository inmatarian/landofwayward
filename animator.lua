
require "class"

Animator = class()

function Animator:init( frames )
  self.frames = frames or {}
  self.pattern = nil
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

function Animator:update(dt)
  if not self.pattern then return end
  self.clock = self.clock + dt
  local length = self.frames[self.pattern][self.index][2]
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

