-------------------------------------------------------
-------------------AnimationTool-----------------------
------------------Time:2018-01-11----------------------
-------------------Author:乔磊-------------------------
------------------QQ:409856476-------------------------
-------------------------------------------------------

rollout ResetBoneColor "ResetColor_QL" 
(	
	group "ResetBipColor"
	(
		button Ret_Bip "ResetBip " toolTip:"一键重置BIP颜色"
	)
	
	group "ResetSelectBone"
	(
		button Ret_bone "ResetSelectBone"  toolTip:"选中的Bone骨骼初始化颜色" 
	)	
	
	group "ResetAllBone"
	(
		button Ret_Allbone "ResetAllBone"  toolTip:"一键重置场景中所以的bone骨骼颜色" 
	)
	
	on Ret_Bip pressed do
	(
		CS_All=for i in objects where (classof i==Biped_Object) collect i
		(
			for j in CS_All do 
			(
				select $*Bip001_L*
				for i in selection do
				(   
					i.wirecolor = (color 28 28 177)
					if i.name == "Bip001_L_Finger0" then
					(
						i.wirecolor = (color 134 6 6)
					)
				)
			)
			for j in CS_All do 
			(
				select $*Bip001_R*
				for i in selection do
				(   
					i.wirecolor = (color 6 134 6)
					if i.name == "Bip001_R_Finger0" then
					(
						i.wirecolor = (color 224 198 87)
					)
				)
			)	
			for j in CS_All do 
			(
				select $*Spine*
				for i in selection do
				(   
					i.wirecolor = (color 8 110 134)
				)	
			)	
				
------手指
			for j in CS_All do 
			(
				select $*L_Finger*
				for i in selection do	
				(
					i.wirecolor = (color 108 8 136)
				)
				select $*R_Finger0*
				for i in selection do	
				(
					i.wirecolor = (color 113 134 6)
				)
				
				select $*L_Finger0*
				for i in selection do	
				(
					i.wirecolor = (color 134 6 6)
				)
				select $*R_Finger0*
				for i in selection do	
				(
					i.wirecolor = (color 224 198 87)
				)
				
-----脚趾
				select $*L_Toe*
				for i in selection do	
				(
					i.wirecolor = (color 108 8 136)
				)
				select $*R_Toe*
				for i in selection do	
				(
					i.wirecolor = (color 113 134 6)
				)
				
				$Bip001_Pelvis.wirecolor = (color 224 198 87)
				$Bip001_Neck.wirecolor =  (color 8 110 134)
				$Bip001_Head.wirecolor = (color 166 202 240)
				$Bip001.wirecolor = (color 166 202 240)
				
				
			)			
		)	
	)

-----重置选中的bone	
	on Ret_bone pressed do
	(
		if selection.count ==0 then
		(
			messagebox "至少需要选择一节Bone" beep:false
		)
		else
		(   
			for i =1 to selection.count do
			(   
				selection[i].wirecolor = color 174 186 203					
			) 
		)			
	)

-----一键重置所有的bone	
	on Ret_Allbone pressed do
	(
	  
	     for i in $* where classof i == BoneGeometry  do 
		 (	 
			i.wirecolor = color 174 186 203	
		 )
		
	)
		
)createdialog ResetBoneColor
	
	

