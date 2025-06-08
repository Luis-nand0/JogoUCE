local player = {}

player.x = 100
player.y = 100
player.w = 32 * 2       -- largura da hitbox mantém 64
player.h = 64      -- altura da hitbox reduzida para 96 (64 * 1.5)

player.vx = 0
player.vy = 0
player.speed = 300
player.jumpForce = -600
player.gravity = 1000
player.isOnGround = false
player.jumpCount = 0
player.maxJumps = 2

player.world = nil

-- SPRITE
player.sprite = nil
player.quads = {}
player.currentQuad = nil
player.animTimer = 0
player.animFrame = 1
player.animSpeed = 0.15
player.facing = 1 -- 1 = direita, -1 = esquerda

player.scale = 2

function player.load(world, x, y)
    player.x = x or player.x
    player.y = y or player.y

    player.sprite = love.graphics.newImage("assets/spr_player.png")
    local frameWidth = 32
    local frameHeight = 32 -- sprite correto

    for i = 0, 3 do
        player.quads[i+1] = love.graphics.newQuad(i * frameWidth, 0, frameWidth, frameHeight, player.sprite:getDimensions())
    end
    player.currentQuad = player.quads[3]

    if player.world and player.world ~= world then
        player.world:remove(player)
    end
    if not player.world or player.world ~= world then
        world:add(player, player.x, player.y, player.w, player.h)
        player.world = world
    else
        world:update(player, player.x, player.y)
    end
end

function player.update(dt, world)
    player.vy = player.vy + player.gravity * dt

    player.vx = 0
    local moving = false
    if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        player.vx = -player.speed
        moving = true
        player.facing = -1
    elseif love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        player.vx = player.speed
        moving = true
        player.facing = 1
    end

    if not player.isOnGround then
        player.currentQuad = player.quads[4]
    elseif moving then
        player.animTimer = player.animTimer + dt
        if player.animTimer >= player.animSpeed then
            player.animTimer = 0
            player.animFrame = (player.animFrame % 2) + 1
        end
        player.currentQuad = player.quads[player.animFrame]
    else
        player.currentQuad = player.quads[3]
    end

    local goalX = player.x + player.vx * dt
    local goalY = player.y + player.vy * dt
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
    love.graphics.setColor(1, 1, 1)
    local scaleX = player.facing * player.scale
    local offsetX = 0
    if player.facing == -1 then
        offsetX = player.w
    end

    local spriteHeight = 32 * player.scale
    love.graphics.draw(
        player.sprite,
        player.currentQuad,
        player.x + offsetX,
        player.y + player.h - spriteHeight, -- alinhado na base da hitbox reduzida
        0,
        scaleX,
        player.scale
    )
end

return player
