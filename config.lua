love.window.setTitle("Pong")

love.window.setMode(600, 400)

window = {}
window.width, window.height, window.flags = love.window.getMode()

scoreFont = love.graphics.newFont(36)
love.graphics.setFont(scoreFont)