allGameObjects = {}

GameObject = {}
function GameObject:new(x, y, speedx, speedy, maxspeedx, maxspeedy, width, height, color)
    local obj = {}
    obj.x = x or 0
    obj.y = y or 0
    obj.speedx = speedx or 0
    obj.speedy = speedy or 0
    obj.maxspeedx = maxspeedx or 0
    obj.maxspeedy = maxspeedy or 0
    obj.width = width or 10
    obj.height = height or 10
    obj.color = {}
    for k, v in ipairs(color or {}) do
        obj.color[k] = v or 255
    end
    
    setmetatable(obj, self)
    self.__index = self
    table.insert(allGameObjects, obj)
    return obj
end

function GameObject:draw()
    love.graphics.setColor(self.color[1],self.color[2],self.color[3],self.color[4])
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function GameObject:move(dt)
    self.speedx = self.limitSpeed(self.speedx, self.maxspeedx)
    self.speedy = self.limitSpeed(self.speedy, self.maxspeedy)
    
    self.x = self.x + self.speedx*dt
    self.y = self.y + self.speedy*dt
end

function GameObject.limitSpeed(speed, maxspeed)
    if math.abs(speed) > maxspeed then
        local sign = speed < 0 and -1 or 1
        speed = sign * maxspeed
    end
    return speed
end