
SoundEffect = Util.strict {
  MENU = "+g-ege-ege";
  GEM = "5c-gec-gec";
  COIN = "6a#a#zx";
  HEALTH = "cge-zcge";
  AMMO = "-c+c+c-g-g-g";
  KEY = "4gec-g+ec-ge+c-gec";
  FULLKEYS = "-gc#-a#a";
  UNLOCK = "ceg+c-eg+ce-g+ceg";
  LOCKED = "s1a#z+a#-a#x";
  PLAYERHURT = "c-zgd#c-gd#c";
  ENEMYHURT = "zc-d#g-cd#";
  PLAYERBURNT = "a#e-a#e-a#e-a#e";
  PLAYERDIED = "+c-gd#cd#c-gd#gd#c-g+c-gd#cd#c-gd#gd#c";
  PUSHED = "1d#x";
  TELEPORT = "2c+c+c2d#+d#+d#2g+g+g3cd#g";
  PLAYERSHOOT = "z+c-c";
  BREAK = "1a+a+a";
  NOAMMO = "-af#-f#a";
  EXPLODE = "1c+c0d#+d#-g+g-c#";
  ENTRANCE = "2cg+e+c2c#g#+f+c#2da+f#+d2d#a#+g+d#";
  DRAGONFIRE = "z0ca#f+d#cf#";
  SCROLL = "cg+c-eda+d-f#eb+e-g#";
  GOOP = "1c+c+c+c+c";
}

-- -- --

local mzxSongList = {
  "5c-gec-gec"; -- Gem
  "5c-gec-gec"; -- Magic Gem
  "cge-zcge"; -- Health
  "-c+c+c-g-g-g"; -- Ammo
  "6a#a#zx"; -- Coin
  "-cegeg+c-g+cecegeg+c"; -- Life
  "-cc#dd#e"; -- Lo Bomb
  "cc#dd#e"; -- Hi Bomb
  "4gec-g+ec-ge+c-gec"; -- Key
  "-gc#-a#a"; -- Full Keys
  "ceg+c-eg+ce-g+ceg"; -- Unlock
  "s1a#z+a#-a#x"; -- Can't Unlock
  "-a-a+e-e+c-c"; -- Invis. Wall
  "zax"; -- Forest
  "0a#+a#-a#b+b-b"; -- Gate Locked
  "0a+a-a+a-a"; -- Opening Gate
  "-g+g-g+g+g-g+g-g-g+g-g-tg+g"; -- Invinco Start
  "sc-cqxsg-g+a#-a#xx+g-g+a#-a#"; -- Invinco Beat
  "sc-cqxsg-g+f-f+d#-d#+c-ca#-a#2c-c"; -- Invinco End
  "0g+g-gd#+d#-d#"; -- 19-Door locked
  "0g+gd#+d#"; -- Door opening
  "c-zgd#c-gd#c"; -- Hurt
  "a#e-a#e-a#e-a#e"; -- AUGH!
  "+c-gd#cd#c-gd#gd#c-g+c-gd#cd#c-gd#gd#c"; -- Death
  "ic1c+ca#+c1c+cx+d#1c+ca#+c1c+cx+c1c+ca#+c1c+cx+d#1c+c+fc1c+cx"; -- Game over
  "0c+c-c+c-c"; --25 - Gate closing
  "1d#x"; --26-Push
  "2c+c+c2d#+d#+d#2g+g+g3cd#g"; -- 27-Transport
  "z+c-c"; -- 28-shoot
  "1a+a+a"; -- 29-break
  "-af#-f#a"; -- 30-out of ammo
  "+f#"; -- 31-ricochet
  "s-d-d-d"; -- 32-out of bombs
  "c-aec-a"; -- 33-place bomb (lo)
  "+c-aec-a"; -- 34-place bomb (hi)
  "+g-ege-ege"; -- 35-switch bomb type
  "1c+c0d#+d#-g+g-c#"; -- 36-explosion
  "2cg+e+c2c#g#+f+c#2da+f#+d2d#a#+g+d#"; -- 37-Entrance
  "cge+c-g+ecge+c-g+ec"; -- 38-Pouch
  "zcd#gd#cd#gd#cd#gd#cd#gd#cfg#fcfg#fcfg#fcfg#fcga#gcga#gcga#gcga#gs+c"; --39-ring/potion
  "z-a-a-aa-aa"; -- 40-Empty chest
  "1c+c-c#+c#-d+d-d#+d#-e+e-ec"; -- 41-Chest
  "c-gd#c-zd#gd#c"; -- 42-Out of time
  "zc-d#g-cd#"; -- 43-Fire ouch
  "cd#g+cd#g"; -- 44-Stolen gem
  "z1d#+d#+d#"; -- 45-Enemy HP down
  "z0ca#f+d#cf#"; -- 46-Dragon fire
  "cg+c-eda+d-f#eb+e-g#"; -- 47-Scroll/sign
  "1c+c+c+c+c"; -- 48-Goop
}

local zztSongList = {
  "tcf+cf+c"; -- BombSet
  "scdefg"; -- Duplicator
  "tc-c+d-d+e-e+f-f+g-g"; -- Scroll
  "tcegc#fg#df#ad#ga#eg#+c"; -- Passageway
  "t--dc"; -- Inviswall
  "t--f"; -- Push
  "t--gc"; -- locked door
  "t+c+c"; -- Water
  "s.-cd#e"; -- Energizer On
  "s.-f+f-fd#c+c-de"; -- Energizer Song
  "s.-c-a#gf#fd#c"; --  Energizer End
  "t+cegcegceg+sc"; -- Ket
  "tcgbcgb+ic"; -- Door
  "t+c-gec"; -- Gem
  "tcc#d"; -- Ammo
  "tcase"; -- Torch
  "t+c-c-c"; -- Ammo
  "t--ct+cd#"; -- Ouch
}

for i, v in ipairs( mzxSongList ) do
  SoundEffect[string.format("MZX-%02i", i)] = v
end

for i, v in ipairs( zztSongList ) do
  SoundEffect[string.format("ZZT-%02i", i)] = v
end

