-- ============================================
-- 动画破碎工具箱 v1.0
-- 基于阿拉丁动画工具，集成 Voronoi 破碎功能
-- 适用于 3ds Max 2020+
-- ============================================

-- ==================== 破碎工具模块 ====================
rollout FractureTools "破碎工具" width:200 height:300
(
	GroupBox grp1 "破碎设置" pos:[5,5] width:190 height:120
	
	button btnPickObj "选择要破碎的物体" pos:[10,25] width:180 height:25
	label lblObjName "未选择" pos:[10,52] width:180 height:15
	
	label lbl1 "碎片数量:" pos:[10,72] width:60 height:16
	spinner spnParts "" pos:[75,70] width:60 range:[2,200,15] type:#integer
	label lbl2 "噪波强度:" pos:[10,92] width:60 height:16
	spinner spnNoise "" pos:[75,90] width:60 range:[0,1,0.1] type:#float
	
	GroupBox grp2 "操作" pos:[5,130] width:190 height:165
	
	button btnFracture "执行破碎" pos:[10,150] width:180 height:30 enabled:false
	button btnAddPhysics "添加物理(MassFX)" pos:[10,185] width:180 height:25
	button btnBakePhysics "烘焙物理动画" pos:[10,215] width:180 height:25
	button btnCreateGround "创建地面" pos:[10,245] width:85 height:20
	button btnCreateImpact "创建撞击球" pos:[100,245] width:90 height:20
	button btnReset "重置破碎" pos:[10,268] width:180 height:22
	
	local theObject = undefined
	local fracturedParts = #()
	
	-- 在物体内生成随机点
	fn generateRandomPointsInMesh obj count =
	(
		local points = #()
		local bb = nodeGetBoundingBox obj obj.transform
		local minPt = bb[1]
		local maxPt = bb[2]
		
		local tempObj = copy obj
		convertToMesh tempObj
		
		local attempts = 0
		local maxAttempts = count * 50
		
		while points.count < count and attempts < maxAttempts do
		(
			attempts += 1
			local rx = random minPt.x maxPt.x
			local ry = random minPt.y maxPt.y
			local rz = random minPt.z maxPt.z
			local testPt = [rx, ry, rz]
			
			local rayDirs = #([1,0,0], [-1,0,0], [0,1,0], [0,-1,0], [0,0,1], [0,0,-1])
			local hitCount = 0
			
			for dir in rayDirs do
			(
				local r = ray testPt dir
				local hitResult = intersectRay tempObj r
				if hitResult != undefined do hitCount += 1
			)
			
			if hitCount >= 4 do append points testPt
		)
		
		delete tempObj
		
		while points.count < count do
		(
			local center = (minPt + maxPt) / 2
			local offset = (maxPt - minPt) * 0.3
			local ox = random (-offset.x) offset.x
			local oy = random (-offset.y) offset.y
			local oz = random (-offset.z) offset.z
			append points (center + [ox, oy, oz])
		)
		
		points
	)
	
	on btnPickObj pressed do
	(
		if selection.count == 1 and superClassOf selection[1] == GeometryClass then
		(
			theObject = selection[1]
			lblObjName.caption = theObject.name
			btnFracture.enabled = true
		)
		else
		(
			messageBox "请先在场景中选择一个几何体物体" title:"提示"
		)
	)
	
	on btnFracture pressed do
	(
		if theObject == undefined or isDeleted theObject do
		(
			messageBox "请先选择物体" title:"错误"
			return()
		)
		
		undo "Voronoi破碎" on
		(
			disableSceneRedraw()
			
			try
			(
				local nbParts = spnParts.value
				local thePlane = plane width:1 length:1 widthSegs:1 lengthSegs:1
				
				-- 创建副本
				local theMesh = copy theObject
				theMesh.name = "temp_fracture"
				resetXForm theMesh
				convertToMesh theMesh
				
				-- 生成碎片
				local aPartsTemp = for i = 1 to nbParts collect copy theMesh
				local aCoords = generateRandomPointsInMesh theMesh nbParts
				
				for i = 1 to nbParts - 1 do
				(
					for j = i + 1 to nbParts do
					(
						thePlane.pos = (aCoords[i] + aCoords[j]) / 2
						thePlane.dir = aCoords[j] - aCoords[i]
						
						local slice1 = SliceModifier slice_type:2
						local slice2 = SliceModifier slice_type:3
						
						addModifier aPartsTemp[i] slice1
						addModifier aPartsTemp[j] slice2
						aPartsTemp[i].modifiers[1].slice_plane.transform = thePlane.transform
						aPartsTemp[j].modifiers[1].slice_plane.transform = thePlane.transform
						
						addModifier aPartsTemp[i] (Cap_Holes())
						addModifier aPartsTemp[j] (Cap_Holes())
						convertToMesh aPartsTemp[i]
						convertToMesh aPartsTemp[j]
					)
				)
				
				delete thePlane
				delete theMesh
				hide theObject
				
				-- 命名和着色
				for i = 1 to aPartsTemp.count do
				(
					aPartsTemp[i].name = theObject.name + "_Part_" + (formattedPrint i format:"03d")
					aPartsTemp[i].wireColor = random black white
					centerPivot aPartsTemp[i]
				)
				
				fracturedParts = aPartsTemp
				
				enableSceneRedraw()
				messageBox ("成功创建 " + aPartsTemp.count as string + " 个碎片!") title:"完成"
			)
			catch
			(
				enableSceneRedraw()
				messageBox ("破碎失败: " + getCurrentException()) title:"错误"
			)
		)
	)
	
	on btnAddPhysics pressed do
	(
		if fracturedParts.count == 0 do
		(
			-- 尝试选择场景中的碎片
			select $*_Part_*
			fracturedParts = selection as array
		)
		
		if fracturedParts.count == 0 do
		(
			messageBox "没有找到碎片，请先执行破碎" title:"提示"
			return()
		)
		
		local successCount = 0
		local failedObjs = #()
		
		-- 先选中所有碎片
		select fracturedParts
		
		-- 方法1: 尝试使用宏命令 (最可靠的方式)
		try
		(
			macros.run "MassFX" "PxRbDynamicMod"
			successCount = fracturedParts.count
		)
		catch
		(
			-- 方法2: 逐个添加 MassFX 修改器
			for obj in fracturedParts do
			(
				try
				(
					-- 检查是否已有 MassFX 修改器
					local hasMassFX = false
					for m in obj.modifiers do
					(
						if classOf m == MassFX_RBody do hasMassFX = true
					)
					
					if not hasMassFX do
					(
						local rbMod = MassFX_RBody()
						addModifier obj rbMod
						
						-- 设置属性 (使用 try 防止属性名变化)
						try(rbMod.type = 1)catch()  -- Dynamic
						try(rbMod.meshType = 2)catch()  -- Convex
						try(rbMod.RBType = 1)catch()  -- 备用属性名
						try(rbMod.CollisionMeshType = 2)catch()  -- 备用属性名
					)
					successCount += 1
				)
				catch
				(
					append failedObjs obj.name
				)
			)
		)
		
		-- 重新选中所有碎片
		select fracturedParts
		
		-- 显示结果
		if successCount > 0 then
		(
			local msg = "已为 " + successCount as string + " 个碎片添加物理"
			if failedObjs.count > 0 do
				msg += "\n失败: " + failedObjs.count as string + " 个"
			msg += "\n\n下一步:\n1. 打开 MassFX 工具栏\n2. 点击 '开始模拟' 按钮\n3. 模拟完成后点击 '烘焙物理动画'"
			messageBox msg title:"完成"
		)
		else
		(
			-- 所有方法都失败，提示手动操作
			messageBox "自动添加失败，请手动操作:\n\n1. 保持碎片选中状态\n2. 菜单栏: 模拟 → MassFX → 将选定对象设置为动态刚体\n   或使用 MassFX 工具栏的动态刚体按钮" title:"提示"
		)
	)
	
	on btnBakePhysics pressed do
	(
		local baked = false
		
		-- 方法1: 使用宏命令
		try
		(
			macros.run "MassFX" "BakeAllMassFX"
			baked = true
		)
		catch()
		
		-- 方法2: 尝试 MassFX 全局函数
		if not baked do
		(
			try
			(
				MassFX.BakeAll()
				baked = true
			)
			catch()
		)
		
		-- 方法3: 尝试 PhysX 命令
		if not baked do
		(
			try
			(
				physx.bakeAll()
				baked = true
			)
			catch()
		)
		
		if baked then
			messageBox "物理动画已烘焙为关键帧" title:"完成"
		else
			messageBox "请手动烘焙:\n\n菜单: 模拟 → MassFX → 烘焙所有\n或 MassFX 工具栏 → 烘焙按钮" title:"提示"
	)
	
	on btnCreateGround pressed do
	(
		local ground = Plane length:500 width:500 pos:[0,0,0]
		ground.name = "Ground"
		ground.wireColor = color 100 100 100
		
		-- 添加静态刚体
		select ground
		try
		(
			macros.run "MassFX" "PxRbStaticMod"
			messageBox "地面已创建 (静态刚体)" title:"完成"
		)
		catch
		(
			try
			(
				local rbMod = MassFX_RBody()
				addModifier ground rbMod
				try(rbMod.type = 3)catch()  -- Static
				try(rbMod.RBType = 3)catch()
				messageBox "地面已创建 (静态刚体)" title:"完成"
			)
			catch
			(
				messageBox "地面已创建\n请手动设置为静态刚体:\n选中地面 → 模拟 → MassFX → 设置为静态刚体" title:"提示"
			)
		)
	)
	
	on btnCreateImpact pressed do
	(
		local ball = Sphere radius:20 pos:[0,-100,50]
		ball.name = "ImpactBall"
		ball.wireColor = color 255 0 0
		
		-- 添加运动学刚体
		select ball
		try
		(
			macros.run "MassFX" "PxRbKinematicMod"
			messageBox "撞击球已创建 (运动学刚体)\n\n请给撞击球添加位移动画:\n1. 移动到起始位置，按 K 键设置关键帧\n2. 移动时间滑块\n3. 移动球到撞击位置，按 K 键" title:"完成"
		)
		catch
		(
			try
			(
				local rbMod = MassFX_RBody()
				addModifier ball rbMod
				try(rbMod.type = 2)catch()  -- Kinematic
				try(rbMod.RBType = 2)catch()
				messageBox "撞击球已创建 (运动学刚体)\n\n请给撞击球添加位移动画" title:"完成"
			)
			catch
			(
				messageBox "撞击球已创建\n请手动设置为运动学刚体:\n选中球 → 模拟 → MassFX → 设置为运动学刚体\n\n然后给球添加位移动画" title:"提示"
			)
		)
	)
	
	on btnReset pressed do
	(
		-- 重置破碎：删除碎片，恢复原物体
		try
		(
			-- 删除所有碎片
			local parts = $*_Part_* as array
			if parts.count > 0 do
			(
				delete parts
				fracturedParts = #()
			)
			
			-- 显示原物体
			if theObject != undefined and not isDeleted theObject do
			(
				unhide theObject
				select theObject
				lblObjName.caption = theObject.name
				btnFracture.enabled = true
			)
			
			-- 删除地面和撞击球
			try(delete $Ground)catch()
			try(delete $ImpactBall)catch()
			
			messageBox "已重置，可以重新破碎" title:"完成"
		)
		catch
		(
			messageBox "重置失败" title:"错误"
		)
	)
)

-- ==================== 原有动画工具模块 ====================

rollout animationTools "动画绑定工具" width:200 height:300
(
	button btn1 "创建骨骼by物体" pos:[5,5] width:93 height:30
	button btn10 "批量绑定蒙皮" pos:[102,5] width:93 height:30 

	button btn2 "塌陷骨骼动画" pos:[5,40] width:93 height:30
	button btn3 "骨骼父子绑定" pos:[102,40] width:93 height:30	
	 
	button btn4 "清除网格关键帧" pos:[5,75] width:93 height:30
	button btn9 "bone骨骼打直" pos:[102,75] width:93 height:30
	
	button btn5 "<偏移关键帧" pos:[5,110] width:93 height:30
	button btn6 "偏移关键帧>" pos:[102,110] width:93 height:30
	button btn7 "<错位关键帧" pos:[5,145] width:93 height:30
	button btn8 "错位关键帧>" pos:[102,145] width:93 height:30	 

	label lbl1 "错(偏)帧数:" pos:[10,185] width:65 height:16
	spinner spn7 "" pos:[75,182] width:50 height:16 range:[0,1e+006,0] type:#integer	 
	checkbutton ckb2 "选择全部" pos:[130,180] width:65 height:20
	
	label lbl2 "根骨骼:" pos:[10,210] width:45 height:17
	edittext edt1 "" pos:[55,207] width:140 height:22
	
	on btn1 pressed do
	(
		select geometry
		deselect $Bone*
		try(
			objlist = $selection as array
			if objlist.count == 0 then 
			(
				messagebox "请选择一些要绑定骨骼的模型" beep:false
			)
			else
			(
				b0 = dummy pos:[0,0,0]
				b0.name="root"
				for obj in objlist do
				(
					in obj aaa = boneSys.createBone obj.pos obj.pos [0,0,1]
					aaa.parent = obj
				)
			)
			try(delete $Bone001.Parent)catch()
			try(delete $Bone001)catch()
			try(delete SpaceWarps)catch()
		)
		catch()
	)
	
	on btn2 pressed do
	(
		select $Bone*
		objlist = $selection as array
		if objlist.count == 0 then (
			messagebox "请选择一些要烘焙动画的骨骼" beep:false
		)
		else
		(
			local forceUpdate = keyboard.shiftPressed
			for bake_obj in objlist do (
				local p = undefined
				local old_prs_ctrl = copy bake_obj.transform.controller
				with undo on (
					if not forceUpdate then disableSceneRedraw()
					try (
						p = Point()
						for i = animationRange.start to animationRange.end do (
							if forceUpdate then sliderTime = i
							at time i (
								with animate on p.transform = bake_obj.transform
							)
						)
						bake_obj.transform.controller = transform_script()	
						bake_obj.transform.controller = prs()	
						if not (isGroupMember bake_obj) then bake_obj.parent = undefined
						for i = animationRange.start to animationRange.end do (
							at time i (
								with animate on bake_obj.transform = p.transform
							)
						)
						delete p
						p = undefined
						if not forceUpdate then enableSceneRedraw()
					)
					catch(
						if p!=undefined then delete p
						bake_obj.transform.controller = old_prs_ctrl
						if not forceUpdate then enableSceneRedraw()
					)
				)
			)
		)
	)
	
	on btn3 pressed do
	(	
		try(
			select $Bone*
			Bonelist = $selection as array
			if Bonelist.count == 0 then (
				messagebox "请选择需要绑定到根骨骼的骨骼" beep:false
			) 		
			else
			(
				for boneA in Bonelist do
				(
					in boneA $.parent = $root
				)
				print("绑定执行完毕")
			)
		)
		catch()
	)
	
	on btn4 pressed do
	(	
		try(
			select geometry
			deselect $Bone*
			for i in $ do (
				deletekeys $ #allKeys
				$.parent = $root
			)
		)
		catch()
	)
	
	on btn5 pressed do
	(	
		try(
			if (ckb2.state==true) then actionMan.executeAction 0 "40021"
			for i in $ do movekeys i (-1*spn7.value)
		)
		catch()
	)
	
	on btn6 pressed do
	(	
		try(
			if (ckb2.state==true) then actionMan.executeAction 0 "40021"
			for i in $ do movekeys i (spn7.value)
		)
		catch()
	)
	
	on btn7 pressed do
	(	
		try( 
			if ($.count<=1) then (messagebox "请选择大于1个物体" beep:false)
			else
			(			
				x=0
				for i in $ do movekeys i (X+= -1*spn7.value)
			)
		)
		catch()
	)
	
	on btn8 pressed do
	(	
		try(
			if ($.count<=1) then (messagebox "请选择大于1个物体" beep:false)	
			else
			(				
				x=0
				for i in $ do movekeys i (X+=spn7.value)
			)
		)
		catch()
	)
	
	on btn9 pressed do
	(	
		try(
			max set key keys
			objlist = $ as array
			for obj in objlist do
			(
				obj.rotation.controller.X_Rotation.controller.keys[1].value = 0
				obj.rotation.controller.Y_Rotation.controller.keys[1].value = 0
				obj.rotation.controller.Z_Rotation.controller.keys[1].value = 0
			)
		)
		catch()
	)
	
	on btn10 pressed do
	(	
		try(
			select geometry
			deselect $Bone*
			macros.run "Modifier Stack" "Convert_to_Poly"
			
			objlist = $selection as array
			if objlist.count == 0 then 
			(
				messagebox "请选择一些要绑定蒙皮的模型" beep:false
			)
			else
			(
				objlistA = $ as array
				for obj in objlistA do(
					modPanel.setCurrentObject obj
					modPanel.addModToSelection (Skin ())
					objlistB = $.children
					skinOps.addBone $.modifiers[#Skin] objlistB[1] 1
				)
			)
		)
		catch()
	)
)

rollout BatchSetBoneSize "批量设置骨骼尺寸" width:184 height:100
(
	label lbl1 "骨骼宽度:" pos:[10,15] width:60 height:16
	spinner BoneWidth "" pos:[70,12] width:80 height:16
	label lbl2 "骨骼长度:" pos:[10,40] width:60 height:16
	spinner BoneLength "" pos:[70,37] width:80 height:16 
	button ModifySize "修改尺寸" pos:[48,65] width:91 height:27
	
	on ModifySize pressed do
	(	
		try(
			select $Bone*
			objlist = $selection as array
			for obj in objlist do
			(
				$Bone*.width = BoneWidth.value
				$Bone*.height = BoneLength.value
			)
		)
		catch()	
	)
)

rollout SamplifyKeys "简化关键帧" width:200 height:95
(
	GroupBox grp1 "Animation Range" pos:[4,-2] width:192 height:90
	label lbl1 "开始帧:" pos:[10,18] width:45 height:16
	spinner spnStart "" pos:[55,15] width:50 height:16 range:[-100000,100000,0] type:#integer
	label lbl2 "结束帧:" pos:[110,18] width:45 height:16
	spinner spnEnd "" pos:[150,15] width:45 height:16 range:[-100000,100000,80] type:#integer
	label lbl3 "跳帧:" pos:[10,42] width:35 height:16
	spinner SpnDeleteStep "" pos:[45,39] width:40 height:16 range:[1,50,5] type:#integer 
	button BtnDeleteFrames "删除关键帧" pos:[100,37] width:90 height:25

	on BtnDeleteFrames pressed do
	(
		try(
			StartFrame = SpnStart.value +1
			do
			(
				currentEndFrame = StartFrame + SpnDeleteStep.value - 2
				for currentFrame = StartFrame to currentEndFrame do
				(
					for obj in $ do
					(
						i = getKeyIndex obj.controller currentFrame
						if i > 0 then deleteKey obj.controller i
					)
				)
			)
			while ( StartFrame = currentEndFrame + 2 )<= SpnEnd.value
		)
		catch()
	)
)

-- ==================== 一键烘焙蒙皮模块 (基于CGJOY) ====================
rollout BakeToSkinTools "一键烘焙蒙皮" width:200 height:180
(
	GroupBox grp1 "动画范围" pos:[5,5] width:190 height:55
	label lbl1 "起始帧:" pos:[10,28] width:45 height:16
	spinner spnStart "" pos:[55,25] width:45 height:16 range:[0,100000,0] type:#integer
	label lbl2 "结束帧:" pos:[105,28] width:45 height:16
	spinner spnEnd "" pos:[150,25] width:45 height:16 range:[0,100000,100] type:#integer
	
	GroupBox grp2 "操作" pos:[5,65] width:190 height:105
	button btnBakeToSkin "一键烘焙到蒙皮网格" pos:[10,85] width:180 height:30
	progressBar pbProgress "" pos:[10,120] width:180 height:12 value:0 color:[0,150,0]
	label lblStatus "" pos:[10,135] width:180 height:15
	button btnSelectParts "选择所有碎片" pos:[10,152] width:85 height:20
	button btnCleanup "清理临时物体" pos:[100,152] width:90 height:20
	
	local breakObjArr = #()
	
	-- 合并网格并绑定蒙皮
	fn BoneToSkin meshArr meshNameArr vertexNumArr =
	(
		local vertexIndexToNodeArr = #()
		
		-- 合并网格
		for index = 2 to meshArr.count do
		(
			if isValidNode meshArr[index] do
				meshop.attach meshArr[1] meshArr[index]
		)
		
		-- 轴点归零
		toolMode.coordsys #world
		meshArr[1].pivot = [0,0,0]
		meshArr[1].name = "CombinedMesh_Skinned"
		
		-- 添加蒙皮修改器
		select meshArr[1]
		modPanel.addModToSelection (Skin ()) ui:on
		
		-- 添加骨骼到蒙皮
		for index = 1 to meshNameArr.count do
		(
			local boneName = meshNameArr[index] + "_Bone"
			local boneNode = getNodeByName boneName
			if boneNode != undefined do
				skinOps.addBone meshArr[1].modifiers[#Skin] boneNode 1
		)
		
		-- 计算每个顶点对应的骨骼索引
		for meshIdx = 1 to meshNameArr.count do
		(
			for vIdx = 1 to vertexNumArr[meshIdx] do
			(
				append vertexIndexToNodeArr meshIdx
			)
		)
		
		-- 分配权重
		local allVertNum = meshop.getNumVerts meshArr[1]
		for index = 1 to allVertNum do
		(
			if index <= vertexIndexToNodeArr.count do
			(
				skinOps.SetVertexWeights meshArr[1].modifiers[#skin] index vertexIndexToNodeArr[index] 1
			)
			-- 更新进度
			lblStatus.caption = "权重: " + index as string + " / " + allVertNum as string
			pbProgress.value = (index as float / allVertNum * 100)
		)
		
		return meshArr[1]
	)
	
	on btnBakeToSkin pressed do
	(
		if selection.count == 0 do
		(
			messageBox "请先选择要烘焙的破碎碎片" title:"提示"
			return()
		)
		
		breakObjArr = selection as array
		local animStart = spnStart.value
		local animEnd = spnEnd.value
		
		undo "一键烘焙蒙皮" on
		(
			try
			(
				lblStatus.caption = "创建骨骼..."
				pbProgress.value = 0
				
				-- 创建根骨骼
				if $Root == undefined do
					Dummy pos:[0,0,0] name:"Root"
				
				local meshNameArr = #()
				local vertexNumArr = #()
				
				-- 为每个碎片创建控制骨骼
				for obj in breakObjArr do
				(
					local ctrlName = obj.name + "_Bone"
					local ctrl = Dummy pos:obj.pos name:ctrlName
					ctrl.parent = $Root
					ctrl.scale = [0.5, 0.5, 0.5]
					
					append meshNameArr obj.name
					convertToMesh obj
					append vertexNumArr (meshop.getNumVerts obj)
				)
				
				lblStatus.caption = "烘焙动画..."
				
				-- 烘焙动画到骨骼
				local totalFrames = animEnd - animStart + 1
				local frameCount = 0
				
				for frame = animStart to animEnd do
				(
					for obj in breakObjArr do
					(
						local ctrlName = obj.name + "_Bone"
						local ctrl = getNodeByName ctrlName
						if ctrl != undefined do
						(
							animate on
							(
								at time frame
								(
									ctrl.pos = obj.pos
									ctrl.rotation = obj.rotation
								)
							)
						)
					)
					frameCount += 1
					pbProgress.value = (frameCount as float / totalFrames * 50)
					lblStatus.caption = "烘焙帧: " + frame as string
				)
				
				lblStatus.caption = "合并网格..."
				
				-- 转换为网格并合并
				local meshArr = for obj in breakObjArr collect obj
				
				-- 执行蒙皮绑定
				local result = BoneToSkin meshArr meshNameArr vertexNumArr
				
				pbProgress.value = 100
				lblStatus.caption = "完成!"
				
				select result
				messageBox ("烘焙完成!\n生成: " + result.name + "\n骨骼数: " + meshNameArr.count as string) title:"成功"
			)
			catch
			(
				lblStatus.caption = "错误!"
				messageBox ("烘焙失败: " + getCurrentException()) title:"错误"
			)
		)
	)
	
	on btnSelectParts pressed do
	(
		select $*_Part_*
		if selection.count == 0 then
			messageBox "没有找到碎片 (*_Part_*)" title:"提示"
		else
			messageBox ("已选择 " + selection.count as string + " 个碎片") title:"完成"
	)
	
	on btnCleanup pressed do
	(
		try
		(
			delete $*_Bone
			delete $Root
			messageBox "临时骨骼已清理" title:"完成"
		)
		catch
		(
			messageBox "没有找到需要清理的物体" title:"提示"
		)
	)
)

-- ==================== 导出工具模块 ====================
rollout ExportTools "导出工具" width:200 height:80
(
	button btnExportFBX "导出选中为FBX" pos:[10,10] width:180 height:30
	button btnExportAll "导出全部碎片FBX" pos:[10,45] width:180 height:30
	
	on btnExportFBX pressed do
	(
		if selection.count == 0 do
		(
			messageBox "请先选择要导出的物体" title:"提示"
			return()
		)
		
		local savePath = getSaveFileName caption:"保存FBX" types:"FBX(*.fbx)|*.fbx"
		if savePath != undefined do
		(
			exportFile savePath #noPrompt selectedOnly:true using:FBXEXP
			messageBox "导出完成!" title:"成功"
		)
	)
	
	on btnExportAll pressed do
	(
		select $*_Part_*
		if selection.count == 0 do
		(
			messageBox "没有找到碎片物体" title:"提示"
			return()
		)
		
		local savePath = getSaveFileName caption:"保存FBX" types:"FBX(*.fbx)|*.fbx"
		if savePath != undefined do
		(
			exportFile savePath #noPrompt selectedOnly:true using:FBXEXP
			messageBox ("导出 " + selection.count as string + " 个碎片完成!") title:"成功"
		)
	)
)

-------------------------------------------------------------	
globalrollout = newrolloutfloater "动画破碎工具箱 v1.0" 210 1050
addRollout FractureTools globalrollout
addRollout BakeToSkinTools globalrollout
addRollout animationTools globalrollout
addRollout BatchSetBoneSize globalrollout
addRollout SamplifyKeys globalrollout 
addRollout ExportTools globalrollout
-------------------------------------------------------------------------
