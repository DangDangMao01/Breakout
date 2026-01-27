rollout mytools "我的工具"
	（
	   colorpicker cpk_1"选择物体" width :80 height : 30

     
	on cpk_1 changed col do 
		
	(
		print col
		
		$.color = col
		
		)
       
）
		CreateDialog mytools 100 60