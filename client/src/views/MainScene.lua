-- 登陆场景
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()
    self.connect_time = 0;
    -- add background image
    local bg = display.newSprite("login/login_bg.png")
    local bgSize = bg:getContentSize();

    local scalex = display.width/bgSize.width
    local scaley = display.height/bgSize.height

    bg:setScale(math.max(scalex, scaley));
    bg:setAnchorPoint(cc.p(0,0));
    self:addChild(bg)


    local center_off = 30;
    -- add login_tb 
    local login_tb = display.newSprite("login/login_tb.png")
    login_tb:setPosition(display.cx, display.cy + login_tb:getContentSize().height/2 + center_off)
    self:addChild(login_tb)

    -- add login_btn
    local login_btn = ccui.Button:create()
    login_btn:loadTextureNormal("login/login_button.png")
    login_btn:setTitleText("登 录")
    login_btn:setTitleFontSize(40)
    login_btn:addClickEventListener(function ( ... )
        -- body
        --进入登陆界面 
        self:connectSocket(function ( ... )
            -- body
            MsgMgr.loginout = false;
            MsgMgr.outtype = nil;
            require("app.MyApp"):create():enterScene("LoginScene", "MOVEINR")
        end)
    end)


    local btnsize = login_btn:getContentSize();
    login_btn:setPosition(display.cx, display.cy - btnsize.height/2 - center_off )
    self:addChild(login_btn);
    
    -- add register_btn 
    local register_btn = ccui.Button:create()
    register_btn:loadTextureNormal("login/login_button.png")
    register_btn:setTitleText("注 册");
    register_btn:setTitleFontSize(40)
    register_btn:addClickEventListener(function ( ... )
        -- body
        self:connectSocket( function ( ... )
            -- body
            MsgMgr.loginout = false;
            MsgMgr.outtype = nil;
            require("app.MyApp"):create():enterScene("RegisterScene", "MOVEINR")
        end)
    end)
    register_btn:setPosition(display.cx, display.cy - btnsize.height * 2 - center_off)
    self:addChild(register_btn)
   

    if MsgMgr.loginout then  -- 被迫登出,弹出提示
        local _type = MsgMgr.outtype;
        if _type == 1 then  --     其他地方登录
            local layout=  Utils.createPop(1, {ms="账号在其他设备登录"});
            self:addChild(layout); 
            layout:setPosition((display.width - layout.size.width)/2, (display.height - layout.size.height)/2);
        end

    end 
end

function MainScene:connectSocket( callback )
    -- body
    if socketwork.isConnect("tcp") then 
        if callback then 
            callback();
        end 
    else 
         self.connect_time = self.connect_time + 1;
        -- 创建遮挡
        if not self:getChildByName("zd_bg") then
            self:createBg();
        end

        MsgMgr.connect(ClientConfig.ip, ClientConfig.port, function (erroinfo)
            -- body
            if erroinfo.cmd == EVENT_CONNECTED then  -- socket连接成功
                print(">>>>>>> MainScene Socket connect  succ")
                self:removeChildByName("zd_bg")
                if callback then 
                    callback();
                end 
            else 
                print(">>>>>>> MainScene Socket connect  fail connect_time = ", self.connect_time);
                if self.connect_time > 5 then  --重连大于5次，弹出提示框
                    local layout=  Utils.createPop(2, {ms="连接服务器失败，请检查你的网络，重新进入游戏",yesFun = function ( ... )
                        -- body
                        self.connect_time = 0;
                        Utils.setTimeout(self, 1, function ( ... )
                            -- body
                            self:connectSocket(callback);
                        end)
                    end, yesstr = "继续重连", noFun = function ( ... )
                        -- body
                        self:removeChildByName("zd_bg");
                    end});
                    
                    layout:setName("popwin")
                    self:addChild(layout); 
                    layout:setPosition((display.width - layout.size.width)/2, (display.height - layout.size.height)/2);
                else
                    -- 连接失败，重试 
                    Utils.setTimeout(self, 1, function ( ... )
                        -- body
                        self:connectSocket(callback);
                    end)
                 end 
            end
        end)
    end 
end

function MainScene:createBg()
    -- body
    local bg = ccui.Layout:create()
    bg:setAnchorPoint(cc.p(0,0))
    bg:setContentSize(cc.size(display.width, display.height));
    bg:setPosition(0, 0);
    bg:setTouchEnabled(true);
    bg:setName("zd_bg")
    self:addChild(bg);

    local tips = cc.Label:createWithSystemFont("网络连接中....", "Arial", 32)
    tips:setTextColor(cc.c3b(255, 0, 0));
    local action = cc.Blink:create(1,1)
    tips:runAction(cc.RepeatForever:create(action));
    bg:addChild(tips)
    tips:setPosition(display.cx, 40) 

end
return MainScene
