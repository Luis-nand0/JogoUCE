local fase_final = {}
local fundo
local fonte

function fase_final.load()
    fundo = love.graphics.newImage("mapas/vitoria.png") -- use o nome correto da imagem salva
    fonte = love.graphics.newFont(48)
    love.audio.stop() -- parar música anterior se houver
end

function fase_final.update(dt)
    -- nada a atualizar
end

function fase_final.draw()
    -- Desenhar o fundo ocupando a tela inteira
    love.graphics.draw(fundo, 0, 0, 0,
        love.graphics.getWidth() / fundo:getWidth(),
        love.graphics.getHeight() / fundo:getHeight()
    )

    -- Mensagem extra (opcional)
    love.graphics.setFont(fonte)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Obrigado por jogar!", 0, love.graphics.getHeight() - 100, love.graphics.getWidth(), "center")
end

function fase_final.keypressed(key)
    if key == "escape" or key == "return" then
        love.event.quit() -- fecha o jogo
    end
end

return fase_final
