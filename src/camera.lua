

function new_camera(player)

    -- dummy initialization, should be overwritten in get_camera_position instantly
    local x_bounds = {left=0, right=128}
    local y_bounds = {bottom=0, top=128}
    local camera_position = {x=0, y=0}

    -- camera position where the player would be in the center of the frame
    local player_focus_point = {x=0, y=0}

    local function update_player_focus_point()
        player_focus_point.x = round(player.x())-56
        player_focus_point.y = round(player.y())-56
    end

    local function get_position()
        update_player_focus_point()
        camera_position = player_focus_point

        camera_position.x = mid(x_bounds.left, player_focus_point.x, x_bounds.right);
        camera_position.y = mid(y_bounds.bottom, player_focus_point.y, y_bounds.top);
        return {x=camera_position.x, y=camera_position.y}
    end

    local function set_x_bounds(x_min)
        x_bounds.left = x_min
        x_bounds.right = x_min+128
    end

    return {
        get_position=get_position,
        set_bounds=set_x_bounds,
    }
end


