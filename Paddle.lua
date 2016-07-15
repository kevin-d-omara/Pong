Paddle = GameObject:new()
table.remove(allGameObjects)  -- don't want prototype in object list

--window.width-18

function Paddle:new(side, color)
    local width = 15
    local gap = 10
    local x = side == "left" and (gap) or (window.width - gap - width)
    local obj = GameObject:new(x, window.height/2-30, 0, 0, 0, 475, width, 60, color)
    obj.bassBounce = love.audio.newSource("sounds/deep-bass-bounce.wav", "static")
    
    setmetatable(obj,self)
    self.__index = self
    return obj
end

function Paddle:bounceWall()
    table.insert(soundQueue, self.bassBounce)
end