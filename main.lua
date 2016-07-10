--[[
    By Kevin O'Mara
    Version 0.2
--]]

-- original pong: https://www.youtube.com/watch?v=it0sf4CMDeM

-- TODO:
--      - sound effects (ambient, collision, point scored)
--      - background??
--      - 'package' up; test cross platform-ness via Linux
--      ???
--      profit

function love.load()
    math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) )
    
    -- sound stack
    soundStack = {}
    
    -- requires
    require "config"
    require "music"
    require "menu"
    require "Selector"
    require "GameObject"
    require "Paddle"
    require "Player"
    require "Ball"
    require "collisions"

--[[
    ingameAmbience:setVolume(.3)
    ingameAmbience:setLooping(true)
    ingameAmbience:play()
--]]    
    
    -- gamestate => menu -> ingame -> (paused) -> gameover
    gamestate = "menu"
    isPaused = false
end

function love.update(dt)
    if gamestate == "ingame" then
        -- player input
        for _, player in ipairs(allPlayers) do
            player:checkIfKeyIsDown(dt)
        end
        
        -- update screen positions
        for _, obj in ipairs(allGameObjects) do
            obj:move(dt)
        end
        
        checkForCollisions()
    elseif gamestate == "menu" then
        function love.keypressed(key)
            menu.keypressed(key)
        end
    elseif gamestate == "gameover" then
        
    end
    
    -- audio
    for k, update in ipairs(musicStack) do
        if update(dt) == false then
            table.remove(musicStack, k)
        end
    end
    
    for k, sound in ipairs(soundStack) do
        sound:play()
        soundStack[k] = nil
    end
end

function love.draw()
    if gamestate == "ingame" then
        for _, obj in ipairs(allGameObjects) do
            obj:draw()
        end
        
        drawDashedLine('y', window.width/2-2, 0, 4, window.height/19, 19, {255,255,255,255})
        
        -- display score
        local score = string.format("%.2d   %.2d", player1.score, player2.score)
        love.graphics.setColor(204,0,204,255)
        love.graphics.printf(score, 0, 35, window.width, 'center')
    elseif gamestate == "menu" then
        menu.display(menu.pages.current)
    elseif gamestate == "gameover" then
        
    end
end

--[[ arguments:
xy = horizontal (x) or vertical (y) line
x  = starting x position
y  = starting y position
w  = width of single dash
h  = height of single dash
n  = number of dashes (includes blank dashes)
color = {r,g,b,a}
--]]
function drawDashedLine(x_y, x, y, w, h, n, color)
    love.graphics.setColor(color[1] or 255, color[2] or 255, color[3] or 255, color[4] or 255)
    for i = 0, n, 2 do
        local tx = x_y == 'y' and x-w/2 or x+w*i
        local ty = x_y == 'y' and y+h*i or y-h/2
        love.graphics.rectangle("fill", tx, ty, w, h)
    end
end






