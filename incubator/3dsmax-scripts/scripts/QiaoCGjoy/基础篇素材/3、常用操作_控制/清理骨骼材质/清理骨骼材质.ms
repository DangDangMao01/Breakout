-------------------------------------------------------
-------------------AnimationTool-----------------------
------------------Time:2017-10-11----------------------
-------------------Author:乔磊-------------------------
------------------QQ:409856476-------------------------
-------------------------------------------------------

rollout myrollout "ClearBoneMaterial" width:161 height:115
(
	button GetNumberBones "ClearBoneMaterial " pos:[34,41] width:97 height:20 toolTip:"一键清理骨骼材质"
	
     
	on GetNumberBones pressed do
	(
	
		for i in $* where classof i == BoneGeometry or classof i == Biped_Object do 
		(
			i.material = undefined
		)	 
		 	    
		
	)
)
	createdialog myrollout
	
	

