rollout mytools "我的工具"
(
	
	checkbox ck_1"最终大图"checked:true
	
	
	checkbox ck_2"色彩通道"
	
	
	checkbox ck_3"AO通道"
	
	
	checkbox ck_4"影子通道"
	
	
	checkbox ck_5"正侧通道"
	
	
	button bt_1 "立即渲染"width:80 height:30
	
	on ck_1 changed state do
	
	(
			if ck_1.checked == true then print"勾选了大图渲染！"
				
			if ck_1.checked == true then print"取消了大图渲染！"
		
		
		)
	
	
	
	
	
	)
	
	CreateDialog mytools 200 180