
Sound = {
  bank = {};
  effectFiles = {};
  effectData = {};
}

function Sound.init()
  for name, file in pairs(Sound.effectFiles) do
    Sound.effectData[name] = love.sound.newSoundData(file)
  end
end

function Sound.playsound(name)
  local sound = love.audio.newSource(Sound.effectData[name])
  Sound.bank[sound] = sound
  love.audio.play(sound)
end

function Sound.playmod( file )
  Sound.stopmod()
  Sound.bgm = love.audio.newSource(file, "stream")
  Sound.bgm:setLooping( true )
  Sound.bgm:setVolume(0.8)
  love.audio.play(Sound.bgm)
  Sound.bgmfile = file
end

function Sound.stopmod()
  if not Sound.bgm then return end
  love.audio.stop(Sound.bgm)
  Sound.bgm = nil
  Sound.bgmfile = nil
end

function Sound.update()
  local remove = {}
  for _, src in pairs(Sound.bank) do
    if src:isStopped() then table.insert(remove, src) end
  end
  for _, src in ipairs(remove) do
    Sound.bank[src] = nil
  end
end

