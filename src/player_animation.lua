

function new_player_animation()

    local x_flip = false
    local frame = 0

    local head_sprites = {
        standing = {198,199},
        walking = {201,201},
        jumping_up_right = {202,202},
        jumping_down_right = {200,200},
        jumping_up = {203,203},
    }

    local body_sprites = {
        standing = {214,215},
        walking = {216, 217},
        hero_landing = {213},
    }

    local function get_index_for_body(draw_info)
        local criterion
        if draw_info.vel.x==0 then
            criterion = frame < 60
        else
            criterion = frame%30 < 15
        end

        if criterion then
            return 1
        else
            return 2
        end
    end

    local function get_head_offset(draw_info)
        local x_offset = x_flip and 1 or -1
        local y_offset = (frame > 70 or frame < 10) and -4 or -5
        return {x=x_offset, y=y_offset}
    end

    local function get_index_for_head(draw_info)
        if (frame > 90) or (frame < 30) then
            return 1
        else
            return 2
        end
    end

    local function get_sprites(draw_info)
        local body_sprite_choice, head_sprite_choice

        -- standing
        if draw_info.vel.x==0 then
            if draw_info.vel.y == 0 then
                head_sprite_choice=head_sprites.standing[get_index_for_head(draw_info)]
            else
                head_sprite_choice=head_sprites.jumping_up[get_index_for_head(draw_info)]
            end
            body_sprite_choice=body_sprites.standing[get_index_for_body(draw_info)]

        -- walking
        else
            if draw_info.vel.y < -5 then
                head_sprite_choice=head_sprites.jumping_up_right[get_index_for_head(draw_info)]
            elseif draw_info.vel.y > 5 then
                head_sprite_choice=head_sprites.jumping_down_right[get_index_for_head(draw_info)]
            else
                head_sprite_choice=head_sprites.walking[get_index_for_head(draw_info)]
            end
            body_sprite_choice=body_sprites.walking[get_index_for_body(draw_info)]
        end

        if draw_info.hero_landing then
            body_sprite_choice=body_sprites.hero_landing[1]
        end
        return {body=body_sprite_choice, head=head_sprite_choice}
    end

    local function update_animation(draw_info)

        local sprite_choice = get_sprites(draw_info)
        local head_y_flip = draw_info.vel.x==0 and draw_info.vel.y > 0

        if draw_info.vel.x>0 then x_flip=false end
        if draw_info.vel.x<0 then x_flip=true end

        frame = (frame+1)%120

        return {
            head_sprite=sprite_choice.head,
            head_x=round(draw_info.pos.x)+get_head_offset(draw_info).x,
            head_y=round(draw_info.pos.y)+get_head_offset(draw_info).y,
            head_x_flip=x_flip,
            head_y_flip=head_y_flip,

            body_sprite=sprite_choice.body,
            body_x=round(draw_info.pos.x),
            body_y=round(draw_info.pos.y),
            body_x_flip=x_flip,
            body_y_flip=false,
        }
    end

    return {
        update_animation=update_animation,
    }

end


