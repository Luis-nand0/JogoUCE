local Coletavel = {}
Coletavel.__index = Coletavel

-- Vamos criar uma fonte maior só uma vez para reaproveitar
local fonteGrande = love.graphics.newFont(24) -- tamanho 24, pode ajustar

function Coletavel.new(x, y, w, h, valor)
    local self = setmetatable({}, Coletavel)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.valor = valor
    self.coletado = false
    return self
end

function Coletavel:draw()
    if not self.coletado then
        love.graphics.setFont(fonteGrande)
        love.graphics.setColor(1, 1, 0)          -- amarelo para o texto
        love.graphics.print(tostring(self.valor), self.x, self.y)
        love.graphics.setColor(1, 1, 1)          -- reset cor para branco
        love.graphics.setFont(love.graphics.getFont()) -- reset fonte padrão, opcional
    end
end

return Coletavel
