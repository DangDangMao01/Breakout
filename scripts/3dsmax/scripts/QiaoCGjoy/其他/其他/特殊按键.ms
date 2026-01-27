rollout Anim_pose "特殊按键" 
(
	dotNetControl Anim_pose "System.Windows.Forms.Button" width:110 height:20  


	fn btns2_fn btnName btnText =  
		(
			btnName.flatstyle =  (dotNetclass "System.Windows.Forms.FlatStyle").Flat  --创建样式
			--cb = ((colorman.getColor #background)*255) as color
			btnName.BackColor = (dotNetClass "System.Drawing.Color").fromARGB 0 169 255 --设置背景色
			cf = ((colorman.getColor #text)*255) as color  --获取文本颜色
			btnName.forecolor = (dotnetclass "system.drawing.color").FromArgb cf.r cf.g cf.b --设置字体颜色
			btnName.FlatAppearance.BorderSize =0 --边缘加粗
			
			btnName.font = dotNetObject "System.Drawing.Font" "Bookman Old Style" 13 --设置字体 以及字体大小
			btnName.text = btnText
		)
	
	on Anim_pose open do 
	(
	
		btns2_fn Anim_pose "Pose" --按键颜色设置	
		
	)	
	on Anim_pose MouseClick do
	(
	
	  if Anim_pose.text == "Animation"  then 
	   ( 
			Anim_pose.text = "Pose" 
			Animation_Pose = "Pose" 
			Anim_pose.BackColor = (dotNetClass "System.Drawing.Color").fromARGB 0 169 255 --设置背景色

		)
	  else 
		( 
			Anim_pose.text = "Animation"
			Animation_Pose = "Animation"
			Anim_pose.BackColor = (dotNetClass "System.Drawing.Color").fromARGB 255 128 64 --设置背景色

		)

		
		
	)


	
)createDialog Anim_pose
