local suit = require "libs.suit"
local pauseMenu = {}

local show = false
local cooldown = 0

local fonteArial

function pauseMenu.load()
    -- Ajuste o caminho para onde o arquivo arial.ttf estiver no seu projeto
    fonteArial = love.graphics.newFont("assets/fonts/arial.ttf", 16)
    suit.theme.font = fonteArial
end

function pauseMenu.toggle()
    if show then
        pauseMenu.close()
    else
        pauseMenu.open()
    end
end

function pauseMenu.open()
    show = true
end

function pauseMenu.close()
    show = false
    cooldown = 0.2  -- bloqueia reabertura por 0.2 segundos
end

function pauseMenu.isVisible()
    return show
end

function pauseMenu.update()
    if not show then return end

    local larguraTela = love.graphics.getWidth()
    local alturaTela = love.graphics.getHeight()

    local larguraBotao = 200
    local alturaBotao = 40
    local espacamento = 10
    local totalAltura = alturaBotao * 2 + espacamento

    local x = (larguraTela - larguraBotao) / 2
    local y = (alturaTela - totalAltura) / 2

    suit.layout:reset(x, y)
    suit.layout:padding(10, 10)

    if suit.Button("Continuar", suit.layout:row(larguraBotao, alturaBotao)).hit then
        pauseMenu.close()
    end

    if suit.Button("Sair do Jogo", suit.layout:row()).hit then
        love.event.quit()
    end
end

function pauseMenu.draw()
    if not show then return end

    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1)

    suit.draw()
end

function pauseMenu.updateCooldown(dt)
    if cooldown > 0 then
        cooldown = cooldown - dt
    end
end

function pauseMenu.canToggle()
    return cooldown <= 0
end

return pauseMenu
