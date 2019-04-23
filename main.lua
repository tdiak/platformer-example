function love.load()
    world = love.physics.newWorld(0, 500, false)
    world:setCallbacks(beginContact, endContact, preSolve, postSolve)
    sprites = {}
    sprites.coin_sheet = love.graphics.newImage('sprites/coin_sheet.png')
    sprites.player_jump = love.graphics.newImage('sprites/player_jump.png')
    sprites.player_stand = love.graphics.newImage('sprites/player_stand.png')

    platforms = {}

    require('player')
    anim8 = require('anim8/anim8')
    require('coin')

    sti = require('simpleTiled/sti')
    gameMap = sti("maps/map.lua")

    for i, obj in ipairs(gameMap.layers['Platforms'].objects) do
        spawnPlatform(obj.x, obj.y, obj.width, obj.height)
    end

    for i, obj in ipairs(gameMap.layers['Coins'].objects) do
        spawnCoin(obj.x, obj.y)
    end
end


function love.update(dt)
    world:update(dt)
    playerUpdate(dt)
    gameMap:update(dt)

    for i, coin in ipairs(coins) do
        coin.animation:update(dt)
    end

    coinUpdate(dt)
end


function love.draw()
    gameMap:drawLayer(gameMap.layers['Tile Layer 1'])
    love.graphics.draw(player.sprite, player.body:getX(), player.body:getY(), nil, player.direction, 1, sprites.player_stand:getWidth()/2, sprites.player_stand:getHeight()/2)

    for i, coin in ipairs(coins) do
        coin.animation:draw(sprites.coin_sheet, coin.x, coin.y, nil, nil, nil, 20.5, 21)
    end
end


function love.keypressed(key, scancode, isrepeat)
    if key == "up" and player.grounded then
        player.body:applyLinearImpulse(0, -2500)
    end
end


function beginContact(a, b, coll)
    player.grounded = true
end


function endContact(a, b, coll)
    player.grounded = false
end


function spawnPlatform(x, y, width, height)
    local platform = {}
    platform.body = love.physics.newBody(world, x, y, "static")
    platform.shape = love.physics.newRectangleShape(width/2, height/2, width, height)
    platform.fixture = love.physics.newFixture(platform.body, platform.shape)
    platform.width = width
    platform.height = height
    
    table.insert(platforms, platform)
end


function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((y2 - y1)^2 + (x2 - x1)^2)
end