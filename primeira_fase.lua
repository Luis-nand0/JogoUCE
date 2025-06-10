local sti = require("libs.sti")
local bump = require("libs.bump")
local utils = require("utils")
local player = require("player")
local Conta = require("conta")
local Coletavel = require("coletavel")

local fase = {}
local conta

local spritePortaFechada = love.graphics.newImage("assets/porta_fechada.png")
local spritePortaAberta = love.graphics.newImage("assets/porta_aberta.png")

-- Função util para gerar valores únicos
local function gerarValoresDistratores(qtd, corretos)
    local distratores = {}
    while #distratores < qtd do
        local valor = love.math.random(1, 20)
        local duplicado = false
        for _, c in ipairs(corretos) do
            if valor == c then
                duplicado = true
                break
            end
        end
        for _, d in ipairs(distratores) do
            if valor == d then
                duplicado = true
                break
            end
        end
        if not duplicado then
            table.insert(distratores, valor)
        end
    end
    return distratores
end

function fase.load()
    fase.background = love.graphics.newImage("mapas/fundo1.png")

    fase.world = bump.newWorld(32)
    fase.map = sti("mapas/primeira_fase.lua", { "bump" })
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

        -- Criar a conta com operadores e valores
    -- Criar a conta com operadores e valores
    conta = Conta.nova()
    local valorCorreto = conta:getResultado()
    local corretos = { valorCorreto }

    -- Gerar valores distratores (diferentes do resultado correto)
    local qtdTotal = #fase.map.layers["pontos"].objects
    local qtdDistratores = math.max(0, qtdTotal - 1)
    local distratores = gerarValoresDistratores(qtdDistratores, corretos)

    -- Junta tudo para distribuir no mapa
    local todosValores = { valorCorreto }
    for _, v in ipairs(distratores) do
        table.insert(todosValores, v)
    end

    -- Embaralha os valores
    for i = #todosValores, 2, -1 do
        local j = love.math.random(i)
        todosValores[i], todosValores[j] = todosValores[j], todosValores[i]
    end

    -- Posiciona nos pontos definidos no mapa
    local i = 1
    for _, obj in ipairs(fase.map.layers["pontos"].objects) do
        if obj.properties.isPoint and i <= #todosValores then
            local valor = todosValores[i]
            local c = Coletavel.new(obj.x, obj.y, obj.width, obj.height, valor)
            table.insert(fase.pontos, c)
            i = i + 1
        end
    end

    -- Saídas
    for _, obj in ipairs(fase.map.layers["exits"].objects) do
        if obj.properties.isExit then
            table.insert(fase.exits, {
                x = obj.x,
                y = obj.y,
                w = obj.width,
                h = obj.height,
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

            conta:adicionarResposta(ponto.valor)
            ponto.coletado = true
        end
    end

    -- Checar se player encostou na saída e conta está correta
    for _, exit in ipairs(fase.exits) do
        if player.x < exit.x + exit.w and
           player.x + player.w > exit.x and
           player.y < exit.y + exit.h and
           player.y + player.h > exit.y then

            if conta:estaCorreta() then
                require("main").mudarFase("segunda_fase")
            end
        end
    end
end

function fase.draw()
    utils.camera:attach()

    -- Fundo
    local bg = fase.background
    local bgW, bgH = bg:getWidth(), bg:getHeight()
    local mapW = fase.map.width * fase.map.tilewidth
    local mapH = fase.map.height * fase.map.tileheight

    for x = 0, mapW, bgW do
        for y = 0, mapH, bgH do
            love.graphics.draw(bg, x, y)
        end
    end

    -- Camada de chão
    fase.map:drawLayer(fase.map.layers["floor"])

    -- Jogador e pontos
    player.draw()
    for _, ponto in ipairs(fase.pontos) do
        ponto:draw()
    end

    -- Saídas com sprites
    for _, exit in ipairs(fase.exits) do
        local sprite = conta:estaCorreta() and spritePortaAberta or spritePortaFechada
        love.graphics.draw(sprite, exit.x, exit.y)
    end

    utils.camera:detach()
    conta:desenhar()
end

function fase.keypressed(key)
    player.keypressed(key)
end

return fase
