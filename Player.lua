allPlayers = {}

Player = {}
function Player:new(paddle, up, down)
    local obj = {}
    obj.paddle = paddle
    obj.control = {up = up, down = down}
    obj.score = 0
    
    setmetatable(obj, self)
    self.__index = self
    table.insert(allPlayers, obj)
    return obj
end

function Player:checkIfKeyPressed(dt)
    if love.keyboard.isDown(self.control.up) then
        self.paddle.speedy = -1.0 * self.paddle.maxspeedy
    elseif love.keyboard.isDown(self.control.down) then
        self.paddle.speedy = self.paddle.maxspeedy
    else
        self.paddle.speedy = 0
    end
end

-- todo: change controls to 'a-z' & 'k-m'
paddle1 = GameObject:new(10, window.height/2-30, 0, 0, 0, 475, 8, 60, "rectangle", {255,0,0,255})
player1 = Player:new(paddle1, "w", "s")

paddle2 = GameObject:new(window.width-18, window.height/2-30, 0, 0, 0, 475, 8, 60, "rectangle", {0,0,255,255})
player2 = Player:new(paddle2, "up", "down")