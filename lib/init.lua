
-- Class loader
local Origin = {}
function Origin.__index( t, k )
  local f = k:lower():gsub("(_)", "/")
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

setmetatable( _G, Origin )

