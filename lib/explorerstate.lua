
ExplorerState = class()

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
  self.map = Map("maps/testboard.tmx")
  local px, py = self.map:locateEntity(EntityCode.SYLVIA)
  px, py = px or 1, py or 1
  self.player = Player( px, py )
  self.camera = Camera(self.player)
  self.map:addSprite(self.player)
  self:loadThings()
  self.camera:setBounds( 0, 0, self.map.width, self.map.height )
  self.ammoAnim = Animator( self.ammoFrames )
end

function ExplorerState:loadThings()
  for y = 0, self.map.height do
    for x = 0, self.map.width do
      local code = self.map:getEntity( x, y )
      local factory = self.entityFactory[code]
      if factory then self.map:addSprite( factory(self, x, y) ) end
    end
  end
end

do
  local factory = {}
  factory[EntityCode.AMMO] = function(self, x, y) return Ammo(x, y) end;
  factory[EntityCode.HEALTH] = function(self, x, y) return Health(x, y) end;
  ExplorerState.entityFactory = factory
end

function ExplorerState:draw()
  love.graphics.setColor( WHITE )
  local cam = self.camera
  self.map:draw(cam)

  self:drawAmmo()

  -- debug
  local pl = self.player
  Graphics:text( 0, 0, WHITE, string.format("PLY P(%.2f,%.2f) X(%.2f,%.2f) T(%i,%i)", pl.x, pl.y, pl.xexcess, pl.yexcess, pl.xtarget, pl.ytarget) )
  local vx, vy = cam:screenTranslate( pl.x, pl.y )
  Graphics:text( 0, 8, WHITE, string.format("CAM P(%.2f,Y%.2f) S(X%.2f,Y%.2f)", cam.x, cam.y, vx, vy) )
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

function ExplorerState:update(dt)
  local key = Waygame.keypress
  if key["escape"]==1 then
    collectgarbage()
    local count = 0
    for i, v in pairs(Sprite.weakSpritesTable) do count = count + 1 end
    print( "Living sprites", count, "Ammo", Waygame.ammo )
    Waygame:popState()
  end
  if key["p"]==1 then Waygame:pushState( PauseState() ) end
  self.map:update(dt)
  self.camera:update(dt)
  self:updateAmmo(dt)
end

function ExplorerState:updateAmmo(dt)
  local W = Waygame
  if W.ammo < W.ammoMax then
    W.ammoRecover = W.ammoRecover + dt
    if W.ammoRecover >= 3.0 then
      W.ammoRecover = W.ammoRecover - 3.0
      W.ammo = W.ammo + 1
      self.ammoAnim:resetPattern("newammo")
    end
  end
  self.ammoAnim:update(dt)
end

