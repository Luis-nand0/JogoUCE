local player = {}

player.x = 100
player.y = 100
player.w = 32
player.h = 64

player.vx = 0
player.vy = 0
player.speed = 200
player.jumpForce = -600

player.gravity = 1000
player.isOnGround = false

-- Variável para guardar o mundo atual do player
player.world = nil

-- Controle para pulo duplo
player.jumpCount = 0
player.maxJumps = 2

function player.load(world, x, y)
    player.x = x or player.x
    player.y = y or player.y

    -- Se já estava em outro mundo, remove antes
    if player.world and player.world ~= world then
        player.world:remove(player)
    end

    -- Se ainda não estiver no mundo, adiciona
    if not player.world or player.world ~= world then
        world:add(player, player.x, player.y, player.w, player.h)
        player.world = world
    else
        -- Se já estiver no mesmo mundo, atualiza posição
        world:update(player, player.x, player.y)
    end
end

function player.update(dt, world)
    -- Aplica gravidade
    player.vy = player.vy + player.gravity * dt

    -- Movimento lateral
    player.vx = 0
    if love.keyboard.isDown("a") then
        player.vx = -player.speed
    elseif love.keyboard.isDown("d") then
        player.vx = player.speed
    end

    -- Calcula destino
    local goalX = player.x + player.vx * dt
    local goalY = player.y + player.vy * dt

    -- Move no mundo atual
    local actualX, actualY, cols, len = player.world:move(player, goalX, goalY)

    player.x, player.y = actualX, actualY

    player.isOnGround = false
    for i = 1, len do
        local col = cols[i]
        if col.normal.y < 0 then
            player.isOnGround = true
            player.vy = 0
            player.jumpCount = 0
        elseif col.normal.y > 0 then
            player.vy = 0
        end
    end

    player.world:update(player, player.x, player.y)
end

function player.keypressed(key)
    if (key == "space" or key == "up") and player.jumpCount < player.maxJumps then
        player.vy = player.jumpForce
        player.jumpCount = player.jumpCount + 1
    end
end

function player.draw()
    love.graphics.setColor(0, 0.5, 1)
    love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
    love.graphics.setColor(1, 1, 1)
end

return player
