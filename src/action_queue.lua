

-- the action queue allows the shadows to copy the actions of any other
-- character uses a ring buffer for efficiency, which means the memory is
-- constant

function new_action_queue(size, pos_0)

    local ring_buffer = {}
    local index = 1

    for ii = 1,size do
        ring_buffer[ii] = pos_0
    end

    local function get_next_index() return flr(index % size + 1) end

    local function push(new_entry)
        index = get_next_index()
        ring_buffer[index] = new_entry
    end

    local function peek()
        return ring_buffer[get_next_index()]
    end

    return {
        queue_new_action=push,
        get_next_action=peek,
    }
end


