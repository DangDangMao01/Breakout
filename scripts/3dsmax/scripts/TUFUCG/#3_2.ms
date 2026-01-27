rollout mytools "工具条"
(
	
	label lb_1 "我的工具v1.0" width:200 height:20  pos:[70,5]
	
	edittext edt_1 "姓名：" width:100 bold:true
	edittext edt_2 "介绍：" width:100  height:80 labelOnTop:true 
	
	on edt_1 changed var do print "输入中···"
		/*当 edt_1在改变输入的内容的时候，print打印提示“输入中···”*/
	
	on edt_2 entered var do 
	(
		print var 
		messageBox "输入完成！"
		
		
		
		
		
		)
	
	)
	
	CreateDialog mytools 200 300