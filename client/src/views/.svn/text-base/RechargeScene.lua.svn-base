local RechargeScene = class("RechargeScene", cc.load("mvc").ViewBase)

function RechargeScene:onCreate()
    
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
    local title = cc.Label:createWithSystemFont("充值", "Arial", 40)
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
    self:createCenter(title_bgsize.height)
    
end

function RechargeScene:createCenter( startY )
    -- body
    local czbg = display.newSprite("recharge/bg.png");
    local bgsize = czbg:getContentSize();
    self:addChild(czbg);
    local scalex = display.width/bgsize.width
    czbg:setScaleX(scalex);

    czbg:setPosition(display.cx, display.height - startY -  bgsize.height/2 - 20);


     --微信充
    local wxcz = ccui.Button:create("recharge/exit_bg.png")
    self:addChild(wxcz) 
    wxcz:addClickEventListener(function ( ... )
        -- body
        local layout=  Utils.createPop(1, {ms="系统升级中...",});
        self:addChild(layout); 
        layout:setPosition((display.width - layout.size.width)/2, (display.height - layout.size.height)/2);
    end);

    wxcz:setTitleText("充值")
    wxcz:setTitleFontSize(34)

    local czsize = wxcz:getContentSize();
    wxcz:setPosition(display.width - czsize.width /2 - 40, display.height - startY - 70)

    local offy = 160;

     --支付宝充值
    local zfbcz = ccui.Button:create("recharge/exit_bg.png")
    self:addChild(zfbcz) 
    zfbcz:addClickEventListener(function ( ... )
        -- body
        local layout=  Utils.createPop(1, {ms="系统升级中...",});
        self:addChild(layout); 
        layout:setPosition((display.width - layout.size.width)/2, (display.height - layout.size.height)/2);
    end);
    zfbcz:setTitleText("充值")
    zfbcz:setTitleFontSize(34)
    zfbcz:setPosition(display.width - czsize.width /2 - 40, display.height - startY - 70 - offy);
 
end


return RechargeScene;
