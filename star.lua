	local starGroup
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
	
	return starGroup

