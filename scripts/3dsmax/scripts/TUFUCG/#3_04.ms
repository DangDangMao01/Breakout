
rollout mytools "我的工具"
(
	label lb_1 "我的工具1.0" width: 200 height:20  pos:[70,5]
	edittext edt_1 "姓名" width:180
	edittext edt_2  "简介"width:170 height:60
	
	
	button bt_1"打印"width:160 height:25
	 
	
	on bt_1 pressed do
	(
		
		
		print edt_1.text
		print edt_2.text
		messageBox "打印成功！"
		
		)
	
	)
	
	CreateDialog mytools 300 300