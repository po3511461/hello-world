local LoginScene = class("LoginScene", cc.load("mvc").ViewBase)

function LoginScene:onCreate()
    -- add background image
    local bg = display.newSprite("login/login_bg.png")
    local bgSize = bg:getContentSize();
    local scalex = display.width/bgSize.width
    local scaley = display.height/bgSize.height

    local scale = math.max(scalex, scaley) 
    bg:setScale(scale) 
    bg:setAnchorPoint(cc.p(0,0));
    self:addChild(bg)

    local center_off = 150;
    -- add login_tb 
    local login_tb = display.newSprite("login/login_tb.png")
    login_tb:setPosition(display.cx, display.cy + login_tb:getContentSize().height/2 + center_off)
    self:addChild(login_tb)


    -- 输入信息
    local _off = 30
    local start_y = display.cy + 100
    local inputbg = display.newSprite("login/login_input.png");

    -- 手机号码输入框
    local layout = ccui.Layout:create(); 
    layout:setAnchorPoint(cc.p(0, 0))

    local label = cc.Label:createWithSystemFont("手机号码  :  ", "Arial", 42);
    label:setTextColor(cc.c3b(0,0,0))
    label:setPositionY(3)
    label:setAnchorPoint(cc.p(0, 0));
    local labelSize = label:getContentSize();
    layout:addChild(label)

    local inputsize = inputbg:getContentSize();
    local input_nm = cc.EditBox:create(inputsize ,"login/login_input.png");
    local zhxx = FileUtil.readFileByTable("zhxx");
    if zhxx and zhxx.nm then 
        input_nm:setText(zhxx.nm);
    end 
                -- FileUtil.writeFileByTable("zhxx", zhxx);
    input_nm:setAnchorPoint(cc.p(0,0))
    input_nm:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    input_nm:setPosition(labelSize.width, 0);
    layout:addChild(input_nm);
    input_nm:setPlaceHolder("请输入手机号码")
    input_nm:setPlaceholderFontSize(30)
    -- input_nm:setPlaceholderFontColor(cc.c3b(0,0,0))
    local layoutsize = cc.size(labelSize.width + inputsize.width, inputsize.height)
    layout:setContentSize(layoutsize);
    layout:setPosition((display.width - layoutsize.width)/2 - 50, start_y - inputsize.height - _off )
    self:addChild(layout); 
   	

    -- 密码
    local layout = ccui.Layout:create(); 
    layout:setAnchorPoint(cc.p(0, 0))

    local label = cc.Label:createWithSystemFont("密码         :  ", "Arial", 42);
    label:setTextColor(cc.c3b(0,0,0))
    label:setAnchorPoint(cc.p(0, 0));
    label:setPositionY(3)
    local labelSize = label:getContentSize();
    layout:addChild(label)

    local inputsize = inputbg:getContentSize();
    local input_pw =  cc.EditBox:create(inputsize ,"login/login_input.png");
    input_pw:setPlaceHolder("请输入密码")
    input_pw:setInputFlag(0);
    -- input_pw:setPlaceholderFontColor(cc.c3b(0,0,0))
    input_pw:setMaxLength(13); 
    input_pw:setPlaceholderFontSize(30)
    input_pw:setAnchorPoint(cc.p(0,0))
    input_pw:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    input_pw:setPosition(labelSize.width, 0);
    layout:addChild(input_pw);

    local layoutsize = cc.size(labelSize.width + inputsize.width, inputsize.height)
    layout:setContentSize(layoutsize);
    layout:setPosition((display.width - layoutsize.width)/2 - 50, start_y - (inputsize.height + _off)*2)
    self:addChild(layout); 

    
    -- 顯示密碼 按鈕 
    local pwBtn = ccui.Button:create("login/show_btn.png");
    layout:addChild(pwBtn);
    local btnsize = pwBtn:getContentSize()
    pwBtn:setPosition(layoutsize.width - btnsize.width/2 , - btnsize.height/2 - 30)
    pwBtn:addClickEventListener(function ( ... )
        -- body
        input_pw:setInputFlag(1);
        local pw = input_pw:getText()
        input_pw:setText(pw);
        
    end)
    -- 按钮 
    local btn_y = start_y - (inputsize.height + _off)*2 - 200;
   
   	local layout = ccui.Layout:create();
    layout:setAnchorPoint(cc.p(0, 0))

    -- add login_btn
    local login_btn = ccui.Button:create()
    login_btn:setAnchorPoint(cc.p(0, 0))
    login_btn:loadTextureNormal("login/login_button.png")
    login_btn:setTitleText("登 录")
    login_btn:setTitleFontSize(40)
    login_btn:addClickEventListener(function ( ... )
        -- body
        -- 发送登陆请求
        local nm = input_nm:getText() 
        local pw = input_pw:getText();
        if nm == "" or pw == "" then 
            local layout=  Utils.createPop(1, {ms="请输入手机号和密码"});
            layout:setName("popwin")
            self:addChild(layout); 
            layout:setPosition((display.width - layout.size.width)/2, (display.height - layout.size.height)/2);
            return;
        end 
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
            
        local param =  {mobilePhone=nm, password = pw, deviceInfo= deviceInfo}
        MsgMgr.sendData({cmd = 101, msg =param}); 
        -- 登陆回调函数
        MsgMgr.waitMsg(101,function (data)
            -- body
            if data.code == 0 then  --注册成功
                -- print("登陆账号成功，请登录！");
                MyInfo = data.data; 
                ClientConfig.nm = nm;
                ClientConfig.pw = pw;
                local zhxx = {};
                zhxx.nm = nm;
                FileUtil.writeFileByTable("zhxx", zhxx);
                require("app.MyApp"):create():enterScene("CityScene", "MOVEINR")
            else
                -- 弹出错误提示 
                CodeRes.showTip(data.code); 
                print("登陆失败, data.code = ", data.code)
            end 
        end)
    end)

    local btnsize = login_btn:getContentSize();
    layout:addChild(login_btn);
    
    -- add cancel_btn 
    local cancel_btn = ccui.Button:create()
    cancel_btn:setAnchorPoint(cc.p(0, 0))
    cancel_btn:loadTextureNormal("login/login_button.png")
    cancel_btn:setTitleText("取 消");
    cancel_btn:setTitleFontSize(40)
    cancel_btn:addClickEventListener(function ( ... )
        -- body
        -- 回到登陆界面
        require("app.MyApp"):create():enterScene("MainScene", "MOVEINR")
    end)
    cancel_btn:setPositionX(btnsize.width + 10)
    layout:addChild(cancel_btn)

    local layoutsize = cc.size(btnsize.width * 2 + 10, btnsize.height)
    layout:setPosition((display.width - layoutsize.width)/2, btn_y);
    self:addChild(layout)
end

return LoginScene
