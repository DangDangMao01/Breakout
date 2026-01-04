try(destroyDialog Main_rollout)catch()
rollout Main_rollout "CreateAnimation" width:305 height:158
(
	GroupBox 'grp_BakeAnimaton' "BakeAnimation" pos:[12,7] width:278 height:139 align:#left
	edittext 'edt_Star' "Star" pos:[33,37] width:115 height:24 enabled:true align:#left 
	edittext 'edt_End' "End" pos:[158,37] width:115 height:24 align:#left
	button 'btn_BakeAnimation' "Bake" pos:[55,73] width:182 height:27 align:#left
	progressBar 'PROGRESS' "ProgressBar" pos:[35,122] width:226 height:11 align:#left
	label 'progressText' "0/0" pos:[36,104] width:64 height:11 align:#left
	
	global breakObj = #()

	fn BoneToSkin =
	(
		vertexNumArr = #()
		meshNameArr = #()
		vertexIndexToNodeArr = #()
		macros.run "Modifier Stack" "Convert_to_Mesh"
		meshArr = selection as Array
		--存顶点数
		for obj in meshArr do 
		(
			append vertexNumArr (meshop.getNumVerts obj)
			append meshNameArr obj.name
		)
		--合并网格体
		for index = 2 to meshArr.count do
		(
			attach MeshArr[1] meshArr[index]
		)
		--轴点归零
		toolMode.coordsys #world
		$.pivot = [0,0,0]
		
		--添加蒙皮骨骼
		select meshArr[1]
		modPanel.addModToSelection (Skin ()) ui:on
		for index = 1 to meshArr.count do
		(
			boneName = meshNameArr[index] + "_Bone"
			boneNode = getNodeByName boneName
			skinOps.addBone $.modifiers[#Skin] boneNode 1
		)
		--获得每个点对应的模型Index
		for meshName = 1 to meshNameArr.count do
		(
			for index = 1 to vertexNumArr[meshName] do
			(
				append vertexIndexToNodeArr meshName
			)
		)
		--分配权重
		allVerNum = meshop.getNumVerts $
		for index = 1 to allVerNum do
		(
			skinOps.SetVertexWeights $.modifiers[#skin] index vertexIndexToNodeArr[index] 1
			--UI提示信息
			progressText.text = (index as string) +" / "+ (allVerNum as string)
			progress.value = index/allVerNum *100
		)
		
	)

	on btn_BakeAnimation pressed do
	(
		--创建骨骼
		if(Selection.count == 0 )then
		(
			MessageBox "请先选择破碎物体"
		)
		else
		(
			if $Root == undefined
			do
			(
				Dummy pos:[0,0,0] name:"Root"
			)
			
			global breakObj = Selection as array
			
			for obj in breakObj do 
			(
				--创建控制器
				controlleName = obj.name + "_Bone"
				Dummy pos:obj.pos name:controlleName
				controlleObj = getNodeByName controlleName
				controlleObj.parent = $Root
				scale controlleObj [3,3,3]
			)
		)
		
		--转换到本地空间赋值
		toolMode.coordsys #local
		animStar = edt_Star.text as Integer
		animEnd = edt_End.text as Integer
		for frame = animStar  to animEnd do 
		(
			for obj in breakObj do 
			(
				controlleName = obj.name + "_Bone"
				controlleObj = getNodeByName controlleName
				--objPos = at time frame obj.pos
				--objRotation = at time frame obj.Rotation
				animate On 
				(
					at time frame(controlleObj.pos= obj.pos;controlleObj.Rotation = obj.Rotation)
				)
			)
		)
		--转换到父空间赋值
		toolMode.coordsys #parent
		for frame = animStar  to animEnd do 
		(
			for obj in breakObj do 
			(
				controlleName = obj.name + "_Bone"
				controlleObj = getNodeByName controlleName
				--objPos = at time frame obj.pos
				--objRotation = at time frame obj.Rotation
				animate On 
				(
					at time frame(controlleObj.pos= obj.pos;controlleObj.Rotation = obj.Rotation)
				)
			)
		)
		--将控制器添加至蒙皮修改器
		BoneToSkin()
	)
)
createDialog Main_rollout