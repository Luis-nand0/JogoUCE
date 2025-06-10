local conta = {}

-- Carrega a fonte personalizada para a conta
local fonteConta = love.graphics.newFont("fontes/SuperAdorable.ttf", 36)

function conta.nova()
    local self = {
        respostaJogador = nil,
        completa = false,
        erro = false
    }

    local operadores = { "+", "-", "x" }
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
    elseif self.operador == "x" then
        a = love.math.random(1, 5)
        b = love.math.random(1, 5)
        self.alvo = a * b
    end

    self.operandos = { a, b }

    setmetatable(self, { __index = conta })
    return self
end

function conta:adicionarResposta(valor)
    self.respostaJogador = valor
    self:verificar()
end

function conta:verificar()
    if self.respostaJogador ~= nil then
        self.completa = self.respostaJogador == self.alvo
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
    local a, b = self.operandos[1], self.operandos[2]
    local resposta = self.respostaJogador or "?"
    local texto = string.format("%d %s %d = %s", a, self.operador, b, resposta)

    local larguraTela = love.graphics.getWidth()

    local fonteOriginal = love.graphics.getFont()
    love.graphics.setFont(fonteConta)

    local larguraTexto = fonteConta:getWidth(texto)
    local x = (larguraTela - larguraTexto) / 2
    local y = 20

    love.graphics.print(texto, x, y)

    if self.erro then
        local erroTexto = "Resposta errada! Aperte R para reiniciar."
        local larguraErro = fonteConta:getWidth(erroTexto)
        local xErro = (larguraTela - larguraErro) / 2
        love.graphics.setColor(1, 0.2, 0.2)
        love.graphics.print(erroTexto, xErro, y + 40)
        love.graphics.setColor(1, 1, 1)
    end

    love.graphics.setFont(fonteOriginal)
end
function conta:getResultado()
    return self.alvo
end


return conta
