
ExplorerState = class {}

do
  local LENGTH = 0.05
  ExplorerState.ammoFrames = {
    default = { { SpriteCode.AMMO4, Animator.FREEZE } },
    newammo = {
      { SpriteCode.AMMO1, LENGTH },
      { SpriteCode.AMMO2, LENGTH },
      { SpriteCode.AMMO4, LENGTH },
      { SpriteCode.AMMO3, LENGTH },
      { SpriteCode.AMMO4, Animator.FREEZE },
    }
  }
end

function ExplorerState:init()
  self.hp = 1
  self.id = "maps/testboard.tmx"
  self.map = Map("maps/testboard.tmx")
  local px, py = self.map:locateEntity(EntityCode.SYLVIA)
  px, py = px or 1, py or 1
  self.player = Player( px, py )
  self.player:setGamestate(self)
  self.camera = Camera(self.player)
  self.map:addSprite(self.player)
  self:loadThings()
  self.camera:setBounds( 0, 0, self.map.width, self.map.height )
  self.ammoAnim = Animator( self.ammoFrames )
  collectgarbage()
end

function ExplorerState:loadThings()
  for y = 0, self.map.height do
    for x = 0, self.map.width do
      local code = self.map:getEntity( x, y )
      local factory = self.entityFactory[code]
      if factory then
        local id = Util.hash( self.id, x, y )
        if not Waygame.deadItems[id] then
          local thing = factory(self, x, y, id)
          self.map:addSprite(thing)
          thing:setGamestate(self)
        end
      end
    end
  end
end

do
  local factory = {}
  factory[EntityCode.AMMO] = function(self, x, y, id) return Ammo(x, y, id) end;
  factory[EntityCode.HEALTH] = function(self, x, y, id) return Health(x, y, id) end;
  factory[EntityCode.RUFFIAN] = function(self, x, y, id) return RuffianEnemy(x, y, id) end;
  factory[EntityCode.TIGER] = function(self, x, y, id) return TigerEnemy(x, y, id) end;
  factory[EntityCode.SNAKE] = function(self, x, y, id) return SnakeEnemy(x, y, id) end;
  factory[EntityCode.BEAR] = function(self, x, y, id) return BearEnemy(x, y, id) end;
  factory[EntityCode.GHOST] = function(self, x, y, id) return GhostEnemy(x, y, id) end;
  factory[EntityCode.EYE] = function(self, x, y, id) return EyeEnemy(x, y, id) end;
  factory[EntityCode.DRAGON] = function(self, x, y, id) return DragonEnemy(x, y, id) end;
  factory[EntityCode.SPIDER] = function(self, x, y, id) return SpiderEnemy(x, y, id) end;
  ExplorerState.entityFactory = factory
end

function ExplorerState:draw()
  Graphics:resetColor()
  local cam = self.camera
  self.map:draw(cam)

  self:drawAmmo()
  self:drawHealth()

  if Waygame.debug then
    local pl = self.player
    Graphics:text( 0, 0, Palette.WHITE,
      string.format("PLY P(%.2f,%.2f) X(%.2f,%.2f) T(%i,%i)",
        pl.x, pl.y, pl.xexcess, pl.yexcess, pl.xtarget, pl.ytarget) )
    local vx, vy = cam:screenTranslate( pl.x, pl.y )
    Graphics:text( 0, 8, Palette.WHITE,
      string.format("CAM P(%.2f,Y%.2f) S(X%.2f,Y%.2f)", cam.x, cam.y, vx, vy) )
  end
end

function ExplorerState:drawAmmo()
  local amax = Waygame.ammoMax
  if amax == 0 then return end
  local ammo = Waygame.ammo
  local x = (math.floor(Graphics.gameWidth / 2.0)-8)-(8*(amax-1))
  local y = Graphics.gameHeight - 24

  local i = 1
  if ammo > 0 then
    while i<=(ammo-1) do
      Graphics:drawSprite( x, y, SpriteCode.AMMO4 )
      i, x = i + 1, x + 16
    end

    Graphics:drawSprite( x, y, self.ammoAnim:current() )
    i, x = i + 1, x + 16
  end

  while i<=amax do
    Graphics:drawSprite( x, y, SpriteCode.AMMO0 )
    i, x = i + 1, x + 16
  end
end

function ExplorerState:drawHealth()
  local x, y = 2, Graphics.gameHeight - 9
  local hp = math.max(0, math.min(math.floor(self.hp), 100))
  local full = math.floor(hp/5)
  local half = ((hp-full*5) >= 2) and true or false
  local i = 0
  while i < full do
    Graphics:drawSprite( x, y, SpriteCode.GREENBAR )
    x, i = x + 5, i + 1
  end
  if half then
    Graphics:drawSprite( x, y, SpriteCode.HALFBAR )
    x, i = x + 5, i + 1
  end
  while i < 20 do
    Graphics:drawSprite( x, y, SpriteCode.EMPTYBAR )
    x, i = x + 5, i + 1
  end
end

function ExplorerState:update(dt)
  if Input.menu:isClicked() or Input.pause:isClicked() then
    Waygame:pushState( PauseState() )
  else
    self.map:update(dt)
    self.camera:update(dt)
    self:updateAmmo(dt)
  end
  self.hp = self.hp + dt * 5
  if self.hp > 125 then self.hp = 0 end
end

function ExplorerState:updateAmmo(dt)
  local W = Waygame
  if W.ammo < W.ammoMax then
    W.ammoRecover = W.ammoRecover + ( dt / 2.5 )
    if W.ammoRecover >= 1.0 then
      W.ammo = W.ammo + 1
      self.ammoAnim:resetPattern("newammo")
      if W.ammo < W.ammoMax then
        W.ammoRecover = W.ammoRecover - 1.0
      else
        W.ammoRecover = 0
      end
    end
  end
  self.ammoAnim:update(dt)
end

function ExplorerState:fadeIn( speed, callback )
  Waygame:pushState( FadeState( 0.0, 1.0, speed or 0.5, callback ) )
end

function ExplorerState:fadeOut( speed, callback )
  Waygame:pushState( FadeState( 1.0, 0.0, speed or -0.5, callback ) )
end

function ExplorerState:handleSign(ent)
  if self.signTable and self.signTable[ent] then
    Waygame:pushState( SignState(self.signTable[ent]) )
  end
end

