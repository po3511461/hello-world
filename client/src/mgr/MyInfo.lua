MyInfo = {
	password = "", -- 密码
	mobilePhone = "",  -- 手机号
	promoCode= "",  -- 邀请码
	nickName="",  -- 昵称
	avatar="",  --头像
	pid=0,  -- pid;
	jb ="", -- 金币;
	roomList = {};
	roomData = nil; -- 进入房间后，roomdata赋值，退出房间清空
	roomID = nil; -- 进入房间后，roomid赋值， 退出房间清空
	bankGold = 0; --银行金币
	introduction = ""; -- 个人信息
	rankList = {}; -- 排行榜数据
	uniqueId = 0 ;-- 用于转账的id 
};