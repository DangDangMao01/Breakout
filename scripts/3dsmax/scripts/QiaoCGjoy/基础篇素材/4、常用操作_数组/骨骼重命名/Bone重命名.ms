rollout bonerename "bone命名排序" 
(
	button 'bone_rename' "命名 Bone"  width:60 height:21 toolTip:"选中的Bone骨骼名称初始化命名并创建层" 	
	local Tem_Export = #()		
	on bone_rename pressed do
	(
		if selection.count ==0 then
		(
			messagebox "至少需要选择一节Bone" beep:false
		)
		else
		(   
			layer = layermanager.newLayerFromName "Bone"
			layer = layermanager.getLayerFromName "Bone"
			TemBone = #()
			for i =1 to selection.count do
			(   
				if classOf selection[i] == bonegeometry then
				(
					if i<10 then	
					selection[i].name = "Bone" + "0" + (i as string)
					else
					selection[i].name = "Bone" + (i as string)
				)
					layer.addNode selection[i]
					append TemBone selection[i]
			) 
			selectionSets["Bone"] = TemBone
		)			
	)	
) createDialog bonerename