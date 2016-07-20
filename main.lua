--[[
    By Kevin O'Mara
    Version 1.0.0
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
        if isPaused then
            if key == pauseButton then
                allSongs:unPause()
                isPaused = false
            elseif key == 'space' then
                allGameObjects:remove(ball)
                resetGame()
                allSongs:unPause()
                gamestate = "ingame"
                isPaused = false
            elseif key == 'backspace' then
                allGameObjects:remove(ball)
                resetGame()
                -- fade ingame music over to menu music
                music.fadeOut(music.current, .6)
                music.fadeIn(music.intro, .6)
                music.current = music.intro
                gamestate = "menu"
                isPaused = false
            elseif key == 'tab' then
                love.event.quit()
            end
        else -- not paused
            if key == pauseButton then
                allSongs:pause()
                isPaused = true
            end 
        end
    elseif gamestate == "menu" then
        menu.keypressed(key)
    elseif gamestate == "gameover" then
        if key == 'space' then
            resetGame()
            -- fade ingame music over to menu music
            music.fadeOut(music.current, .6)
            music.fadeIn(music.ingameAmbience, .6)
            music.current = music.ingameAmbience
            
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
    if gamestate == "ingame" then
        if isPaused then
            -- do nothing
        else -- not paused
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
                -- fade sounds
                music.fadeOut(music.current, .6)
                music.fadeIn(music.gameEnd, .6)
                music.current = music.gameEnd
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
        
        if isPaused then
            love.graphics.setColor(255,153,0,255)
            love.graphics.printf("PAUSED", 135, 70, window.width, 'center')
            
            love.graphics.setFont(optionFont)
            love.graphics.printf("Restart?", 135, 145, window.width, 'center')
            love.graphics.printf("Menu", 135, 225, window.width, 'center')
            love.graphics.printf("Exit", 135, 305, window.width, 'center')
            
            love.graphics.setFont(subOptionFont)
            love.graphics.printf("(spacebar)", 135, 185, window.width, 'center')
            love.graphics.printf("(backspace)", 135, 265, window.width, 'center')
            love.graphics.printf("(tab)", 135, 345, window.width, 'center')
        end
        
    elseif gamestate == "menu" then
        menu.display(menu.pages.current)
        menu.showControls()

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