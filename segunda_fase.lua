local sti = require("libs.sti")
local bump = require("libs.bump")
local utils = require("utils")
local player = require("player")
local Conta = require("conta")
local Coletavel = require("coletavel")

local fase = {}
local conta
local background

-- Carregar as sprites das portas (igual no código anterior)
local spritePortaFechada = love.graphics.newImage("assets/porta_fechada.png")
local spritePortaAberta = love.graphics.newImage("assets/porta_aberta.png")

function fase.load()
    background = love.graphics.newImage("mapas/fundo3.png")

    fase.world = bump.newWorld(32)
    fase.map = sti("mapas/segunda_fase.lua", { "bump" })
    fase.map:bump_init(fase.world)

    fase.exits = {}
    fase.pontos = {}

    for _, obj in ipairs(fase.map.layers["walls"].objects) do
        if obj.properties.collidable then
            fase.world:add(obj, obj.x, obj.y, obj.width, obj.height)
        end
    end

    for _, obj in ipairs(fase.map.layers["spawn"].objects) do
        if obj.name == "playerSpawn" then
            player.load(fase.world, obj.x, obj.y - player.h)
            break
        end
    end

    conta = Conta.nova()
    local valor1 = conta.operandos[1]
    local valor2 = conta.operandos[2]

    local pontosMapa = {}
    for _, obj in ipairs(fase.map.layers["pontos"].objects) do
        if obj.properties.isPoint then
            table.insert(pontosMapa, obj)
        end
    end

    for i = #pontosMapa, 2, -1 do
        local j = love.math.random(1, i)
        pontosMapa[i], pontosMapa[j] = pontosMapa[j], pontosMapa[i]
    end

    local usados = {}
    usados[valor1] = true
    usados[valor2] = true

    local valores = { valor1, valor2 }

    while #valores < #pontosMapa do
        local aleatorio = love.math.random(1, 20)
        if not usados[aleatorio] then
            usados[aleatorio] = true
            table.insert(valores, aleatorio)
        end
    end

    for i, obj in ipairs(pontosMapa) do
        local valor = valores[i]
        local c = Coletavel.new(obj.x, obj.y, obj.width, obj.height, valor)
        table.insert(fase.pontos, c)
    end

    for _, obj in ipairs(fase.map.layers["exits"].objects) do
        if obj.properties.isExit then
            table.insert(fase.exits, {
                x = obj.x,
                y = obj.y,
                w = obj.width,
                h = obj.height
            })
        end
    end

    local mapWidth = fase.map.width * fase.map.tilewidth
    local mapHeight = fase.map.height * fase.map.tileheight
    local screenWidth, screenHeight = love.graphics.getDimensions()
    utils.initCamera(mapWidth, mapHeight, screenWidth, screenHeight)
end

function fase.update(dt)
    fase.map:update(dt)
    player.update(dt, fase.world)

    for _, ponto in ipairs(fase.pontos) do
        if not ponto.coletado and
           player.x < ponto.x + ponto.w and
           player.x + player.w > ponto.x and
           player.y < ponto.y + ponto.h and
           player.y + player.h > ponto.y then

            conta:adicionar(ponto.valor)
            ponto.coletado = true
        end
    end

    if conta.completa then
        for _, exit in ipairs(fase.exits) do
            if player.x < exit.x + exit.w and
               player.x + player.w > exit.x and
               player.y < exit.y + exit.h and
               player.y + player.h > exit.y then

                require("main").mudarFase("terceira_fase")
                return
            end
        end
    end
end

function fase.draw()
    utils.camera:attach()

    love.graphics.draw(background, 0, 0)
    fase.map:drawLayer(fase.map.layers["floor"])

    player.draw()

    for _, ponto in ipairs(fase.pontos) do
        ponto:draw()
    end

    -- Desenhar as saídas com sprites de porta (fechada ou aberta)
    for _, exit in ipairs(fase.exits) do
        local sprite = conta.completa and spritePortaAberta or spritePortaFechada
        love.graphics.draw(sprite, exit.x, exit.y)
    end

    utils.camera:detach()

    conta:desenhar()
end

function fase.keypressed(key)
    player.keypressed(key)
end

return fase
