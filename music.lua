music = {}
music.intro = love.audio.newSource("sounds/intro.wav", "static")
    music.intro:setVolume(.4)
    music.intro:setLooping(true)
    music.intro:play()
    music.current = music.intro
music.ingameAmbience = love.audio.newSource("sounds/ingame-ambience.wav", "static")
music.gameEnd = love.audio.newSource("sounds/game-end.wav", "static")

musicStack = {}     -- to control fade in/out effects

function music.fadeOut(song, time)
    local volume = love.audio.getVolume(song)
    local factor = volume/time
    
    table.insert(musicStack, function(dt)
        volume = volume - factor * dt
        if volume <= 0 then
            song:pause()
            return false
        else
            song:setVolume(volume)
        end
        --print("out volume: ", love.audio.getVolume(song))
    end)
end

function music.fadeIn(song, time, maxVolume)
    local volume = 0
    local factor = maxVolume/time
    song:setVolume(0)
    song:setLooping(true)
    song:play()
    
    table.insert(musicStack, function(dt)
        volume = volume + factor * dt
        if volume >= maxVolume then
            song:setVolume(maxVolume)
            return false
        else
            song:setVolume(volume)
        end
        --print("in volume: ", love.audio.getVolume(song))
    end)
end


--[[
Audio API

love.audio.pause()
love.audio.play( source)     /   Source:play()
love.audio.resume()
love.audio.rewind()

love.audio.setVolume()    -- master volume
--]]