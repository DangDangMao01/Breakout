rollout Jihe "layer" width:170 height:187
(
	button 'Pink_moduan' "选择末端" pos:[15,16] width:60 height:25 toolTip:"选择bone骨骼末端" align:#left
	button 'Duan_link' "一键断link" pos:[92,54] width:60 height:25 toolTip:"一键断link,并设置蒙皮姿势" align:#left
	button 'Cl_modle' "清骨骼材质" pos:[92,18] width:60 height:25 toolTip:"一键清理骨骼材质" align:#left
	checkbutton 'Frz_modle' "冻结模型" pos:[15,53] width:60 height:25 toolTip:"冻结场景内所有模型" align:#left
	button 'CS_layer' "CS层集" pos:[15,87] width:60 height:25 toolTip:"创建cs层集" align:#left
	button 'Bone_Layer' "Bone层集" pos:[92,87] width:60 height:25 toolTip:"创建Bone层集" align:#left

	on Pink_moduan pressed do
	(  
	fn findEnds arr = ---选择末端
	(
		ends = for x in arr where (x.children.count == 0) collect x-----判断是否为末端
		return ends
	)
		undo on
		(
			clearSelection()-----清除当前场景选择节点
			(
				for a in objects where (classof a == BoneGeometry) do-----是bone骨骼的话收集
				selectMore a	
			)
		)
	     ends = findEnds selection			
		 select ends
	)
	on Duan_link pressed do
	(
		sas = selection as array-----所有选择的作为一个数组
		for i in sas do 
	 (
		 i.Transform.controller = prs ()-----断开链接约束
		 i.AssumeSkinPose ()-----采用蒙皮姿势
	 )
	)
	on Cl_modle pressed do
	(
		for i in $* where (classof i == BoneGeometry or classof i == Biped_Object) do
	    i.material = undefined
	)-----清理骨骼材质
	on Frz_modle changed state do
	(
	   if state then
	   (
		   Mod_Freeze=for i in objects where(classof i == Editable_Poly or classof i == Editable_mesh )collect i
		   Mod_Freeze.showFrozenInGray = off-----不使用灰度显示冻结模型
		   freeze Mod_Freeze
		   )
		else
		   (
			Mod_Freeze=for i in objects where(classof i == Editable_Poly or classof i == Editable_mesh )collect i
			unfreeze Mod_Freeze
			)
	 )-----冻结模型
	on CS_layer pressed do
	(
		(
		Cs_jihe=for i in objects where (classof i == Biped_Object) collect i-----收集biped骨骼
		layer = Layermanager.newLayerFromName "Biped"-----创建biped层集
	    layer = Layermanager.getLayerfromName "Biped"-----获取biped层集
		for K in Cs_jihe do
		(
			layer.addNode K
		)
		selectionSets["Biped"] = Cs_jihe -----创建biped集合
		)
		(
			select $*Nub*
			b = #()
			for i in selection do
			(   
				append b i
			)
			layer = layermanager.newLayerFromName "biped_Nub"-----创建biped_Nub层集
			layer = LayerManager.getLayerFromName "biped_Nub"-----获取biped_Nub层集
			for y in b do 
			(
				layer.addNode y
			)	
			selectionSets["biped_Nub"] = b -----创建biped_Nub集合
			
		)
	 )
	on Bone_Layer pressed do
	(
		Bone_jihe=for i in objects where (classof i ==  BoneGeometry) collect i-----收集bone骨骼
		layer = Layermanager.newLayerFromName "Bone"------创建bone层集
	    layer = Layermanager.getLayerfromName "Bone"------获取bone层集
		for T in Bone_jihe do
		(
			layer.addNode T
		)
		selectionSets["Bone"] = Bone_jihe-----创建bone集合
	)
)
Createdialog Jihe