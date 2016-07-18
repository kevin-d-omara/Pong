--[[
    By Kevin O'Mara
    Version 0.3.5
--]]

-- based on: http://www.ponggame.org/

function love.load()
    -- queues
    soundQueue = {}
    eventQueue = {}
    
    -- requires
    require "config"
    require "music"
    require "GameObject"
    require "Paddle"
    require "Player"
    require "Ball"
    require "collisions"
    require "menu"
    require "Selector"
    
    -- gamestate => menu -> ingame -> (paused) -> gameover
    gamestate = "menu"
    isPaused = false
end

function love.keypressed(key, _, isrepeat)
    if gamestate == "ingame" then
        -- do nothing
    elseif gamestate == "menu" then
        menu.keypressed(key)
    elseif gamestate == "gameover" then
        if key == 'space' then
            resetGame()
            gamestate = "ingame"
        elseif key == 'backspace' then
            resetGame()
            
            -- fade ingame music over to menu music
            music.fadeOut(music.current, .6)
            music.fadeIn(music.intro, .6)
            music.current = music.intro
            
            gamestate = "menu"
        elseif key == 'escape' then
            love.event.quit()
        end
    end
end

function resetGame()
    player1.score = 0
    player2.score = 0
    player1.paddle.y = window.height/2-30
    player2.paddle.y = window.height/2-30
    Ball:spawnBall()
end

function love.update(dt)
    --[[ events
    for k, event in ipairs(eventQueue) do
        if event() == false then
            table.remove(eventQueue, k)
        end
    end
    --]]
    
    if gamestate == "ingame" then
        -- player input
        for _, player in ipairs(allPlayers) do
            player:checkIfKeyIsDown(dt)
        end
        
        -- update screen positions
        for _, obj in ipairs(allGameObjects) do
            obj:move(dt)
        end
        
        checkForCollisions(dt)
        
        -- check win condition
        if player1.score >= maxScore or player2.score >= maxScore then
            gamestate = "gameover"
            winner = player1.score >= maxScore and player1 or player2
            for k, v in ipairs(allGameObjects) do
                if v == ball then table.remove(allGameObjects, k) end   -- remove ball
            end
        end
    elseif gamestate == "menu" then
        -- do nothing
    elseif gamestate == "gameover" then
        -- do nothing        
    end
    
    -- audio
    for k, update in ipairs(musicQueue) do
        if update(dt) == false then
            table.remove(musicQueue, k)
        end
    end
    
    for k, sound in ipairs(soundQueue) do
        sound:play()
        soundQueue[k] = nil
    end
end

function love.draw()
    if gamestate == "ingame" then        
        for _, obj in ipairs(allGameObjects) do
            obj:draw()
        end
        
        drawDashedLine('y', window.width/2-2, 0, 4, window.height/31, 31, {255,255,255,255})
        
        -- display score
        love.graphics.setFont(optionFont)
        local score = string.format("%.2d   %.2d", player1.score, player2.score)
        love.graphics.setColor(204,0,204,255)
        love.graphics.printf(score, 0, 35, window.width, 'center')
        
    elseif gamestate == "menu" then
        menu.display(menu.pages.current)
        
        -- show menu controls:
        love.graphics.setFont(subOptionFont)
        love.graphics.draw(keys_arrow, 0, 0, 0, .1, .1)     -- left side
        love.graphics.print("menu control", 10, 100)
        love.graphics.draw(keys_enter, 568, 2, 0, .1, .1)   -- right side
        love.graphics.print("select", 578, 52)
        love.graphics.draw(keys_backspace, 568, 92, 0, .1, .1)
        love.graphics.print("go back", 568, 142)
        
    elseif gamestate == "gameover" then
        love.graphics.setColor(255,255,255,255)
        love.graphics.setFont(gameoverFont)
        local offset = winner == player1 and -1 or 1
        love.graphics.printf("WIN", 135*offset, 70, window.width, 'center')
        
        love.graphics.setFont(optionFont)
        love.graphics.printf("Play Again?", 135*offset, 145, window.width, 'center')
        love.graphics.printf("Menu", 135*offset, 225, window.width, 'center')
        love.graphics.printf("Exit", 135*offset, 305, window.width, 'center')
        
        love.graphics.setFont(subOptionFont)
        love.graphics.printf("(spacebar)", 135*offset, 185, window.width, 'center')
        love.graphics.printf("(backspace)", 135*offset, 265, window.width, 'center')
        love.graphics.printf("(escape)", 135*offset, 345, window.width, 'center')
        
        -- shader to fade these; or just adjust alpha :P)
        for _, obj in ipairs(allGameObjects) do
            obj:draw()
        end
        
        drawDashedLine('y', window.width/2-2, 0, 4, window.height/31, 31, {255,255,255,255})
        
        -- display score
        love.graphics.setFont(optionFont)
        local score = string.format("%.2d   %.2d", player1.score, player2.score)
        love.graphics.setColor(204,0,204,255)
        love.graphics.printf(score, 0, 35, window.width, 'center')
        --
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