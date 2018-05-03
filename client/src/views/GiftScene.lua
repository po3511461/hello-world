local GiftScene = class("GiftScene", cc.load("mvc").ViewBase)

function GiftScene:onCreate()
    -- add background image
    local bg = display.newSprite("city/bg.jpg")
    local bgSize = bg:getContentSize();
    local scalex = display.width/bgSize.width
    local scaley = display.height/bgSize.height

    local scale = math.max(scalex, scaley) 
    bg:setScale(scale) 
    bg:setAnchorPoint(cc.p(0,0));
    self:addChild(bg)


    -- add title_bg
    local title_bg = display.newSprite("city/top.jpg");
    local title_bgsize = title_bg:getContentSize()
    title_bg:setAnchorPoint(cc.p(0,1));
    title_bg:setPosition(0, display.height);
    title_bg:setScaleX(display.width/title_bgsize.width)
    self:addChild(title_bg); 

    -- add title
    local title = cc.Label:createWithSystemFont("赠送礼物", "Arial", 40)
    title:setPosition(display.cx, display.height - title_bgsize.height/2)
    title:enableShadow(cc.c4b(0, 0, 0), cc.size(1,1), 1) -- 启动阴影 
    title:enableOutline(cc.c4b(0,0,0), 1) -- 启动描边
    self:addChild(title); 

    local fh_wz = ccui.Text:create("< 我的", "Arial" , 40)
    local wz_size = fh_wz:getContentSize();
    local downLocation;
    fh_wz:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            downLocation = sender:getTouchMovePosition()
            move = false

            sender:setOpacity(150)
        elseif eventType == ccui.TouchEventType.ended then
            sender:setOpacity(255)
            if not move then
                require("app.MyApp"):create():enterScene("SetUpScene", "moveinl");
            end     
        elseif eventType == ccui.TouchEventType.moved then
            local p1 = sender:getTouchMovePosition()
            if downLocation  and  (math.abs(downLocation.x-p1.x) > wz_size.width or  math.abs(downLocation.y-p1.y) >wz_size.height ) then
                move = true
                sender:setOpacity(255)
            else 
                sender:setOpacity(150)
            end 
        elseif eventType == ccui.TouchEventType.cancel then 
            move = true
            sender:setOpacity(255)
        end
    end)

    fh_wz:setTouchEnabled(true);
    fh_wz:setAnchorPoint(cc.p(0, 0.5))
    fh_wz:setPosition(5, display.height - title_bgsize.height/2)
    self:addChild(fh_wz); 


    --jbtb
    local bg_y = display.height -  title_bgsize.height
    local jbtb = display.newSprite("gift/jb.png"); 
    local jb_size = jbtb:getContentSize();
    self:addChild(jbtb);
    local jb_y = bg_y - 30 - jb_size.height/2
    jbtb:setPosition(jb_size.width/2 + 20, jb_y);

    local jb = cc.Label:createWithSystemFont("银行金币: " .. Utils.getJb(MyInfo.bankGold), "Arial", 30); 
    self.jb = jb;
    local jbSize = jb:getContentSize();
    self:addChild(jb);
    jb:setTextColor(cc.c3b(0,0,0));
    jb:setPosition(jb_size.width + 30 + jbSize.width/2, jb_y)


    local record = ccui.Button:create("gift/record.png");
    self:addChild(record);
    record:setTitleText("礼物记录")
    record:setTitleFontSize(28)
    local recordsize = record:getContentSize();
    record:setPosition(display.width - recordsize.width/2 - 20, jb_y); 
    record:addClickEventListener(function ( ... )
        require("app.MyApp"):create():enterScene("GiftRecordScene", "moveinr");
    end)

    local line = display.newSprite("gift/line.png");
    self:addChild(line); 
    line:setScaleX((display.width - 20)/ line:getContentSize().width)
    local lien_y = jb_y - jb_size.height/2 - 20
    line:setPosition(display.cx, lien_y);
    local input_value;

    --gift\
    local gift1 = ccui.Button:create("gift/one.png");
    local giftsize = gift1:getContentSize();
    local offx = 30; 
    local off_w = (display.width - offx *2 - giftsize.width)/3 
    self:addChild(gift1)
    gift1:setPosition(offx + giftsize.width/2, lien_y - giftsize.height/2 - 70);
    gift1:addClickEventListener(function ( ... )
        -- body
        input_value:setText(10000)
    end)
    local gift2 = ccui.Button:create("gift/ten.png");
    self:addChild(gift2);
    gift2:setPosition(offx + giftsize.width/2 + off_w, lien_y - giftsize.height/2 - 70)
    gift2:addClickEventListener(function ( ... )
        -- body
        input_value:setText(100000);
    end)
    local gift3 = ccui.Button:create("gift/bai.png");
    self:addChild(gift3);
    gift3:setPosition(offx + giftsize.width/2 + off_w * 2, lien_y - giftsize.height/2 - 70)
    gift3:addClickEventListener(function ( ... )
        -- body
        input_value:setText(1000000)
    end)
    local gift4 = ccui.Button:create("gift/qian.png");
    self:addChild(gift4);
    gift4:setPosition(offx + giftsize.width/2 + off_w * 3, lien_y - giftsize.height/2 - 70)
    gift4:addClickEventListener(function ( ... )
        -- body
        input_value:setText(10000000)
    end)

    local start_y = lien_y - giftsize.height - 80
    local _off = 50;
    local inputbg = display.newSprite("login/login_input.png");
    
    --szf
    local layout = ccui.Layout:create(); 
    layout:setAnchorPoint(cc.p(0, 0))

    local label = cc.Label:createWithSystemFont("受赠方ID:", "Arial", 40);
    label:setTextColor(cc.c3b(0,0,0))
    label:setAnchorPoint(cc.p(0, 0));
    local labelSize = label:getContentSize();
    layout:addChild(label)

    local inputsize = inputbg:getContentSize();
    local input_id = cc.EditBox:create(inputsize ,"login/login_input.png");


    input_id:setAnchorPoint(cc.p(0,0))
    input_id:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    input_id:setPosition(labelSize.width, 0);
    layout:addChild(input_id);

    local layoutsize = cc.size(labelSize.width + inputsize.width, inputsize.height)
    layout:setContentSize(layoutsize);
    layout:setPosition((display.width - layoutsize.width)/2, start_y - inputsize.height - _off)
    self:addChild(layout); 

     -- 检测昵称
    local layout = ccui.Layout:create(); 
    layout:setAnchorPoint(cc.p(0, 0))

    local label = cc.Label:createWithSystemFont("受赠方ID:", "Arial", 40);
    label:setTextColor(cc.c3b(0,0,0))
    label:setAnchorPoint(cc.p(0, 0));
    local labelSize = label:getContentSize();
    label:hide();
    layout:addChild(label)

    local btn = ccui.Button:create("gift/btn.png");
    btn:setTitleText("检 测 昵 称");
    btn:setTitleFontSize(38)
    btn:addClickEventListener(function ( ... )
        -- body
        local nm = tonumber(input_id:getText())
        if not nm  then         
            local layout=  Utils.createPop(1, {ms="请输入对方的id"});
            layout:setName("popwin")
            self:addChild(layout); 
            layout:setPosition((display.width - layout.size.width)/2, (display.height - layout.size.height)/2);
            return;
        end

        local param ={uniqueId = nm, pid = nm}
        MsgMgr.sendData({cmd = 1004, msg = param}); 
        -- 登陆回调函数
        MsgMgr.waitMsg(1004,function (data)
            -- body
            if data.code == 0 then  --获取成功
                local info = data.data.playerSimpleInfo;
                local layout=  Utils.createPop(1, {ms=info.nickName});
                layout:setName("popwin")
                self:addChild(layout); 
                layout:setPosition((display.width - layout.size.width)/2, (display.height - layout.size.height)/2);
            else
                -- 弹出错误提示 
                CodeRes.showTip(data.code);
                print("登陆失败, data.code = ", data.code)
            end 
        end)
    end)
    btn:setAnchorPoint(cc.p(0,0));
    btn:setPosition(labelSize.width, 0);
    layout:addChild(btn);
    local btnsize = btn:getContentSize();
    btn:setScale(inputsize.width/btnsize.width, inputsize.height/btnsize.height);
    local layoutsize = cc.size(labelSize.width + inputsize.width, inputsize.height)
    layout:setContentSize(layoutsize);
    layout:setPosition((display.width - layoutsize.width)/2, start_y - (inputsize.height + _off) * 2)
    self:addChild(layout); 

    -- giftvalue 
    local layout = ccui.Layout:create(); 
    layout:setAnchorPoint(cc.p(0, 0))

    local label = cc.Label:createWithSystemFont("礼物价值:", "Arial", 40);
    label:setTextColor(cc.c3b(0,0,0))
    label:setAnchorPoint(cc.p(0, 0));
    local labelSize = label:getContentSize();
    layout:addChild(label)

    local inputsize = inputbg:getContentSize();
    input_value = cc.EditBox:create(inputsize ,"login/login_input.png");


    input_value:setAnchorPoint(cc.p(0,0))
    input_value:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    input_value:setPosition(labelSize.width, 0);
    layout:addChild(input_value);

    local layoutsize = cc.size(labelSize.width + inputsize.width, inputsize.height)
    layout:setContentSize(layoutsize);
    layout:setPosition((display.width - layoutsize.width)/2, start_y - (inputsize.height + _off)*3)
    self:addChild(layout); 

    -- 密码
    local layout = ccui.Layout:create(); 
    layout:setAnchorPoint(cc.p(0, 0))

    local label = cc.Label:createWithSystemFont("取款密码:", "Arial", 40);
    label:setTextColor(cc.c3b(0,0,0))
    label:setAnchorPoint(cc.p(0, 0));
    local labelSize = label:getContentSize();
    layout:addChild(label)

    local inputsize = inputbg:getContentSize();
    local input_pwd = cc.EditBox:create(inputsize ,"login/login_input.png");

    input_pwd:setAnchorPoint(cc.p(0,0))
    input_pwd:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    input_pwd:setPosition(labelSize.width, 0);
    layout:addChild(input_pwd);

    local layoutsize = cc.size(labelSize.width + inputsize.width, inputsize.height)
    layout:setContentSize(layoutsize);
    layout:setPosition((display.width - layoutsize.width)/2, start_y - (inputsize.height + _off)*4)
    self:addChild(layout);  
    local zs_btn = ccui.Button:create("gift/login.png");
    zs_btn:setTitleText("赠 送");
    zs_btn:setTitleFontSize(40);
    zs_btn:setPosition(display.width/2, start_y - (inputsize.height + _off)*5)
    self:addChild(zs_btn);
    zs_btn:addClickEventListener(function ( ... )
        -- body
        local nm = tonumber(input_id:getText())
        local jb = tonumber(input_value:getText())
        local pwd = input_pwd:getText()
        if not nm  then         
            local layout=  Utils.createPop(1, {ms="请输入对方的id"});
            layout:setName("popwin")
            self:addChild(layout); 
            layout:setPosition((display.width - layout.size.width)/2, (display.height - layout.size.height)/2);
            return;
        end
        if pwd == "" then  
            local layout=  Utils.createPop(1, {ms="请输入正确的密码"});
            layout:setName("popwin")
            self:addChild(layout); 
            layout:setPosition((display.width - layout.size.width)/2, (display.height - layout.size.height)/2);
            return;
        end
        if not jb  or jb == 0 then  
            local layout=  Utils.createPop(1, {ms="请输入正确的金额"});
            layout:setName("popwin")
            self:addChild(layout); 
            layout:setPosition((display.width - layout.size.width)/2, (display.height - layout.size.height)/2);
            return;
        end
        local param =  {bankPwd= pwd, gold = jb, uniqueId = nm} --uniquedId
        MsgMgr.sendData({cmd = 30004, msg =param}); 
        -- 注册回调函数
        MsgMgr.waitMsg(30004,function ( data)
            -- body
            if data.code == 0 then  --注册成功
                print("转账成功");
                input_id:setText("");
                input_value:setText("");
                input_pwd:setText("");  
                MyInfo.bankGold = data.data.bankGold 
                self.jb:setString("银行金币: " .. Utils.getJb(MyInfo.bankGold));
                local layout=  Utils.createPop(1, {ms="转账成功"});
                layout:setName("popwin")
                self:addChild(layout); 
                layout:setPosition((display.width - layout.size.width)/2, (display.height - layout.size.height)/2);
            else 
                CodeRes.showTip(data.code); 
            end 
        end)
    end)
end

return GiftScene
