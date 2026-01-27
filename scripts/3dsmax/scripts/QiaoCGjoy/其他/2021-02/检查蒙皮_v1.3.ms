-------------------------------------------------------
-------------------AnimationTool-----------------------
------------------Time:2018-06-07----------------------
-------------------Author:乔磊-------------------------
------------------QQ:409856476-------------------------
---------------------- by Joe--------------------------
------------------QQ: 738746223------------------------
-------------------------------------------------------
--2019年4月13日
--添加只显示蒙皮骨骼

rollout Skin_Check "SkinCheck"
(
	--checkbox 'Hide' "" pos:[10,10] width:10  checked:true tooltip:"勾选时只显示模型与蒙皮骨骼"align:#left
	button Skin_Check "检查蒙皮" pos:[13,7] tooltip:"选择需要检查的蒙皮" align:#left
	button Batch_Remove "批量移除" pos:[89,7] tooltip:"请注意，此功能可批量移除所有蒙皮骨骼"align:#right
	edittext BoneNumber "蒙皮骨骼数:"
	
	listbox 'lbx1' "无权重骨骼：" tooltip:"双击或者右击选择删除"
	
	button 'skinHide' "简捷显示" tooltip:"只显示蒙皮骨骼" across:2 align:#left
	button Quick_Remove "全部移除" tooltip:"移除列表中所有无权重骨骼" align:#right
	
	button 'Batch_Remove_0.001' "0.001位" pos:[13,239]  width:60 height:21 toolTip:"去除0.001位权重" across:2 align:#left
	
	button 'Batch_Remove_0.01' "0.01位"   width:60 height:21 toolTip:"去除0.01位权重" align:#right
	
	
	local un_id =#() 					---无权重的骨骼ID
	local Un_BoneName =#() 			--无权重骨骼名字
	local objSkin  					---捡取的蒙皮信息
	local val_num =100   				---权重位数，默认0.001
	local skin_num = 0 				---蒙皮骨骼数
	local Bone_Name =#()
	local selmode_Name =""            -- 选择模型的命名
	progressBar QR_bar  color:blue		---进度条

	
	hyperlink lbl_help "帮助" address:"https://www.cgjoy.com/forum.php?mod=viewthread&tid=211812&page=1&extra=#pid9898326" align:#center offset:[0,10]
	
	-------------------------------------------------------------------------------------------------------------------------------------------

	fn UnSkinBoneId   =  ---查找无权重骨骼ID
	(
		local usedBone = #{}
		local numSkinVerts = skinOps.getNumberVertices objSkin
		for n=1 to numSkinVerts do
		(
			local numBoneWeights = skinOps.getVertexWeightCount objSkin n
			for b=1 to numBoneWeights do
			(
				local boneID = skinOps.getVertexWeightBoneID objSkin n b
				if boneID != undefined do usedBone[boneID] = true
			)
		)
		
		struct bone_weight  ---绑定骨骼ID和骨骼名
		(
			n_ame,
			index
		)

		
		un_id =#() -- 无权重骨骼ID
		for i =1 to skin_num do
		(
			if (usedBone[i] == false) do
			(
				tem_bone = bone_weight()
				tem_bone.n_ame = skinOps.GetBoneName objSkin i 1
				tem_bone.index = i
				append un_id tem_bone
			)
		)
	
	)
----------------------------------------------------------------------------------------------------------------------------

	fn ChangeBoneName  a_array = ---转换ID骨骼名
	(
		
		Un_BoneName =#()
	
		for i =1 to a_array.count do
		(
			local a_string = a_array[i].n_ame
			append Un_BoneName a_string
		)
		
	)
	
	
----------------------------------------------------------------------------------------------------------------------------
	
	
	fn rounding_off val  = --- 四舍五入
	(

		val = (val*val_num+0.5) as integer
			
		val = (val as float)/val_num
			

	)
	
----------------------------------------------------------------------------------------------------------------------------
	
	fn round_off val  = --- 取整
	(

		val = (val*val_num) as integer
			
		val = (val as float)/val_num
			

	)
			
	
	
----------------------------------------------------------------------------------------------------------------------------
	
	fn SkinBoneId  = ---优化权重位数
	(
		
		
		numSkinVerts = #{1..(skinOps.getNumberVertices objSkin)} --获取参与蒙皮的点
		
		local tem_id = #()
		local tem_val = #()
		
		for n=1 to numSkinVerts.count do
		(
			numBoneWeights = skinOps.getVertexWeightCount objSkin n    --每个点有几根骨骼影响
			
            for b=1 to numBoneWeights do
			(
				vertexWeight = skinOps.getVertexWeight objSkin n b --获取第n个点参与的第b个骨骼的ID
				
				tem_id[b]  = skinOps.getVertexWeightBoneID objSkin n b
				
				tem_val[b] = rounding_off vertexWeight 

			)
			
			tem = 1.0
			for b=numBoneWeights to 2 by -1 do
			(
				tem_val[b]=round_off tem_val[b]
				if tem_val[b] > tem do tem_val[b] = tem
				skinOps.SetVertexWeights objSkin n tem_id[b] tem_val[b]
				
				tem = tem - tem_val[b]
			)
			
			skinOps.SetVertexWeights objSkin n tem_id[1] tem

			QR_bar.value = 100-100.*n/numSkinVerts.count
		)
			QR_bar.value = 0
	)
	
	
	
----------------------------------------------------------------------------------------------------------------------------	
	
	fn ShowBone  =   ---显示
	(
		lbx1.items=Un_BoneName
		
		
	)
----------------------------------------------------------------------------------------------------------------------------
	
	fn Get_NumberBones = ---检查蒙皮骨骼数
	(
		max modify mode
		objSkin  = $.modifiers[#Skin]
		if objSkin == undefined then
		(
			skin_num = 0
			BoneNumber.text= "0"
			messageBox "当前模型没有 Skin 修改器"
			return false
		)
		selmode_Name = selection[1].name
		skinOps.RemoveZeroWeights objSkin
		skin_num = skinOps.GetNumberBones objSkin
		BoneNumber.text= skin_num as string
		--skin_num = 0
		true
	)
----------------------------------------------------------------------------------------------------------------------------	

	fn get_Skinbone_fn = --得到蒙皮骨骼
	(
		Bone_Name = #()
		if (Get_NumberBones ()) == true then
		(
			local TemName = undefined
			local TemNode = undefined
			for i =1 to skin_num do
			(
				TemName = skinOps.GetBoneName objSkin i 1
				TemNode = getNodeByName TemName
				if TemNode != undefined do append Bone_Name TemNode
			)
		)
	)
	
	
	
	
----------------------------------------------------------------------------------------------------------------------------	
	
	on Skin_Check pressed do
	(
		if selection.count == 1 then	
		(

			Get_NumberBones ()
			UnSkinBoneId ()

			ChangeBoneName un_id	

		)
		else
		(
			messageBox "选择单个模型 "
		
			Un_BoneName =#()
			
		)
		
		
		ShowBone()
		
		BoneNumber.text= skin_num as string
		skin_num = 0
	
	
	)
	
	on skinHide pressed do
	(	
		
		get_Skinbone_fn ()
		all_bone = for i in $* where classof i == BoneGeometry or classof i == Biped_Object collect i
		select all_bone
		max hide selection
		
		unhide Bone_Name
		hideByCategory.shapes = true
		hideByCategory.helpers = true
		--selectionSets["skin_bone"] = Bone_Name
		selectionSets[selmode_Name] = Bone_Name
		
		
	)
	
	
----------------------------------------------------------------------------------------------------------------------------	
	
	on Batch_Remove pressed do  ----批量删除
	(
		if selection.count == 1 then	
		(
			if (Get_NumberBones ()) == true then
			(
				skinOps.RemoveZeroWeights objSkin
				skinOps.multiRemove objSkin
			)

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
		
		UnSkinBoneId ()

		ChangeBoneName un_id
		
		ShowBone()
		
		BoneNumber.text= skin_num as string
		skin_num = 0

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
		
		UnSkinBoneId ()

		ChangeBoneName un_id
		
		ShowBone()
		
		BoneNumber.text= skin_num as string
		skin_num = 0
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
		
		Get_NumberBones () ---检查蒙皮骨骼数
				
		UnSkinBoneId () ---查找无权重骨骼ID

		ChangeBoneName un_id ---转换ID骨骼名
		
		ShowBone() ---显示
		
		
		BoneNumber.text= skin_num as string
		skin_num = 0
		
		QR_bar.value = 0
		
	)
	
----------------------------------------------------------------------------------------------------------------------------	

	on Batch_Remove_0.001 pressed do  ---去除0.001位
	(
		val_num =1000
		if selection.count == 1 then	
		(
			Get_NumberBones ()
			SkinBoneId ()

		)
		else
		(
			messageBox "选择单个模型 "
			
		)


	)
	
	on Batch_Remove_0.01 pressed do ---去除0.01位
	(
		val_num =100
		if selection.count == 1 then	
		(
			Get_NumberBones ()
			SkinBoneId () 

		)
		else
		(
			messageBox "选择单个模型 "
			
		)
 
	)


	
)

	rollout About_Sign "About" width:162
	(
		label b "海贼"
		label c "409856476@qq.com"
		label e "2018.06"
	)


	AllRollout = newRolloutFloater "蒙皮检查" 175 360	
	addRollout Skin_Check AllRollout	
	addRollout About_Sign AllRollout
 
	Skin_Check.open = true
	About_Sign.open = false

