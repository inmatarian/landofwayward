
local function classcall(class, ...)
  local inst = {}
  setmetatable(inst, inst)
  inst.__index = class
  if inst.init then inst:init(...) end
  return inst
end

local masterclass = {}

function masterclass:subclass( prototype )
  prototype = prototype or {}
  prototype.__index = self
  prototype.__call = classcall
  return setmetatable(prototype, prototype)
end

function masterclass:superinit(obj, ...)
  self.__index.init(obj, ...)
end

function class( prototype )
  return masterclass:subclass( prototype )
end

