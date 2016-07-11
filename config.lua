love.window.setTitle("Pong")
love.window.setMode(600, 400)
window = {}
window.width, window.height, window.flags = love.window.getMode()

math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) )
love.keyboard.setKeyRepeat(true)

scoreFont = love.graphics.newFont(36)   -- TODO: remove
titleFont = love.graphics.newFont(36)
optionFont = love.graphics.newFont(28)
subOptionFont = love.graphics.newFont(20)
love.graphics.setFont(scoreFont)