function checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)   -- AABB bounding box
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function checkForCollisions()
    -- ball -> paddle
    for _, player in ipairs(allPlayers) do
        local paddle = player.paddle
        if checkCollision(ball.x,ball.y,ball.width,ball.height, paddle.x, paddle.y, paddle.width, paddle.height) then
            ball.speedx = -1 * ball.speedx          -- flip ball's x-dir
            local bMid = ball.y + ball.height/2     -- ball midpoint (y-dir)
            local pMid = paddle.y + paddle.height/2 -- paddle midpoint (y-dir)
            bMid = bMid - pMid          -- center bMid on pMid
            local p4 = paddle.height/4  -- quarter of paddle height
            local m = 0     -- slope
            local b = 0     -- intercept
            if bMid < -p4 then      -- top quarter
                m = -1 * ball.maxspeedy * (.5) / p4 -- (4/5 - 3/10)
                b = -1 * ball.maxspeedy * (-.2)     -- (2 * 3/10 - 4/5)
            elseif bMid < 0 then    -- middle-top quarter
                m = -1 * ball.maxspeedy * 3/10 / p4
                b = -1 * 1
            elseif bMid == 0 then   -- middle
                -- nothing
            elseif bMid <= p4 then  -- middle-bottom quarter
                m = ball.maxspeedy * 3/10 / p4
                b = 1
            else                    -- bottom quarter
                m = ball.maxspeedy * (.5) / p4      -- (4/5 - 3/10)
                b = ball.maxspeedy * (-.2)          -- (2 * 3/10 - 4/5)
            end
            ball.speedy = m * math.abs(bMid) + b      -- "f(x) = m*x + b"
            local sign = paddle == paddle1 and 1 or -1
            ball.x = paddle.x + sign * (paddle.width + 1)
        end
    end    
    
    -- ball -> top/bottom of screen
    if ball.y < 0 or ball.y + ball.height > window.height then
        ball.speedy = -1 * ball.speedy          -- invert y-direction
        ball.bounce()
    end
    
    -- ball -> left/right of screen
    if ball.x < -10 then
        scorePoint(player2)
        ball.score()
    elseif ball.x + ball.width > window.width + 10 then
        scorePoint(player1)
        ball.score()
    end
    
    -- paddle -> top/bottom of screen
    for _, player in ipairs(allPlayers) do
        local paddle = player.paddle
        if paddle.y < 0 then
            paddle.speedy = 0
            paddle.y = paddle.y + 10
            paddle:bounceWall()
        elseif paddle.y + paddle.height > window.height then
            paddle.speedy = 0
            paddle.y = paddle.y - 10
            paddle:bounceWall()
        end
    end
end

function scorePoint(player)
    player.score = player.score + 1
    allGameObjects:remove(ball)
    Ball:spawnBall(player)
end