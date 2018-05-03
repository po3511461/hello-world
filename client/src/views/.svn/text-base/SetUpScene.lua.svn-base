local SetUpScene = class("SetUpScene", cc.load("mvc").ViewBase)

function SetUpScene:onCreate()
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
    local title = cc.Label:createWithSystemFont("个人中心", "Arial", 40)
    title:setPosition(display.cx, display.height - title_bgsize.height/2)
    title:enableShadow(cc.c4b(0, 0, 0), cc.size(1,1), 1) -- 启动阴影 
    title:enableOutline(cc.c4b(0,0,0), 1) -- 启动描边
    self:addChild(title); 

    local fh_wz = ccui.Text:create("< 红信", "Arial" , 40)
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
                require("app.MyApp"):create():enterScene("CityScene", "moveinl");
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


    --info
    local bg_y = display.height -  title_bgsize.height
   	local info_bg = display.newSprite("person/info_bg.jpg");
   	local bgSize = info_bg:getContentSize(); 
   	self:addChild(info_bg); 
   	info_bg:setAnchorPoint(cc.p(0,1)) 
   	local scalex = display.width/bgSize.width
   	info_bg:setScaleX(scalex);
   	info_bg:setPosition(0, bg_y)

    -- 头像
   	local tx = display.newSprite("head/" ..  MyInfo.avatar ..".jpg"); 
   	self:addChild(tx)
   	tx:setPosition(60, bg_y - bgSize.height/2)

    local layout = ccui.Layout:create();
    self:addChild(layout);

    layout:setAnchorPoint(cc.p(0, 0)); 

    -- 用户名
    local height = 0 
    local nm = cc.Label:createWithSystemFont(MyInfo.nickName, "Arial", 30)
    local nmSize = nm:getContentSize();
    nm:setAnchorPoint(cc.p(0, 0))
    nm:setPosition(0, -nmSize.height);
    -- nm:enableShadow(cc.c4b(0, 0, 0), cc.size(1,1), 1) -- 启动阴影 
    -- nm:enableOutline(cc.c4b(0,0,0), 1) -- 启动描边
    nm:setTextColor(cc.c3b(0, 0, 0));
    layout:addChild(nm); 

    height = height + nmSize.height + 5;
    
    -- 金币
    local jb = cc.Label:createWithSystemFont("金币金额  " .. MyInfo.jb, "Arial", 24)
    local jbSize = jb:getContentSize();
    jb:setTextColor(cc.c3b(0, 0, 0));
    jb:setPosition(0, -height - jbSize.height);
    layout:addChild(jb); 
    jb:setAnchorPoint(cc.p(0, 0))
    height = height + jbSize.height + 5;

    -- 推荐码
    local zh = cc.Label:createWithSystemFont("账号   " .. MyInfo.uniqueId, "Arial", 24)
    local zhSize = zh:getContentSize();
    zh:setTextColor(cc.c3b(0, 0, 0));
    zh:setPosition(0, -height - zhSize.height);
    layout:addChild(zh); 
    zh:setAnchorPoint(cc.p(0, 0))
    height = height + zhSize.height + 5;

    layout:setContentSize(cc.size(display.width, height));

    layout:setPosition(60 + tx:getContentSize().width/2 + 25,  bg_y - (bgSize.height - height)/2)


    --推荐吗 
    local info_y = bg_y - bgSize.height -20;
    local offy = 20 
    local tjm = display.newSprite("person/code.jpg")
    self:addChild(tjm) 
    local tjmsize = tjm:getContentSize();
    tjm:setScaleX(display.width/ tjmsize.width);
    tjm:setPosition(0,  info_y - tjmsize.height - offy);
    tjm:setAnchorPoint(cc.p(0, 0)); 

    local tjmwz = cc.Label:createWithSystemFont(MyInfo.promoCode, "Arial", 24);
    tjmwz:setAnchorPoint(cc.p(1, 0));
    tjmwz:setTextColor(cc.c3b(0, 0, 0));
    tjmwz:setPosition(display.width - 20,  (tjmsize.height - tjmwz:getContentSize().height)/2)
    tjm:addChild(tjmwz); 

    --排行榜 
    local tjm_y = tjm:getPositionY();

    local rank = ccui.Button:create("person/rank.jpg")
    rank:addClickEventListener(function ( ... )
        -- body
        local param =  {type=1}
        MsgMgr.sendData({cmd = 4001, msg =param}); 
        -- 注册回调函数
        MsgMgr.waitMsg(4001, function ( data)
            -- body
            if data.code == 0 then  --请求列表成功
                print("请求财富列表成功");
                MyInfo.rankList = data.data; 
                require("app.MyApp"):create():enterScene("RankScene", "MOVEINR");
            else 
                CodeRes.showTip(data.code); 
            end 
        end)
    end);
    self:addChild(rank) 
    local ranksize = rank:getContentSize();
    rank:setScaleX(display.width/ ranksize.width);
    rank:setPosition(0,  tjm_y - ranksize.height - offy);
    rank:setAnchorPoint(cc.p(0, 0)); 

    --礼物 
    local rank_y = rank:getPositionY()
    local gift = ccui.Button:create("person/gift.jpg")
    self:addChild(gift) 
    gift:addClickEventListener(function ( ... )
        -- body
        require("app.MyApp"):create():enterScene("GiftScene", "MOVEINR");
   
    end)
    local giftsize = gift:getContentSize();
    gift:setScaleX(display.width/ giftsize.width);
    gift:setPosition(0,  rank_y - giftsize.height - offy);
    gift:setAnchorPoint(cc.p(0, 0)); 



    --设置
    local gift_y = gift:getPositionY()
    local set = ccui.Button:create("person/set.jpg")
    self:addChild(set)
    set:addClickEventListener(function ( ... )
        -- body
        -- require("app.MyApp"):create():enterScene("SetInfoScene", "MOVEINR");
        local record = require("views.RedPackageRecordScene"):create(); 
        self:addChild(record);
    end)
    local setsize = set:getContentSize();
    set:setScaleX(display.width/ setsize.width);
    set:setPosition(0,  gift_y - setsize.height - offy);
    set:setAnchorPoint(cc.p(0, 0)); 


    --充值
    local set_y = set:getPositionY()
    local pay = ccui.Button:create("person/pay.jpg")
    self:addChild(pay) 
    pay:addClickEventListener(function ( ... )
        -- body
        require("app.MyApp"):create():enterScene("RechargeScene", "MOVEINR")
    end)
    local paysize = pay:getContentSize();
    pay:setScaleX(display.width/ paysize.width);
    pay:setPosition(0,  set_y - paysize.height - offy);
    pay:setAnchorPoint(cc.p(0, 0)); 

    --bank
    local bank_y = pay:getPositionY()
    local bank = ccui.Button:create("person/bank.jpg")
    bank:addClickEventListener(function ( ... )
        -- body
        require("app.MyApp"):create():enterScene("BankScene", "MOVEINR");
    end)
    
    self:addChild(bank) 
    local banksize = bank:getContentSize();
    bank:setScaleX(display.width/ banksize.width);
    bank:setPosition(0,  bank_y - banksize.height - offy);
    bank:setAnchorPoint(cc.p(0, 0)); 

    --退出 
    local exit_y = bank:getPositionY()
    local exit = ccui.Button:create("person/exit.jpg")
    self:addChild(exit) 
    exit:addClickEventListener(function ( ... )
        -- body
        local layout=  Utils.createPop(2, {ms="你确定退出游戏?", yesFun = function ( ... )
            -- body
            -- 退出游戏，不切断socket，直接清除玩家数据，重新登录。
            local param =  {}
            MsgMgr.sendData({cmd = 102, msg =param}); 
        end});
        layout:setName("popwin")
        self:addChild(layout); 
        layout:setPosition((display.width - layout.size.width)/2, (display.height - layout.size.height)/2);
        
    end)

    local exitsize = exit:getContentSize();
    exit:setScaleX(display.width/ exitsize.width);
    exit:setPosition(0,  exit_y - exitsize.height - offy - 40 );
    exit:setAnchorPoint(cc.p(0, 0)); 
end

return SetUpScene
