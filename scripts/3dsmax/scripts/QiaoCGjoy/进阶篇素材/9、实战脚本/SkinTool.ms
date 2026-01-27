-------------------------------------------------------
-------------------AnimationTool-----------------------
------------------Time:2018-06-01----------------------
-------------------Author:乔磊-------------------------
------------------QQ:409856476-------------------------
-------------------------------------------------------


	fn findEnds arr = ---选择末端
	(
		ends = for i in arr where (i.children.count == 0) collect i
		return ends
	)
	
	


rollout layer "Layer" 
(
	
	button 'bone_rename' "命名 Bone" pos:[13,78] width:60 height:21 toolTip:"选中的Bone骨骼名称初始化命名并创建层" align:#left
	button 'selEnd_btn' "选择末端" pos:[13,28] width:60 height:21 toolTip:"  选中所有Bone骨骼的末端骨骼" align:#left
	button 'end_rename' "末端命名" pos:[75,28] width:60 height:21 toolTip:"    末端骨骼排序名称\n创建加入biped_end层\n      统一尺寸颜色" align:#left	

		
	button 'CRE_HP' "创建 HP" pos:[75,53] width:60 height:21 toolTip:"依次选择受击挂接与顶部挂接物体" align:#left
	button 'CRE_CS' "创建 CS" pos:[13,53] width:60 height:21 toolTip:"为所有CS骨骼创建加入biped层" align:#left
	button 'Cle_layer' "清空层集" pos:[13,3] width:60 height:21 toolTip:"一键清除空集以及所有层" align:#left 
 
 
 
	checkbutton 'Fz_Mdl' "冻结模型" pos:[75,3] width:60 height:21  align:#left
	button 'CRE_Export' "Export 01" pos:[75,78] width:60 height:21 toolTip:"创建Export 01集合" align:#left
	
	button 'Del_H' "删除空点" pos:[13,104] width:60 height:21 toolTip:"删除场景中的particle view" align:#left
	button 'check_name' "检查重名" pos:[75,104] width:60 height:21 align:#left --pos:[36,189]
 
	label 'lab_01' "有0根重名骨骼"  
	
	
	local TemlayerName =#()
	local Tem_Export = #()
	
	--------------------------------------------------------------------------------------------------------------

	
	--------------------------------------------------------------------------------------------------------------
	
	
	
	--------------------------------------------------------------------------------------------------------------
	
	
	--------------------------------------------------------------------------------------------------------------
	/*
	on biaoqing_rename pressed do
	(
		if selection.count ==0 then
		(
			messagebox "至少需要选择一节Bone" beep:false
		)
		else
		(   
			
			layer = layermanager.newLayerFromName "biaoqing_bone"
			layer = LayerManager.getLayerFromName "biaoqing_bone"
			(
				biaoqing = #()
				for i =1 to selection.count do
				(   
					if classOf selection[i] == bonegeometry then
					(
						if i<10 then
						selection[i].name = "biaoqing_bone" + "0" + (i as string)
						else
						selection[i].name = "biaoqing_bone" + (i as string)	
					)
						layer.addNode selection[i]	
						append biaoqing selection[i]
						append Tem_Export selection[i]
				) 
				selectionSets["biaoqing_bone"] = biaoqing
			)
		)	
	)
	*/
	--------------------------------------------------------------------------------------------------------------
	
	
	
	
	--------------------------------------------------------------------------------------------------------------
	
	
	--------------------------------------------------------------------------------------------------------------
	
	
	--------------------------------------------------------------------------------------------------------------
	
	
	--------------------------------------------------------------------------------------------------------------
	
	/*
	on Cle_EX pressed do
	(
		Tem_Export = #()
		selectionSets["Export01"] = Tem_Export
	)
	
	*/
	--------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------


	
	

	
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
		local end_pos = #(0.15,-0.15,0.15)--末端的Y坐标值
		local z_pos = #(1.2,1.2,2.3)--Z轴坐标值
		local y_pos = #(0.2,-0.2,0)--Y轴偏移值
	
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
	
	
	--------------------------------------------------------------------------------------------------------
	/*
	on Bac_Cull pressed do
	(
		if selection.count ==0 then 
			(
				messagebox "至少需要选择一个对象" beep:false
			)
		else
			(
			max backface cull toggle
			)
	)
	*/
	--------------------------------------------------------------------------------------------------------	
	
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
		   for y = 1 to  SameNameNode.count do --在相同的骨骼里进行在排查
			(
	    		if SameNameNode[y].name == AllNodes[i].name do
	            (
	                append SameNameNode AllNodes[i] --相同命名的骨骼加入集合
	            )
			--break()
			)
		   for x = i+1 to AllNodes.count do --从选择的第二节骨骼进行排查
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










--------------------------------------------------------------------------------------------------------------

rollout Bone_Name "BoneName" width:162 height:458
(
	GroupBox 'grp2' "表情" pos:[5,4] width:141 height:92 align:#left
	button 'REyelid' "右眼皮" pos:[75,22] width:64 height:21 toolTip:"右眼皮" align:#left
	button 'LEyelid' "左眼皮" pos:[9,22] width:64 height:21 toolTip:"左眼皮" align:#left
	button 'REyeball' "右眼珠" pos:[75,46] width:64 height:21 toolTip:"右眼珠" align:#left
	button 'LEyeball' "左眼珠" pos:[9,46] width:64 height:21 toolTip:"左眼珠" align:#left
	button 'Mouth' "嘴" pos:[9,70] width:64 height:21 toolTip:"嘴" align:#left
	button 'CRE_Bone' "Bone" pos:[75,70] width:64 height:21 toolTip:" 为选择的骨骼创建Bone集合" align:#left
	
	GroupBox 'grp3' "头发" pos:[4,98] width:140 height:172 align:#left	
	
	

	button 'hat_cf_bone' "长发" pos:[9,116] width:64 height:21 toolTip:"长发" align:#left
	button 'hat_cmw_bone' "长马尾" pos:[75,116] width:64 height:21 toolTip:"长马尾" align:#left
	button 'hat_Lmw_bone' "左马尾" pos:[9,141] width:64 height:21 toolTip:"左马尾" align:#left
	button 'hat_Rmw_bone' "右马尾" pos:[75,141] width:64 height:21 toolTip:"右马尾" align:#left
	button 'hat_Lzf_bone' "左中分" pos:[9,166] width:64 height:21 toolTip:"左中分" align:#left
	button 'hat_Rzf_bone' "右中分" pos:[75,166] width:64 height:21 toolTip:"右中分" align:#left
	button 'hat_Lpf_bone' "左盘发" pos:[9,191] width:64 height:21 toolTip:"左盘发" align:#left
	button 'hat_Rpf_bone' "右盘发" pos:[75,191] width:64 height:21 toolTip:"右盘发" align:#left
	button 'hat_Llh_bone' "左刘海" pos:[9,217] width:64 height:21 toolTip:"左刘海" align:#left
	button 'hat_Rlh_bone' "右刘海" pos:[75,217] width:64 height:21 toolTip:"右刘海" align:#left
	button 'hat_Lbf_bone' "左鬓发" pos:[9,242] width:64 height:21 toolTip:"左鬓发" align:#left
	button 'hat_Rbf_bone' "右鬓发" pos:[75,242] width:64 height:21 toolTip:"右鬓发" align:#left		
		
		
		
		
		
		
	
	
	
	GroupBox 'grp4' "袖子" pos:[4,274] width:140 height:67 align:#left
	
	button 'dbxL_bone' "dbxL_bone" pos:[76,290] width:64 height:21 toolTip:"大臂袖左" align:#left
	button 'xbxL_bone' "xbxL_bone" pos:[76,315] width:64 height:21 toolTip:"小臂袖左" align:#left
	button 'dbxR_bone' "dbxR_bone" pos:[9,290] width:64 height:21 toolTip:"大臂袖右" align:#left
	button 'xbxR_bone' "xbxR_bone" pos:[9,315] width:64 height:21 toolTip:"小臂袖右" align:#left	
	
	
	
	
	GroupBox 'grp1' "裙摆" pos:[4,344] width:140 height:109 align:#left
	button 'qbF_bone' "qbF_bone" pos:[40,427] width:64 height:21 toolTip:"裙摆前" align:#left
	button 'qbL_bone' "qbL_bone" pos:[75,404] width:64 height:21 toolTip:"裙摆左" align:#left
	button 'qbR_bone' "qbR_bone" pos:[9,404] width:64 height:21 toolTip:"裙摆右" align:#left
	button 'qbBL_bone' "qbBL_bone" pos:[75,380] width:64 height:21 toolTip:"裙摆后左" align:#left
	button 'qbBR_bone' "qbBR_bone" pos:[9,380] width:64 height:21 toolTip:"裙摆后右" align:#left
	button 'qbB_bone' "qbB_bone" pos:[40,357] width:64 height:21 toolTip:"裙摆后" align:#left
	

	 
	--button 'CRE_Export' "Export 01" pos:[41,204] width:60 height:21 toolTip:"一键创建Export 01集合" align:#left

	
	local TemlayerName =#()
	
	
	--------------------------------------------------------------------------------------------------------------

	on CRE_Bone pressed do
	(	
		Tem_bone =selection
		selectionSets["Bone"] = Tem_bone
	)
	-------------------------------------------------------------------------------------------------------------


	on REyelid pressed do
	(
		if selection.count ==0 then
		(
			messagebox "至少需要选择一节Bone" beep:false
		)
		else
		(   
			layer = layermanager.newLayerFromName "biaoqing"
			layer = LayerManager.getLayerFromName  "biaoqing"
			if classOf $ == bonegeometry then
			(
				$.name = "REyelid_BQ" 
				$.wirecolor = color 135 6 6
			)
			layer.addNode $
			--append Tem_Export $
		) 
	)---右眼皮
	
	--------------------------------------------------------------------------------------------------------------
	
	on LEyelid pressed do
	(
		if selection.count ==0 then
		(
			messagebox "至少需要选择一节Bone" beep:false
		)
		else
		(   
			layer = layermanager.newLayerFromName "biaoqing"
			layer = LayerManager.getLayerFromName  "biaoqing"
			TemBone = #()
			if classOf $ == bonegeometry then
			(
				$.name = "LEyelid_BQ" 
				$.wirecolor = color 135 6 6
			)
			layer.addNode $
			--append Tem_Export $
		) 			
	)---左眼皮
	
	
	
	--------------------------------------------------------------------------------------------------------------
	
	on REyeball pressed do
	(
		if selection.count ==0 then
		(
			messagebox "至少需要选择一节Bone" beep:false
		)
		else
		(   
			layer = layermanager.newLayerFromName "biaoqing"
			layer = LayerManager.getLayerFromName  "biaoqing"
			TemBone = #()
			if classOf $ == bonegeometry then
			(
				$.name = "REyeball_BQ"
				$.wirecolor = color 135 6 6				
			)
			layer.addNode $
			--append Tem_Export $
		) 
	)---右眼珠	
	
	
	
	--------------------------------------------------------------------------------------------------------------

	on LEyeball pressed do
	(
		if selection.count ==0 then
		(
			messagebox "至少需要选择一节Bone" beep:false
		)
		else
		(   
			layer = layermanager.newLayerFromName "biaoqing"
			layer = LayerManager.getLayerFromName  "biaoqing"
			TemBone = #()
			if classOf $ == bonegeometry then
			(
				$.name = "LEyeball_BQ" 
				$.wirecolor = color 135 6 6
			)
			layer.addNode $
			--append Tem_Export $
		) 
	)---左眼珠		
	
	
	
	--------------------------------------------------------------------------------------------------------------
	
	on Mouth pressed do
	(
		if selection.count ==0 then
		(
			messagebox "至少需要选择一节Bone" beep:false
		)
		else
		(   
			layer = layermanager.newLayerFromName "biaoqing"
			layer = LayerManager.getLayerFromName  "biaoqing"
			TemBone = #()
			if classOf $ == bonegeometry then
			(
				$.name = "Mouth" 
				$.wirecolor = color 135 6 6
			)
			layer.addNode $
			--append Tem_Export $
		) 
	)---嘴		
	

	
	--------------------------------------------------------------------------------------------------------------
	
	
	on hat_cf_bone pressed do
	(
		if selection.count ==0 then
		(
			messagebox "至少需要选择一节Bone" beep:false
		)
		else
		(   
			layer = layermanager.newLayerFromName "hat_bone"
			layer = LayerManager.getLayerFromName  "hat_bone"
			TemBone = #()
			for i =1 to selection.count do
			(   
				if classOf selection[i] == bonegeometry then
				(
					if i<10 then	
					selection[i].name = "hat_cf_bone" + "0" + (i as string)
					else
					selection[i].name = "hat_cf_bone" + (i as string)
				)
					layer.addNode selection[i]
					--append Tem_Export selection[i]
			) 
		)			
	)---长发
	
	
	
	--------------------------------------------------------------------------------------------------------------
	on hat_cmw_bone pressed do
	(
		if selection.count ==0 then
		(
			messagebox "至少需要选择一节Bone" beep:false
		)
		else
		(   
			layer = layermanager.newLayerFromName "hat_bone"
			layer = LayerManager.getLayerFromName  "hat_bone"
			TemBone = #()
			for i =1 to selection.count do
			(   
				if classOf selection[i] == bonegeometry then
				(
					if i<10 then	
					selection[i].name = "hat_cmw_bone" + "0" + (i as string)
					else
					selection[i].name = "hat_cmw_bone" + (i as string)
				)
					layer.addNode selection[i]
					--append Tem_Export selection[i]
			) 
		)			
	)---长马尾
	
	
	
	--------------------------------------------------------------------------------------------------------------
	on hat_Lmw_bone pressed do
	(
		if selection.count ==0 then
		(
			messagebox "至少需要选择一节Bone" beep:false
		)
		else
		(   
			layer = layermanager.newLayerFromName "hat_bone"
			layer = LayerManager.getLayerFromName  "hat_bone"
			TemBone = #()
			for i =1 to selection.count do
			(   
				if classOf selection[i] == bonegeometry then
				(
					if i<10 then	
					selection[i].name = "hat_Lmw_bone" + "0" + (i as string)
					else
					selection[i].name = "hat_Lmw_bone" + (i as string)
				)
					layer.addNode selection[i]
					--append Tem_Export selection[i]
			) 
		)			
	)---左马尾
	
	
	--------------------------------------------------------------------------------------------------------------
	on hat_Rmw_bone pressed do
	(
		if selection.count ==0 then
		(
			messagebox "至少需要选择一节Bone" beep:false
		)
		else
		(   
			layer = layermanager.newLayerFromName "hat_bone"
			layer = LayerManager.getLayerFromName  "hat_bone"
			TemBone = #()
			for i =1 to selection.count do
			(   
				if classOf selection[i] == bonegeometry then
				(
					if i<10 then	
					selection[i].name = "hat_Rmw_bone" + "0" + (i as string)
					else
					selection[i].name = "hat_Rmw_bone" + (i as string)
				)
					layer.addNode selection[i]
					--append Tem_Export selection[i]
			) 
		)			
	)---右马尾
	
	
	
	--------------------------------------------------------------------------------------------------------------
	on hat_Lzf_bone pressed do
	(
		if selection.count ==0 then
		(
			messagebox "至少需要选择一节Bone" beep:false
		)
		else
		(   
			layer = layermanager.newLayerFromName "hat_bone"
			layer = LayerManager.getLayerFromName  "hat_bone"
			TemBone = #()
			for i =1 to selection.count do
			(   
				if classOf selection[i] == bonegeometry then
				(
					if i<10 then	
					selection[i].name = "hat_Lzf_bone" + "0" + (i as string)
					else
					selection[i].name = "hat_Lzf_bone" + (i as string)
				)
					layer.addNode selection[i]
					--append Tem_Export selection[i]
			) 
		)			
	)---左中分
	
	
	
	--------------------------------------------------------------------------------------------------------------
	on hat_Rzf_bone pressed do
	(
		if selection.count ==0 then
		(
			messagebox "至少需要选择一节Bone" beep:false
		)
		else
		(   
			layer = layermanager.newLayerFromName "hat_bone"
			layer = LayerManager.getLayerFromName  "hat_bone"
			TemBone = #()
			for i =1 to selection.count do
			(   
				if classOf selection[i] == bonegeometry then
				(
					if i<10 then	
					selection[i].name = "hat_Rzf_bone" + "0" + (i as string)
					else
					selection[i].name = "hat_Rzf_bone" + (i as string)
				)
					layer.addNode selection[i]
					--append Tem_Export selection[i]
			) 
		)			
	)---右中分
	
	
	
	--------------------------------------------------------------------------------------------------------------
	on hat_Lpf_bone pressed do
	(
		if selection.count ==0 then
		(
			messagebox "至少需要选择一节Bone" beep:false
		)
		else
		(   
			layer = layermanager.newLayerFromName "hat_bone"
			layer = LayerManager.getLayerFromName  "hat_bone"
			TemBone = #()
			for i =1 to selection.count do
			(   
				if classOf selection[i] == bonegeometry then
				(
					if i<10 then	
					selection[i].name = "hat_Lpf_bone" + "0" + (i as string)
					else
					selection[i].name = "hat_Lpf_bone" + (i as string)
				)
					layer.addNode selection[i]
					--append Tem_Export selection[i]
			) 
		)			
	)---左盘发
	
	
	--------------------------------------------------------------------------------------------------------------
	on hat_Rpf_bone pressed do
	(
		if selection.count ==0 then
		(
			messagebox "至少需要选择一节Bone" beep:false
		)
		else
		(   
			layer = layermanager.newLayerFromName "hat_bone"
			layer = LayerManager.getLayerFromName  "hat_bone"
			TemBone = #()
			for i =1 to selection.count do
			(   
				if classOf selection[i] == bonegeometry then
				(
					if i<10 then	
					selection[i].name = "hat_Rpf_bone" + "0" + (i as string)
					else
					selection[i].name = "hat_Rpf_bone" + (i as string)
				)
					layer.addNode selection[i]
					--append Tem_Export selection[i]
			) 
		)			
	)---右盘发
	
	
	--------------------------------------------------------------------------------------------------------------
	on hat_Llh_bone pressed do
	(
		if selection.count ==0 then
		(
			messagebox "至少需要选择一节Bone" beep:false
		)
		else
		(   
			layer = layermanager.newLayerFromName "hat_bone"
			layer = LayerManager.getLayerFromName  "hat_bone"
			TemBone = #()
			for i =1 to selection.count do
			(   
				if classOf selection[i] == bonegeometry then
				(
					if i<10 then	
					selection[i].name = "hat_Llh_bone" + "0" + (i as string)
					else
					selection[i].name = "hat_Llh_bone" + (i as string)
				)
					layer.addNode selection[i]
					--append Tem_Export selection[i]
			) 
		)			
	)---左刘海
	
	
	--------------------------------------------------------------------------------------------------------------
	on hat_Rlh_bone pressed do
	(
		if selection.count ==0 then
		(
			messagebox "至少需要选择一节Bone" beep:false
		)
		else
		(   
			layer = layermanager.newLayerFromName "hat_bone"
			layer = LayerManager.getLayerFromName  "hat_bone"
			TemBone = #()
			for i =1 to selection.count do
			(   
				if classOf selection[i] == bonegeometry then
				(
					if i<10 then	
					selection[i].name = "hat_Rlh_bone" + "0" + (i as string)
					else
					selection[i].name = "hat_Rlh_bone" + (i as string)
				)
					layer.addNode selection[i]
					--append Tem_Export selection[i]
			) 
		)			
	)---右刘海
	
	
	--------------------------------------------------------------------------------------------------------------
	on hat_Lbf_bone pressed do
	(
		if selection.count ==0 then
		(
			messagebox "至少需要选择一节Bone" beep:false
		)
		else
		(   
			layer = layermanager.newLayerFromName "hat_bone"
			layer = LayerManager.getLayerFromName  "hat_bone"
			TemBone = #()
			for i =1 to selection.count do
			(   
				if classOf selection[i] == bonegeometry then
				(
					if i<10 then	
					selection[i].name = "hat_Lbf_bone" + "0" + (i as string)
					else
					selection[i].name = "hat_Lbf_bone" + (i as string)
				)
					layer.addNode selection[i]
					--append Tem_Export selection[i]
			) 
		)			
	)---左鬓发
	on hat_Rbf_bone pressed do
	(
		if selection.count ==0 then
		(
			messagebox "至少需要选择一节Bone" beep:false
		)
		else
		(   
			layer = layermanager.newLayerFromName "hat_bone"
			layer = LayerManager.getLayerFromName  "hat_bone"
			TemBone = #()
			for i =1 to selection.count do
			(   
				if classOf selection[i] == bonegeometry then
				(
					if i<10 then	
					selection[i].name = "hat_Rbf_bone" + "0" + (i as string)
					else
					selection[i].name = "hat_Rbf_bone" + (i as string)
				)
					layer.addNode selection[i]
					--append Tem_Export selection[i]
			) 
		)			
	)---右鬓发
	on dbxL_bone pressed do
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
					selection[i].name = "dbxL_bone" + "0" + (i as string)
					else
					selection[i].name = "dbxL_bone" + (i as string)
				)
					layer.addNode selection[i]
					--append TemBone selection[i]
					--append Tem_Export selection[i]
				
			) 
			--selectionSets["Bone"] = TemBone
		)			
	)---大臂袖左
	on xbxL_bone pressed do
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
					selection[i].name = "xbxL_bone" + "0" + (i as string)
					else
					selection[i].name = "xbxL_bone" + (i as string)
				)
					layer.addNode selection[i]
				--	append TemBone selection[i]
					--append Tem_Export selection[i]
				
			) 
			--selectionSets["Bone"] = TemBone
		)			
	)---小臂袖左
	on dbxR_bone pressed do
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
					selection[i].name = "dbxR_bone" + "0" + (i as string)
					else
					selection[i].name = "dbxR_bone" + (i as string)
				)
					layer.addNode selection[i]
				--	append TemBone selection[i]
					--append Tem_Export selection[i]
				
			) 
			--selectionSets["Bone"] = TemBone
		)			
	)---大臂袖右
	on xbxR_bone pressed do
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
					selection[i].name = "xbxR_bone" + "0" + (i as string)
					else
					selection[i].name = "xbxR_bone" + (i as string)
				)
					layer.addNode selection[i]
				--	append TemBone selection[i]
					--append Tem_Export selection[i]
				
			) 
			--selectionSets["Bone"] = TemBone
		)			
	)---小臂袖右
	on qbF_bone pressed do
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
					selection[i].name = "qbF_bone" + "0" + (i as string)
					else
					selection[i].name = "qbF_bone" + (i as string)
				)
					layer.addNode selection[i]
				--	append TemBone selection[i]
					--append Tem_Export selection[i]
				
			) 
			--selectionSets["Bone"] = TemBone
		)			
	)---裙摆前
	on qbL_bone pressed do
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
					selection[i].name = "qbL_bone" + "0" + (i as string)
					else
					selection[i].name = "qbL_bone" + (i as string)
				)
					layer.addNode selection[i]
				--	append TemBone selection[i]
					--append Tem_Export selection[i]
				
			) 
			--selectionSets["Bone"] = TemBone
		)			
	)---裙摆左
	on qbR_bone pressed do
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
					selection[i].name = "qbR_bone" + "0" + (i as string)
					else
					selection[i].name = "qbR_bone" + (i as string)
				)
					layer.addNode selection[i]
				--	append TemBone selection[i]
					--append Tem_Export selection[i]
				
			) 
			--selectionSets["Bone"] = TemBone
		)			
	)---裙摆右
	on qbBL_bone pressed do
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
					selection[i].name = "qbBL_bone" + "0" + (i as string)
					else
					selection[i].name = "qbBL_bone" + (i as string)
				)
					layer.addNode selection[i]
				--	append TemBone selection[i]
					--append Tem_Export selection[i]
				
			) 
			--selectionSets["Bone"] = TemBone
		)			
	)---裙摆后左
	on qbBR_bone pressed do
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
					selection[i].name = "qbBR_bone" + "0" + (i as string)
					else
					selection[i].name = "qbBR_bone" + (i as string)
				)
					layer.addNode selection[i]
				--	append TemBone selection[i]
					--append Tem_Export selection[i]
				
			) 
			--selectionSets["Bone"] = TemBone
		)			
	)---裙摆后右
	on qbB_bone pressed do
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
					selection[i].name = "qbB_bone" + "0" + (i as string)
					else
					selection[i].name = "qbB_bone" + (i as string)
				)
					layer.addNode selection[i]
				--	append TemBone selection[i]
					--append Tem_Export selection[i]
				
			) 
			--selectionSets["Bone"] = TemBone
		)			
	)---裙摆后
)
	

--------------------------------------------------------
	
rollout userDefined "Userdefined" width:162 height:58
	(
	
		edittext 'bonename_tex' "" pos:[14,9] width:90 height:17 align:#left
		button 'Cle_btn' "Clean" pos:[108,7] width:38 height:21 toolTip:"清空" align:#left
		button 'Sta_btn' "Start" pos:[75,34] toolTip:"执行命名排序" 
		checkbox 'In_Ex' "InEx" pos:[25,35] width:40 height:15 checked:true align:#left toolTip:"自定义骨骼是否加入Bone" align:#left
		
		
		on Cle_btn pressed do
		(
			bonename_tex.text=""
		)
		on Sta_btn pressed do
		(
			if In_Ex.checked then
			(
				layer = layermanager.newLayerFromName  "Bone"

				layer = LayerManager.getLayerFromName  "Bone"
			)
			else
			(
				layer = layermanager.newLayerFromName bonename_tex.text

				layer = LayerManager.getLayerFromName  bonename_tex.text
			)
			--TemUser = #()
			for i=1 to selection.count do
			(
				(
					if i<10 then	
						selection[i].name=(bonename_tex.text + "0" + i as string)
					else
						selection[i].name=(bonename_tex.text + i as string)
				)
				layer.addNode selection[i]
		
				--append Tem_Export selection[i]
			
			)
				
		)
			--selectionSets[bonename_tex.text] = TemUser
			--selectionSets["Export01"] = Tem_Export

	)
	
----------------------------------------------------------------------------------------------------------------------------	
----------------------------------------------------------------------------------------------------------------------------	
----------------------------------------------------------------------------------------------------------------------------		
	
rollout Skin_Check "SkinCheck"
(
	
	button Skin_Check "检查蒙皮" pos:[13,7] tooltip:"选择需要检查的蒙皮"align:#left
	button Batch_Remove "批量移除" pos:[89,7] tooltip:"请注意，此功能可批量移除所有蒙皮骨骼"align:#right
	edittext BoneNumber "蒙皮骨骼数:"
	
	listbox 'lbx1' "无权重骨骼：" tooltip:"双击或者右击选择删除"
	button Quick_Remove "全部移除" tooltip:"移除列表中所有无权重骨骼"
	
	
	global un_id =#() ---无权重的骨骼ID
	global Un_BoneName =#() --无权重骨骼名字
	global objSkin
	local skin_num = 0 ---蒙皮骨骼数
	progressBar QR_bar  color:blue--进度条

	
	hyperlink lbl_help "帮助" address:"https://www.cgjoy.com/forum.php?mod=viewthread&tid=211812&page=1&extra=#pid9898326" align:#center offset:[0,10]
	
	

	fn UnSkinBoneId obj_Skin bone_count =
	(
		
		skin_index=#{1.. bone_count} --骨骼蒙皮ID列表
		
		numSkinVerts = #{1..(skinOps.getNumberVertices obj_Skin)} --获取参与蒙皮的点
		
		global SkinBoneID = #()  --有权重骨骼ID集合
		
		for n=1 to numSkinVerts.count do
		(
			numBoneWeights = skinOps.getVertexWeightCount obj_Skin n    --每个点有几根骨骼影响
			
            for b=1 to numBoneWeights do
			(
				boneID       = skinOps.getVertexWeightBoneID obj_Skin n b  --获取第n个点参与的第b个骨骼的ID
				append SkinBoneID boneID
	
			)

		)
		SkinBoneID=makeUniqueArray SkinBoneID ----去除数组中重复的元素
		SkinBoneID = sort SkinBoneID  ----数组排序
		skin_index = skin_index as array    ----位数组转数组
		
		struct bone_weight  ---绑定骨骼ID和骨骼名
		(
			n_ame,
			index
		)

		
		un_id =#() -- 无权重骨骼ID
		/*
		for i = SkinBoneID.count to 1 by -1 do	 --- num_id - SkinBoneID
		(
			un_id = deleteitem num_id SkinBoneID[i]
		)
		un_id
		*/
		for i =1 to skin_index.count  do    ---skin_index - SkinBoneID
		(
			if (findItem SkinBoneID (skin_index[i])) == 0 do
			(
				tem_bone = bone_weight()
				tem_bone.n_ame = skinOps.GetBoneName objSkin skin_index[i] 1
				tem_bone.index = i
				append un_id tem_bone
			)
		)
	
	)
----------------------------------------------------------------------------------------------------------------------------

	fn ChangeBoneName obj_Skin a_array = ---转换ID骨骼名
	(
		
		Un_BoneName =#()
		/*
		for i=1 to a_array.count do
		(	
			append Un_BoneName (skinOps.GetBoneName obj_Skin a_array[i] 1)
		) 
		Un_BoneName
		*/
		for i =1 to a_array.count do
		(
			local a_string = a_array[i].n_ame
			append Un_BoneName a_string
		)
		
	)
	

	
	
----------------------------------------------------------------------------------------------------------------------------
	
	
	
	
	fn ShowBone  =   ---显示
	(
		lbx1.items=Un_BoneName
		
		
	)
----------------------------------------------------------------------------------------------------------------------------
	
	fn Get_NumberBones = ---检查
	(
		if selection.count == 1 then	
		(
			max modify mode
			global objSkin  = $.modifiers[#Skin]
			skinOps.RemoveZeroWeights objSkin
			skin_num = skinOps.GetNumberBones objSkin
			
			--UnId = UnSkinBoneId objSkin skin_num			
			UnSkinBoneId objSkin skin_num

			ChangeBoneName objSkin un_id
	
			ShowBone()

		)
		else
		(
			messageBox "选择单个模型 "
			Un_BoneName =#()
			ShowBone()
			
		)
			BoneNumber.text= skin_num as string
			skin_num = 0
	
		
	)
	
----------------------------------------------------------------------------------------------------------------------------	
	
	on Skin_Check pressed do
	(

		Get_NumberBones ()
	
	)
----------------------------------------------------------------------------------------------------------------------------	
	on Batch_Remove pressed do  ----批量删除
	(
		if selection.count == 1 then	
		(
			max modify mode
			objSkin  = $.modifiers[#Skin]
			skinOps.RemoveZeroWeights objSkin
			skinOps.multiRemove objSkin

		)
		else
		(
			messageBox "选择单个模型 "
		)

		Get_NumberBones ()
		

	)
----------------------------------------------------------------------------------------------------------------------------	
	
	on lbx1 selected nameIndex do  ---选择
	(

		local a_index = (un_id[lbx1.selection]).index  ---获取骨骼ID
		skinOps.SelectBone objSkin a_index     ----选取ID骨骼
		
		
		/*
		--sel_bone_name = (getNodeByName lbx1.items[nameIndex]).name
	
		for i=1 to  un_id.count do
		(
			tem_name = skinOps.GetBoneName objSkin un_id[i] 1
			if sel_bone_name == tem_name then
			(
				skinOps.SelectBone objSkin  un_id[i]
			)	
		)
	*/

	)
	
----------------------------------------------------------------------------------------------------------------------------	
	
	on lbx1 doubleClicked sel do  ---双击删除
	(
		local a_index = (un_id[lbx1.selection]).index

		skinOps.removebone objSkin a_index
		
		temp = lbx1.items

		deleteItem temp sel

		lbx1.items = temp
		
		Get_NumberBones ()

	)
	
----------------------------------------------------------------------------------------------------------------------------	
		

	on lbx1 rightClick sel do  ---右击删除
	(
		local a_index = (un_id[lbx1.selection]).index

		skinOps.removebone objSkin a_index
		
		temp = lbx1.items

		deleteItem temp sel

		lbx1.items = temp
		
		Get_NumberBones ()
	)
	
----------------------------------------------------------------------------------------------------------------------------	
	
	on Quick_Remove pressed do  ---快速移除
	(
		
		max modify mode
		
		for i =un_id.count to 1 by -1 do
		(
			local a_id = un_id[i].index
			modPanel.setCurrentObject objSkin ---选择蒙皮层
			skinOps.removebone objSkin a_id
			QR_bar.value = 100-100.*i/un_id.count
		)
		Get_NumberBones () 
		QR_bar.value = 0
		
	)

	
	
)
----------------------------------------------------------------------------------------------------------------------------	
----------------------------------------------------------------------------------------------------------------------------	
----------------------------------------------------------------------------------------------------------------------------	

Global SkinHideManager		
try (destroydialog SkinHideManager) catch()
	
	
rollout SkinHideManager "SkinHideManager" 
(
	GroupBox 'grp1' "Hide Selected" pos:[4,4] width:136 height:46 align:#left
	button 'uiBtnHideSelVerts' "Vertex" pos:[13,22] width:38 height:21 across:3 align:#left
	button 'uiBtnHideSelFace' "Face" pos:[54,22] width:31 height:21 align:#left
	button 'uiBtnHideSelElem' "Element" pos:[88,22] width:45 height:21 align:#left
	
	button 'uiBtnUnhideAll' "Unhide All" pos:[39,54] width:63 height:21 align:#left
	
	GroupBox 'grp2' "Option" pos:[4,81] width:136 height:40 align:#left
	checkbox 'uiChkHideUnselected' "Hide Unselected" pos:[23,100] width:101 height:15 across:2 align:#left
	
	hyperlink lbl_help "帮助" address:"https://www.cgjoy.com/forum.php?mod=viewthread&tid=207292" align:#center offset:[0,10]

	function CheckSkinModifier obj =
	(
		if ( obj.modifiers.count == 0 ) do return 0
		for o = 1 to obj.modifiers.count do
		(
			if ( (classof obj.modifiers[o])  == Skin ) do return o
		)
		return 0
	)
	

	local idEditPolyModifier
	local idSkinModifier
	function CheckType obj =
	(
		idSkinModifier = CheckSkinModifier obj
		if idSkinModifier == 0 do return 0
		
		if ( obj.modifiers.count == 1 ) do (
			if ( (classof $.baseobject) == Editable_Poly ) then
			(
				return 3
			)
			else
			(
				return 1
			)
		)
		
		idSkin = CheckSkinModifier obj
		
		for o = idSkin to obj.modifiers.count do
		(
			if ( ( classof obj.modifiers[o] ) == Edit_Poly ) do
			(
				idEditPolyModifier = o		
				return 2
			)
		)
		
		if ( ( classof obj.baseobject ) == Editable_Poly ) do return 3
		
		return 0
	)
	

	function GetSkinVertSelection skinMod =
	(
		bitArr = #{}
		loopIndex = 1
		errFlag = false
		testValue = true
		while errFlag == false do
		(
			try
			(
				testValue = skinOps.IsVertexSelected skinMod loopIndex
			)
			catch
			(
				return bitArr
			)
			
			append bitArr loopIndex
			if testValue == 0 do
			(
				bitArr[loopIndex] = false
			)
			loopIndex += 1
		)
		return bitArr
	)
	
	
	
	
	
	on uiBtnHideSelVerts pressed do
	(
		if (selection.count != 1) do return()
			
		skinType = CheckType selection[1]
						
		if ( skinType == 0 ) do return()
		
		disableSceneRedraw()
		undo on (
		case skinType of
		(
			2:
			(
				-- Edit Poly > Skin
				selectedVerts = GetSkinVertSelection selection[1].modifiers[idSkinModifier]
				if (uiChkHideUnselected.state) do
				(
					selectedVerts = -selectedVerts
				)
				modPanel.setCurrentObject selection[1].modifiers[idEditPolyModifier]
				subobjectLevel = 1
				selection[1].modifiers[idEditPolyModifier].SetSelection #Vertex #{}
				selection[1].modifiers[idEditPolyModifier].Select #Vertex selectedVerts
				selection[1].modifiers[idEditPolyModifier].ButtonOp #HideVertex
				subobjectLevel = 0
				modPanel.setCurrentObject selection[1].modifiers[idSkinModifier]
				subobjectLevel = 1
				skinOps.SelectVertices selection[1].modifiers[idSkinModifier] #{}
			)-- 2 end
			
			3:
			(
				-- Edittable Poly > Skin
				selectedVerts = GetSkinVertSelection selection[1].modifiers[idSkinModifier]
				if (uiChkHideUnselected.state) do
				(
					selectedVerts = -selectedVerts
				)
				selection[1].EditablePoly.SetSelection #Vertex selectedVerts
				selection[1].EditablePoly.Hide #Vertex
				subobjectLevel = 1
				skinOps.SelectVertices selection[1].modifiers[idSkinModifier] #{}
			)-- 3 end
			
			default: return ()
		)
		)-- undo end
		enableSceneRedraw()
	)
	on uiBtnHideSelFace pressed do
	(
		if (selection.count != 1) do return()
			
		skinType = CheckType selection[1]
						
		if ( skinType == 0 ) do return()
		
		disableSceneRedraw()
		undo on (
		case skinType of
		(
			2:
			(
				-- Edit Poly > Skin
				selectedVerts = GetSkinVertSelection selection[1].modifiers[idSkinModifier]
				modPanel.setCurrentObject selection[1].modifiers[idEditPolyModifier]
				subobjectLevel = 1
				selection[1].modifiers[idEditPolyModifier].SetSelection #Vertex #{}
				selection[1].modifiers[idEditPolyModifier].Select #Vertex selectedVerts
				selection[1].modifiers[idEditPolyModifier].ConvertSelection #Vertex #Face
				if (uiChkHideUnselected.state) do
				(
					subobjectLevel = 4
					actionMan.executeAction 0 "40044"  -- Selection: Select Invert
				)
				selection[1].modifiers[idEditPolyModifier].ButtonOp #HideFace
				subobjectLevel = 0
				modPanel.setCurrentObject selection[1].modifiers[idSkinModifier]
				subobjectLevel = 1
				skinOps.SelectVertices selection[1].modifiers[idSkinModifier] #{}
			)-- 2 end
			
			3:
			(
				-- Edittable Poly > Skin
				selectedVerts = GetSkinVertSelection selection[1].modifiers[idSkinModifier]
				selection[1].EditablePoly.SetSelection #Vertex selectedVerts
				selection[1].EditablePoly.ConvertSelection #Vertex #Face
				if (uiChkHideUnselected.state) do
				(
					modPanel.setCurrentObject selection[1].baseObject
					subobjectLevel = 4
					actionMan.executeAction 0 "40044"  -- Selection: Select Invert
					subobjectLevel = 0
				)
				selection[1].EditablePoly.Hide #Face
				modPanel.setCurrentObject selection[1].modifiers[idSkinModifier]
				subobjectLevel = 1
				skinOps.SelectVertices selection[1].modifiers[idSkinModifier] #{}
			)-- 3 end
			
			default: return ()
		)
		)-- undo end
		enableSceneRedraw()
	)
	on uiBtnHideSelElem pressed do
	(
		if (selection.count != 1) do return()
				
		skinType = CheckType selection[1]
						
		if ( skinType == 0 ) do return()
		
		disableSceneRedraw()
		undo on (
		case skinType of
		(
			2:
			(
				-- Edit Poly > Skin
				selectedVerts = GetSkinVertSelection selection[1].modifiers[idSkinModifier]
				modPanel.setCurrentObject selection[1].modifiers[idEditPolyModifier]
				subobjectLevel = 1
				selection[1].modifiers[idEditPolyModifier].SetSelection #Vertex #{}
				selection[1].modifiers[idEditPolyModifier].Select #Vertex selectedVerts
				selection[1].modifiers[idEditPolyModifier].ConvertSelection #Vertex #Element
				if (uiChkHideUnselected.state) do
				(
					subobjectLevel = 5
					actionMan.executeAction 0 "40044"  -- Selection: Select Invert
				)
				selection[1].modifiers[idEditPolyModifier].ButtonOp #HideFace
				subobjectLevel = 0
				modPanel.setCurrentObject selection[1].modifiers[idSkinModifier]
				subobjectLevel = 1
				skinOps.SelectVertices selection[1].modifiers[idSkinModifier] #{}
			)-- 2 end
			
			3:
			(
				-- Edittable Poly > Skin
				selectedVerts = GetSkinVertSelection selection[1].modifiers[idSkinModifier]
				selection[1].EditablePoly.SetSelection #Vertex selectedVerts
				selection[1].EditablePoly.ConvertSelection #Vertex #Element
				if (uiChkHideUnselected.state) do
				(
					modPanel.setCurrentObject selection[1].baseObject
					subobjectLevel = 5
					actionMan.executeAction 0 "40044"  -- Selection: Select Invert
					subobjectLevel = 0
				)
				selection[1].EditablePoly.Hide #Face
				modPanel.setCurrentObject selection[1].modifiers[idSkinModifier]
				subobjectLevel = 1
				skinOps.SelectVertices selection[1].modifiers[idSkinModifier] #{}
			)-- 3 end
			
			default: return ()
		)
		)-- undo end
		enableSceneRedraw()
	)
	on uiBtnUnhideAll pressed do
	(
		if (selection.count != 1) do return()
		
		skinType = CheckType selection[1]
						
		if ( skinType == 0 ) do return()
		
		undo on (
		case skinType of
		(
			2:
			(
				selection[1].modifiers[idEditPolyModifier].ButtonOp #UnhideAllFace
				selection[1].modifiers[idEditPolyModifier].ButtonOp #UnhideAllVertex
			)-- 2 end
			
			3:
			(
				selection[1].EditablePoly.unhideAll #Face
				selection[1].EditablePoly.unhideAll #Vertex
			)-- 3 end
			
			default: return ()
		)
		)-- undo end
	)
)

--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
	
rollout Change_Weight "ChangeWeight" 
(
	groupBox 'grp1' "CopySkin" pos:[4,7] width:145 height:99 align:#left

    --pickbutton 'source_bone' "from bone" pos:[35,26] width:93 height:21 toolTip:"选取需要被替换蒙皮的骨骼" align:#left
    button btn_cp "From Bone" pos:[37,26] width:93 height:21 toolTip:"复制选中骨骼权重" align:#left

	--pickbutton 'target_bone' "to bone" pos:[40,52] width:82 height:21 toolTip:"选取替换蒙皮的骨骼" align:#left
    button btn_ps "To Bone" pos:[37,52] width:93 height:21 toolTip:"权重剪贴到选中骨骼" align:#left

    checkbox ckb_sele_ver "" pos:[12,42] checked:false toolTip:"只作用于选中点模式"

	--button 'replaceskin' "Replace" pos:[84,78] width:54 height:21 toolTip:"选取骨骼后执行替换" align:#left

	--button 'Cle_btn' "Clean" pos:[25,78] width:43 height:21 toolTip:"清空选择的骨骼" align:#left

    progressBar Bar "ProgressBar" pos:[13,80] width:130 height:16 color:red--进度条
    -------------------------------------------------------------------------------------------------------------------------
    groupBox group_env "Envelope" pos:[4,110] width:145 height:71

    button btn_env_cp "Copy" pos:[13,129] width:64 height:21 toolTip:"复制当前选中封套"
    button btn_env_pa "Paste" pos:[80,129] width:64 height:21 toolTip:"黏贴封套到选中骨骼"
    button Reset_Env "ResEnv" pos:[52,153] toolTip:"选取模型重置封套"
    -------------------------------------------------------------------------------------------------------------------------
    hyperlink lbl_help "帮助" address:"https://www.cgjoy.com/thread-210984-1-1.html" align:#center offset:[0,10]
    --button btn_cp "From"
    --button btn_ps "To"

	local aBones
	local BoneID
    global in_R
    global out_R
    global objSkin
    global id_a
    global id_b
    global skin_bone
    global objmesh


	-- FUNCTIONS -------------------------------------------------------------------
    fn get_skin_mod_ver obj_skin=  --收集蒙皮下选中的 点
    (
        selectedVerts =#()
        for i = 1 to (skinOps.GetNumberVertices obj_skin) do --vertnum is number of vertices in skin object
        (
            theVert = skinOps.IsVertexSelected obj_skin i
            if theVert == 1 do (append selectedVerts i )
        )
        return selectedVerts
    )
    --------------------------------------------------
	fn returnObjectBones obj =
	(
		a = skinOps.getNumberBones obj
		for i in 1 to a collect (skinops.getBoneName obj i 1)
	)--收集蒙皮骨骼 名字
    --------------------------------------------------
    /*
	fn returnBoneIndex SkinBoneNum BoneName =
	(
		BoneID = 0

		for n = 1 to SkinBoneNum.count do
		(

			if 	SkinBoneNum[n] == BoneName do--then
            (
				BoneID = n
            )

		)

		return BoneID
	)*/
    ---返回骨骼ID
    --------------------------------------------------
    fn repskin fron_bone_ID to_bone_ID =
    (
        --try
       -- (
            --max modify mode  --打开蒙皮编辑窗口
            --objSkin = obj_Skin--$.skin  --获取蒙皮文件
            --objSkin = $.modifiers[#Skin]
            --if objSkin != undefined do--then
            undo "skin" on --撤销无效
            (
                SkinBoneNum = returnObjectBones objSkin   --获取蒙皮骨骼
                target_bone_ID = to_bone_ID --returnBoneIndex SkinBoneNum target_bone.text --获取目标骨骼ID
                --target_bone_ID = findItem SkinBoneNum target_bone.text   --获取目标骨骼ID
                --source_bone_ID = findItem SkinBoneNum source_bone.text
                source_bone_ID = fron_bone_ID  --returnBoneIndex SkinBoneNum source_bone.text --获取源骨骼ID

                if ckb_sele_ver.state then
                (
                    skin_ver = get_skin_mod_ver objSkin
                    if skin_ver.count !=0 then
                    (
                        numSkinVerts = skin_ver
                    )
                    else
                    (
                        numSkinVerts = #{1..(skinOps.getNumberVertices objSkin)}
                    )
                )
                else (
                    numSkinVerts = #{1..(skinOps.getNumberVertices objSkin)}  --获取参与蒙皮的点
                )
                -- numSkinVerts =skinOps.getNumberVertices objSkin --获取参与蒙皮的点


                if target_bone_ID != 0 and source_bone_ID != 0 then
                (
                    -- Process Skin --------------------------------------------------------

                    --for n = 1 to numSkinVerts do
                    for n in numSkinVerts do
                    (
                        -- Find number of bones effecting curent vertex

                        numBoneWeights = skinOps.getVertexWeightCount objSkin n   --获取骨骼ID为n参与的蒙皮点 --每个点有几根骨骼影响

                        -- Find all bone weights

                        aBoneID         = #()  --创建骨骼ID集合
                        aVertWeights    = #()  --创建权重中集合
                         -- skinOps.GetSelectedBone  skin  --当前选择骨骼序号
                        for b = 1 to numBoneWeights do
                        (
                            vertexWeight = skinOps.getVertexWeight objSkin n b   --获取第n个点的参与的第b个骨骼权重值
                            boneID       = skinOps.getVertexWeightBoneID objSkin n b  --获取第n个点参与的第b个骨骼的ID

                            append aBoneID boneID    --收集这个点参与的所有骨骼ID
                            append aVertWeights vertexWeight  ---收集这个点参与的每根骨骼ID的权重值
                        )

                        foundsource_boneIndex = 0
                        for b = 1 to aBoneID.count do   -- 解析查找被替换骨骼的的骨骼序列号数
                        (
                            if aBoneID[b] == source_bone_ID do--then
                            (
                                foundsource_boneIndex = b
                            )
                        )

                        foundtarget_boneIndex = 0
                        for b = 1 to aBoneID.count do   -- 解析查找替换骨骼的的骨骼序列号数
                        (
                            if aBoneID[b] == target_bone_ID do --then
                            (
                                foundtarget_boneIndex = b
                            )
                        )
                        if foundsource_boneIndex > 0 do --then
                        (
                            sourceWeight = aVertWeights[foundsource_boneIndex]  -- 收集

                            if foundtarget_boneIndex > 0 then
                            (
                                aVertWeights[foundtarget_boneIndex] += aVertWeights[foundsource_boneIndex]
                            )
                            else
                            (
                                append aVertWeights sourceWeight
                                append aBoneID target_bone_ID
                            )

                            deleteItem aVertWeights foundsource_boneIndex
                            deleteItem aBoneID foundsource_boneIndex

                            skinOps.replaceVertexWeights objSkin n aBoneID aVertWeights

                                -- End of this vertex
                            update $
                        )
                        --Change_Weight.Bar.value = 100.*n/numSkinVerts
                        Change_Weight.Bar.value = 100.*n/(numSkinVerts.count)
                    )
                    Change_Weight.Bar.value = 0
                )
                else
                (
                    messageBox "ERROR: Source Bone not found in Skin!" title:"target2source"
                )
            )
            /*
            else
            (
                messageBox "模型没有蒙皮,是否选错了模型     "
            )
            */
       -- )catch (print "lllllllllllllllll")
    )

    --------------------------------------------------
	-- START OF SCRIPT -------------------------------------------------------------
    --skinOps.addbone <Skin> <Bone_node> <Update_integer>
    -----------------------------------------------------
    on btn_cp pressed do
    (
        objSkin = $.modifiers[#Skin]
        if objSkin != undefined do
        (
            id_a = skinOps.GetSelectedBone objSkin
			btn_cp.caption= skinOps.GetBoneName objSkin id_a 1
			
        )
		--source_bone.text = obj.name
		
    )
    on btn_ps pressed do
    (
        objSkin = $.modifiers[#Skin]
        if objSkin != undefined then
        (
            id_b = skinOps.GetSelectedBone objSkin
            if id_a != id_b do
            (
                repskin id_a id_b
			
            )
        )
        else(
            messageBox "模型没有蒙皮,是否选错了模型     "
        )
    )
    -----------------------------------------------------
	on btn_env_cp pressed do
	(

            objSkin =$.modifiers[#Skin]
            objmesh = $
            if objSkin != undefined do
            (
                skin_bone = returnObjectBones objSkin
                bone_id = skinOps.GetSelectedBone objSkin
                if bone_id != 0 then
                (
                    in_R =#() --内圈
                    out_R = #() -- 外圈
                    for i=1 to 2 do
                    (
                        in_R_a = skinOps.getInnerRadius objSkin bone_id i
                        in_R[i] = in_R_a

                        out_R_a = skinOps.getOuterRadius objSkin bone_id i
                        out_R[i] = out_R_a
                    )
                )
                else(
                    messageBox "选中骨骼错误  "
                )
            )
	)
    -----------------------------------------------------
    on btn_env_pa pressed do
    (
        if selection.count !=0 do
        (
            skinbones_name = for i in selection collect i.name
            select objmesh
            max modify mode
            --Change_Weight.Bar.color = blue
            for p= 1 to skinbones_name.count do
            (
                bone_id = findItem skin_bone skinbones_name[p]
                if bone_id != 0 do
                (

                    for o= 1 to 2 do
                    (
                        --try (
                            skinOps.setInnerRadius objSkin bone_id o in_R[o]   --内圈

                            skinOps.setOuterRadius objSkin bone_id o out_R[o]  --外圈
                        --)catch()
                    )
                    Change_Weight.Bar.value = 10.*p/(skinbones_name.count)
                )

            )
            Change_Weight.Bar.value = 0
        )
    )
    -----------------------------------------------------
    on Reset_Env pressed do
    (
        objSkin =$.modifiers[#Skin]
        --skin_BoneNum = returnObjectBones objSkin
        skin_BoneNum = skinOps.getNumberBones objSkin
        for i=1 to skin_BoneNum do
        (
            Bone_Name=skinOps.GetBoneName  objSkin i 1 ---获取ID骨骼名称
            --Bone_Name = ChangeName Bone_Name
            if Bone_Name != undefined do
            (
                try (
                    boneobj = execute ("$"+Bone_Name)
                    )
                catch
                (
                    boneobj = execute ("$"+"'"+Bone_Name+"'")
                )

            )
            case (classof boneobj ) of
            (
                BoneGeometry :
                (
                    --Bone_length=execute("$" + Bone_Name + ".length") ---获取骨骼长度
                    Bone_length=boneobj.length ---获取骨骼长度
                    --Bone_length * 0.2
                    --skinOps.setEndPoint objSkin i [0,0,0]
                    skinOps.setEndPoint objSkin i [0,0,0]   ---重置当前ID骨骼结束封套点
                    skinOps.setStartPoint objSkin i [Bone_length,0,0]  ---重置当前ID骨骼开始封套点
                )
                Biped_Object :
                (
                    /*
                    bound = nodeGetBoundingBox boneobj boneobj.transform
                    selSize = ( bound[2] - bound[1] )

                    --skinOps.setEndPoint objSkin i [0,0,0]
                    skinOps.setStartPoint objSkin i [(selSize.z*0.5),0,0]
                    */
                )
            )
            Change_Weight.Bar.value = (i / skin_BoneNum) * 100
        )
        Change_Weight.Bar.value = 0
    )
	
)

--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
	
	
rollout custom "Custom" width:162 height:122
	(
					
		global SkinIniFile = (getDir #Scripts)+"\diaoyong.ini"
		
		button 'butt1' "Path…" pos:[22,3] width:95 height:24 toolTip:"加载脚本" align:#left
		button 'butt_1' "" pos:[7,3] width:15 height:24 toolTip:"清除脚本路径" align:#left
		button 'butt2' "Path…" pos:[22,32] width:95 height:24 toolTip:"加载脚本" align:#left
		button 'butt_2' "" pos:[7,32] width:15 height:24 toolTip:"清除脚本路径" align:#left
		button 'butt3' "Path…" pos:[22,62] width:95 height:24 toolTip:"加载脚本" align:#left
		button 'butt_3' "" pos:[7,62] width:15 height:24 toolTip:"清除脚本路径" align:#left
		button 'butt4' "Path…" pos:[22,92] width:95 height:24 toolTip:"加载脚本" align:#left
		button 'butt_4' "" pos:[7,92] width:15 height:24 toolTip:"清除脚本路径" align:#left
	


		on custom open do
		(
			if ( getINISetting  "SkinIniFile" "diaoyong" "jiaoben1" ) != "" then 
			(
				butt1.text =getFilenameFile ( getINISetting   "SkinIniFile" "diaoyong" "jiaoben1" )
			) else ( butt1.text = "Path…" )
			if ( getINISetting  "SkinIniFile" "diaoyong" "jiaoben2" ) != "" then 
			(
				butt2.text =getFilenameFile ( getINISetting   "SkinIniFile" "diaoyong" "jiaoben2" )
			) else ( butt2.text = "Path…" )
			
			if ( getINISetting  "SkinIniFile" "diaoyong" "jiaoben3" ) != "" then 
			(
				butt3.text =getFilenameFile ( getINISetting   "SkinIniFile" "diaoyong" "jiaoben3" )
			) else ( butt3.text = "Path…" )
				
			if ( getINISetting  "SkinIniFile" "diaoyong" "jiaoben4" ) != "" then 
			(
				butt4.text =getFilenameFile ( getINISetting   "SkinIniFile" "diaoyong" "jiaoben4" )
			) else ( butt4.text = "Path…" )
						
		)
			
			
		on butt1 pressed do
		(
			if butt1.text == "Path…" then 
			(
				jiaoben1 = getOpenFileName caption:"" types:"All Files (*.*)|*.*|ms (*.ms)|*.ms|mse (*.mse)|*.mse|"
			if jiaoben1 != undefined then
			(
				butt1.text = getFilenameFile jiaoben1
				setINISetting  "SkinIniFile" "diaoyong" "jiaoben1" (jiaoben1 as string)
			)
			)
			else( fileIn ( getINISetting  "SkinIniFile" "diaoyong" "jiaoben1" as string) )
		)
		on butt_1 pressed do
		(
			butt1.text = "Path…"
			setINISetting  "SkinIniFile" "diaoyong" "jiaoben1" (butt1.text as string)
		)
		on butt2 pressed do
		(
			if butt2.text == "Path…" then 
			(
				jiaoben2 = getOpenFileName caption:"" types:"All Files (*.*)|*.*|ms (*.ms)|*.ms|mse (*.mse)|*.mse|"
			if jiaoben2 != undefined then
			(
				butt2.text = getFilenameFile jiaoben2
				setINISetting  "SkinIniFile" "diaoyong" "jiaoben2" (jiaoben2 as string)
			)
			)
			else( fileIn ( getINISetting  "SkinIniFile" "diaoyong" "jiaoben2" as string) )
		)
		on butt_2 pressed do
		(
			butt2.text = "Path…"
			setINISetting  "SkinIniFile" "diaoyong" "jiaoben2" (butt2.text as string)	
		)
		on butt3 pressed do
		(
			if butt3.text == "Path…" then 
			(
				jiaoben3 = getOpenFileName caption:"" types:"All Files (*.*)|*.*|ms (*.ms)|*.ms|mse (*.mse)|*.mse|"
			if jiaoben3 != undefined then
			(	
				butt3.text = getFilenameFile jiaoben3
				setINISetting  "SkinIniFile" "diaoyong" "jiaoben3" (jiaoben3 as string)
			)
			)
			else( fileIn ( getINISetting  "SkinIniFile" "diaoyong" "jiaoben3" as string) )
			)
		on butt_3 pressed do
		(	
			butt3.text = "Path…"
			setINISetting  "SkinIniFile" "diaoyong" "jiaoben3" (butt3.text as string)	
		)
		on butt4 pressed do
		(
			if butt4.text == "Path…" then 
			(
				jiaoben4 = getOpenFileName caption:"" types:"All Files (*.*)|*.*|ms (*.ms)|*.ms|mse (*.mse)|*.mse|"
				if jiaoben4 != undefined then
				(
					butt4.text = getFilenameFile jiaoben4
					setINISetting  "SkinIniFile" "diaoyong" "jiaoben4" (jiaoben4 as string)
				)
				)
				else( fileIn ( getINISetting  "SkinIniFile" "diaoyong" "jiaoben4" as string) )
			)
		on butt_4 pressed do
		(	
			butt4.text = "Path…"
			setINISetting  "SkinIniFile" "diaoyong" "jiaoben4" (butt4.text as string)	
		)
	)
	
	
try(destroyDialog boneDivider)catch()
rollout boneDivider "Bone Divider" width:165 height:185
(	
	GroupBox grp_ops "Post Hierarchy Options:" pos:[5,5] width:155 height:80
	checkbox chk_hier "Create Hierarchy" pos:[10,20] width:105 height:15 checked:true enabled:true 
	checkbox chk_par "Parent to Original" pos:[10,35] width:105 height:15 checked:true
	checkbox chk_retB "Retain Children" pos:[10,65] width:105 height:15 checked:false
	checkbox chk_retA "Retain Parent" pos:[10,50] width:105 height:15 checked:false
	checkbox chk_rep "Replace Original Bone" pos:[10,100] width:145 height:15 checked:false
	GroupBox grp_set "Settings:" pos:[5,85] width:155 height:55
	label lbl_div "Divisions:" pos:[20,120] width:50 height:15
	spinner spn_div "" pos:[75,120] width:80 height:16 range:[2,999,3] type:#integer
	button btn_div "Divide" pos:[5,145] width:155 height:25
	
	hyperlink lbl_help "帮助" address:"https://www.cgjoy.com/forum.php?mod=viewthread&tid=209123" align:#center offset:[0,10]
	
	fn divideBone2 b num axis:1 =
	(
		d = b.transform[axis] 		
		pos1 = b.pos
		pos2 = d * b.length-- using the transform x axis as the direction
		
		lastPos = pos1
		newBones = #()
		for i in 1 to num do
		(
			nextPos = pos1 + (d  * ((b.length/num)*i))
			x = boneSys.createBone lastPos nextPos b.dir
			append newBones x
			lastPos = nextPos
		)
		newBones
	)
	
	
	on btn_div pressed do
	(
		sel = for i in selection where classOf i == BoneGeometry collect i
		
		segs = spn_div.value
		txt = "Divide Bones:" + segs as string
		undo txt on
		(
			for i in sel do
			(
				nb = divideBone2 i segs
				count = nb.count
				
				if chk_hier.enabled and chk_hier.checked do
				(
					for h in 1 to count do
					(
						if h != count do nb[h+1].parent = nb[h]
					)
				)
				
				if chk_retA.checked do
				(
					nb[1].parent = i.parent
				)
				
				if chk_retB.checked do
				(
					c = for h in i.children collect h
					for h in c do h.parent = nb[count]
				)
				
				if chk_rep.checked then
				(
					delete i
				)
				else if chk_par.enabled and chk_par.checked do
				(
					for b in nb do b.parent = i
				)
			)
		)
	)
	
	fn initUI =
	(
		chk_par.enabled = not chk_retA.checked and not chk_rep.checked
-- 		chk_hier.enabled = not chk_par.checked
	)
	
	on chk_par changed state do initUI()
	on chk_rep changed state do initUI()	
	on chk_retA changed state do initUI()
	
)	

	rollout Raplace "Raplace" 
	(
	
		
		label 'name1' "Find:" pos:[34,6] width:24 height:13 align:#left 
 

		label 'name2' "Replace:" pos:[24,27] width:42 height:13 align:#left 
 


		edittext 'nam1' "" pos:[69,6] width:70 height:17 align:#left 
 
		edittext 'nam2' "" pos:[69,27] width:70 height:17 align:#left 
 


		button 'start_rename' "Change Name" pos:[38,56] width:83 height:21 toolTip:"为选中的物体替换字符" align:#left
		


		on start_rename pressed do
		(
			if selection.count ==0 then
			(
				messagebox "至少需要选择一个对象" beep:false
			)
			else
			(
				xx1=nam1.text
				xx2=nam2.text
				
				for j in selection do
					(
						aa=j.name
						cc=0
						for i=1 to aa.count do
							if aa[i]==xx1[1] then
							(
								cc+=1
								yy=i+1
								for bb=2 to xx1.count do
								(
									if aa[yy]==xx1[bb] then
										cc+=1
									else
										cc=0
										yy+=1
								)
								
								if cc==xx1.count then
									(
										zz=1
										qq=aa.count-i-xx1.count
										rr=i+xx1.count
										ee=aa[rr]
										ss=aa[1]
										for zz=2 to i-1 do
											ss=ss+aa[zz]
										for ww=1 to qq do
											(											
												rr+=1
												ee=ee+aa[rr]
											)
										if i>1 then
											(
												if (aa.count-i)>=xx1.count then
													tt=ss+xx2+ee
												else tt=ss+xx2
												j.name=tt
											)
										if i==1 then
											(
												if aa.count==xx1.count then
													tt=xx2
												if aa.count>xx1.count then
													tt=xx2+ee
												j.name=tt
											)
									)
							)
					)
			)
		)
	)

		
	rollout About_Sign "About" width:162
	(
		label b "海贼"
		label c "409856476@qq.com"
		label e "2018.03"
	)
	

	AllRollout = newRolloutFloater "SkinTool_QL" 170 285	
	addRollout Layer AllRollout
	addRollout boneDivider AllRollout
	addRollout Bone_Name AllRollout
	addRollout Userdefined AllRollout
	addRollout Skin_Check AllRollout
	addRollout SkinHideManager AllRollout
	addRollout Change_Weight AllRollout
	addRollout Custom AllRollout
	addRollout Raplace AllRollout	
	addRollout About_Sign AllRollout
 
	Raplace.open = false
	About_Sign.open = false
	Skin_Check.open = false
	SkinHideManager.open = false
	boneDivider.open = false
	Change_Weight.open = false
	--custom