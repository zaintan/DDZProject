local sprotoparser = require "lualib.sproto.sprotoparser"--require "sprotoparser"
local proto = {}

proto.c2s = sprotoparser.parse [[
.package {
    type 0 : integer
    session 1 : integer
}

login 1 {
    request {
        smid 0 : string
        type 1 : integer
    }
    response {
        status 0 : integer
        msg 1 : string
        username 2 : string
        ontable 3 : boolean
    }
}

createRoom 2 {
    request {
        level 0 : integer
        playtype 1 : integer
    }
    response {
        status 0 : integer
        fid    1 : string
    }
}

joinRoom 3 {
    request {
        uid 0 : string 
        fid 1 : string 
    }
    response {
        status 0 : integer
        fid    1 : string
    }
}

]]

proto.s2c = sprotoparser.parse [[
.package {
    type 0 : integer
    session 1 : integer
}

heartbeat 1 {}
]]

return proto
