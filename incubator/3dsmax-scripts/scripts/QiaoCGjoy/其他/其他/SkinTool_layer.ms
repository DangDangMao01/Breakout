	fn findEnds arr = ---选择末端
	(
		ends = for i in arr where (i.children.count == 0) collect i
		return ends
	)
	
	


rollout layer "Layer" 
(
	button 'Cle_layer' "清空层集" pos:[13,3] width:60 height:21 toolTip:"一键清除空集以及所有层" align:#left 
	checkbutton 'Fz_Mdl' "冻结模型" pos:[75,3] width:60 height:21  align:#left
	
	button 'selEnd_btn' "选择末端" pos:[13,28] width:60 height:21 toolTip:"  选中所有Bone骨骼的末端骨骼" align:#left
	button 'end_rename' "末端命名" pos:[75,28] width:60 height:21 toolTip:"    末端骨骼排序名称\n创建加入biped_end层\n      统一尺寸颜色" align:#left	

	button 'CRE_CS' "创建 CS" pos:[13,53] width:60 height:21 toolTip:"为所有CS骨骼创建加入biped层" align:#left	
	button 'CRE_HP' "创建 HP" pos:[75,53] width:60 height:21 toolTip:"依次选择受击挂接与顶部挂接物体" align:#left
	
	button 'bone_rename' "命名 Bone" pos:[13,78] width:60 height:21 toolTip:"选中的Bone骨骼名称初始化命名并创建层" align:#left
	button 'CRE_Export' "Export 01" pos:[75,78] width:60 height:21 toolTip:"创建Export 01集合" align:#left
	
	button 'Del_H' "删除空点" pos:[13,104] width:60 height:21 toolTip:"删除场景中的particle view" align:#left
	button 'check_name' "检查重名" pos:[75,104] width:60 height:21 align:#left --pos:[36,189]
 
	label 'lab_01' "有0根重名骨骼"  
	
	
	local TemlayerName =#()
	local Tem_Export = #()
	
	--------------------------------------------------------------------------------------------------------------

	
	--------------------------------------------------------------------------------------------------------------
	

	
	on bone_rename pressed do
	(
		if selection.count ==0 then
		(
			messagebox "至少需要选择一节Bone" beep:false
		)
		else
		(   
			layer = layermanager.newLayerFromName "Bone"
			layer = LayerManager.getLayerFromName  "Bone"
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
					--append Tem_Export selection[i]
				
			) 
			selectionSets["Bone"] = TemBone
		)			
	)
	on selEnd_btn pressed do
	(		undo on
		(
			clearSelection()
			for x in objects do
			(
				if (classOf x.baseObject) == boneGeometry do
				(
					selectMore x
				)
				if (classOf  x == XRefObject)  and (classof x.actualBaseObject  == BoneGeometry) then
				(
					selectMore x
				)
			)
		)	
		ends = findEnds selection
		select ends
	)
	on end_rename pressed do
	(
		if selection.count ==0 then
		(
			messagebox "至少需要选择一节Bone" beep:false
		)
		else
		(   
			layer = layermanager.newLayerFromName "end"
			layer = LayerManager.getLayerFromName  "end"
			TemEnd = #()
			for i =1 to selection.count do
			(   
				if classOf selection[i] == bonegeometry then
				(   
					--selection[i].width = selection[i].height =selection[i].length =0.05
					selection[i].wirecolor = color 6 135 6
					(
						if i<10 then	
						selection[i].name = "moduan_bone" + "0" + (i as string)
						else
						selection[i].name = "moduan_bone" + (i as string)
					)
						 layer.addNode selection[i]		
						append TemEnd selection[i]
				) 
				selectionSets["end"] = TemEnd
			)	
		)			
	)
	on CRE_HP pressed do
	(
		local Tem = #()
		local HP_Name = #("HP_hit001","HP_hit002","HP_Buff")
		local end_pos = #(0.15,-0.15,0.15)
		local z_pos = #(1.2,1.2,2.3)
		local y_pos = #(0.2,-0.2,0)
	
		if selection.count ==2 then
		(
			for i=1 to 3 do 
			(
				tempBone =BoneSys.createBone  [0,y_pos[i],z_pos[i]] [0,end_pos[i]+y_pos[i],z_pos[i]] [0,0,0]
				tempBone.width=.05
				tempBone.height=.05
				tempBone.name = HP_Name[i]
				tempBone.wirecolor = color 255 0 0
				layer = layermanager.newLayerFromName "HP"
				layer = LayerManager.getLayerFromName  "HP"
				layer.addNode tempBone
				--append Tem tempBone
			)
	
			$HP_hit001.parent = $selection[1]
			$HP_hit002.parent = $selection[1]
			$HP_Buff.parent = $selection[2]
			selectionSets["HP"] = #($HP_hit001,$HP_hit002,$HP_Buff)		
		)
		
		else
		(
			messagebox "请依次选择两个物体" beep:false
		)
	
		
	)
	on CRE_CS pressed do
	(
		(
			CS_All=for i in objects where (classof i==Biped_Object) collect i
			layer = layermanager.newLayerFromName "biped"
			layer = LayerManager.getLayerFromName "biped"
			--selectionSets["Export 01"] = CS_All
			for j in CS_All do 
			(
				layer.addNode j
				--append Tem_Export j
			)	
			selectionSets["biped"] = CS_All
		)
		(
			select $*Nub*
			b = #()
			for i in selection do
			(   
				append b i
			)
			layer = layermanager.newLayerFromName "biped_Nub"
			layer = LayerManager.getLayerFromName "biped_Nub"
			for y in b do 
			(
				layer.addNode y
			)	
			selectionSets["biped_Nub"] = b
			
		)
	)
	
	--------------------------------------------------------------------------------------------------------
	
	on Cle_layer pressed do
	(
		for i =1 to LayerManager.count-1 do
		(
		 ilayer = layerManager.getLayer i
		 layerName = ilayer.name
		append TemlayerName layerName
		)
		for j=1 to TemlayerName.count do 
		(
			LayerManager.deleteLayerByName TemlayerName[j]
		)
		--selectionSets.count
		for n=selectionSets.count to 1 by -1 do 
		(	
			deleteItem selectionSets selectionSets[n]
		)
		
	)
	
	--------------------------------------------------------------------------------------------------------------------------------------------------
	
	on Fz_Mdl changed state do
	(
		if state then
		(
			Mod_Arr=for i in objects where(classof i==Editable_Poly or classof i==Editable_mesh or classof i==PolyMeshObject)collect i
			Mod_Arr.showFrozenInGray = off
			freeze Mod_Arr
		)
		else
		(
			Mod_Arr=for i in objects where(classof i==Editable_Poly or classof i==Editable_mesh or classof i==PolyMeshObject)collect i
			unfreeze Mod_Arr
		)		
	)---冻结
	--------------------------------------------------------------------------------------------------------------------------------------------------
	
	

	
	on CRE_Export pressed do
	(	
		Tem_Export =selection
		selectionSets["Export01"] = Tem_Export
	)
	on Del_H pressed do
	(
	
		delete $'particle view*'
	
	)
	on check_name pressed do ---检查重名骨骼
	(
		local SameNameNode =#()
		lab_01.text ="有 "+(SameNameNode.count as string ) +" 根重名骨骼"
	    AllNodes = for i in objects where ((classof i==Biped_Object) or (classof i== BoneGeometry)) collect i
	    SameNameNode = #()
	    for i = 1 to AllNodes.count do
		(
		   for y = 1 to  SameNameNode.count do
			(
	    		if SameNameNode[y].name == AllNodes[i].name do
	            (
	                append SameNameNode AllNodes[i]
	            )
			--break()
			)
		   for x = i+1 to AllNodes.count do
			(
			    if AllNodes[i].name == AllNodes[x].name do
	            (
	                append SameNameNode AllNodes[i]
	            )
			)
		)
	    clearselection()
	    if SameNameNode.count != 0 do
	    (
	        lab_01.text ="有 "+(SameNameNode.count as string ) +" 根重名骨骼"
	        select SameNameNode
	    )
	
	)
)
Createdialog layer

