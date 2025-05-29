function love.conf(t)
    t.identity = "JogoEducativo"        -- Pasta de save
    t.version = "11.5"                  -- Versão do Love2D
    t.console = false                   -- Ative se quiser ver prints no terminal

    t.window.title = "Desafio da Soma"
    t.window.icon = nil                 -- Pode adicionar ícone depois
    t.window.width = 960
    t.window.height = 540
    t.window.resizable = false
    t.window.vsync = 1
    t.window.msaa = 0

    -- Desativar módulos que não serão usados
    t.modules.joystick = false
    t.modules.physics = false
    t.modules.touch = false
    t.modules.thread = false
end
