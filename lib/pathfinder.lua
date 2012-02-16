-- Implementation of A* Heuristic Path Finding

PathFinder = {}

local insert = table.insert
local abs = math.abs
local remove = table.remove
local pairs = pairs
local floor = math.floor
local concat = table.concat

local TIMEOUT = 128

local function dist( startx, starty, currx, curry, targx, targy )
  local dx1, dy1 = currx - targx, curry - targy
  local dx2, dy2 = startx - targx, starty - targy
  local cross = abs(dx1*dy2 - dx2*dy1)
  return (abs(targx-currx) + abs(targy-curry)) * (1+(cross*0.001))
end

local function lochash(x, y)
  return (y * 1000 + x)
end

local function buildPath( target, parent, dir )
  local backpath = {}
  while target do
    insert(backpath, dir[target])
    target = parent[target]
  end
  local N = #backpath
  local m = floor(N/2)
  for i = 1, m do
    backpath[i], backpath[N-i+1] = backpath[N-i+1], backpath[i]
  end
  return concat(backpath)
end

local function sortPriorityQueue( q, f )
  table.sort(q, function( a, b )
    return (f[a] > f[b])
  end)
end

function PathFinder.getPath( sprite, tx, ty, map )
  local sx, sy = floor(sprite.x), floor(sprite.y)
  tx, ty = floor(tx), floor(ty)
  local startID, targetID = lochash(sx, sy), lochash(tx, ty)
  local startDist = dist(sx, sy, sx, sy, tx, ty)
  local cap = startDist * 5
  local known, closed, f, g, h, x, y = {}, {}, {}, {}, {}, {}, {}
  local parent, dir = {}, {}
  local openqueue = {}
  local opennodes, nodecount, nodetimeout = 1, 0, TIMEOUT
  local adjlist = {{0, -1, 'N'}, {0, 1, 'S'}, {-1, 0, 'W'}, {1, 0, 'E'}}

  known[startID], x[startID], y[startID] = true, sx, sy
  g[startID], h[startID], f[startID] = 0, startDist, startDist
  openqueue[1] = startID

  while opennodes > 0 do
    opennodes, nodecount = opennodes - 1, nodecount + 1
    local bestID = remove( openqueue )
    if bestID == targetID then
      return buildPath(bestID, parent, dir)
    end
    local qchanges = false
    local wasClosed = closed[bestID]
    closed[bestID] = true
    if (not wasClosed) and (g[bestID] < cap) then
      local bestX, bestY = x[bestID], y[bestID]
      local nextG = g[bestID] + 1
      for _, v in ipairs( adjlist ) do
        local nx, ny, nd = bestX+v[1], bestY+v[2], v[3]
        local id = lochash(nx, ny)
        if not closed[id] then
          if not known[id] then
            if sprite:blockedAt( nx, ny ) then
              known[id], closed[id] = true, true
            else
              opennodes = opennodes + 1
              known[id] = true
              x[id], y[id] = nx, ny
              g[id], h[id] = nextG, dist(sx, sy, nx, ny, tx, ty)
              f[id] = g[id] + h[id]
              parent[id], dir[id] = bestID, nd
              insert(openqueue, id)
              qchanges = true
            end
          elseif nextG < g[id] then
            parent[id], dir[id] = bestID, nd
            g[id], f[id] = nextG, h[id] + nextG
            qchanges = true
          end
        end
      end
    end
    if qchanges then sortPriorityQueue( openqueue, f ) end
    if nodecount >= nodetimeout then
      nodetimeout = nodetimeout + TIMEOUT
      if coroutine.running() then coroutine.yield() end
    end
  end
  print( "Unable to find path after search", nodecount )
  return nil
end

