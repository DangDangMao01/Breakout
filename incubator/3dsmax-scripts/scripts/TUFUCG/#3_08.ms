rollout mytools "我的工具"
(
	
	spinner sp_1 "灯光亮度："range:[0.01,100,1]
	
	
	spinner sp_2 "阴影细节" range:[0,100,8] type:#integer
	
	spinner sp_3 "灯光位置X：" range:[0,999999,0] width:120 type:#float 
	
	spinner sp_4 "灯光位置Y：" range:[0,999999,0] width:120 type:#float 
	
	
	spinner sp_5 "灯光位置Z：" range:[0,999999,0] width:120 type:#float  scale:0.001
	
	button bt_1"创建灯光"width:60 height:30
	
	
	
	on bt_1 pressed do
	(
		print("灯光亮度为：" + sp_1.value  as string  )
		
		print("阴影细分为：" + sp_2.value  as string  )
		
		print("灯光位置X为：" + sp_3.value  as string  )
		
		print("灯光位置Y为：" + sp_4.value  as string  )
		
		print("灯光位置Z为：" + sp_5.value  as string  )
		
		messagebox "灯光创建完成！"title:"创建成功！"beep:flase
		
		
		
		)
	 
	)
	CreateDialog mytools 200 180