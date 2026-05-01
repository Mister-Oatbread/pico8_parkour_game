

function _init()
    fps = 60
    dt = 1/fps
    player = new_character("player", "red")
    shadow_1 = new_character("shadow", "orange", player)
end

function _update60()
    player.update()
    shadow_1.update()
end

function _draw()
    cls()
    player.draw()
    shadow_1.draw()
end


