function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function checkForCollisions()
    -- ball -> paddle
    for _, player in ipairs(allPlayers) do
        local paddle = player.paddle
        if CheckCollision(ball.x,ball.y,ball.width,ball.height, paddle.x, paddle.y, paddle.width, paddle.height) then
            ball.speedx = -1 * ball.speedx      -- invert x-direction
            ball.speedy = ball.speedy + 1/2*paddle.speedy
            ball.bounce()
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
    Ball:spawnBall()
end