

function _init()
    fps = 60
    dt = 1/fps
    player = new_character("player", "red")
    shadow_1 = new_character("shadow", "orange", player)
    shadow_2 = new_character("shadow", "yellow", shadow_1)
    shadow_3 = new_character("shadow", "green", shadow_2)
end

function _update60()
    player.update()
    shadow_1.update()
    shadow_2.update()
    shadow_3.update()
end

function _draw()
    cls()
    shadow_3.draw()
    shadow_2.draw()
    shadow_1.draw()
    player.draw()
end


