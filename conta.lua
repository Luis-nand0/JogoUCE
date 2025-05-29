local conta = {}

function conta.nova(alvo)
    local self = {
        alvo = alvo,
        coletados = {},
        completa = false
    }
    setmetatable(self, { __index = conta })
    return self
end

function conta:adicionar(valor)
    if #self.coletados < 2 then
        table.insert(self.coletados, valor)
    end
    self:verificar()
end

function conta:verificar()
    if #self.coletados == 2 then
        local soma = self.coletados[1] + self.coletados[2]
        self.completa = soma == self.alvo
    end
end

function conta:verificarSaida(player, exits)
    if not self.completa then return end

    for _, exit in ipairs(exits) do
        local colidiu =
            player.x + player.w > exit.x and
            player.x < exit.x + exit.w and
            player.y + player.h > exit.y and
            player.y < exit.y + exit.h

        if colidiu then
            require("main").mudarFase("segunda_fase")
            break
        end
    end
end

function conta:estaCorreta()
    return self.completa
end

function conta:desenhar()
    local texto = "_ + _ = " .. self.alvo
    if self.coletados[1] then texto = self.coletados[1] .. " + _ = " .. self.alvo end
    if self.coletados[2] then texto = self.coletados[1] .. " + " .. self.coletados[2] .. " = " .. self.alvo end

    local larguraTela = love.graphics.getWidth()
    local fonte = love.graphics.getFont()
    local larguraTexto = fonte:getWidth(texto)
    local x = (larguraTela - larguraTexto) / 2
    local y = 20

    love.graphics.print(texto, x, y)
end

return conta
