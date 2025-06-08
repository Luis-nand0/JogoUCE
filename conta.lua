local conta = {}

-- Carrega a fonte personalizada para a conta
local fonteConta = love.graphics.newFont("fontes/SuperAdorable.ttf", 36)

function conta.nova()
    local self = {
        coletados = {},
        completa = false,
        erro = false
    }

    local operadores = { "+", "-", "*" }
    self.operador = operadores[love.math.random(1, #operadores)]

    local a, b
    if self.operador == "+" then
        a = love.math.random(1, 10)
        b = love.math.random(1, 10)
        self.alvo = a + b
    elseif self.operador == "-" then
        a = love.math.random(5, 15)
        b = love.math.random(1, a)
        self.alvo = a - b
    elseif self.operador == "*" then
        a = love.math.random(1, 5)
        b = love.math.random(1, 5)
        self.alvo = a * b
    end

    self.operandos = { a, b }

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
        local resultado
        if self.operador == "+" then
            resultado = self.coletados[1] + self.coletados[2]
        elseif self.operador == "-" then
            resultado = self.coletados[1] - self.coletados[2]
        elseif self.operador == "*" then
            resultado = self.coletados[1] * self.coletados[2]
        end
        self.completa = resultado == self.alvo
        self.erro = not self.completa
    end
end

function conta:estaCorreta()
    return self.completa
end

function conta:deuErro()
    return self.erro
end

function conta:desenhar()
    local texto = "_ " .. self.operador .. " _ = " .. self.alvo
    if self.coletados[1] then
        texto = self.coletados[1] .. " " .. self.operador .. " _ = " .. self.alvo
    end
    if self.coletados[2] then
        texto = self.coletados[1] .. " " .. self.operador .. " " .. self.coletados[2] .. " = " .. self.alvo
    end

    local larguraTela = love.graphics.getWidth()

    local fonteOriginal = love.graphics.getFont()
    love.graphics.setFont(fonteConta)

    local larguraTexto = fonteConta:getWidth(texto)
    local x = (larguraTela - larguraTexto) / 2
    local y = 20

    love.graphics.print(texto, x, y)

    if self.erro then
        local erroTexto = "Conta errada! Aperte R para reiniciar."
        local larguraErro = fonteConta:getWidth(erroTexto)
        local xErro = (larguraTela - larguraErro) / 2
        love.graphics.setColor(1, 0.2, 0.2)
        love.graphics.print(erroTexto, xErro, y + 40)
        love.graphics.setColor(1, 1, 1)
    end

    love.graphics.setFont(fonteOriginal)
end

return conta
