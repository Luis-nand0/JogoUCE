local menu = {}
local suit = require "libs/suit"

-- Variáveis do menu
local larguraTela, alturaTela
local opcoes = false -- Estado do menu de opções
local imageFundo

function menu.load()
    larguraTela = love.graphics.getWidth()
    alturaTela = love.graphics.getHeight()
    imageFundo = love.graphics.newImage("assets/images/fundo-menu.png")
end

function menu.update(dt)
    suit.layout:reset(larguraTela/2 - 100, alturaTela/2 - 100)
    
    if not opcoes then
        -- Menu principal
        if suit.Button("Iniciar Jogo", suit.layout:row(200, 40)).hit then
            -- Inicia a primeira fase
            local main = require("main")
            if main.mudarFase then
                main.mudarFase("primeira_fase")
            end
        end
        
        suit.layout:row() -- Espaço entre botões
        
        if suit.Button("Controles", suit.layout:row(200, 40)).hit then
            opcoes = true
        end
        
        suit.layout:row() -- Espaço entre botões
        
        if suit.Button("Sair", suit.layout:row(200, 40)).hit then
            love.event.quit()
        end
    else
        -- Menu de opções
        suit.Label("Menu de Opções", suit.layout:row(200, 30))
        suit.layout:row() -- Espaço
        
        suit.Label("(Opções serão implementadas aqui)", suit.layout:row(250, 30))
        suit.layout:row() -- Espaço
        suit.layout:row() -- Espaço
        
        if suit.Button("Voltar", suit.layout:row(200, 40)).hit then
            opcoes = false
        end
    end
end

function menu.draw()
    -- Desenha a imagem de fundo
    love.graphics.setColor(1, 1, 1, 1) -- Cor branca para não alterar a imagem
    
    if imageFundo then
        -- Redimensiona a imagem para cobrir toda a tela
        local scaleX = larguraTela / imageFundo:getWidth()
        local scaleY = alturaTela / imageFundo:getHeight()
        love.graphics.draw(imageFundo, 0, 0, 0, scaleX, scaleY)
    else
        -- Fundo colorido como fallback caso a imagem não carregue
        love.graphics.setColor(0.1, 0.1, 0.2, 1)
        love.graphics.rectangle("fill", 0, 0, larguraTela, alturaTela)
    end
    
    -- Overlay semi-transparente para dar contraste com o texto
    love.graphics.setColor(0, 0, 0, 0.4) -- Preto 40% transparente
    love.graphics.rectangle("fill", 0, 0, larguraTela, alturaTela)
    
    -- Título
    love.graphics.setColor(1, 1, 1, 1)
    local fonteTitulo = love.graphics.newFont(24)
    love.graphics.setFont(fonteTitulo)
    local titulo = "JOGO UCE"
    local tituloLargura = fonteTitulo:getWidth(titulo)
    love.graphics.print(titulo, (larguraTela - tituloLargura) / 2, 80)
    
    -- Desenha a interface SUIT
    suit.draw()
end

function menu.keypressed(key)
    suit.keypressed(key)
    
    -- Permite navegação com ESC no menu de opções
    if key == "escape" and opcoes then
        opcoes = false
    end
end

function menu.textinput(t)
    suit.textinput(t)
end

return menu