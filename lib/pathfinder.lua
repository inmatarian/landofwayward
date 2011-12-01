-- Implementation of A* Heuristic Path Finding

PathFinder = {}

local insert = table.insert
local abs = math.abs
local remove = table.remove
local pairs = pairs
local floor = math.floor
local concat = table.concat

local function dist( startx, starty, currx, curry, targx, targy )
  local dx1, dy1 = currx - targx, curry - targy
  local dx2, dy2 = startx - targx, starty - targy
  local cross = abs(dx1*dy2 - dx2*dy1)
  return (abs(targx-currx) + abs(targy-curry)) * (1+(cross*0.001))
end

local function lochash(x, y)
  return (y * 1000 + x)
end

local function Node(x, y, id, parentid, g, h, d, open, closed)
  return { id=id, parentid=parentid, x=x, y=y, f=g+h, g=g, h=h, d=d, open=open or true, closed=closed or false }
end

local function updateNode( node, newG )
  node.g, node.f = newG, node.h + newG
end

local function cmpNodes( a, b )
  return (a.f > b.f)
end

local function getBestNode( open )
  local best
  for _, node in pairs(open) do
    if not best or node.f < best.f then best = node end
  end
  return best
end

local function blockedAt(x, y, map)
  local ent = map:getEntity( x, y )
  return ent == EntityCode.BLOCK
end

local function adjacentLocations( x, y, map )
  local list = {}
  if not blockedAt(x-1, y, map) then insert(list, {x-1, y, 'W'}) end
  if not blockedAt(x+1, y, map) then insert(list, {x+1, y, 'E'}) end
  if not blockedAt(x, y-1, map) then insert(list, {x, y-1, 'N'}) end
  if not blockedAt(x, y+1, map) then insert(list, {x, y+1, 'S'}) end
  return list
end

local function buildPath( target, lookup )
  local backpath = {}
  local id, last
  while target do
    insert(backpath, target.d)
    id = target.parentid
    if id then target = lookup[id] else target = nil end
  end
  local N = #backpath
  if backpath[#backpath]=="I" then remove(backpath); N = N - 1 end
  local m = floor(N/2)
  for i = 1, m do
    backpath[i], backpath[N-i+1] = backpath[N-i+1], backpath[i]
  end
  return concat(backpath)
end

function PathFinder.getPath( sx, sy, tx, ty, map )
  sx, sy, tx, ty = floor(sx), floor(sy), floor(tx), floor(ty)
  local startID, targetID = lochash(sx, sy), lochash(tx, ty)
  local originalDist = dist(sx, sy, sx, sy, tx, ty)
  local startNode = Node(sx, sy, startID, nil, 0, originalDist, "I")
  local cap = originalDist * 5
  local open, lookup = {}, {}
  local opennodes, nodecount = 1, 0
  open[startID] = startNode
  lookup[startID] = startNode

  while opennodes >= 1 do
    local bestNode = getBestNode(open)
    nodecount, opennodes = nodecount + 1, opennodes - 1
    open[bestNode.id] = nil
    if bestNode.id == targetID then
      return buildPath(bestNode, lookup)
    end
    bestNode.closed, bestNode.open = true, false
    local g = bestNode.g + 1
    for _, v in pairs( adjacentLocations( bestNode.x, bestNode.y, map ) ) do
      local x, y, dir = v[1], v[2], v[3]
      local id = lochash(x, y)
      local node = lookup[id]
      if not node then
        node = Node(x, y, id, bestNode.id, g, dist(sx, sy, x, y, tx, ty), dir)
        lookup[id] = node
        open[id] = node
        opennodes = opennodes + 1
      elseif node.open and (g < node.g) then
        node.parentid = bestNode.id
        node.g = g
        node.f = node.h + g
        node.d = dir
      end
      if node.f > cap then
        node.closed, node.open = true, false
      end
    end
  end
  return nil
end

