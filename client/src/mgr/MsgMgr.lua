MsgMgr = {
    socketName = "tcp";
    ip = nil;
    port = nil;
    recvFuncs = {};
    reconnect_time = 0; --重连次数
    connecting = false; -- 连接进行中
    wait_start_time = 0; --上次发消息的时间
    waitSche = nil;  -- 消息倒计时
    zd = nil; -- 消息遮挡
    waitCmd = {};
    cmd_info = {
        [1] = {send = "ReqPing", recv = "ResPong"},
        [100] = {send = "CreateAccount", recv = "RecvCreateAccount"},
        [101] = {send = "Login", recv = "RecvCreateAccount"},
        [102] = {send = "ReqLogoutMsg", recv = "ResLogoutMsg"}, --退出游戏
        [20001] = {send = "JoinRoomMsg", recv = "RecvJoinRoomMsg"}, -- 进房间，
        [20002] = {send = "ExitRoomMsg"}, -- 退出房间
        [20003] = {send = "ReceiveRedPacketMsg", recv = "RecvReceiveRedPacketMsg"}, --领取红包
        [20004] = {send = "ReqRedPacketRecordMsg", recv = "ResRedPacketRecordMsg"}, --红包领取记录
        [20005] = {send = "", recv = "RedPacketUpdateMsg"}, --红包推送信息
        [30001] = {send = "ReqDepositeGoldMsg", recv = "ResDepositeWithdrawGoldMsg"}, -- 存款
        [30002] = {send = "ReqWithdrawGoldMsg", recv = "ResDepositeWithdrawGoldMsg"}, -- 取款
        [30003] = {send = "ReqBankRecordsMsg", recv = "ResBankRecordsMsg"}, -- 银行记录（包括存取款，转账收账，充值记录）
        [30004] = {send = "ReqTransferGoldMsg", recv = "ResTransferGoldMsg"}, -- 转账
        [30007] = {send = "ReqModifyBankPwdMsg", recv = "ResModifyBankPwdMsg"}, -- 修改密码
        [30008] = {send = "", recv = "ResGoldChangeMsg"}, -- 身上金币推送
        [30009] = {send = "", recv = "ResBankGoldChangeMsg"}, -- 银行金币推送
        [30005] = {send = "", recv = "ResPushReceivedTransferGoldMsg"}, --转账推送
        [1001] = {send = "ReqModifyPlayerInfoMsg", recv = "ResModifyPlayerInfoMsg"}; --请求修改个人资料，修改资料需要扣除一定的金币
        [1002] = {send = "ReqModifyPlayerPasswordMsg", recv = "ResModifyPlayerPasswordMsg" }; -- 请求修改玩家登录密码
        [1003] = {send = "ReqModifyPlayerContactInfoMsg", recv = "ResModifyPlayerContactInfoMsg" }; --请求修改联系方式（电话号码，QQ，微信，邮箱）-开发中，后期功能
        [1004] = {send = "ReqPlayerInfoMsg", recv = "ResPlayerInfoMsg" }; 
        [4001] = {send = "ReqRankListMsg", recv =  "ResRankListMsg"}; --  排行榜列表                     
    };  
}

local self = MsgMgr
MsgMgr.connect = function (ip,port, connectCallBack)
    -- body
    if not ip or not port then
        print("socket connect failed, ip or  port is nil");
        return;
    end 
    if not self.isreconnecting then 
        self.connecting = true;
    end 

    self.ip = ip;
    self.port = port;

    --注册socket 连接回调函数 
    Messager[APPMessageCenter] = {} 
    Messager[APPMessageCenter].getMessage = function (self, erroinfo )
        -- body
        -- 断线重连
        if MsgMgr.isreconnecting then 
            if  connectCallBack  then 
                connectCallBack(erroinfo)
            end 
            return;
        end 

        if erroinfo.cmd == EVENT_CONNECTED then  -- socket连接成功
            -- 心跳
            if MsgMgr.heartSche then 
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(MsgMgr.heartSche);
                MsgMgr.heartSche = nil  -- 消息倒计时
            end 

            MsgMgr.heartSche= cc.Director:getInstance():getScheduler():scheduleScriptFunc(function ( ... )
                -- body
                local param =  {}
                MsgMgr.sendData({cmd = 1, msg =param}); 
            end, 2, false);

            MsgMgr.connecting = false;
    
            if connectCallBack then
                connectCallBack(erroinfo);
            end
            
        elseif erroinfo.cmd == EVENT_CONNECT_TIMEOUT then -- socket连接超时
            MsgMgr.socketError()
        elseif erroinfo.cmd == EVENT_DISCONNECTED then -- socket连接断开
            MsgMgr.socketError()
        elseif erroinfo.cmd == EVENT_CONNECT_FAILURE then --socket连接错误
            MsgMgr.socketError()
        end

        if MsgMgr.connecting then  --连接中才调用回调
            if connectCallBack then
                connectCallBack(erroinfo);
            end   
        end
    end

     --注册 socket 消息接收回调
    function currentScene:getNetMessage(name, cmd, code, messdata)
        if name == MsgMgr.socketName then
            -- 消息返回触发监听函数。
            MsgMgr.recvMsg(cmd, code, messdata)
        end 
    end 

    --建立socket连接，参数1：socket的名字；参数2：连接的ip地址；参数3：连接的端口号
    socketwork.connect(self.socketName, ip, port); 

    --注册所有的pb文件
    RegisterProtoFile("pb/ReqMessage.pb"); 
    RegisterProtoFile("pb/ResponseMessage.pb"); 
    RegisterProtoFile("pb/ResponseBankMessage.pb"); 
    RegisterProtoFile("pb/RequestBankMessage.pb"); 
    RegisterProtoFile("pb/RequestPlayerMessage.pb"); 
    RegisterProtoFile("pb/RequestRankMessage.pb"); 
    RegisterProtoFile("pb/ResponsePlayerMessage.pb"); 
    RegisterProtoFile("pb/ResponseRankMessage.pb"); 
    
    -- 添加全局消息消息监听
    MsgMgr.addCmdCallBack(30005, function (data)
        -- body
        -- 更新银行金币
        if data.code == 0 then 
            MyInfo.bankGold = data.data.bankGold;
            -- 更新银行金币
        end
    end) 

    MsgMgr.addCmdCallBack(30008, function (data)
        -- body
        -- 更新金币
        if data.code == 0 then 
            MyInfo.jb = data.data.gold;
        end
    end)

    MsgMgr.addCmdCallBack(30009, function (data)
        -- body
        -- 更新银行金币
        if data.code == 0 then 
            MyInfo.bankGold = data.data.bankGold;
        end
    end)

    MsgMgr.addCmdCallBack(20005,function (data)
        -- body
        if data.code == 0 then  -- 新增红包local info = data.data; if info.roomId == MyInfo.roomID then  self:addRedPackage(data.)
            local info = data.data ; 
            if MyInfo.roomID and info.roomId == MyInfo.roomID then  -- 新红包推送
                local scene = display.getRunningScene()
                local view = scene:getChildByName("viewBase")
                view:addRedPackage(info.newRed)
            end
        end
    end)

    --退出游戏通知
    MsgMgr.addCmdCallBack(102, function (data)
        -- body
        if data.code == 0 then 
            local _type = data.data.type;
            MsgMgr.outtype = _type
            MsgMgr.loginout = true;
            -- 断开tcp连接
            socketwork.disConnect(MsgMgr.socketName);
            MsgMgr.reEnterGame();
        end 
    end)
end

--发送socket消息
-- @param data （table类型）
    -- cmd 消息码  
    -- msg  参数 
MsgMgr.sendData = function (data)
    -- body
    if not data.cmd then
        print("socket sendData failed, cmd is nil"); 
    end  

    local cmd_info = self.cmd_info[data.cmd];
    if not cmd_info then 
        print("socket sendData failed, cmd is not register"); 
        return;
    end 

    print("socket sendData: " .. table.tostring(data))
    local messageObj = nil 
    if cmd_info.send then  
        --encode一个消息体，参数1：使用哪个proto中的message对象  参数2：需要被encode的lua对象   
        messageObj = protobuf.encode(cmd_info.send, data.msg)
    end

    -- 发送 socket 信息 
    local err = SendNetMessage(data.cmd, messageObj, self.socketName);
    if err == -10001 or err == -10002 then  -- 没找到该socekt/ socket已经断开， 重新回到登录界面。
        self:reconnected(); -- 进入断线重连机制
    end 
end


--等待消息回调
MsgMgr.waitMsg = function (cmd, callback)
    if not cmd or not callback then 
        return;
    end 

    if not self.recvFuncs[cmd] then 
        self.recvFuncs[cmd] = {};
    end

    local msginfo = {}
    msginfo.one = true;
    msginfo.callback = callback;
    table.insert(self.recvFuncs[cmd], msginfo);

    -- 在当前场景中添加遮挡
    self.addWaitWin(cmd);
end
           
MsgMgr.addWaitWin = function ( cmd )
    -- body
    self.waitCmd[cmd] = true;
    if not self.zd then 
        -- 当前场景中添加遮挡
        self.zd = Utils.createWaitLayer() 
        local scene = display.getRunningScene() 
        scene:addChild(self.zd);

        -- 获取当前时间时间戳
        self.wait_start_time = os.time();
        -- 创建定时器每秒检测一下
        self.waitSche = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()  
            local now = os.time()
            if now - self.wait_start_time >= 2 then 
                self.zd.zd:show();
                self.zd.bg:show();
            end 
            if now - self.wait_start_time >=15 then  -- 等待5秒消息仍然未返回，断开socket连接重新进入游戏 
                -- 进入游戏内重连
                self:reconnected();
            end 
        end,1,false) --每一秒执行一次
    end 
end 

-- 处理消息回调
MsgMgr.recvMsg = function ( cmd, code, data)
    -- body
    if cmd  then 
        local result = {};
        result.cmd = cmd;
        result.code = code;  
        local cmd_info = self.cmd_info[tonumber(cmd)];
        if data and cmd_info and cmd_info.recv and tonumber(code) == 0 then
            local tb = protobuf.decode(cmd_info.recv, data)
            if not tb then
                error("protobuf decode failed: cmd=" .. cmd .. ",recv = " .. cmd_info.recv)
            end 
            result.data = tb;
        end 
        print(table.tostring(result)); --打印返回信息.

        -- 关闭等待窗口
        self.removeWaitWin(cmd)

        local funcs =  self.recvFuncs[cmd]
        if funcs then 
            -- 遍历消息监听回调 , 移除只监听一次的消息
            for i=#funcs , 1 ,-1 do 
                local funInfo = funcs[i]; 
                funInfo.callback(result);  
                if funInfo.one then  
                    table.remove(funcs, i);
                end  
            end 
        end 
    end 
end

MsgMgr.removeWaitWin = function ( cmd )
    -- body
    -- 关闭遮挡窗口
    self.waitCmd[cmd] = nil;

    if not next(self.waitCmd) then -- 所有需要等待的消息已经返回
        -- 关闭遮挡 并且关掉计时器
        --关闭消息等待计时器
        if self.waitSche then 
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.waitSche);
            self.waitSche = nil;
        end

        -- 关闭遮挡
        if self.zd then 
            self.zd:removeSelf();
        end 
        self.zd = nil;
    end 
end 
 
--注册消息回调 
MsgMgr.addCmdCallBack = function (cmd, callback)
    if not cmd or not callback then 
        return;
    end 

    if not self.recvFuncs[cmd] then 
        self.recvFuncs[cmd] = {};
    end
    local funinfo = {};
    funinfo.callback = callback;
    table.insert(self.recvFuncs[cmd], funinfo);
end

 
--移除消息回调
MsgMgr.removeCmdCallBack = function (cmd)
    if not cmd then 
        return;
    end 

    if self.recvFuncs[cmd] then 
        self.recvFuncs[cmd] = {};
    end
end 

MsgMgr.clear = function ( ... )
    -- body
    self.recvFuncs = {}; -- 清空业务消息回调
    self.ip = nil; 
    self.port = nil;
    self.reconnect_time = 0; --重连次数
    self.waitCmd = {};
    if self.zd then
        self.zd:removeSelf();
    end
    self.zd = nil;
    self.connecting = false; -- 连接进行中
    self.wait_start_time = 0; --上次发消息的时间
    if self.waitSche then 
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.waitSche);
        self.waitSche = nil  -- 消息倒计时
    end

    -- 心跳
    if self.heartSche then 
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.heartSche);
        self.heartSche = nil  -- 消息倒计时
    end  
end

-- socket异常
MsgMgr.socketError = function(iserror)
    -- 区分游戏中，还是MainScene界面
    if not self.connecting then -- 游戏中断线，进入重连机制
        if not self.loginout then -- 没有登出的情况下，才重连
            local scene = display.getRunningScene();
            scene:runAction(cc.Sequence:create({cc.DelayTime:create(3), cc.CallFunc:create(function ( ... )
                -- body
                self:reconnected(); 
            end)}))  
        end
    end 
end 

-- 游戏内断线重连
MsgMgr.reconnected = function ( ... )
    print(">>>>>>>>>>>>socket reconnected")
    -- body
    -- 关闭socket 
    socketwork.disConnect(MsgMgr.socketName);
    
    -- 清空socket数据 
    local reconnect_time = self.reconnect_time;
    self.clear(); 
    -- 清空玩家数据 
    MyInfo = {};
    self.reconnect_time = reconnect_time;
    self.isreconnecting = true; -- 断线重连中

    -- 创建重连遮挡
    self.zd = Utils.createWaitLayer() 
    local scene = display.getRunningScene() 
    scene:addChild(self.zd);

    -- 重新连接socket
    MsgMgr.connect(ClientConfig.ip, ClientConfig.port, function (erroinfo)
        -- body
        if erroinfo.cmd == EVENT_CONNECTED then  -- socket连接成功
            -- 直接进入游戏，重新登录
            print(">>>>>>>>>>>>> socket reconnected succ");
            -- 继续心跳
            if self.heartSche then 
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.heartSche);
                self.heartSche = nil  -- 消息倒计时
            end 

            self.heartSche= cc.Director:getInstance():getScheduler():scheduleScriptFunc(function ( ... )
                -- body
                local param =  {}
                MsgMgr.sendData({cmd = 1, msg =param}); 
            end, 2, false);

            MsgMgr.reconnect_time = 0;
            MsgMgr.isreconnecting = false;
            -- 关闭遮挡
            if self.zd then 
                self.zd:removeSelf();
                self.zd = nil;
            end 

            -- 重新进入游戏
            if ClientConfig.nm then 
                local deviceInfo = {
                    packageId = "unknown";
                    device = Device_Info.platform, 
                    osVersion = Device_Info.system_vision,
                    deviceModel = Device_Info.model, 
                    mac = Device_Info.mac,
                    uuid = Device_Info.uuid,
                    idfa = Device_Info.idfa,
                    idfv = Device_Info.idfv,
                    androidId = Device_Info.androidId,
                    androidSdkVersion = GetMacAddress:getSdkVersion() or "unkonw",
                    imei = Device_Info.imei, 
                    telephone = "unknow",
                    }
                local param =  {mobilePhone=ClientConfig.nm, password = ClientConfig.pw, deviceInfo = deviceInfo}
                MsgMgr.sendData({cmd = 101, msg=param}); 
                -- 登陆回调函数
                MsgMgr.waitMsg(101,function (data)
                    -- body
                    if data.code == 0 then  --注册成功
                        -- print("登陆账号成功，请登录！");
                        MyInfo = data.data; 
                        require("app.MyApp"):create():enterScene("CityScene", "MOVEINR")
                    else
                        -- 弹出错误提示 
                        CodeRes.showTip(data.code); 
                        print("登陆失败, data.code = ", data.code)
                    end 
                end)
            end                
        else
            print(">>>>>>>>>>>>> socket reconnected fail, reconnect_time = ", self.reconnect_time);
            if MsgMgr.reconnect_time > 5 then  --重连大于5次，弹出提示框
                local layout=  Utils.createPop(2, {ms="连接服务器失败，请检查你的网络，重新进入游戏",yesFun = function ( ... )
                    -- body
                    MsgMgr.reconnect_time = 0;
                    MsgMgr.reconnected();
                end, yesstr = "继续重连", noFun = function ( ... )
                    -- body
                    MsgMgr.reEnterGame();
                end});
                
                local scene = display.getRunningScene();
                scene:addChild(layout); 
                layout:setPosition((display.width - layout.size.width)/2, (display.height - layout.size.height)/2);
            else
                -- 等待一秒钟继续重试 
                local scene = display.getRunningScene() 
                scene:runAction(cc.Sequence:create({cc.DelayTime:create(3), cc.CallFunc:create(function ( ... )
                    -- body
                    MsgMgr.reconnect_time = MsgMgr.reconnect_time + 1;
                    MsgMgr.reconnected();
                end)})) 
                
            end
        end
    end)
end

-- 退出游戏，不切断socket，直接清除玩家数据，重新登录。
MsgMgr.reEnterGame = function ( ... )
    -- body
    self.clear(); -- 清空业务消息 相关的回调函数。
    MyInfo = {}; -- 清空玩家数据
    require("app.MyApp"):create():enterScene("MainScene", "MOVEINR"); -- 回到登录界面
end