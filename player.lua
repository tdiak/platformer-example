player = {}
player.body = love.physics.newBody(world, 100, 100, "dynamic")
player.shape = love.physics.newRectangleShape(66, 92)
player.fixture = love.physics.newFixture(player.body, player.shape)