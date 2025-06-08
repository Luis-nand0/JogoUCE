local suit = require("libs.suit")
local pauseMenu = require("pause_menu")

local primeira_fase = require("primeira_fase")
local segunda_fase   = require("segunda_fase")
local terceira_fase  = require("terceira_fase")
local quarta_fase    = require("quarta_fase")
local fase_final     = require("fase_final")
local menu           = require("menu")

local fonteBase -- variável para a fonte base do jogo

-- Começa no menu
local faseAtual = menu
local nomeDaFaseAtual = "menu"

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Carrega a fonte SuperAdorable no tamanho 20 (mude se quiser outro tamanho)
    fonteBase = love.graphics.newFont("fontes/ttf/DejaVuSans.ttf")
    love.graphics.setFont(fonteBase)

    faseAtual.load()
end

function love.update(dt)
    -- atualiza cooldown (para ESC) toda frame
    if pauseMenu.updateCooldown then
        pauseMenu.updateCooldown(dt)
    end

    if pauseMenu.isVisible() then
        pauseMenu.update()
        return  -- bloqueia update da fase enquanto pause estiver visível
    end

    faseAtual.update(dt)
end

function love.draw()
    faseAtual.draw()
    pauseMenu.draw()
end

function love.keypressed(key)
    -- R: reiniciar a fase atual (exceto no menu e sem pause)
    if key == "r" then
        if nomeDaFaseAtual ~= "menu" and not pauseMenu.isVisible() then
            mudarFase(nomeDaFaseAtual)
        end
        return
    end

    -- repassa outras teclas
    if not pauseMenu.isVisible() and faseAtual.keypressed then
        faseAtual.keypressed(key)
    end
end

function love.keyreleased(key)
    -- ESC: aqui tratamos somente na keyreleased, para evitar toggle duplo
    if key == "escape" then
        if nomeDaFaseAtual ~= "menu" then
            if pauseMenu.canToggle and pauseMenu.canToggle() then
                pauseMenu.toggle()
            end
        else
            love.event.quit()
        end
    end
end

function love.textinput(t)
    if not pauseMenu.isVisible() and faseAtual.textinput then
        faseAtual.textinput(t)
    end
end

function love.mousepressed(x, y, button)
    if not pauseMenu.isVisible() and faseAtual.mousepressed then
        faseAtual.mousepressed(x, y, button)
    end
end

function love.mousereleased(x, y, button)
    if not pauseMenu.isVisible() and faseAtual.mousereleased then
        faseAtual.mousereleased(x, y, button)
    end
end

-- Troca de fases
function mudarFase(nome)
    nomeDaFaseAtual = nome

    if nome == "primeira_fase" then
        faseAtual = primeira_fase
    elseif nome == "segunda_fase" then
        faseAtual = segunda_fase
    elseif nome == "terceira_fase" then
        faseAtual = terceira_fase
    elseif nome == "quarta_fase" then
        faseAtual = quarta_fase
    elseif nome == "fase_final" then
        faseAtual = fase_final
    elseif nome == "menu" then
        faseAtual = menu
    else
        print("Fase desconhecida: " .. tostring(nome))
        return
    end

    if pauseMenu.close then
        pauseMenu.close()
    end
    faseAtual.load()
end

package.loaded["main"] = {
    mudarFase = mudarFase
}
