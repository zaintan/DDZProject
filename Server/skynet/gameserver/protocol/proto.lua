local mes = [[
    .UserInfo {
        age 0 : integer
        name 1 : string
    }

    .HelloMsg {
        content 0 : string
        user 1 : UserInfo
        bools 2 : *boolean
        number 3: integer
    }

    .Answer {
        name 0 : string
        content 1 : string
    }
]]

return mes


--[[
local sprotoparser = require "sprotoparser"

local proto = {}

proto.c2s = sprotoparser.parse [[
    .UserInfo {
        age 0 : integer
        name 1 : string
    }

    .HelloMsg {
        content 0 : string
        user 1 : UserInfo
        bools 2 : *boolean
        number 3: integer
    }
]]

--[[
proto.s2c = sprotoparser.parse [[
    .Answer {
        name 0 : string
        content 1 : string
    }
]]

--return proto
