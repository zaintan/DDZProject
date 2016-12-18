local SocketCMD = {
	CLIENT_REQUEST_LOGIN   				=  0x1001,--客户端请求登录
	SERVER_RESPONSE_LOGIN  				=  0x1002,--server返回登录结果

	CLIENT_REQUEST_JOIN_ROOM            =  0x1003,--客户端请求 加入房间
	SERVER_RESPONSE_ENTER_ROOM          =  0x1004,--server返回进入房间信息

	CLIENT_REQUEST_CREATE_ROOM          =  0x1005,--客户端请求 创建房间

	CLIENT_REQUEST_READY                =  0x1006,--客户端请求 准备
	SERVER_NOTICE_PLAYER_ENTER          =  0x1007,--server广播 用户 进入
	SERVER_NOTICE_PLAYER_READY          =  0x1008,--server广播 用户 准备

	CLIENT_REQUEST_TAKE_OPERATOR        =  0x1009,--客户端请求 操作(出牌,下注,加注,看牌,弃牌)
	SERVER_NOTICE_PLAYER_OPERATOR       =  0x1010,--server广播 用户操作

}
return SocketCMD