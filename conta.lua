local conta = {}

function conta.nova()
    local self = {
        coletados = {},
        completa = false
    }

    -- Escolhe operador aleatório
    local operadores = { "+", "-", "*" }
    self.operador = operadores[love.math.random(1, #operadores)]

    -- Gera operandos de acordo com o operador
    local a, b
    if self.operador == "+" then
        a = love.math.random(1, 10)
        b = love.math.random(1, 10)
        self.alvo = a + b
    elseif self.operador == "-" then
        a = love.math.random(5, 15)
        b = love.math.random(1, a)  -- garante que não seja negativo
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
    end
end

function conta:estaCorreta()
    return self.completa
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
    local fonte = love.graphics.getFont()
    local larguraTexto = fonte:getWidth(texto)
    local x = (larguraTela - larguraTexto) / 2
    local y = 20

    love.graphics.print(texto, x, y)
end

return conta
