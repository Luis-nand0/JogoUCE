local primeira_fase = require("primeira_fase")
local segunda_fase = require("segunda_fase")
local terceira_fase = require("terceira_fase")
local quarta_fase = require("quarta_fase")

local faseAtual = primeira_fase

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    faseAtual.load()
end

function love.update(dt)
    faseAtual.update(dt)
end

function love.draw()
    faseAtual.draw()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    faseAtual.keypressed(key)
end

-- Função para trocar de fase
function mudarFase(nome)
    if nome == "primeira_fase" then
        faseAtual = primeira_fase
    elseif nome == "segunda_fase" then
        faseAtual = segunda_fase
    elseif nome == "terceira_fase" then
        faseAtual = terceira_fase
    elseif nome == "quarta_fase" then
        faseAtual = quarta_fase
    else
        print("Fase desconhecida: " .. tostring(nome))
        return
    end

    faseAtual.load()
end

-- Exporta a função para outras partes do código
package.loaded["main"] = {
    mudarFase = mudarFase
}
