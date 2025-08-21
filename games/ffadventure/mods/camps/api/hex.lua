local gen = PcgRandom(os.time())

local HEX = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"}

_c.generate = function (_looper)
    if _looper == nil then
        _looper = 0
    end
    local val = ""
    for _i in ipairs({1, 2, 3, 4, 5, 6}) do
        val = val .. HEX[gen:rand_normal_dist(0, 16)]
    end
    if camps.id_exists(val) and _looper > 16 then
        val = _c.generate(_looper+1)
    end
    return val
end
