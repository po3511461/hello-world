-- 发红包场景

local RedPackageScene = class("RedPackageScene", cc.load("mvc").ViewBase)

function RedPackageScene:onCreate()
	self.page_index = 1; --1:操作按钮不显示， 2:操作按钮显示
	self.listdata = MyInfo.roomData.redPacketList

	table.sort(self.listdata, function ( a,b)
		-- body
		return a.id < b.id;
	end)

	for i,v in ipairs(self.listdata)do 
		-- v.cd = 5000;
		if  v.cd  then 
			v.endtime = os.time() + math.ceil(v.cd /1000); 
		end 
	end 

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
    local layout = ccui.Layout:create();
    layout:setLocalZOrder(10);
    local title_bg = display.newSprite("city/top.jpg");
    local title_bgsize = title_bg:getContentSize()
    title_bg:setScaleX(display.width/title_bgsize.width)
    title_bg:setAnchorPoint(cc.p(0,0))
    layout:setContentSize(cc.size(display.width, title_bgsize.height))
    self:addChild(layout);
   	layout:setAnchorPoint(cc.p(0,0))
    layout:setPosition(0, display.height - title_bgsize.height);
    layout:addChild(title_bg); 

    self.title_bgsize = title_bgsize;
    -- add title
    local roomInfo 
	-- body
	for i,v in ipairs(MyInfo.roomList)do 
		if v.id == MyInfo.roomID then 
			roomInfo = v;
			break;
		end 
	end 

    local nm = "金币群"
    if roomInfo then 
    	nm = roomInfo.name
    end 
    local title = cc.Label:createWithSystemFont(nm, "Arial", 40)
    title:setPosition(display.cx,  title_bgsize.height/2)
    title:enableShadow(cc.c4b(0, 0, 0), cc.size(1,1), 1) -- 启动阴影 
    title:enableOutline(cc.c4b(0,0,0), 1) -- 启动描边
    layout:addChild(title); 

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
            	-- 退出房间
            	local param =  {id=MyInfo.roomID}
			    MsgMgr.sendData({cmd = 20002, msg =param}); 
			    -- 进入房间
			    MsgMgr.waitMsg(20002,function (data)
			        -- body
			        if data.code == 0 then  -- 退出房间成功
			        	MyInfo.roomID = nil;
			        	MyInfo.roomData = nil;
			            require("app.MyApp"):create():enterScene("CityScene", "moveinl");
			        else
			            print("退出房间失败, data.code = ", data.code);
			        end
			    end)
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
    fh_wz:setPosition(5, title_bgsize.height/2)
    layout:addChild(fh_wz);

    --center
    local hbbg = display.newSprite("redpackage/rpbg.png");
	local hb_size = hbbg:getContentSize();
	local cell_height = (hb_size.height + 20)
    self.cell_height = cell_height;

    local bottom_height = 85
	-- add ScrollView 滚动区域
	local center_height = display.height - title_bgsize.height - bottom_height - 5
	self.center_height = center_height;
	self.centerview = self:createTableView(display.width, center_height)  
	self.centerview:setPosition(0, bottom_height);  
	self.centerview:setVisible(true)  
	self.centerview:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)  
	self.centerview:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)  
	self.centerview:setAnchorPoint(cc.p(0,0))  
	self.centerview:setName("centerview")
	self:addChild(self.centerview)
	self.centerview:setDelegate();
	self.centerview:reloadData()
	if #self.listdata * cell_height >= center_height then 
		self.centerview:setContentOffset(cc.p(0 , 0));
	end 
	-- bottom
	self:createBottom()  
end


function RedPackageScene:createBottom( ... )
	-- body	
	local layout = ccui.Layout:create();
	self:addChild(layout);
	layout:setAnchorPoint(cc.p(0, 0));


	local bottom_bg = display.newSprite("redpackage/bottom.jpg");
	layout:addChild(bottom_bg)
	local bottom_bgsize = bottom_bg:getContentSize();
	bottom_bg:setScaleX(display.width/ bottom_bgsize.width);
	bottom_bg:setAnchorPoint(cc.p(0,0))
	bottom_bg:setPosition(0, 0)

	layout:setContentSize(cc.size(display.width, bottom_bgsize.height))

	local offy = 40
	local offx = 40
	-- 喇叭按钮
	local lb_btn = ccui.Button:create("redpackage/lb.png")
	lb_btn:addClickEventListener(function ( ... )

	end)
	lb_btn:setPosition(offx, offy)
	layout:addChild(lb_btn);

	--输入框
	local input = display.newSprite("redpackage/input.png")
	input:setPosition(display.width/2, offy)
	layout:addChild(input);

	-- add
	local add_btn = ccui.Button:create("redpackage/add.png", "redpackage/add_pre.png");
	add_btn:addClickEventListener(function ( ... )
		-- body
		if self.page_index ==1 then 
			self.page_index = 2; 
			local action = cc.MoveTo:create(0.1, cc.p(0, 350));
			layout:runAction(action);
			self.centerview:setPosition(0, bottom_bgsize.height + 350)

			self.centerview:setContentOffset(cc.p(0,0))

			-- 打开萌版
			local bg = ccui.Layout:create()
			bg:setLocalZOrder(5)
			bg:setAnchorPoint(cc.p(0, 0));
			bg:setPosition(0, 85);
			bg:setTouchEnabled(true);
			bg:setName("zd_bg")
			local listener = cc.EventListenerTouchOneByOne:create();
		    listener:registerScriptHandler(function (touch, event)
		        -- 测试代码 关闭，操作按钮弹出。
		        local beginPos = touch:getLocation()
		      	if beginPos.y >= 350+85 then 
		 			if self.page_index == 2 then 
		 				self.page_index=1;
						layout:setPosition(0, 0);
						self.centerview:setPosition(0, bottom_bgsize.height)
						layout:removeChildByName("zd_bg", true);
					end
			        return true;
			    end
		    end,cc.Handler.EVENT_TOUCH_BEGAN)
		    local eventDispatcher = bg:getEventDispatcher()
		    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, bg)
			layout:addChild(bg);
		end 
	end)
	add_btn:setPosition(display.width - offx, offy)
	layout:addChild(add_btn);

	-- 操作按钮 
	local _height = 350
	-- layout:setPosition(0, _height);

	local cz_bg = display.newSprite("redpackage/bottom.jpg")
	local czbg_size = cz_bg:getContentSize();
	cz_bg:setScaleY(_height/czbg_size.height);
	cz_bg:setAnchorPoint(cc.p(0,1))
	layout:addChild(cz_bg)

	local czinfo = {
		{type = 1, png = "redpackage/rp.png", prepng = "redpackage/rp_pre.png"}, --红包
		{type = 2, png = "redpackage/pay.png", prepng = "redpackage/pay_pre.png"}, --充值
		{type = 3, png = "redpackage/check.png", prepng = "redpackage/check_pre.png"}, --账单
		{type = 4, png = "redpackage/kf.png", prepng = "redpackage/kf_pre.png"}, --客服
		{type = 5, png = "redpackage/rank.png", prepng = "redpackage/rank_pre.png"}, --排行榜
		{type = 6, png = "redpackage/bank.png", prepng = "redpackage/bank_pre.png"}, --银行
	}
	-- 排行榜按钮 
	--红包按钮 
	local row_num = 4 -- 一排4个
	local offy = 40
	local off_h = 20
	local btn_size = display.newSprite("redpackage/rp.png"):getContentSize();
	local offx = btn_size.width/2 + 40
	local off_w = (display.width- offx * 2)/3
	for i, v in ipairs(czinfo)do 
		local hb_btn = ccui.Button:create(v.png, v.pre_png);
		hb_btn:addClickEventListener(function ( ... )
			-- body
			if v.type == 1 then
				--点击红包按钮
			elseif v.type == 2 then 
				--点击充值按钮
			end 
		end)
		hb_btn:setPosition(offx + math.floor((i -1)%row_num) * off_w,   - (offy + btn_size.height/2 +  math.floor((i -1)/row_num) *  (off_h + btn_size.height)));

		layout:addChild(hb_btn)
	end 
end

-----------------
--创建TableView  
function RedPackageScene:createTableView(width, height)  
	local hbbg = display.newSprite("redpackage/rpbg.png");
	local hb_size = hbbg:getContentSize();

    local membersTableView = cc.TableView:create(cc.size(width, height)); 

    -- 设置cell的数量
    membersTableView:registerScriptHandler(function (view) 	
        return #self.listdata;
    end,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)   
  	
  	-- cell的尺寸大小 	
    membersTableView:registerScriptHandler(function (view,index)  
        return display.width, self.cell_height;
    end,cc.TABLECELL_SIZE_FOR_INDEX)  
  	
  	-- 为TableView创建在某个位置的Cell。
    membersTableView:registerScriptHandler(function (view,index)  
        local cell = view:cellAtIndex(index)  
 
	    if not cell then
	    	cell = cc.TableViewCell:new();
	    	local info = self.listdata[index + 1]
	        if  info then 
	        	local item = self:createCenterItem(info) 
	        	cell.id = info.id;
	        	cell.info = info;
	        	cell:addChild(item) 
	        end 
	    end  
	    return cell  
    end,cc.TABLECELL_SIZE_AT_INDEX)  
  	
  	-- 选中cell回调
    membersTableView:registerScriptHandler(function (view,cell)  
        --点击红包 
        --获取红包状态 
        -- 打开抢红包界面
        -- 如果 红包已经
        local info  = cell.info 
        if info.opened == 1  then -- 已经领取过，弹出领取详情界面 
        	local param =  {roomId=MyInfo.roomID, redPacketId = info.id}
		    MsgMgr.sendData({cmd = 20004, msg =param}); 
		    -- 进入房间
		    MsgMgr.waitMsg(20004,function (data)
		        -- body
		        if data.code == 0 then  -- 退出房间成功
		        	local list = data.data.receiveRecordList;
	    			self:createXqPanel(list, info);
		        else
		           	CodeRes.showTip(data.code); 
		        end
		    end)
       	else 
       		if  info.finish then -- 已经领取完了 
       			-- 弹出你来晚了 
       			self:createEndPanel(cell);
       		else
       			self:createPreOpenPanel(cell);
       		end  
       	end 

    end,cc.TABLECELL_TOUCHED)  
  
    return membersTableView  
end  

-----------------------------
-- 绘制房间红包列表
-- @param data = {id:红包id, sendPid:发送者id，sendNickName=发送者名称, sendAvatar=发送者头像, 
--	             roomId=房间id,redPacketMoney=红包金额，mines=雷数}
function RedPackageScene:createCenterItem( data )
	-- body
	local cell_height = self.cell_height
	local layout = ccui.Layout:create()
	layout.size = cc.size(display.width, cell_height)
	layout:setAnchorPoint(cc.p(0, 0));
	layout:setContentSize(layout.size);

	local tx = display.newSprite("head/" .. data.sendAvatar .. ".jpg");
	layout:addChild(tx)

	tx:setAnchorPoint(cc.p(0, 1));
	tx:setPosition(10, cell_height)

	if data.opened == 1 then -- 已经打开了红白 
		local bg_btn = display.newSprite("redpackage/geted.png")
		bg_btn:setAnchorPoint(cc.p(0,1))
		bg_btn:setPosition(cc.p(tx:getContentSize().width + 15, cell_height));
		layout:addChild(bg_btn);
	else
		local bg_btn = display.newSprite("redpackage/rpbg.png")
		bg_btn:setAnchorPoint(cc.p(0,1))
		bg_btn:setPosition(cc.p(tx:getContentSize().width + 15, cell_height));
		local bgSize = bg_btn:getContentSize();
		layout:addChild(bg_btn);

		-- 图标
		local hb_tb = display.newSprite("redpackage/rptb.png");
		bg_btn:addChild(hb_tb)
		hb_tb:setPosition(70, 115)

		--title 
		local title = cc.Label:createWithSystemFont(data.redPacketMoney .. " 金币" .. data.id, "Arial", 35); 
		title:setAnchorPoint(cc.p(0, 1))
		-- title:setTextColor(cc.c3b(0, 0, 0));
		bg_btn:addChild(title);
		title:setPosition(120, cell_height - 40); 

		-- txt
		local txt = cc.Label:createWithSystemFont("领取红包", "Arial", 35); 
		txt:setAnchorPoint(cc.p(0, 0))
		-- txt:setTextColor(cc.c3b(0, 0, 0));
		bg_btn:addChild(txt);
		txt:setPosition(120, cell_height - 145); 
		-- ms   
		local ms = cc.Label:createWithSystemFont("红信红包", "Arial", 24); 
		ms:setAnchorPoint(cc.p(0, 0))
		ms:setTextColor(cc.c3b(0, 0, 0));
		bg_btn:addChild(ms);
		ms:setPosition(30, 5);

		if data.endtime  then
			local cd = math.ceil(data.endtime - os.time())
			if cd > 0 then 
				-- 回执开枪倒计时 
				local djs = cc.Label:createWithSystemFont("开抢倒计时: " .. cd, "Arial", 24); 
				djs.cd = cd 
				djs:setAnchorPoint(cc.p(0, 0))
				djs:setTextColor(cc.c3b(255, 0, 0));
				local djssize = djs:getContentSize();
				bg_btn:addChild(djs);
				djs:setPosition(bgSize.width - djssize.width - 10, 5);
				djs:runAction(
					cc.Repeat:create(
						cc.Sequence:create({
							cc.DelayTime:create(1);
							cc.CallFunc:create(function ( ... )
								-- body
								djs.cd = djs.cd - 1;
								if djs.cd <= 0 then 
									djs:setString("");
								else 
									djs:setString("开抢倒计时: " .. djs.cd);
								end 
							end)
						}), cd)
				);
			end 
		end  

	end 
	

	return layout;
end

function RedPackageScene:addRedPackage(data)
	-- body
	if data then 
		if data.sendPid == MyInfo.pid then 
			-- 弹出该你发红包提示
			local layout=  Utils.createPop(1, {ms = "您抢的最多，系统已帮您发红包！"});
			local scene = display.getRunningScene()
		    scene:addChild(layout); 
		    layout:setPosition((display.width - layout.size.width)/2, (display.height - layout.size.height)/2);
		end 

		if data.cd then 
			data.endtime = os.time() + math.ceil(data.cd /1000); 
		end 
		table.insert(self.listdata, data);
	end

	table.sort(self.listdata, function (a,b)
		return a.id < b.id 		-- body
	end)

	if self.page_index == 2 then 
		self.centerview:reloadData() -- 
		self.centerview:setContentOffset(cc.p(0 ,0)); -- 停留在最底部 
		return ;
	end 
	
	local old_set = self.centerview:getContentOffset();

	self.centerview:reloadData() -- 


	local realheight = #self.listdata *(self.cell_height)
	
	if realheight >= self.center_height then 
		if old_set.y == 0 then 
			self.centerview:setContentOffset(old_set); -- 停留在最底部 
		else 
			self.centerview:setContentOffset(cc.p(0, old_set.y - self.cell_height)); -- 停留在最底部 
		end 
	end 

end

-- 红包被打开ia界面 {money}
function RedPackageScene:createOpenPanel( info,redinfo )
	-- body
    local layout = ccui.Layout:create(); 
    layout:setLocalZOrder(101)
    layout:setTouchEnabled(true);
    local layoutsize = cc.size(display.width, display.height)
    layout:setContentSize(layoutsize);
    layout:setName("openpanel");
    self:addChild(layout);

    local bg = display.newSprite("redpackage/open_bg.jpg");
    local bgSize = bg:getContentSize();
    local scalex = display.width/bgSize.width
    bg:setAnchorPoint(0, 1);
    bg:setScaleX(scalex);
    bg:setPosition(0, display.height);
    layout:addChild(bg)

    -- 关闭按钮 
    local btn_offy = 20
    local exit_btn = ccui.Button:create("redpackage/close_text.png");
    local exit_btnsize = exit_btn:getContentSize(); 
    exit_btn:setPosition(exit_btnsize.width/2 + 20, display.height - exit_btnsize.height/2 - btn_offy);
    exit_btn:addClickEventListener(function ( ... )
    	-- body
    	self:removeChildByName("openpanel");
    end)
    layout:addChild(exit_btn)

    local title = cc.Label:createWithSystemFont("红信红包", "Arial", 34)
    local titlesize = title:getContentSize(); 
    layout:addChild(title); 
    title:setPosition(display.cx, display.height - titlesize.height/2 - btn_offy); 
 	
 	-- 记录
    local record_btn = ccui.Button:create("redpackage/rp_rec.png");
    local record_btnsize = record_btn:getContentSize(); 
    record_btn:setPosition(display.width -  record_btnsize.width/2 - 20, display.height - record_btnsize.height/2 - btn_offy);
    record_btn:addClickEventListener(function ( ... )
    	-- body
    	-- 打开今年的所有红包记录 
    	-- require("app.MyApp"):create():enterScene("RedPackageRecordScene", "MOVEINR")
    	local record = require("views.RedPackageRecordScene"):create(); 
    	self:addChild(record);
    	-- self:createRecordPanel();
    end)
    layout:addChild(record_btn)
  
    local jbbg = display.newSprite("redpackage/jbbg.jpg");
    local bgsize = jbbg:getContentSize();
    jbbg:setPosition(display.cx, display.height - bgsize.height/2  - btn_offy - 60)
    layout:addChild(jbbg);

    local jb = cc.Label:createWithSystemFont("你的余额: " .. MyInfo.jb - info.money, "Arial" , 28);
    jbbg:addChild(jb);
    jb:setPosition(bgsize.width/2, bgsize.height/2)

   
    layout:runAction(cc.Sequence:create({cc.DelayTime:create(0.5), cc.CallFunc:create(function ( ... )
    	-- body
    	 -- 播放金币特效
	    local sprite = display.newSprite("redpackage/jbbg.jpg");
		-- sprite:setOpacity(10);
	    layout:addChild(sprite)
	    local bgsize = sprite:getContentSize();
	    sprite:setPosition(display.cx, display.height - bgsize.height/2 - btn_offy - 180)
	    -- 播放金币特效 
	    local animation = cc.Animation:create();
		-- 加入每帧图片
		for i =1, 30 do 
			animation:addSpriteFrameWithFile("redpackage/jbtx/" .. i .. ".png")
		end 
		-- 设置每帧播放时间
		animation:setDelayPerUnit(1.5/30); 
		animation:setRestoreOriginalFrame(true);
		-- 创建 Animate 对象
		local action = cc.Animate:create(animation);
		-- 执行animation动画
		sprite:runAction(cc.Sequence:create({action, cc.CallFunc:create(function ( ... )
			-- body
			sprite:hide();
			jb:setString("你的余额: " .. MyInfo.jb);
		end)}));
		sprite:setLocalZOrder(10);

		-- 播放音效
		cc.SimpleAudioEngine:getInstance():playEffect("music/jb.mp3");
    end)}))
    --头像
    local tx = display.newSprite("head/" .. redinfo.sendAvatar .. ".jpg");
    local tx_y = display.height - 240
    local txSize = tx:getContentSize()
    layout:addChild(tx);
    tx:setPosition(display.width/2,  tx_y);

    -- 名字
    local nm = cc.Label:createWithSystemFont(redinfo.sendNickName, "Arial", 30)
    local nmsize = nm:getContentSize()
    nm:setTextColor(cc.c3b(0,0,0));
    local nm_y = tx_y - txSize.height/2 -  nmsize.height/2 - 45
    layout:addChild(nm);
    nm:setPosition(display.width/2, nm_y);

    local des = cc.Label:createWithSystemFont("恭喜发财，大吉大利", "Arial", 30)
    local dessize = des:getContentSize()
    des:setTextColor(cc.c3b(0,0,0));
    local des_y = nm_y - nmsize.height/2 -  dessize.height/2 - 20
    layout:addChild(des);
    des:setPosition(display.width/2, des_y);

    local reward = cc.Label:createWithSystemFont( info.money .. " 金币", "Arial", 30)
    local rewardsize = reward:getContentSize()
    reward:setTextColor(cc.c3b(0,0,0));
    local reward_y = des_y - rewardsize.height/2 -  dessize.height/2 - 70
    layout:addChild(reward);
    reward:setPosition(display.width/2, reward_y);


    local re_des = cc.Label:createWithSystemFont("已经存入您的金币包", "Arial", 30)
    local re_dessize = re_des:getContentSize()
    re_des:setTextColor(cc.c3b(0,0,0));
    local re_des_y = reward_y - rewardsize.height/2 -  re_dessize.height/2 - 30
    layout:addChild(re_des);
    re_des:setPosition(display.width/2, re_des_y);
    

    --领取列表
   	local lq_des = cc.Label:createWithSystemFont("已领取" .. 1 .. "/10个, 共" .. info.money .. "/" .. redinfo.redPacketMoney  .. "金币" , "Arial", 30)
    local lq_dessize = lq_des:getContentSize()
    lq_des:setTextColor(cc.c3b(0,0,0));
    local lq_des_y = re_des_y - re_dessize.height/2 - 75;
    layout:addChild(lq_des);
    lq_des:setPosition(lq_dessize.width/2 + 20, lq_des_y);


    -- 列表
    local start_y = lq_des_y - lq_dessize.height/2 - 10
    local center_height = start_y - 20
    local ScrollView_2 = ccui.ScrollView:create()
    ScrollView_2:setBounceEnabled(true)
    ScrollView_2:setDirection(1)
    ScrollView_2:setInnerContainerSize({width = display.width, height = center_height})
    ScrollView_2:ignoreContentAdaptWithSize(false)
    ScrollView_2:setClippingEnabled(true)
    ScrollView_2:setBackGroundColorType(1)
    ScrollView_2:setBackGroundColor({r = 255, g = 150, b = 100})
    ScrollView_2:setBackGroundColorOpacity(0)
    ScrollView_2:setLayoutComponentEnabled(true)
    ScrollView_2:setCascadeColorEnabled(true)
    ScrollView_2:setCascadeOpacityEnabled(true)
    ScrollView_2:setPosition(0, 20)
    local _layout = ccui.LayoutComponent:bindLayoutComponent(ScrollView_2)
    _layout:setPositionPercentX(0.7800)
    _layout:setPositionPercentY(0.4464)
    _layout:setPercentWidth(0.2083)
    _layout:setPercentHeight(0.3125)
    _layout:setSize({width = display.width, height = center_height})
    _layout:setLeftMargin(748.8054)
    _layout:setRightMargin(11.1946)
    _layout:setTopMargin(154.3036)
    _layout:setBottomMargin(285.6964)
   	layout:addChild(ScrollView_2)

    local lbdata ={ {nickName=MyInfo.nickName, avatar = MyInfo.avatar, money = info.money}, 
    				};
    local itemsize
   	for i,v in ipairs(lbdata)do
   		local item = self:createListItem(v);
   		ScrollView_2:addChild(item);
   		if not itemsize then 
   			itemsize = item.size;
   		end
   	end 

   	local scrollsize = ScrollView_2:getContentSize();
    local height = scrollsize.height;
    local offy = 0;
    if itemsize then 
        local realheight = (itemsize.height + offy) * # lbdata
        if realheight < height then 
            realheight  = height;
        end 

        for i,v in ipairs(ScrollView_2:getChildren())do 
            v:setPosition(0, realheight - i * itemsize.height); 
        end
    end 
    ScrollView_2:setInnerContainerSize(cc.size(display.width, height)); 
end


-- 红包被打开ia界面 {money}
function RedPackageScene:createXqPanel( list,redinfo )
	-- body
	-- 獲取運氣最佳
	local info 
	-- local maxjb = 0
	-- for i,v in ipairs(list)do 
	-- 	if v.money > maxjb then 
	-- 		info = v;
	-- 	end 
	-- end

    local layout = ccui.Layout:create(); 
    layout:setLocalZOrder(101)
    layout:setTouchEnabled(true);
    local layoutsize = cc.size(display.width, display.height)
    layout:setContentSize(layoutsize);
    layout:setName("openpanel");
    self:addChild(layout);

    local bg = display.newSprite("redpackage/open_bg.jpg");
    local bgSize = bg:getContentSize();
    local scalex = display.width/bgSize.width
    bg:setAnchorPoint(0, 1);
    bg:setScaleX(scalex);
    bg:setPosition(0, display.height);
    layout:addChild(bg)


    -- 关闭按钮 
    local btn_offy = 30
    local exit_btn = ccui.Button:create("redpackage/close_text.png");
    local exit_btnsize = exit_btn:getContentSize(); 
    exit_btn:setPosition(exit_btnsize.width/2 + 20, display.height - exit_btnsize.height/2 - btn_offy);
    exit_btn:addClickEventListener(function ( ... )
    	-- body
    	self:removeChildByName("openpanel");
    end)
    layout:addChild(exit_btn)

    local title = cc.Label:createWithSystemFont("红信红包", "Arial", 30)
    local titlesize = title:getContentSize(); 
    layout:addChild(title); 
    title:setPosition(display.cx, display.height - titlesize.height/2 - btn_offy); 
 	
 	-- 记录
    -- local record_btn = ccui.Button:create("redpackage/rp_rec.png");
    -- local record_btnsize = record_btn:getContentSize(); 
    -- record_btn:setPosition(display.width -  record_btnsize.width/2 - 20, display.height - record_btnsize.height/2 - btn_offy);
    -- record_btn:addClickEventListener(function ( ... )
    -- 	-- body
    	
    -- end)
    -- layout:addChild(record_btn)

    --头像
    local tx = display.newSprite("head/" .. redinfo.sendAvatar .. ".jpg");
    local tx_y = display.height - 240
    local txSize = tx:getContentSize()
    layout:addChild(tx);
    tx:setPosition(display.width/2,  tx_y);

    -- 名字
    local nm = cc.Label:createWithSystemFont(redinfo.sendNickName, "Arial", 30)
    local nmsize = nm:getContentSize()
    nm:setTextColor(cc.c3b(0,0,0));
    local nm_y = tx_y - txSize.height/2 -  nmsize.height/2 - 45
    layout:addChild(nm);
    nm:setPosition(display.width/2, nm_y);

    local des = cc.Label:createWithSystemFont("恭喜发财，大吉大利", "Arial", 30)
    local dessize = des:getContentSize()
    des:setTextColor(cc.c3b(0,0,0));
    local des_y = nm_y - nmsize.height/2 -  dessize.height/2 - 20
    layout:addChild(des);
    des:setPosition(display.width/2, des_y);
 

    -- 列表
    local start_y = des_y - 120;
    local center_height = start_y - 20
    local ScrollView_2 = ccui.ScrollView:create()
    ScrollView_2:setBounceEnabled(true)
    ScrollView_2:setDirection(1)
    ScrollView_2:setInnerContainerSize({width = display.width, height = center_height})
    ScrollView_2:ignoreContentAdaptWithSize(false)
    ScrollView_2:setClippingEnabled(true)
    ScrollView_2:setBackGroundColorType(1)
    ScrollView_2:setBackGroundColor({r = 255, g = 150, b = 100})
    ScrollView_2:setBackGroundColorOpacity(0)
    ScrollView_2:setLayoutComponentEnabled(true)
    ScrollView_2:setCascadeColorEnabled(true)
    ScrollView_2:setCascadeOpacityEnabled(true)
    ScrollView_2:setPosition(0, 20)
    local _layout = ccui.LayoutComponent:bindLayoutComponent(ScrollView_2)
    _layout:setPositionPercentX(0.7800)
    _layout:setPositionPercentY(0.4464)
    _layout:setPercentWidth(0.2083)
    _layout:setPercentHeight(0.3125)
    _layout:setSize({width = display.width, height = center_height})
    _layout:setLeftMargin(748.8054)
    _layout:setRightMargin(11.1946)
    _layout:setTopMargin(154.3036)
    _layout:setBottomMargin(285.6964)
   	layout:addChild(ScrollView_2)

    -- local lbdata ={ {nm=MyInfo.nickName, tx = MyInfo.avatar, jb = info.money}, 
    -- 				};
    local itemsize
   	for i,v in ipairs(list)do
   		local item = self:createListItem(v);
   		ScrollView_2:addChild(item);
   		if not itemsize then 
   			itemsize = item.size;
   		end
   	end 

   	local scrollsize = ScrollView_2:getContentSize();
    local height = scrollsize.height;
    local offy = 0;
    if itemsize then 
        local realheight = (itemsize.height + offy) * # list
        if realheight > height then 
            height  = realheight;
        end 

        for i,v in ipairs(ScrollView_2:getChildren())do 
            v:setPosition(0, height - i * itemsize.height); 
        end
    end 
    ScrollView_2:setInnerContainerSize(cc.size(display.width, height)); 
end

function RedPackageScene:createListItem( data )
	-- body
	local layout = ccui.Layout:create()
	local bg = display.newSprite("redpackage/list_bg.jpg");
	local bgSize = bg:getContentSize();
	bg:setPosition(display.cx, bgSize.height/2)
	bg:setScaleX(display.width/bgSize.width);
	layout.size = cc.size(display.width, bgSize.height);
	layout:addChild(bg);
	layout:setContentSize(cc.size(display.width, bgSize.height));


	--tx 
	local tx = display.newSprite("head/" .. data.avatar .. ".jpg");
	layout:addChild(tx);
	local txSize = tx:getContentSize(); 
	tx:setPosition(txSize.width/2 + 10, bgSize.height/2)

	--nm 
	local nm = cc.Label:createWithSystemFont(data.nickName, "Arial", 30)
	nm:setTextColor(cc.c3b(0,0,0));
	layout:addChild(nm)
	local nmsize = nm:getContentSize();
	nm:setPosition(txSize.width + nmsize.width/2 + 20, bgSize.height/2)

	--jb 
	local jb = cc.Label:createWithSystemFont(data.money, "Arial", 30)
	local jbsize = jb:getContentSize();
	jb:setTextColor(cc.c3b(0,0,0)) 
	layout:addChild(jb); 
	jb:setPosition(display.width - jbsize.width/2 - 20, bgSize.height/2 + jbsize.height/2)

	-- zuijia 
	if data.luck then 
		local hot = display.newSprite("redpackage/hot.png");
		local hotsize = hot:getContentSize();
		layout:addChild(hot);
		local txSize = tx:getContentSize(); 
		hot:setPosition(display.width - hotsize.width/2 - 20, bgSize.height/2 - hotsize.height/2)
	end 
	return layout;
end

-- 打开抢红包界面 
-- @param cell.info = {id:红包id, sendPid:发送者id，sendNickName=发送者名称, sendAvatar=发送者头像, 
--	             roomId=房间id,redPacketMoney=红包金额，mines=雷数}
function RedPackageScene:createPreOpenPanel( cell )
	-- body
	local info = cell.info;
	-- 打开抢红包界面 
    local layout = ccui.Layout:create();
    layout:setLocalZOrder(101)
    layout:setTouchEnabled(true);
    local layoutsize = cc.size(display.width, display.height)
    layout:setContentSize(layoutsize);
    layout:setName("preOpen");
    self:addChild(layout);

    local bg = cc.LayerColor:create(cc.c4b(0,0,0, 180),display.width, layoutsize.height);
    layout:addChild(bg)

    --添加close_bg 
    local close_bg = display.newSprite("redpackage/close_bg.png");
    local close_bgsize = close_bg:getContentSize();
    close_bg:setPosition(cc.p(layoutsize.width/2, layoutsize.height/2 + 10));
    layout:addChild(close_bg);
    
    local btn_offy = 30
    local exit_btn = ccui.Button:create("redpackage/close_text.png");
    local exit_btnsize = exit_btn:getContentSize(); 
    exit_btn:setPosition(exit_btnsize.width/2 + 30, close_bgsize.height - exit_btnsize.height/2 - 20);
    exit_btn:addClickEventListener(function ( ... )
    	-- body
    		self:removeChildByName("preOpen");
    end)
    close_bg:addChild(exit_btn)

    local tx =display.newSprite("head/" .. info.sendAvatar .. ".jpg");
    local txSize = tx:getContentSize()
    local tx_y = close_bgsize.height - txSize.height/2 - 70
    close_bg:addChild(tx);
    tx:setPosition(close_bgsize.width/2, tx_y);

    local nm = cc.Label:createWithSystemFont(info.sendNickName, "Arial", 30)
    local nmsize = nm:getContentSize()
    local nm_y = tx_y - txSize.height/2 -  nmsize.height/2 - 25
    close_bg:addChild(nm);
    nm:setPosition(close_bgsize.width/2, nm_y);

    -- 开红包按钮
    local open_btn = ccui.Button:create("redpackage/open_btn.png");
    local open_btnsize = open_btn:getContentSize();
    open_btn:addClickEventListener(function ( ... )
    	-- body
    	-- 发送打开红包信息
    	if info.endtime then
    		if info.endtime - os.time() > 0 then 
    			local layout=  Utils.createPop(1, {ms = "cd中,请稍后"});
				local scene = display.getRunningScene()
			    scene:addChild(layout); 
			    layout:setPosition((display.width - layout.size.width)/2, (display.height - layout.size.height)/2);
			    return;
    		end  
    	end 
    	
    	local param =  {roomId=MyInfo.roomID, redPacketId = info.id}
	    MsgMgr.sendData({cmd = 20003, msg =param}); 
	    -- 进入房间
	    MsgMgr.waitMsg(20003,function (data)
	        -- body
	        if data.code == 0 then  -- 退出房间成功
	        	self:removeChildByName("preOpen");
	        	info.opened = 1; --刷新cell信息 
	        	self:addRedPackage(); --刷新界面
    			self:createOpenPanel(data.data, info);
	        else
	            print("领取红包失败, data.code = ", data.code);
	           	print(CodeRes.showTip)
	           	CodeRes.showTip(data.code); 
	        end
	    end)
    end)
    close_bg:addChild(open_btn); 
    open_btn:setPosition(close_bgsize.width/2 , 280)
end


-- 红包已经领完，来晚了界面
-- @param cell.info = {id:红包id, sendPid:发送者id，sendNickName=发送者名称, sendAvatar=发送者头像, 
--	             roomId=房间id,redPacketMoney=红包金额，mines=雷数}
function RedPackageScene:createEndPanel( cell )
	-- body
	local info = cell.info;
	-- 打开抢红包界面 
    local layout = ccui.Layout:create();
    layout:setLocalZOrder(101)
    layout:setTouchEnabled(true);
    local layoutsize = cc.size(display.width, display.height)
    layout:setContentSize(layoutsize);
    layout:setName("endpanel");
    self:addChild(layout);

    local bg = cc.LayerColor:create(cc.c4b(0,0,0, 180),display.width, layoutsize.height);
    layout:addChild(bg)

    --添加close_bg 
    local close_bg = display.newSprite("redpackage/late.jpg");
    local close_bgsize = close_bg:getContentSize();
    close_bg:setPosition(cc.p(layoutsize.width/2, layoutsize.height/2 + 10));
    layout:addChild(close_bg);
    
    local btn_offy = 30
    local exit_btn = ccui.Button:create("redpackage/close_text.png");
    local exit_btnsize = exit_btn:getContentSize(); 
    exit_btn:setPosition(exit_btnsize.width/2 + 30, close_bgsize.height - exit_btnsize.height/2 - 20);
    exit_btn:addClickEventListener(function ( ... )
    	-- body
    	self:removeChildByName("endpanel");
    end)
    close_bg:addChild(exit_btn)
   
    -- 查看详情蚊子 
    local lqxq_btn = ccui.Button:create("redpackage/lq_xq.png");
    local lqxq_btnsize = lqxq_btn:getContentSize();
    lqxq_btn:addClickEventListener(function ( ... )
    	-- body
    	local param =  {roomId=MyInfo.roomID, redPacketId = info.id}
	    MsgMgr.sendData({cmd = 20004, msg =param}); 
	    -- 进入房间
	    MsgMgr.waitMsg(20004,function (data)
	        -- body
	        if data.code == 0 then  -- 退出房间成功
	        	local list = data.data.receiveRecordList;
    			self:createXqPanel(list, info);
	        else
	           	CodeRes.showTip(data.code); 
	        end
	    end)
    end)
    close_bg:addChild(lqxq_btn); 
    lqxq_btn:setPosition(close_bgsize.width/2 , 110)
end

return RedPackageScene;