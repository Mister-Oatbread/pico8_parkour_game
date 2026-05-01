

-- file containing player stuff
function new_character(type, color, tracked_character)
    local pos = {x=60, y=120}
    local vel = {x=0, y=0}
    local acc = {x=0, y=0}

    local gravity = 200

    local is_shadow = type == "shadow"
    local action_queue = new_action_queue(3)
    local in_flight = false
    local tracked_character = tracked_character

    local color_value
    if color == "orange" then
        color_value = 9
    elseif color == "yellow" then
        color_value = 10
    elseif color == "green" then
        color_value = 11
    else
        color_value = 8
    end

    local buttons = {
        up=false,
        down=false,
        left=false,
        right=false,
        jump=false,
        swap=false,
    }

    -- write button actions to the buttons table
    local function fetch_inputs()
        buttons.left = btn(0) and not btn(1)
        buttons.right = btn(1) and not btn(0)
        buttons.jump = btn(4)
    end

    -- take inputs and change player state based to reflect inputs
    local function process_inputs()
        -- accelerate to the left or the right
        if buttons.left then
            acc.x = -100
        elseif buttons.right then
            acc.x = 100
        else
            vel.x = 0
            acc.x = 0
        end

        -- initial jump, followed by "gliding upward", depending if jump button
        -- is still pressed
        acc.y = gravity
        if buttons.jump then
            if vel.y == 0 and acc.y == gravity then
                acc.y = -30*gravity
            else
                acc.y = .5*gravity
            end
        end
    end

    -- apply physics to the player
    local function do_physics()
        pos.x += dt*vel.x
        pos.y += dt*vel.y

        vel.x += dt*acc.x
        vel.y += dt*acc.y

        -- limit x velocity and y position
        vel.x = mid(-50, vel.x, 50)
        pos.y = min(120, pos.y)
        if pos.y == 120 and acc.y >= 0 then vel.y = 0 end
    end

    local function follow()
        action_queue.queue_new_action(tracked_character.get_position())
        pos = action_queue.get_next_action()
    end

    local function update()
        if is_shadow then
            follow()
        else
            fetch_inputs()
            process_inputs()
            do_physics()
        end
    end

    -- draw player, and color the shirt
    local function draw()
        local sprite = buttons.jump and 17 or 1
        pal(9, color_value)
        spr(sprite, round(pos.x), round(pos.y))
        pal()
    end

    return {
        get_position=function() return pos end,
        update=update,
        draw=draw,
    }
end


