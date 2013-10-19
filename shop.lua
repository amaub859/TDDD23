--Set up the storyboard class
local storyboard = require("storyboard");
local scene = storyboard.newScene()

local mydata = require("mydata")
local widget = require( "widget")

--Forward references so that we can access objects accross functions
local bar;
local spinIt;
local deviceType = 0
local numOfDevice = 4
local device = {}
local locked = true

local function createDevices(deviceType)
	local view = scene.view
	
	if deviceType == 1 then
		deviceImg = display.newImageRect("images/bar.png",100,100)
	elseif deviceType == 2 then
		deviceImg = display.newImageRect("images/foo.png",100,100)
	else
		deviceImg = display.newImageRect("images/bar.png",100,100)	
	end

	
	view:insert(deviceImg)
	return deviceImg
end

local function onButtonExit(e)
	if e.phase == "ended" then
			unlockDevice.alpha = 0
			buttonGetNow.alpha = 1
			buttonBuy.alpha = 0
			scrollView._view._isLocked = false
	end
	return true
end

local function onButtonGetNow(e)
	if e.phase == "ended" then
		buttonGetNow.alpha = 0
		buttonBuy.alpha = 1
	end
	return true
end

local function onButtonBuy(e)
	if e.phase == "ended" then
		if locked == false then
			unlockDevice.alpha = 0
			scrollView._view._isLocked = false
			buttonGetNow.alpha = 1
			buttonBuy.alpha = 0
			if #mydata.star >= 3 then
				mydata.deviceUnlocked = 2
			end
			
			locked = true
			storyboard.removeScene("nextLevel")
			storyboard.gotoScene("nextLevel", {time =250, effect="crossFade"})
		end	
	end
	return true
end

local function onButtonHome(e)
	if e.phase == "ended" then
		timer.performWithDelay(20, home)
	end
	return true
end


local function unlock()
	local view = scene.view
	
		------------Level Completed------------ 
	local frameGroup = display.newGroup()
	
	local frame = display.newImageRect("images/background.png",300,200)
	local frameText = display.newText("Level Completed", 0, 0, native.systemFont, 24)
	frameText:setTextColor(0,0,0)
	
	star1 = display.newImageRect("images/star2.png",50,50)

	buttonGetNow = display.newImageRect("images/nextBtn.png",40,40)
	buttonGetNow:addEventListener("touch",onButtonGetNow)
	
	buttonBuy = display.newImageRect("images/star2.png",40,40)
	buttonBuy:addEventListener("touch",onButtonBuy)
	buttonBuy.alpha = 0
	
	buttonExit = display.newImageRect("images/nextBtn.png",40,40)
	buttonExit:addEventListener("touch",onButtonExit)

	frameText.x = 0
	frameText.y = -80
	
	star1.x = 0
	star1.y = 0

	buttonGetNow.x = 0
	buttonGetNow.y = 80
	
	buttonBuy.x = 0
	buttonBuy.y = 80
	
	buttonExit.x = 120
	buttonExit.y = -80
	
	frameGroup:insert(frame)
	frameGroup:insert(frameText)
	frameGroup:insert(star1)
	frameGroup:insert(buttonGetNow)
	frameGroup:insert(buttonBuy)
	frameGroup:insert(buttonExit)
	
	view:insert(frameGroup)
	
	return frameGroup
	---------------------------------------
end


function scene:createScene(e)	

	local view = self.view
	
	background = display.newRect(0, 0, _W, _H);
	background:setFillColor(255,255,255);
	view:insert(background)
	
	homeBtn = display.newImageRect("images/foo.png",40,40)
	homeBtn.x = _W - 25
	homeBtn.y = 25 
	homeBtn.alpha = 0.8
	homeBtn:addEventListener("touch",onButtonHome)
	view:insert(homeBtn)
	
	starGroup = display.newGroup()
	local font = "HelveticaNeue" or native.systemFont;
	starTxt = display.newText(string.format("%1dx", #mydata.star),0,0,font,15);
	starTxt:setTextColor(0,0,0)
	starTxt.x = _W - 10
	starTxt.y = _H - 10
	
	starsPic = display.newImageRect("images/star2.png",20,20)
	starsPic.x = _W - 30
	starsPic.y = _H - 15
	
	starGroup:insert(starsPic)
	starGroup:insert(starTxt)
	starGroup.alpha = 0.8
	view:insert(starGroup)
	
	
	scrollView = widget.newScrollView
	{
		width = _W,
		height = _H * 0.5,
		--bottomPadding = 50,
		--id = "onTop",
		horizontalScrollDisabled = false,
		verticalScrollDisabled = true,
		listener = scrollListener,
	}
	scrollView:setReferencePoint(display.CenterReferencePoint)
	scrollView.x = _W * 0.5
	scrollView.y = _H * 0.5	 
	view:insert(scrollView)
end

function scene:enterScene(e)

	unlockDevice = unlock()
	unlockDevice.x = _W *0.5
	unlockDevice.y = _H *0.5
	unlockDevice.alpha = 0
		
	for i=1 ,numOfDevice do
		device[i] = createDevices(i)
		device[i].x = _W/2 + (_W/1.2 * (i-1))
		device[i].y = scrollView.contentHeight * 0.5
		device[i].id = "Button" .. i
		scrollView:insert(device[i])
		
		function touchIt(e)
			local t = e.target
			local phase = e.phase
			
			if(e.phase == "began") then

				display.getCurrentStage():setFocus(t)
				self.hasFocus = true
				
				scrollView._view._isLocked = true
				unlockDevice.alpha = 1
				
				if t.id == "Button1" then
					print(t.id)
					if #mydata.star >= 3 then
						locked = false
					end		
				elseif t.id == "Button2" then
					if #mydata.star >= 6 then
						locked = false
					end	 
				end
				
				
				
				
			elseif(self.hasFocus) then
				if(e.phase == "moved") then
					                    
					print("moved")
							
				elseif(e.phase == "ended" or e.phase == "cancelled") then
			
					display.getCurrentStage():setFocus(nil)
					self.hasFocus = false;
					print("ended")
				end
			end
			return true
		end

		device[i]:addEventListener("touch",touchIt)
		
		
		
		
	--[[	function reload(e)
			local t = e.target
			local phase = e.phase
			local animProperties
			--local right
			
			if  phase == "began" then
				display.getCurrentStage():setFocus( t )
				t.isFocus = true
				start = e.x
				
			elseif phase == "moved" then
				
				if start > e.x then
					left = true
					right = false
					--print(left)
				else
					left = false 
					right = true
					--print(left)
				end			
				
				local anim = {}
				--print (left)
				if left then
					--print("inside")
						animProperties = {
						time = 1000,
						x = device[i].x - _W/2,
						transition = easing.inQuad,
						onComplete =function()
							--noClick = true
						end
					}
				end
				
				if (right) then
						animProperties = {
						time = 1000,
						x = device[i].x + _W/2,
						transition = easing.inQuad,
						onComplete =function()
							--noClick = true
						end
					}
				end		
				
				anim[i] = transition.to(device[i],animProperties)	
				
			elseif phase == "ended" or phase == "cancelled" then
				display.getCurrentStage():setFocus( nil )
				t.isFocus = false
			
				noClick = false
				--device[i]:translate(_W/2 - device[i].x,0)
				--device[i].x = device[i].x - _W/2
			end
		end
		background:addEventListener("touch", reload)
		]]
		
	end
	
	function spinIt(e)
		device[1].rotation = (device[1].rotation - 2) % 360
	end
	Runtime:addEventListener("enterFrame",spinIt)
	
	function spinIt2(e)
		device[2].rotation = (device[2].rotation - 2) % 360
	end
	Runtime:addEventListener("enterFrame",spinIt2)
	
	function spinIt3(e)
		device[3].rotation = (device[3].rotation - 2) % 360
	end
	Runtime:addEventListener("enterFrame",spinIt3)
	
	function home()
		storyboard.removeScene("mainMeny")
		storyboard.gotoScene("mainMeny", {time =250, effect="crossFade"})
	end

	
end

function scene:exitScene(e)
	--Stop listeners, timers, and animations (transitions)
	print("hej")
	
	Runtime:removeEventListener("enterFrame",spinIt)
	Runtime:removeEventListener("enterFrame",spinIt2)
	Runtime:removeEventListener("enterFrame",spinIt3)


	for i = numOfDevice, 1, -1 do
			display.remove(device[i])
			device[i] = nil
	end

end

scene:addEventListener("createScene", scene);
scene:addEventListener("enterScene", scene);
scene:addEventListener("exitScene", scene);
--There are more events you can listen for;
--See the Corona docs

return scenern scene