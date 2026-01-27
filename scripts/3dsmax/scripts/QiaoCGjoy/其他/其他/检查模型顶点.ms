
rollout Check_ModelPoint "CheckModelPoint" 
(
	group "检查所有模型的点"
	(

		button 'Check_Model' "开始检查"
		
	)
	local c_point=#()

	
	
	on Check_Model pressed do
	(
		poly_All=for i in objects where (classof i==Editable_Poly ) collect i
		
		if poly_All.count != 0 then	
		( 
			for i in poly_All do
			(
					
				local tem =0
				tem = polyop.getNumVerts i
				if tem ==0 then
				(
					append c_point i
					
					
				)
				else ()
		
			)
			
			if c_point.count != 0 then
			(
				select c_point
			)
			else
			(
				messageBox "模型都有顶点 "
			)
			

		)
		else
		(
			messageBox "场景中无poly模型 "

		)

		

		
	)	
	
	
		
)
	createdialog  Check_ModelPoint