

-- file containing player stuff
function new_character(type, color, tracked_character)
    local pos = {x=60, y=248}
    local vel = {x=0, y=0}
    local acc = {x=0, y=0}

    local gravity = 200
    local max_speed = 80

    local player_animation = new_player_animation()

    local frame = 0

    local sprite_info = {
        sprite=1,
        x=pos.x,
        y=pos.y,
        x_flip=false,
        y_flip=false,
    }
    local facing_left = false
    local facing_right = false
    local hero_landing = false
    local face_plant = false
    local hero_landing_frames = 200

    local can_jump = true
    local on_ground

    local is_shadow = type == "shadow"
    local action_queue = new_action_queue(20, sprite_info)
    local in_flight = false

    local colors = {
        ["orange"]=9,
        ["yellow"]=10,
        ["green"]=11,
        ["red"]=8,
        ["blue"]=1,
        ["pink"]=2,
    }
    local color_value = colors[color]

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
        if not face_plant then
            if buttons.left then
                acc.x = -80
            elseif buttons.right then
                acc.x = 100
            else
                vel.x = 0
                acc.x = 0
            end
        else
            acc.x = -3*vel.x
        end

        on_ground = pos.y==248

        -- initial jump, followed by "gliding upward", depending if jump button
        -- is still pressed
        acc.y = gravity
        if buttons.jump and can_jump then
            if on_ground then
                acc.y = -10*gravity
            else
                -- acc.y = -.3*gravity
                acc.y = -gravity
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
        vel.x = mid(-max_speed, vel.x, max_speed)
        pos.y = min(248, pos.y)

        -- touchdown
        if pos.y >= 248 and acc.y >= 0 then

            -- player was to fast, do hero landing
            if vel.y > 200 then
                player_camera.trigger_camera_shake("touchdown")
                sfx(0)
                hero_landing_frames = 0
                if abs(vel.x) > (max_speed - 1) then
                    face_plant = true
                else
                    hero_landing = true
                    vel.x = 0
                end
            end

            pos.y = 248
            vel.y = 0
            acc.y = 0
        end

        if hero_landing_frames < 60 then
            if hero_landing then vel.x=0 end
            hero_landing_frames += 1
            can_jump = false
        else
            hero_landing = false
            face_plant = false
            can_jump = true
        end
    end

    local function check_collision()

    end

    -- collect everything that is releveant for drawing
    local function get_draw_info()
        return {
            pos=pos,
            vel=vel,
            acc=acc,
            on_ground=on_ground,
            hero_landing=hero_landing,
            face_plant=face_plant,
        }
    end

    -- shadow only
    -- fetches next action from action queue and writes it to sprite info
    local function follow()
        action_queue.queue_new_action(tracked_character.get_sprite_info())
        sprite_info = action_queue.get_next_action()
    end

    -- takes information on how sprite should be displayed and saves it
    local function write_sprite_info()
        sprite_info = player_animation.update_animation(get_draw_info())
    end

    -- draw player, and color the shirt
    local function draw_sprite()
        pal(8, color_value)
        if is_shadow then
            pal(15, 13)
            pal(12,1)
            pal(13,5)
            pal(7,5)
        end
        spr(sprite_info.body_sprite,
            sprite_info.body_x,
            sprite_info.body_y,
            1,
            1,
            sprite_info.body_x_flip,
            sprite_info.body_y_flip)
        spr(sprite_info.head_sprite,
            sprite_info.head_x,
            sprite_info.head_y,
            1,
            1,
            sprite_info.head_x_flip,
            sprite_info.head_y_flip)
        pal()
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

    local function draw()
        if not is_shadow then
            write_sprite_info()
        end
        draw_sprite()
    end

    return {
        get_sprite_info=function() return sprite_info end,
        update=update,
        draw=draw,
        pos=function() return pos end,
        vel=function() return vel end,
        acc=function() return acc end,
    }
end


