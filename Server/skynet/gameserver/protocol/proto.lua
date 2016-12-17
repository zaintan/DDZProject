local sprotoparser = require "sprotoparser"

local proto = {}

proto.c2s = sprotoparser.parse [[
.package {
	type 0 : integer
	session 1 : integer
}

msgTest 1 {
    request {
        id 0 : integer
        name 1 : string
    }
}

handshake 2 {
	response {
		msg 0  : string
	}
}

get 3 {
	request {
		what 0 : string
	}
	response {
		result 0 : string
	}
}

set 4 {
	request {
		what 0 : string
		value 1 : string
	}
}

quit 5 {}

]]

proto.s2c = sprotoparser.parse [[
.package {
	type 0 : integer
	session 1 : integer
}

heartbeat 1 {}
]]

return proto
