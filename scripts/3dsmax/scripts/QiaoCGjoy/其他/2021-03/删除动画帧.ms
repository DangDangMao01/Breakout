
rollout dr "Animat" 
(

	group "Bone_Del_Keys" 
	(
		--checkbox save_0 "保持第一帧" checked:true enabled:false 
		--checkbox save_0 "保持当前帧" checked:true enabled:false 
		
		checkbox 'Pos_chk' "Del Pos" pos:[13,26] width:66 height:15 toolTip:"删除Bone移动帧" align:#left
		checkbox 'Rot_chk' "Del Rot" pos:[13,46] width:66 height:15 toolTip:"删除Bone旋转帧" align:#left
		checkbox 'Scale_chk' "Del Scale" pos:[13,66] width:66 height:15 toolTip:"删除Bone缩放帧" align:#left
		checkbox 'Sel_chk' "Del Select" pos:[13,86] width:66 height:15 toolTip:"删除Bone所选帧上的以上参数" align:#left
		button 'OK_btn' "Del" pos:[90,24] width:34 height:78 toolTip:"删除所选中的参数" align:#left
	)
		
	fn delRot a =
	(
		deselectKeys a
		selectKeys a.rotation.controller 
		deleteKeys a #selection 
	)
		
	fn delPos b =
	(
		deselectKeys b
		selectKeys b.pos.controller 
		deleteKeys b #selection 
	)
		
	fn delScale c =
	(
		deselectKeys c
		selectKeys c.scale.controller 
		deleteKeys c #selection 
	)
	
	fn Ali_0_trans_fn a =
	(
		sliderTime = 0f
		tem = a.transform
		
	)


	
	
	on OK_btn pressed do
	(
		objKeys = selection as array

		sliderTime = 0f
		
		
		
	
		undo on
		(
			if Sel_chk.checked then
			(
				if Rot_chk.checked  do			
				(
					for f = 1 to objKeys.count do 
					(
						
						deleteKeys objKeys[f].rotation.controller #selection
						
					)
				)
					
				if Pos_chk.checked  do
				(
					for g = 1 to objKeys.count do 
					(
						deleteKeys objKeys[g].pos.controller #selection
					)
				)
					
				if Scale_chk.checked  do
				(
					for h = 1 to objKeys.count do 
					(
						deleteKeys objKeys[h].scale.controller #selection
					)
				)
			)
			else
			(
				if Rot_chk.checked  do			
				(
					for j = 1 to objKeys.count do 
					(
						delRot objKeys[j]
					)
				
				)
					
				if Pos_chk.checked  do
				(
					for k = 1 to objKeys.count do
					(
						delPos objKeys[k]
					)					
				)
					
				if Scale_chk.checked  do
				(
					for l = 1 to objKeys.count do
					(
						delScale objKeys[l]
					)					
				)
			)
		)
	)
)
createDialog dr