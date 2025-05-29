local Camera = require("libs/hump/camera")

local utils = {}

utils.camera = nil

function utils.initCamera(mapWidth, mapHeight, screenWidth, screenHeight)
    utils.camera = Camera(mapWidth / 2, mapHeight / 2)

    -- Ajustar escala para caber na tela inteira (opcional)
    local scaleX = screenWidth / mapWidth
    local scaleY = screenHeight / mapHeight
    local scale = math.min(scaleX, scaleY)

    utils.camera:zoom(scale)
end

return utils
