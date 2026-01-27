rollout mytools "我的工具"
(
	spinner sp_1 "灯光亮度："range:[0.01,100,1]

	spinner sp_2 "阴影细分："rannge:[0,100,8] type:#integer 

	angle ang_1"太阳角度"pos:[20,60]
	
	angle ang_2 "太阳高度"pos:[120,60] degrees:45 color:(color 50 150 20) diameter:80 ranger:[0,90,45]

	button bt_1 "创建灯光" width:100 height:30  pos:[50,200]
	
	on bt_1 pressed do 
	(
    print ("灯光亮度为："+ sp_1.value as string )

	print ("阴影细分为："+ sp_2.value as string )

    print ("照射角度为："+ ang_1.degrees as string )

    print ("灯光亮度为："+ ang_2.degrees as string )

	messagebox "灯光创建完成！" title:"创建成功！" beep:false 
	
	)
	
	
	)
	
	
	CreateDialog mytools 200 240