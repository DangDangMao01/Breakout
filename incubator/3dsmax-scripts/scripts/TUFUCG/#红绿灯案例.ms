rollout mytools"我的工具"
(
	
	radiobuttons radb_1"开关切换："labes:#("红""黄""绿") pos:[30,15]
	
	checkbutton light_1"O"width:50 height:50 highlightColor:(color 200 50 20) pos:[75,70] checked:true
	
	checkbutton light_2"X"width:50 height:50 highlightColor:(color 200 50 20) pos:[75,120] 
	
	checkbutton light_3"X"width:50 height:50 highlightColor:(color 200 50 20) pos:[75,170] 
	
	on radb_1changed state do
	(
		
		change = case radb_1.state of
			
		(
			1:(
			light_1.state = true
			
			light_1.text = "O"
			
			light_2.state = light_3.state = false
			
			light_2.text = light_3text = "X"
			
			print "红灯亮"
			
						
			)
			2: (
				light_2.state = true
				light_2.text = "X"
				light_1.state = light_3.state = false
				light_1.text = light_3.text = "X"
				print "黄灯亮"
			)
			3: (
				light_3.state = true
				light_3.text = "O"
				light_1.state = light_2.state = false
				light_1.text = light_2.text = "X"
				print "绿灯亮"
			
			)
		
		)
	
	)
	CreateDialog myloots 200 300