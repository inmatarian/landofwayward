
Sound = {
  rate = 44100;
  bits = 16;
  channel = 1;
  bpm = 200;
  bank = {};

  GEM = "5c-gec-gec";
  COIN = "6a#a#zx";
  HEALTH = "cge-zcge";
  AMMO = "-c+c+c-g-g-g";
  KEY = "4gec-g+ec-ge+c-gec";
  FULLKEYS = "-gc#-a#a";
  UNLOCK = "ceg+c-eg+ce-g+ceg";
  LOCKED = "s1a#z+a#-a#x";
  PLAYERHURT = "c-zgd#c-gd#c";
  ENEMYHURT = "a#e-a#e-a#e-a#e";
  PLAYERBURNT = "zc-d#g-cd#";
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

function Sound:init()
  --
end

function Sound:playmod( file )
  self:stopmod()
  self.bgm = love.audio.newSource(file, "stream")
  self.bgm:setLooping( true )
  self.bgm:setVolume(0.8)
  love.audio.play(self.bgm)
  self.bgmfile = file
end

function Sound:stopmod()
  if not self.bgm then return end
  love.audio.stop(self.bgm)
  self.bgm = nil
  self.bgmfile = nil
end

-- Sound Shock Synth Engine 3k Max Force
local function pianofreq( key )
  return 440 * math.pow( 2, (key-49)/12 )
end

local function parseMZXSongString( s, song, addnotefunc )
  local bpm = song.bpm
  local notes = "ABCDEFGX"
  local N = s:len()
  for i = 1, N do
    local c = s:sub(i, i):upper()
    local cn = (i < N) and s:sub(i+1, i+1) or ' '
    if c == '0' then song.oct = 0
    elseif c == '1' then song.oct = 1
    elseif c == '2' then song.oct = 2
    elseif c == '3' then song.oct = 3
    elseif c == '4' then song.oct = 4
    elseif c == '5' then song.oct = 5
    elseif c == '6' then song.oct = 6
    elseif c == '+' then
      song.oct = song.oct + 1
      if song.oct > 6 then song.oct = 6 end
    elseif c == '-' then
      song.oct = song.oct - 1
      if song.oct < 0 then song.oct = 0 end
    elseif c == '!' then song.dur = song.dur / 3
    elseif c == '.' then song.dur = song.dur * 1.5
    elseif c == 'Z' then song.dur = bpm/16
    elseif c == 'T' then song.dur = bpm/8
    elseif c == 'S' then song.dur = bpm/4
    elseif c == 'I' then song.dur = bpm/2
    elseif c == 'Q' then song.dur = bpm
    elseif c == 'H' then song.dur = bpm*2
    elseif c == 'W' then song.dur = bpm*4
    elseif notes:find(c) then
      addnotefunc( song, c, cn )
    end
  end
end

local PI = math.pi
local function squareWave( phase, rate, freq )
  phase = phase + 2*PI/rate
  if phase >= 2*PI then
    phase = phase - 2*PI
  end
  local x = math.sin(freq * phase)
  if x < 0 then return -1, phase else return 1, phase end
end

local function addSongNote( song, c, cn )
  local len = (60/song.bpm) * (song.dur/song.bpm)
  local rate = song.rate
  local N = math.ceil(len * rate)
  local mod = (cn=="#") and 1 or ( (cn=="$") and -1 or 0 )
  local key
  if c == "A" then key = (song.oct*12) + 13 + mod
  elseif c == "B" then key = (song.oct*12) + 15
  elseif c == "C" then key = (song.oct*12) + 4 + mod
  elseif c == "D" then key = (song.oct*12) + 6 + mod
  elseif c == "E" then key = (song.oct*12) + 8
  elseif c == "F" then key = (song.oct*12) + 9 + mod
  elseif c == "G" then key = (song.oct*12) + 11 + mod
  else
    song.idx = song.idx + N
    return
  end
  local freq = pianofreq( key )
  local idx = song.idx
  local s = song.samples
  local phase = 0
  local sample
  for i = 1, N do
    sample, phase = squareWave( phase, rate, freq )
    s:setSample( idx, sample * 0.08 )
    idx = idx + 1
  end
  song.idx = idx
end

local function dummyAddNote( song, c, cn )
  local len = (60/song.bpm) * (song.dur/song.bpm)
  local N = math.ceil(len * song.rate)
  song.idx = song.idx + N
end

function Sound:playsound( s )
  if self.source then self.source:stop() end

  local proto = { dur = self.bpm/8, oct=3, idx=0, rate=self.rate, bpm=self.bpm }
  proto.__index = proto

  local firstpass = setmetatable( {}, proto )
  parseMZXSongString( s, firstpass, dummyAddNote )

  self.soundData = love.sound.newSoundData(firstpass.idx, self.rate, self.bits, self.channel)
  local secondpass = setmetatable( { samples = self.soundData }, proto )
  parseMZXSongString( s, secondpass, addSongNote )

  self.source = love.audio.newSource(self.soundData)
  love.audio.play(self.source)
end

function Sound:update()
  if self.source and self.source:isStopped() then
    self.soundData = nil
    self.source = nil
  end
end

-- -- --

--[===[
songlist = {
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
  "q0a1a2a3a4a5a6a";
  "q0d#1d#2d#3d#4d#5d#6d#";
  "iaxiaxiaxiaxiaxiaxiaxiax";
  "2Icdefgab+cdefgab+cdefgab";
}
]===]


