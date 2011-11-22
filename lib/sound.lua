
Sound = {
  rate = 44100,
  bits = 16,
  channel = 1,
  bpm = 200
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
  local idx = song.idx
  local s = song.samples
  local key
  if c == "A" then key = (song.oct*12) + 13 + mod
  elseif c == "B" then key = (song.oct*12) + 15
  elseif c == "C" then key = (song.oct*12) + 4 + mod
  elseif c == "D" then key = (song.oct*12) + 6 + mod
  elseif c == "E" then key = (song.oct*12) + 8
  elseif c == "F" then key = (song.oct*12) + 9 + mod
  elseif c == "G" then key = (song.oct*12) + 11 + mod
  else
    for i = 1, N do
      s:setSample( idx, 0 )
      idx = idx + 1
    end
    song.idx = idx
    return
  end
  local freq = pianofreq( key )
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

function Sound:playsound( song )
  if self.source then self.source:stop() end
  if type(song)~="string" then error("BAD SONG "..type(song)) end

  local s = song.."ZX"

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

