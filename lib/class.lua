
local function classcall(class, ...)
  local inst = setmetatable({}, class)
  inst:init(...)
  return inst
end

local masterclass = {}

function masterclass.init() end

function masterclass:subclass( prototype )
  prototype = prototype or {}
  prototype.__index = prototype
  prototype_mt = {}
  prototype_mt.__index = self
  prototype_mt.__call = classcall
  return setmetatable(prototype, prototype_mt)
end

function masterclass:super()
  return getmetatable(self).__index
end

function masterclass:superinit(obj, ...)
  return self:super().init(obj, ...)
end

class = setmetatable({}, {
  __call = function( f, prototype )
    return masterclass:subclass( prototype )
  end
})

