rollout layer "Layer"
(
	button 'Cle_layer' "清空层集" width:60 height:21 toolTip:"一键清除空集以及所有层" align:#left across:2
	checkbutton 'Fz_Mdl' "冻结模型" width:60 height:21
	button 'check_name' "检查重名" width:60 height:21 offset:[-5,0]
	
	label 'lab_01' "有0根重名骨骼"
	
	local TemlayerName = #()
	local Tem_Export = #()
-------------------------------------------------------------------------------------------------------------------------------------------------

	on Fz_Mdl changed state do

	(
		if state then
		(
	
		Mod_Arr = for i in objects where ( classof i == Editable_Poly or classof i == Editable_Mesh or classof i == PloyMeshObject ) collect i ---------------------判断模型种类
		Mod_Arr.showFrozenInGray = off  ---------------冻结灰度显示取消
		freeze Mod_Arr         -------------模型冻结
		)
		else
		(
			
		Mod_Arr = for i in objects where ( classof i == Editable_Poly or classof i == Editable_mesh or classof i == PloyMeshObject ) collect i
		unfreeze Mod_Arr  -------------模型解冻
		)
	)
	

-------------------------------------------------------------------------------------------------------------------------------------------------	
	on Cle_layer pressed do 
	
	(
		for i = 1 to LayerManager.count-1 do ------获取层集数量
		(
		ilayer = layerManager.getLayer i     -------获取层集名称
		layerName = ilayer.name
		append TemlayerName layerName --------将空层集放入一个集合中
		)
		for j = 1 to TemlayerName.count do  
		(
			LayerManager.deleteLayerByName TemlayerName[j] -----按照名称去删除层集
		)
		---------selectionSets.count
		for n = selectionSets.count to 1 by -1 do
		(
			deleteItem selectionSets selectionSets[n] -----删除所有集合
		)
	)
-------------------------------------------------------------------------------------------------------------------------------------------------
	on check_name pressed do ---------点击检查重命名骨骼
	(
		local SameNameNode =# ()       -----------------创建空集
		lab_01.text = "有" + ( SameNameNode.count as string ) + "根骨骼重名"    
		AllNodes = for i in objects where (( classof i == Biped_Object ) or ( classof i == BoneGeometry )) collect i --------------将所有骨骼和bone骨骼加入集中
		SameNameNode = #()
		for i = 1 to AllNodes.count do    --------循环
		(
			---for y = 1 to SameNameNode.count do     ------------y循环选择集中的骨骼进行
			(
				---if SameNameNode[y].name == AllNodes[i].name do  ------------比对y所选骨骼和I所选骨骼命名是否相同，如果相同
				(
					---append SameNameNode AllNodes[i]                -----------将I放入集合
				)
			------------------------Y的作用是做2次选择。因为如果出现相同骨骼，其骨骼数量必定大于1，所以通过Y近行比对将外部集内的重复骨骼加入相同命名的骨骼集中------------
			)
			for x = i + 1 to AllNodes.count do   ---------x以i+1排序开始循环所选骨骼
			(
				if AllNodes[i].name == AllNodes[x].name do  -----------比对X所选骨骼和I所选骨骼命名是否相同，如果相同
				(
					append SameNameNode AllNodes[i]    -----------将I放入集合
					append SameNameNode AllNodes[x]
					
				)
			-------------------------------X的作用是将第一次检查出的重命名的骨骼放入，？？？为什么不能再这里将X加入合集中?????
			)
		)
		clearselection()
		if SameNameNode.count != 0 do
		(
			select SameNameNode
			lab_01.text = "有" + (SameNameNode.count as string ) + "根骨骼重名"
		-------------发现问题 当有相同重名骨骼且同命名骨骼数量大于2时 数据记录有误，samenamenode.count有重复记录情况发生
		)
	
	)
	
	
	
	
)
Createdialog layer