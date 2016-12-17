----------------------------------
-- 自定义参数
----------------------------------
local root = './'
local serverpath = root.."gameserver/"

thread = 4
cpath  = root.."cservice/?.so"
harbor = 0
daemon = nil
logger = nil

lua_path   = root.."lualib/?.lua;"..serverpath.."/?.lua;"..root.."service/?.lua"
lua_cpath  = root.."luaclib/?.so;"..serverpath.."/?.so"
lualoader  = root.."lualib/loader.lua"
luaservice = root.."service/?.lua;"..serverpath.."/?.lua;"..serverpath.."service/?.lua"
preload    = serverpath.."init.lua"	-- run preload.lua before every lua service run

-- 采用snlua bootstrap启动hello-world模块
bootstrap  = "snlua bootstrap"
start      = "main"
