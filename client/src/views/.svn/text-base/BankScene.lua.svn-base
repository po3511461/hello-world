local BankScene = class("BankScene", cc.load("mvc").ViewBase)

function BankScene:onCreate()
    self.page_index = 1; -- 1:存款， 2:取款， 3:修改银行密码
    -- add background image
    local bg = display.newSprite("bank/bg.jpg")
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
    local title = cc.Label:createWithSystemFont("存款", "Arial", 40)
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
    
    -- 三点 
    local xq_btn = ccui.Button:create("bank/point.png");
    self:addChild(xq_btn);
    xq_btn:addClickEventListener(function ( ... )
        -- body
        self:createOperation();
    end)
    local btnsize = xq_btn:getContentSize();
    xq_btn:setPosition(display.width - 15 - btnsize.width/2, display.height - title_bgsize.height/2)

    self.center = ccui.Layout:create()
    self.center:setContentSize(cc.size(display.width, display.height))
    self:addChild(self.center);

    self:createCenter()
    

    --bottom 
    self:create_bottom();
end

function BankScene:createOperation( ... )
    -- body
    local layout = ccui.Layout:create();
    layout:setLocalZOrder(101)
    layout:setTouchEnabled(true);
    local layoutsize = cc.size(display.width, display.height)
    layout:setContentSize(layoutsize);
    layout:setName("preOpen");
    self:addChild(layout);

    local bg = cc.LayerColor:create(cc.c4b(0,0,0, 180),display.width, layoutsize.height);
    layout:addChild(bg)

    local qx_btn = ccui.Button:create("bank/record_btn.jpg");
    qx_btn:setTitleText("取 消");
    qx_btn:setTitleColor(cc.c3b(0,0,0))
    qx_btn:setTitleFontSize(40);
    local btnsize = qx_btn:getContentSize();
    qx_btn:setPosition(display.cx, btnsize.height/2);
    qx_btn:addClickEventListener(function ( ... )
        -- body
        self:removeChildByName("preOpen");
    end)
    layout:addChild(qx_btn);

    local record_btn = ccui.Button:create("bank/record_btn.jpg");
    record_btn:setTitleText("银行记录");
    record_btn:setTitleColor(cc.c3b(0,0,0))
    record_btn:setTitleFontSize(40);
    layout:addChild(record_btn);
    local btnsize = record_btn:getContentSize();
    record_btn:setPosition(display.cx, btnsize.height+  btnsize.height/2 + 2);
    record_btn:addClickEventListener(function ( ... )
        -- body
        require("app.MyApp"):create():enterScene("BankRecordScene", "moveinr");
    end)

end

function BankScene:createCenter( ... )
    -- body
    if self.page_index == 1 then 
        self:create_savePage()
    elseif self.page_index == 2 then
        self:create_getPage() 
    elseif self.page_index == 3 then 
        self:create_changePage();
    end 
end

function BankScene:create_bottom( ... )
    -- body
    self.buttons = {};
    local save_btn= ccui.Button:create("bank/bottom_btn.jpg", "bank/bottom_btn_pre.jpg")
    local btnsize = save_btn:getContentSize();
    save_btn:setAnchorPoint(cc.p(0.5, 0));
    save_btn:setTitleFontSize(40)
    save_btn:setTitleText("存 款");
    save_btn:setTitleColor(cc.c3b(0,0,0)); 
    save_btn:setPositionX(btnsize.width/2)
    save_btn:addClickEventListener(function ( ... )
        -- body
        if self.page_index ~= 1 then 
            self.page_index =1; 
            self:chose_page();
            self:createCenter();
        end 
    end)
    self:addChild(save_btn); 
    table.insert(self.buttons, save_btn)

    local get_btn= ccui.Button:create("bank/bottom_btn.jpg", "bank/bottom_btn_pre.jpg")
    get_btn:setAnchorPoint(cc.p(0.5, 0));
    get_btn:setTitleFontSize(40)
    get_btn:setTitleText("取 款");
    get_btn:setTitleColor(cc.c3b(0,0,0)); 
    get_btn:addClickEventListener(function ( ... )
        -- body
        if self.page_index ~= 2 then 
            self.page_index =2; 
            self:chose_page();
            self:createCenter();
        end 
    end)
    get_btn:setPositionX(display.cx)
    self:addChild(get_btn);
    table.insert(self.buttons, get_btn)

    

    local change_btn= ccui.Button:create("bank/bottom_btn.jpg", "bank/bottom_btn_pre.jpg")
    change_btn:setAnchorPoint(cc.p(0.5, 0));
    change_btn:setTitleFontSize(40)
    change_btn:setTitleText("修改密码");
    change_btn:setTitleColor(cc.c3b(0,0,0)); 
    change_btn:setPositionX(display.width - btnsize.width/2)
    self:addChild(change_btn); 
    change_btn:addClickEventListener(function ( ... )
        -- body
        if self.page_index ~= 3 then 
            self.page_index =3; 
            self:chose_page();
            self:createCenter();
        end 
    end)
    table.insert(self.buttons, change_btn)

    self:chose_page();
end

function BankScene:chose_page( ... )
    -- body
    for i, v in ipairs(self.buttons)do 
        if self.page_index == i then
            v:loadTextureNormal("bank/bottom_btn_pre.jpg")
        else 
            v:loadTextureNormal("bank/bottom_btn.jpg")
        end 
    end 
end

--存入金币 
function BankScene:create_savePage( ... )
    -- body
    local center = self.center; 
    self.center:removeAllChildren();
    
    self.title:setString("存款");
    -- 金币   
    local start_x = 160
    local jb_y = display.height - 240
    local jb_ms = cc.Label:createWithSystemFont("携带的金币 : " .. Utils.getJb(MyInfo.jb), "Arial", 30)
    local jbms_size = jb_ms:getContentSize()
    jb_ms:setTextColor(cc.c3b(0, 0, 0));
    jb_ms:setPosition(start_x, jb_y );
    jb_ms:setAnchorPoint(cc.p(0 ,0))
    center:addChild(jb_ms)

    --存款 
    local save = cc.Label:createWithSystemFont("银行的存款 : " .. Utils.getJb(MyInfo.bankGold), "Arial", 30)
    local save_size = save:getContentSize(); 
    save:setPosition(start_x, jb_y - 50); 
    save:setAnchorPoint(cc.p(0 ,0))
    center:addChild(save); 
    save:setTextColor(cc.c3b(0, 0, 0)); 

    --
    -- 存入输入框
    local layout = ccui.Layout:create(); 
    layout:setAnchorPoint(cc.p(0, 0))

    local inputbg = display.newSprite("bank/input.png");
    local inputsize = inputbg:getContentSize();

    local label = cc.Label:createWithSystemFont("要存入的金币: ", "Arial", 30);
    label:setAnchorPoint(cc.p(0, 0));
    label:setTextColor(cc.c3b(0, 0, 0));
    local labelSize = label:getContentSize();
    layout:addChild(label) 
    label:setPosition(0, (inputsize.height - labelSize.height)/2)

    
    local input_nm = ccui.EditBox:create(inputsize ,"bank/input.png");

    input_nm:setAnchorPoint(cc.p(0,0))
    input_nm:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    input_nm:setPosition(labelSize.width, 0);
    layout:addChild(input_nm);

    local cancel_btn = ccui.Button:create("bank/cancel_btn.png"); 
    local btnsize = cancel_btn:getContentSize();
    layout:addChild(cancel_btn);
    cancel_btn:setAnchorPoint(cc.p(0,0));
    cancel_btn:setTitleText("清 除")
    cancel_btn:setTitleFontSize(30);
    cancel_btn:addClickEventListener(function ( ... )
        -- body
        input_nm:setText("") ;
    end)
    cancel_btn:setPosition(labelSize.width + inputsize.width + 10, 0)

    local layoutsize = cc.size(labelSize.width + inputsize.width + btnsize.width + 20, inputsize.height)
    layout:setContentSize(layoutsize);
    layout:setPosition((display.width - layoutsize.width)/2 , display.height - 450);
    center:addChild(layout); 
    

    local sub_btn = ccui.Button:create("bank/btn.png");
    local subbtn_size = sub_btn:getContentSize(); 
    sub_btn:setTitleText("确 认");
    sub_btn:setTitleFontSize(30); 
    center:addChild(sub_btn);
    sub_btn:addClickEventListener(function ( ... )
        -- body
        
        local jb = tonumber(input_nm:getText()) 
        if not jb  or  jb == 0 then 
            local layout=  Utils.createPop(1, {ms="请输入要存入的金额"});
            layout:setName("popwin")
            self:addChild(layout); 
            layout:setPosition((display.width - layout.size.width)/2, (display.height - layout.size.height)/2);
            return;
        end 

        local param =  {gold=jb}
        MsgMgr.sendData({cmd = 30001, msg =param}); 
        -- 注册回调函数
        MsgMgr.waitMsg(30001,function ( data)
            -- body
            if data.code == 0 then  --注册成功
                print("存入金币成功");  
                MyInfo.jb = data.data.gold; -- bankGold 
                MyInfo.bankGold = data.data.bankGold
                jb_ms:setString("携带的金币 : " .. Utils.getJb(MyInfo.jb))  
                save:setString("银行的存款 : " .. Utils.getJb(MyInfo.bankGold))
                input_nm:setText("")

                local layout=  Utils.createPop(1, {ms="存入金币成功"});
                layout:setName("popwin")
                self:addChild(layout); 
                layout:setPosition((display.width - layout.size.width)/2, (display.height - layout.size.height)/2);
            else 
                CodeRes.showTip(data.code); 
            end 
        end)
    
    
    
    
    
    end)
    sub_btn:setPosition(display.cx + 32, display.height - 580);
end
    
-- 取金币
function BankScene:create_getPage( ... )
    -- body
    local center = self.center; 
    self.center:removeAllChildren();
    
    self.title:setString("取款");
    -- 金币   
    local start_x = 160
    local jb_y = display.height - 240
    local jb_ms = cc.Label:createWithSystemFont("携带的金币 : " .. Utils.getJb(MyInfo.jb), "Arial", 30)
    local jbms_size = jb_ms:getContentSize()
    jb_ms:setTextColor(cc.c3b(0, 0, 0));
    jb_ms:setPosition(start_x, jb_y );
    jb_ms:setAnchorPoint(cc.p(0 ,0))
    center:addChild(jb_ms)

    --存款 
    local save = cc.Label:createWithSystemFont("银行的存款 : " .. Utils.getJb(MyInfo.bankGold), "Arial", 30)
    local save_size = save:getContentSize(); 
    save:setPosition(start_x, jb_y - 50); 
    save:setAnchorPoint(cc.p(0 ,0))
    center:addChild(save); 
    save:setTextColor(cc.c3b(0, 0, 0)); 

    --
    -- 取出输入框
    local layout = ccui.Layout:create(); 
    layout:setAnchorPoint(cc.p(0, 0))

    local inputbg = display.newSprite("bank/input.png");
    local inputsize = inputbg:getContentSize();

    local label = cc.Label:createWithSystemFont("要取出的金币: ", "Arial", 30);
    label:setAnchorPoint(cc.p(0, 0));
    label:setTextColor(cc.c3b(0, 0, 0));
    local labelSize = label:getContentSize();
    layout:addChild(label) 
    label:setPosition(0, (inputsize.height - labelSize.height)/2)

    
    local input_nm = ccui.EditBox:create(inputsize ,"bank/input.png");

    input_nm:setAnchorPoint(cc.p(0,0))
    input_nm:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    input_nm:setPosition(labelSize.width, 0);
    layout:addChild(input_nm);

    local cancel_btn = ccui.Button:create("bank/cancel_btn.png"); 
    local btnsize = cancel_btn:getContentSize();
    layout:addChild(cancel_btn);
    cancel_btn:setAnchorPoint(cc.p(0,0));
    cancel_btn:setTitleText("清 除")
    cancel_btn:setTitleFontSize(30);
    cancel_btn:addClickEventListener(function ( ... )
        -- body
        input_nm:setText("");
    end)
    cancel_btn:setPosition(labelSize.width + inputsize.width + 10, 0)

    local layoutsize = cc.size(labelSize.width + inputsize.width + btnsize.width + 20, inputsize.height)
    layout:setContentSize(layoutsize);
    layout:setPosition((display.width - layoutsize.width)/2 , display.height - 450);
    center:addChild(layout); 
    

    local start_x= (display.width - layoutsize.width)/2
    -- 取款密码 输入框
    local layout = ccui.Layout:create(); 
    layout:setAnchorPoint(cc.p(0, 0))

    local inputbg = display.newSprite("bank/input.png");
    local inputsize = inputbg:getContentSize();

    local label = cc.Label:createWithSystemFont("取款密码       : ", "Arial", 30);
    label:setAnchorPoint(cc.p(0, 0));
    label:setTextColor(cc.c3b(0, 0, 0));
    local labelSize = label:getContentSize();
    layout:addChild(label) 
    label:setPosition(0, (inputsize.height - labelSize.height)/2)

    
    local input_pw = ccui.EditBox:create(inputsize ,"bank/input.png");

    input_pw:setAnchorPoint(cc.p(0,0))
    input_pw:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    input_pw:setPosition(labelSize.width, 0);
    layout:addChild(input_pw);

    local layoutsize = cc.size(labelSize.width + inputsize.width, inputsize.height)
    layout:setContentSize(layoutsize);
    layout:setPosition(start_x, display.height - 560);
    center:addChild(layout); 



    local tip = cc.Label:createWithSystemFont("提示: 银行初始密码为888888, 若忘记密码, 请联系客服", "Arial", 22);
    tip:setAnchorPoint(cc.p(0,0));
    tip:setTextColor(cc.c3b(255, 0, 0));
    tip:setPosition(start_x, display.height - 620)
    center:addChild(tip)

    local sub_btn = ccui.Button:create("bank/btn.png");
    local subbtn_size = sub_btn:getContentSize(); 
    sub_btn:setTitleText("确 认");
    sub_btn:setTitleFontSize(30); 
    center:addChild(sub_btn);
    sub_btn:addClickEventListener(function ( ... )
        -- body
         local jb = tonumber(input_nm:getText()) 
        local pw = input_pw:getText(); 
         
        if not jb  or  jb == 0 then 
            local layout=  Utils.createPop(1, {ms="请输入要取出的金额"});
            layout:setName("popwin")
            self:addChild(layout); 
            layout:setPosition((display.width - layout.size.width)/2, (display.height - layout.size.height)/2);
            return;
        end 
        if pw == "" then  
            local layout=  Utils.createPop(1, {ms="请输入你的取款密码"});
            layout:setName("popwin")
            self:addChild(layout); 
            layout:setPosition((display.width - layout.size.width)/2, (display.height - layout.size.height)/2);
            return;
         
        end
        
        local param =  {gold=jb, pwd = pw}
        MsgMgr.sendData({cmd = 30002, msg =param}); 
        -- 注册回调函数
        MsgMgr.waitMsg(30002,function ( data)
            -- body
            if data.code == 0 then  --注册成功
                print("取出金币成功");  
                MyInfo.jb = data.data.gold; -- bankGold 
                MyInfo.bankGold = data.data.bankGold
                jb_ms:setString("携带的金币 : " .. Utils.getJb(MyInfo.jb))  
                save:setString("银行的存款 : " .. Utils.getJb(MyInfo.bankGold));
                input_nm:setText("");
                input_pw:setText("")
                local layout=  Utils.createPop(1, {ms="取出金币成功"});
                layout:setName("popwin")
                self:addChild(layout); 
                layout:setPosition((display.width - layout.size.width)/2, (display.height - layout.size.height)/2);
            else 
                CodeRes.showTip(data.code); 
            end 
        end)
    
    end)
    sub_btn:setPosition(display.cx + 32, display.height - 690);
end

--修改密码
function BankScene:create_changePage( ... )
    -- body
    local center = self.center; 
    self.center:removeAllChildren();
    
    self.title:setString("修改密码");
    -- 金币   
    local start_x = 160
    local jb_y = display.height - 290
    local jb_ms = cc.Label:createWithSystemFont("您当前使用的银行密码为初始密码,存在一定的风险！建议您尽快设置新的银行密码！", "Arial", 30)
    jb_ms:setTextColor(cc.c3b(255, 0, 0));
    jb_ms:setWidth(display.width - start_x - 40); 
    jb_ms:setMaxLineWidth(display.width - start_x - 40);
    local jbms_size = jb_ms:getContentSize()
    jb_ms:setPosition(start_x, jb_y );
    jb_ms:setAnchorPoint(cc.p(0 ,0))
    center:addChild(jb_ms)

    
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

    local input_old = ccui.EditBox:create(inputsize ,"bank/input.png");

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

    local input_new = ccui.EditBox:create(inputsize ,"bank/input.png");

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

    local input_re = ccui.EditBox:create(inputsize ,"bank/input.png");

    input_re:setAnchorPoint(cc.p(0,0))
    input_re:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    input_re:setPosition(labelSize.width, 0);
    layout:addChild(input_re);


    local layoutsize = cc.size(labelSize.width + inputsize.width, inputsize.height)
    layout:setContentSize(layoutsize);
    layout:setPosition(start_x , display.height - 650);
    center:addChild(layout); 

    local tip = cc.Label:createWithSystemFont("提示: 银行初始密码为888888, 若忘记密码, 请联系客服", "Arial", 22);
    tip:setAnchorPoint(cc.p(0,0));
    tip:setTextColor(cc.c3b(255, 0, 0));
    tip:setPosition(start_x, display.height - 700)
    center:addChild(tip)


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
        local param =  {oldPwd= old, pwd = new}
        MsgMgr.sendData({cmd = 30007, msg =param}); 
        -- 注册回调函数
        MsgMgr.waitMsg(30007,function ( data)
            -- body
            if data.code == 0 then  --注册成功
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
    sub_btn:setPosition(display.cx + 32, display.height - 760);
end

return BankScene
