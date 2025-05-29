local primeira_fase = require("primeira_fase")
local segunda_fase = require("segunda_fase")

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
    if nome == "segunda_fase" then
        faseAtual = segunda_fase
    else
        faseAtual = primeira_fase
    end
    faseAtual.load()
end

-- Exporta a função para outras partes do código
package.loaded["main"] = {
    mudarFase = mudarFase
}
