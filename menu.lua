local menu = {}
local suit = require "libs.suit"

-- Variáveis do menu
local larguraTela, alturaTela
local opcoes = false
local imageFundo
local fonteControles
local fonteUI
local imagemControles

function menu.load()
    larguraTela = love.graphics.getWidth()
    alturaTela = love.graphics.getHeight()
    imageFundo = love.graphics.newImage("assets/images/fundo-menu.png")
    imagemControles = love.graphics.newImage("assets/configuracoes.png") -- coloque aqui o caminho da imagem gerada

    -- Fontes
    fonteControles = love.graphics.newFont("fontes/ttf/DejaVuSans-Oblique.ttf", 18)
    fonteUI = love.graphics.newFont("fontes/ttf/DejaVuSans-Oblique.ttf", 16)
    suit.theme.font = fonteUI
end

function menu.update(dt)
    local larguraBotoes = 250
    local alturaBotoes = 40

    if not opcoes then
        local totalBotoes = 3
        local alturaTotal = totalBotoes * (alturaBotoes + 10)
        local posY = (alturaTela / 2) - (alturaTotal / 2)

        suit.layout:reset(
            larguraTela / 2 - larguraBotoes / 2,
            posY
        )

        if suit.Button("Iniciar Jogo", suit.layout:row(larguraBotoes, alturaBotoes)).hit then
            local main = require("main")
            main.mudarFase("primeira_fase")
        end

        if suit.Button("Controles", suit.layout:row(larguraBotoes, alturaBotoes)).hit then
            opcoes = true
        end

        if suit.Button("Sair", suit.layout:row(larguraBotoes, alturaBotoes)).hit then
            love.event.quit()
        end
    else
        -- Quando opcoes = true: botão "Voltar" fica abaixo da imagem de controles
        -- Posicionamos o layout para o botão "Voltar" centralizado horizontalmente e verticalmente com base na imagem

        local imgW = imagemControles:getWidth()
        local imgH = imagemControles:getHeight()

        local posImagemY = (alturaTela / 2) - (imgH / 2) - 50  -- Ajuste -50 para subir um pouco a imagem se quiser

        local posBotaoY = posImagemY + imgH + 20 -- 20 px abaixo da imagem

        suit.layout:reset(
            larguraTela / 2 - larguraBotoes / 2,
            posBotaoY
        )

        if suit.Button("Voltar", suit.layout:row(larguraBotoes, alturaBotoes)).hit then
            opcoes = false
        end
    end
end

function menu.draw()
    love.graphics.setFont(fonteControles)

    -- Fundo
    love.graphics.setColor(1, 1, 1, 1)
    if imageFundo then
        local scaleX = larguraTela / imageFundo:getWidth()
        local scaleY = alturaTela / imageFundo:getHeight()
        love.graphics.draw(imageFundo, 0, 0, 0, scaleX, scaleY)
    else
        love.graphics.setColor(0.1, 0.1, 0.2, 1)
        love.graphics.rectangle("fill", 0, 0, larguraTela, alturaTela)
    end

    -- Overlay
    love.graphics.setColor(0, 0, 0, 0.4)
    love.graphics.rectangle("fill", 0, 0, larguraTela, alturaTela)

   

    -- Imagem de controles (centralizada vertical e horizontalmente)
    if opcoes and imagemControles then
        local imgW = imagemControles:getWidth()
        local imgH = imagemControles:getHeight()
        local posImagemY = (alturaTela / 2) - (imgH / 2) - 50 -- mesmo valor do update

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(imagemControles, (larguraTela - imgW) / 2, posImagemY)
    end

    -- Interface (botões)
    suit.draw()
end

function menu.keypressed(key)
    suit.keypressed(key)
    if key == "escape" and opcoes then
        opcoes = false
    end
end

function menu.textinput(t)
    suit.textinput(t)
end

return menu
