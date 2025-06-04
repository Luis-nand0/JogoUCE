local sti = require("libs.sti")
local bump = require("libs.bump")
local utils = require("utils")
local player = require("player")
local Conta = require("conta")
local Coletavel = require("coletavel")

local fase = {}
local conta

function fase.load()
    fase.world = bump.newWorld(32)
    fase.map = sti("mapas/terceira_fase.lua", { "bump" })
    fase.map:bump_init(fase.world)

    fase.exits = {}
    fase.pontos = {}

    -- Colisões
    for _, obj in ipairs(fase.map.layers["walls"].objects) do
        if obj.properties.collidable then
            fase.world:add(obj, obj.x, obj.y, obj.width, obj.height)
        end
    end

    -- Spawn do jogador
    for _, obj in ipairs(fase.map.layers["spawn"].objects) do
        if obj.name == "playerSpawn" then
            player.load(fase.world, obj.x, obj.y - player.h)
            break
        end
    end

    -- Criar nova conta aleatória
    conta = Conta.nova()
    local valor1 = conta.operandos[1]
    local valor2 = conta.operandos[2]

    -- Pegar pontos do mapa e embaralhar
    local pontosMapa = {}
    for _, obj in ipairs(fase.map.layers["pontos"].objects) do
        if obj.properties.isPoint then
            table.insert(pontosMapa, obj)
        end
    end

    -- Embaralhar os objetos do mapa
    for i = #pontosMapa, 2, -1 do
        local j = love.math.random(1, i)
        pontosMapa[i], pontosMapa[j] = pontosMapa[j], pontosMapa[i]
    end

    -- Definir valores: 2 corretos + o restante como valores errados
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

    -- Criar coletáveis com os valores definidos
    for i, obj in ipairs(pontosMapa) do
        local valor = valores[i]
        local c = Coletavel.new(obj.x, obj.y, obj.width, obj.height, valor)
        table.insert(fase.pontos, c)
    end

    -- Saídas
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

    -- Câmera
    local mapWidth = fase.map.width * fase.map.tilewidth
    local mapHeight = fase.map.height * fase.map.tileheight
    local screenWidth, screenHeight = love.graphics.getDimensions()
    utils.initCamera(mapWidth, mapHeight, screenWidth, screenHeight)
end


function fase.update(dt)
    fase.map:update(dt)
    player.update(dt, fase.world)

    -- Coletar pontos
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

    -- Checar se player encostou na saída e conta está correta
    if conta.completa then
        for _, exit in ipairs(fase.exits) do
            if player.x < exit.x + exit.w and
               player.x + player.w > exit.x and
               player.y < exit.y + exit.h and
               player.y + player.h > exit.y then

                require("main").mudarFase("quarta_fase")
                return
            end
        end
    end
end

function fase.draw()
    utils.camera:attach()

    fase.map:drawLayer(fase.map.layers["floor"])
    fase.map:drawLayer(fase.map.layers["walls"])

    player.draw()

    for _, ponto in ipairs(fase.pontos) do
        ponto:draw()
    end

    for _, exit in ipairs(fase.exits) do
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("line", exit.x, exit.y, exit.w, exit.h)
        love.graphics.setColor(1, 1, 1)
    end

    utils.camera:detach()

    conta:desenhar()
end

function fase.keypressed(key)
    player.keypressed(key)
end

return fase
