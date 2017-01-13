local LoginModel = class("LoginMode", BaseModel)

LoginModel.REQUEST_LOGIN = "LOGIN_REQUEST_LOGIN" 		--请求登录

-- 定义属性
LoginModel.schema = clone(BaseModel.schema)
LoginModel.schema["curLoginType"] = {"number", GameConstant.LoginType.WECHAT}  --值类型，默认值

function LoginModel:ctor(  )
end

function LoginModel:getCurLoginType(  )
	return self.curLoginType_
end

function LoginModel:setCurLoginType( loginType )
	self.curLoginType_ = loginType
end

return LoginModel