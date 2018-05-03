local SetInfoScene = class("SetInfoScene", cc.load("mvc").ViewBase)

function SetInfoScene:onCreate()
    -- add background image
    self.page_index = 1;
    local bg = display.newSprite("setup/bg.jpg")
    local bgSize = bg:getContentSize();
    local scalex = display.width/bgSize.width
    
    bg:setScaleX(scalex) 
    bg:setAnchorPoint(cc.p(0,1));
    bg:setPosition(0, display.height);
    self:addChild(bg)

    -- add title_bg
    local title_bg = display.newSprite("city/top.jpg");
    local title_bgsize = title_bg:getContentSize()
    title_bg:setAnchorPoint(cc.p(0,1));
    title_bg:setPosition(0, display.height);
    title_bg:setScaleX(display.width/title_bgsize.width)
    self:addChild(title_bg); 

    -- add title
    local title = cc.Label:createWithSystemFont("设置", "Arial", 40)
    title:setPosition(display.cx, display.height - title_bgsize.height/2)
    title:enableShadow(cc.c4b(0, 0, 0), cc.size(1,1), 1) -- 启动阴影 
    title:enableOutline(cc.c4b(0,0,0), 1) -- 启动描边
    self:addChild(title); 
    self.title = title;

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

    local start_y = display.height - 210
    --tx 
    local tx = display.newSprite("head/" .. MyInfo.avatar .. ".jpg");
    self:addChild(tx);
    local txSize = tx:getContentSize(); 
    tx:setPosition(txSize.width/2 + 20,  start_y)

    --nm 
    local nm = cc.Label:createWithSystemFont(MyInfo.nickName, "Arial", 30)
    nm:setTextColor(cc.c3b(0,0,0));
    self:addChild(nm)
    nm:setAnchorPoint(cc.p(0, 0.5))
    local nmsize = nm:getContentSize();
    nm:setPosition(txSize.width + 45, start_y + 28)

    --jb 
    local jb = cc.Label:createWithSystemFont("金币金额 " .. MyInfo.jb, "Arial", 24)
    local jbsize = jb:getContentSize();
    jb:setTextColor(cc.c3b(0,0,0)) 
    jb:setAnchorPoint(cc.p(0, 0.5))
    self:addChild(jb); 
    jb:setPosition(txSize.width + 45, start_y - 5)


    --账号
    local tjm = cc.Label:createWithSystemFont("账号 " .. MyInfo.uniqueId, "Arial", 24)
    local tjmsize = tjm:getContentSize();
    tjm:setTextColor(cc.c3b(0,0,0)) 
    tjm:setAnchorPoint(cc.p(0, 0.5))
    self:addChild(tjm); 
    tjm:setPosition(txSize.width + 45, start_y - 31)



    local center = ccui.Layout:create();
    self:addChild(center)
    self.center = center
    center:setContentSize(cc.size(display.width, display.height));

    self:createCenter();
end

function SetInfoScene:createCenter( ... )
    -- body
    if self.page_index == 1 then
        self:createInfo() 
    elseif self.page_index == 2 then 
        self:createChangepw()
    end 
end

function SetInfoScene:createInfo( ... )
    -- body
    local center = self.center;
    center:removeAllChildren()

    --更新签名输入框
    local layout = ccui.Layout:create(); 
    layout:setAnchorPoint(cc.p(0, 0))

    local inputbg = display.newSprite("setup/input_bg.jpg");
    local inputsize = inputbg:getContentSize();
    layout:addChild(inputbg)
    inputbg:setAnchorPoint(cc.p(0,0))

    local title = cc.Label:createWithSystemFont("个性签名:", "Arial", 30)
    local titlesize = title:getContentSize();
    title:setTextColor(cc.c3b(0,0,0)) 
    title:setAnchorPoint(0,0); 
    title:setPosition(10, inputsize.height - titlesize.height - 10)
    inputbg:addChild(title)

    local ms = cc.Label:createWithSystemFont("       " .. MyInfo.introduction, "Arial", 30)
    local mssize = ms:getContentSize()
    ms:setAnchorPoint(cc.p(0,1))
    ms:setTextColor(cc.c3b(0,0,0)); 
    ms:setWidth(inputsize.width - 20)
    ms:setMaxLineWidth(inputsize.width - 20)
    inputbg:addChild(ms)
    ms:setPosition(10, inputsize.height - titlesize.height - 13);
    self.ms = ms ;
    local edit_btn = ccui.Button:create("setup/edit.png"); 
    local btnsize = edit_btn:getContentSize();
    layout:addChild(edit_btn);
    edit_btn:setAnchorPoint(cc.p(0,0));
    edit_btn:setTitleText("编 辑")
    edit_btn:setTitleFontSize(30);
    edit_btn:addClickEventListener(function ( ... )
        self:createChangeInfo();
    end)
    edit_btn:setPosition(inputsize.width - btnsize.width - 15, 15);
    
    layout:setPosition((display.width - inputsize.width)/2 , display.height - 330 - inputsize.height);
    center:addChild(layout); 
    

    local change_pw = ccui.Button:create("setup/cpw.jpg");
    center:addChild(change_pw);
    change_pw:setAnchorPoint(cc.p(0,1))
    change_pw:setPosition(0, display.height - 330 - inputsize.height - 40)
    change_pw:addClickEventListener(function ( ... )
        -- body
        self.page_index = 2; 
        self:createCenter(); 
    end)
end

function SetInfoScene:createChangepw( ... )
    -- body
    local center = self.center;
    center:removeAllChildren()
    self.title:setString("修改密码");

    
    local start_x = 50
    --
    -- 旧密码输入框
    local layout = ccui.Layout:create(); 
    layout:setAnchorPoint(cc.p(0, 0))

    local inputbg = display.newSprite("bank/input.png");
    local inputsize = inputbg:getContentSize();

    local label = cc.Label:createWithSystemFont("旧密码           : ", "Arial", 30);
    label:setAnchorPoint(cc.p(0, 0));
    label:setTextColor(cc.c3b(0, 0, 0));
    local labelSize = label:getContentSize();
    layout:addChild(label) 
    label:setPosition(0, (inputsize.height - labelSize.height)/2)

    local input_old = cc.EditBox:create(inputsize ,"bank/input.png");

    input_old:setAnchorPoint(cc.p(0,0))
    input_old:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    input_old:setPosition(labelSize.width, 0);
    layout:addChild(input_old);


    local layoutsize = cc.size(labelSize.width + inputsize.width, inputsize.height)
    layout:setContentSize(layoutsize);
    layout:setPosition(start_x , display.height - 450);
    center:addChild(layout); 
    
    -- 新密码输入框
    local layout = ccui.Layout:create(); 
    layout:setAnchorPoint(cc.p(0, 0))

    local inputbg = display.newSprite("bank/input.png");
    local inputsize = inputbg:getContentSize();

    local label = cc.Label:createWithSystemFont("新密码           : ", "Arial", 30);
    label:setAnchorPoint(cc.p(0, 0));
    label:setTextColor(cc.c3b(0, 0, 0));
    local labelSize = label:getContentSize();
    layout:addChild(label) 
    label:setPosition(0, (inputsize.height - labelSize.height)/2)

    local input_new = cc.EditBox:create(inputsize ,"bank/input.png");

    input_new:setAnchorPoint(cc.p(0,0))
    input_new:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    input_new:setPosition(labelSize.width, 0);
    layout:addChild(input_new);


    local layoutsize = cc.size(labelSize.width + inputsize.width, inputsize.height)
    layout:setContentSize(layoutsize);
    layout:setPosition(start_x , display.height - 550);
    center:addChild(layout); 


    -- 确认密码输入框
    local layout = ccui.Layout:create(); 
    layout:setAnchorPoint(cc.p(0, 0))

    local inputbg = display.newSprite("bank/input.png");
    local inputsize = inputbg:getContentSize();

    local label = cc.Label:createWithSystemFont("确认新密码    : ", "Arial", 30);
    label:setAnchorPoint(cc.p(0, 0));
    label:setTextColor(cc.c3b(0, 0, 0));
    local labelSize = label:getContentSize();
    layout:addChild(label) 
    label:setPosition(0, (inputsize.height - labelSize.height)/2)

    local input_re = cc.EditBox:create(inputsize ,"bank/input.png");

    input_re:setAnchorPoint(cc.p(0,0))
    input_re:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    input_re:setPosition(labelSize.width, 0);
    layout:addChild(input_re);


    local layoutsize = cc.size(labelSize.width + inputsize.width, inputsize.height)
    layout:setContentSize(layoutsize);
    layout:setPosition(start_x , display.height - 650);
    center:addChild(layout); 


    local sub_btn = ccui.Button:create("bank/btn.png");
    local subbtn_size = sub_btn:getContentSize(); 
    sub_btn:setTitleText("确 认");
    sub_btn:setTitleFontSize(30); 
    center:addChild(sub_btn);
    sub_btn:addClickEventListener(function ( ... )
        -- body
        local old = input_old:getText()
        local new = input_new:getText(); 
        local re = input_re:getText();
        if old  == "" then 
            local layout=  Utils.createPop(1, {ms="请输入你的旧密码"});
            layout:setName("popwin")
            self:addChild(layout); 
            layout:setPosition((display.width - layout.size.width)/2, (display.height - layout.size.height)/2);
            return;
        end 
        if new == "" then  
            local layout=  Utils.createPop(1, {ms="请输入你的新密码"});
            layout:setName("popwin")
            self:addChild(layout); 
            layout:setPosition((display.width - layout.size.width)/2, (display.height - layout.size.height)/2);
            return;
         
        end
        if re == ""  or new ~= re then  
            local layout=  Utils.createPop(1, {ms="你输入的密码不一致"});
            layout:setName("popwin")
            self:addChild(layout); 
            layout:setPosition((display.width - layout.size.width)/2, (display.height - layout.size.height)/2);
            return;
        end

        local param =  {oldPassword= old, newPassword = new, confirmNewPassword = re}
        MsgMgr.sendData({cmd = 1002, msg =param}); 
        -- 注册回调函数
        MsgMgr.waitMsg(1002,function ( data)
            -- body
            if data.code == 0 then  -- 修改成功
                print("修改成功");    
                input_old:setText("");  
                input_new:setText("");
                input_re:setText("");
                local layout=  Utils.createPop(1, {ms="修改密码成功"});
                layout:setName("popwin") 
                self:addChild(layout); 
                layout:setPosition((display.width - layout.size.width)/2, (display.height - layout.size.height)/2);
            else 
                CodeRes.showTip(data.code); 
            end 
        end)
    end)
    sub_btn:setPosition(display.cx + 32, display.height - 730);
end

function SetInfoScene:createChangeInfo( ... )
    -- body
    local layout = ccui.Layout:create(); 
    local bg = display.newSprite("pop/bg.jpg");
    layout:addChild(bg);
    bg:setAnchorPoint(cc.p(0,0));
    local bgSize = bg:getContentSize();
    layout.size = bgSize;
    layout:setContentSize(bgSize);
    layout:setAnchorPoint(cc.p(0,0))

    local title = cc.Label:createWithSystemFont("请输入你要编辑的内容", "Arial", 40);
    layout:addChild(title)
    title:setPosition(bgSize.width/2, bgSize.height - 32)

    local inputbg = display.newSprite("bank/input.png");
    local inputsize = inputbg:getContentSize();

    local input_re = cc.EditBox:create(cc.size(bgSize.width - 20, 200) ,"bank/input.png");
    input_re:setFontSize(30);
    input_re:setAnchorPoint(cc.p(0,0))
    input_re:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    input_re:setPosition(10, 100);
    layout:addChild(input_re);

    
    local yes_btn = ccui.Button:create("pop/yes.png");
    yes_btn:setTitleFontSize(30);
    yes_btn:setTitleText("确 认"); 
    local btnsize = yes_btn:getContentSize();
    yes_btn:setPosition(bgSize.width/2 - btnsize.width/2 - 40, btnsize.height/2 + 20);
    yes_btn:addClickEventListener(function ( ... )
        -- bodydddd
        local new = input_re:getText(); 
      
        new = new or ""; 

        local param =  {nickName= MyInfo.nickName, avatar = avatar, introduction = new}
        MsgMgr.sendData({cmd = 1001, msg =param}); 
        -- 注册回调函数
        MsgMgr.waitMsg(1001,function ( data)
            -- body
            if data.code == 0 then  -- 修改成功
                MyInfo.introduction = new;
                self.ms:setString("       " .. MyInfo.introduction)
                print("修改成功");      
                layout:removeSelf();
                local layout=  Utils.createPop(1, {ms="修改个人信息成功"});
                layout:setName("popwin") 
                self:addChild(layout); 

                layout:setPosition((display.width - layout.size.width)/2, (display.height - layout.size.height)/2);
            else 
                CodeRes.showTip(data.code); 
            end 
        end)
        
    end)

    layout:addChild(yes_btn);


    local no_btn = ccui.Button:create("pop/no.png");
    no_btn:setTitleFontSize(30);
    no_btn:setTitleText("取 消"); 
    local btnsize = no_btn:getContentSize();
    no_btn:setPosition(bgSize.width/2 + btnsize.width/2 + 40, btnsize.height/2 + 20);
    no_btn:addClickEventListener(function ( ... )
        -- body
        layout:removeSelf();
    end)
    layout:addChild(no_btn);

    self:addChild(layout);
    layout:setPosition((display.width - layout.size.width)/2, (display.height - layout.size.height)/2);
    layout:setName("tishi");
end

        
return SetInfoScene
