rollout mytools "工具"
	
(
	checkbutton setup "开"width:180 height:30 highlightColor:(color 50 150 20) pos: [10,60] checked:true
	
	
	on setup changed state do
		
	
	(
		if state == true then
			
		
		(
			setup.text = "关"
			
			print = "我被按下！"
			
			
			)
			
			if state == false then
				
			
			(
				
				setup.text = "开"
				
				print "我被弹起了！"
				
				
				)
		
		)
	)
	
	CreateDialog mytools 200 300
	