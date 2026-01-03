

rollout Do_setSlidingKey "一键全定帧" width:162 height:81
(
	button 'setKey_bt' "选择执行" pos:[51,31] width:60 height:21 toolTip:"只选择两只脚即可" align:#left  
  
	local framestart = animationRange.start 
	local framend =  animationRange.end 
	

	on setKey_bt pressed do
	(
		try (	
		
			max motion mode
		
			if  selection.count !=0 then 
			(
				for i=1 to selection.count do
				(
					for t = framestart to framend by 1f do 
					(
						sliderTime = t
						biped.setSlidingKey selection[i]		
					)
				)
				
			)
			else
			(
				messageBox "请选择腿部骨骼 "
			)
		)catch()
	)
)
Createdialog Do_setSlidingKey
