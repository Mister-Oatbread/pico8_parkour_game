

function _init()
    fps = 60
    dt = 1/fps
    player = new_character("player", "red")
    shadow_1 = new_character("shadow", "orange", player)
    shadow_2 = new_character("shadow", "yellow", shadow_1)
    shadow_3 = new_character("shadow", "green", shadow_2)

    player_camera = new_camera(player)
end

function _update60()
    player.update()
    shadow_1.update()
    shadow_2.update()
    shadow_3.update()
end

function _draw()
    cls()
    cam_pos = player_camera.get_position()
    camera(cam_pos.x, cam_pos.y)
    map()
    shadow_3.draw()
    shadow_2.draw()
    shadow_1.draw()
    player.draw()
end


