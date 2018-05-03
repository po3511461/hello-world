local DescScene = class("DescScene", cc.load("mvc").ViewBase)

function DescScene:onCreate()
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
    local title = cc.Label:createWithSystemFont("说明", "Arial", 40)
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


    --描述
    -- 名称
    local nm = cc.Label:createWithSystemFont("暂未描述", "Arial", 30)
    nm:setAnchorPoint(0,1)
    nm:setPosition(10, display.height - 150)
    nm:setTextColor(cc.c3b(0, 0,0));
    self:addChild(nm);
end

return DescScene
