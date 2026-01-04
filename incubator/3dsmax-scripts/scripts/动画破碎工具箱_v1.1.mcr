-- ============================================
-- 动画破碎工具箱 v1.1
-- 基于阿拉丁动画工具，集成 Voronoi 破碎功能
-- 适用于 3ds Max 2020+
-- 
-- v1.1 更新:
-- - 修复噪波强度参数
-- - 添加破碎进度条
-- - 修复骨骼尺寸设置bug
-- - 修复烘焙蒙皮会破坏原碎片的问题
-- - 统一根骨骼命名
-- - 添加材质继承
-- - 添加最小碎片过滤
-- - 优化FBX导出设置
-- ============================================

-- ==================== 破碎工具模块 ====================
rollout FractureTools "破碎工具" width:200 height:390
(
	GroupBox grp1 "破碎设置" pos:[5,5] width:190 height:145
	
	button btnPickObj "选择要破碎的物体" pos:[10,25] width:180 height:25
	label lblObjName "未选择" pos:[10,52] width:180 height:15
	
	label lbl1 "碎片数量:" pos:[10,72] width:60 height:16
	spinner spnParts "" pos:[75,70] width:60 range:[2,200,15] type:#integer
	label lbl2 "噪波强度:" pos:[10,92] width:60 height:16
	spinner spnNoise "" pos:[75,90] width:60 range:[0,50,5] type:#float
	label lbl3 "最小碎片:" pos:[10,112] width:60 height:16
	spinner spnMinSize "" pos:[75,110] width:60 range:[0,100,1] type:#float
	checkbox chkMaterial "继承材质" pos:[10,130] checked:true
	checkbox chkPreview "仅预览点位" pos:[100,130] checked:false
	
	GroupBox grp2 "操作" pos:[5,155] width:190 height:230
	
	progressBar pbFracture "" pos:[10,173] width:180 height:10 value:0 color:[0,120,200]
	label lblProgress "" pos:[10,185] width:180 height:15
	
	button btnFracture "执行破碎" pos:[10,202] width:180 height:28 enabled:false
	button btnAddPhysics "添加物理(MassFX)" pos:[10,233] width:180 height:24
	
	-- 模拟预览控制
	button btnStartSim "▶ 开始模拟" pos:[10,260] width:88 height:24
	button btnStopSim "■ 停止模拟" pos:[102,260] width:88 height:24
	button btnResetSim "↺ 重置模拟" pos:[10,287] width:88 height:22
	button btnBakePhysics "烘焙动画" pos:[102,287] width:88 height:22
	
	button btnCreateGround "创建地面" pos:[10,312] width:85 height:20
	button btnCreateImpact "创建撞击球" pos:[100,312] width:90 height:20
	button btnReset "重置破碎" pos:[10,337] width:180 height:22
	label lblSimTip "提示: 先添加物理 → 开始模拟 → 满意后烘焙" pos:[10,362] width:180 height:15 style_sunkenedge:false
	
	local theObject = undefined
	local fracturedParts = #()
	local previewPoints = #()
	
	-- 更新进度
	fn updateProgress val msg =
	(
		pbFracture.value = val
		lblProgress.caption = msg
		windows.processPostedMessages()
	)
	
	-- 在物体内生成随机点（带噪波）
	fn generateRandomPointsInMesh obj count noiseAmt =
	(
		local points = #()
		local bb = nodeGetBoundingBox obj obj.transform
		local minPt = bb[1]
		local maxPt = bb[2]
		local center = (minPt + maxPt) / 2
		local size = maxPt - minPt
		
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
			
			-- 应用噪波偏移
			if noiseAmt > 0 do
			(
				local noiseScale = (size.x + size.y + size.z) / 3 * (noiseAmt / 100.0)
				testPt.x += (random -noiseScale noiseScale)
				testPt.y += (random -noiseScale noiseScale)
				testPt.z += (random -noiseScale noiseScale)
			)
			
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
			local offset = size * 0.3
			local ox = random (-offset.x) offset.x
			local oy = random (-offset.y) offset.y
			local oz = random (-offset.z) offset.z
			append points (center + [ox, oy, oz])
		)
		
		points
	)
	
	-- 清除预览点
	fn clearPreviewPoints =
	(
		for p in previewPoints do
		(
			try(delete p)catch()
		)
		previewPoints = #()
	)
	
	on btnPickObj pressed do
	(
		if selection.count == 1 and superClassOf selection[1] == GeometryClass then
		(
			theObject = selection[1]
			lblObjName.caption = theObject.name
			btnFracture.enabled = true
			clearPreviewPoints()
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
		
		clearPreviewPoints()
		
		-- 仅预览模式
		if chkPreview.checked do
		(
			local aCoords = generateRandomPointsInMesh theObject spnParts.value spnNoise.value
			for pt in aCoords do
			(
				local p = Point pos:pt size:5 wireColor:red
				p.name = "PreviewPoint"
				append previewPoints p
			)
			messageBox ("已创建 " + aCoords.count as string + " 个预览点\n取消勾选'仅预览点位'后再次点击执行实际破碎") title:"预览"
			return()
		)
		
		undo "Voronoi破碎" on
		(
			disableSceneRedraw()
			
			try
			(
				local nbParts = spnParts.value
				local noiseAmt = spnNoise.value
				local minSize = spnMinSize.value
				local inheritMat = chkMaterial.checked
				local origMat = theObject.material
				
				updateProgress 5 "准备中..."
				
				local thePlane = plane width:1 length:1 widthSegs:1 lengthSegs:1
				
				-- 创建副本
				local theMesh = copy theObject
				theMesh.name = "temp_fracture"
				resetXForm theMesh
				convertToMesh theMesh
				
				updateProgress 10 "生成切割点..."
				
				-- 生成碎片
				local aPartsTemp = for i = 1 to nbParts collect copy theMesh
				local aCoords = generateRandomPointsInMesh theMesh nbParts noiseAmt
				
				updateProgress 20 "执行切割..."
				
				local totalOps = (nbParts - 1) * nbParts / 2
				local currentOp = 0
				
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
						
						currentOp += 1
						local pct = 20 + (currentOp as float / totalOps * 60)
						if mod currentOp 10 == 0 do
							updateProgress pct ("切割: " + currentOp as string + "/" + totalOps as string)
					)
				)
				
				delete thePlane
				delete theMesh
				
				updateProgress 85 "过滤碎片..."
				
				-- 过滤太小的碎片
				local validParts = #()
				local bb = nodeGetBoundingBox theObject theObject.transform
				local objSize = length (bb[2] - bb[1])
				local minThreshold = objSize * (minSize / 100.0)
				
				for part in aPartsTemp do
				(
					local partBB = nodeGetBoundingBox part part.transform
					local partSize = length (partBB[2] - partBB[1])
					if partSize >= minThreshold then
						append validParts part
					else
						delete part
				)
				
				updateProgress 90 "处理碎片坐标..."
				
				hide theObject
				
				-- 命名、着色、局部坐标归零（但保持视觉位置不变）
				for i = 1 to validParts.count do
				(
					local part = validParts[i]
					part.name = theObject.name + "_Part_" + (formattedPrint i format:"03d")
					part.wireColor = random black white
					
					-- 先转为可编辑网格
					convertToMesh part
					
					-- 轴心居中到碎片几何中心
					centerPivot part
					
					-- 记录轴心的世界位置（这就是碎片应该在的位置）
					local worldPivot = copy part.pivot
					
					-- 将顶点坐标转换为相对于轴心的局部坐标
					local numVerts = meshop.getNumVerts part
					for v = 1 to numVerts do
					(
						local vertPos = meshop.getVert part v
						-- 顶点新位置 = 原位置 - 轴心位置（变成以轴心为原点的局部坐标）
						meshop.setVert part v (vertPos - worldPivot)
					)
					update part
					
					-- 轴心归零
					part.pivot = [0,0,0]
					
					-- 物体位置设为原轴心位置（这样视觉上碎片还在原地）
					part.pos = worldPivot
					
					-- 继承材质
					if inheritMat and origMat != undefined do
						part.material = origMat
				)
				
				fracturedParts = validParts
				
				updateProgress 100 "完成!"
				enableSceneRedraw()
				
				local msg = "成功创建 " + validParts.count as string + " 个碎片!"
				if validParts.count < nbParts do
					msg += "\n(过滤了 " + (nbParts - validParts.count) as string + " 个过小碎片)"
				messageBox msg title:"完成"
			)
			catch
			(
				enableSceneRedraw()
				updateProgress 0 "错误"
				messageBox ("破碎失败: " + getCurrentException()) title:"错误"
			)
		)
	)
	
	on btnAddPhysics pressed do
	(
		if fracturedParts.count == 0 do
		(
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
		
		select fracturedParts
		
		try
		(
			macros.run "MassFX" "PxRbDynamicMod"
			successCount = fracturedParts.count
		)
		catch
		(
			for obj in fracturedParts do
			(
				try
				(
					local hasMassFX = false
					for m in obj.modifiers do
						if classOf m == MassFX_RBody do hasMassFX = true
					
					if not hasMassFX do
					(
						local rbMod = MassFX_RBody()
						addModifier obj rbMod
						try(rbMod.type = 1)catch()
						try(rbMod.meshType = 2)catch()
						try(rbMod.RBType = 1)catch()
						try(rbMod.CollisionMeshType = 2)catch()
					)
					successCount += 1
				)
				catch(append failedObjs obj.name)
			)
		)
		
		select fracturedParts
		
		if successCount > 0 then
		(
			local msg = "已为 " + successCount as string + " 个碎片添加物理"
			if failedObjs.count > 0 do msg += "\n失败: " + failedObjs.count as string + " 个"
			msg += "\n\n下一步:\n1. 打开 MassFX 工具栏\n2. 点击 '开始模拟'\n3. 完成后点击 '烘焙物理动画'"
			messageBox msg title:"完成"
		)
		else
			messageBox "自动添加失败，请手动:\n模拟 → MassFX → 设置为动态刚体" title:"提示"
	)
	
	on btnBakePhysics pressed do
	(
		local baked = false
		try(macros.run "MassFX" "BakeAllMassFX"; baked = true)catch()
		if not baked do try(MassFX.BakeAll(); baked = true)catch()
		if not baked do try(physx.bakeAll(); baked = true)catch()
		
		if baked then
			messageBox "物理动画已烘焙为关键帧\n现在可以导出FBX了" title:"完成"
		else
			messageBox "请手动: 模拟 → MassFX → 烘焙所有" title:"提示"
	)
	
	-- 开始物理模拟预览
	on btnStartSim pressed do
	(
		local started = false
		
		-- 方法1: 使用 MassFXOps
		try(MassFXOps.StartSimulation(); started = true)catch()
		
		-- 方法2: 使用 physx 接口
		if not started do try(physx.startSimulation(); started = true)catch()
		
		-- 方法3: 尝试宏命令
		if not started do
		(
			local cmds = #("StartSimulation", "PxStartSimulation", "RunSimulation", "PlaySimulation")
			for cmd in cmds while not started do
				try(macros.run "MassFX" cmd; started = true)catch()
		)
		
		-- 方法4: 模拟按键盘快捷键 (MassFX 默认无快捷键，但可以尝试)
		if not started do
		(
			try
			(
				-- 打开 MassFX 工具栏
				macros.run "MassFX" "LaunchMassFXWorld"
				messageBox "已打开 MassFX 工具栏\n请点击工具栏上的 ▶ 播放按钮开始模拟" title:"提示"
				started = true
			)
			catch()
		)
		
		if not started do
			messageBox "请手动开始模拟:\n\n1. 菜单: 模拟 → MassFX → 显示 MassFX 工具栏\n2. 点击工具栏上的 ▶ 播放按钮" title:"提示"
	)
	
	-- 停止物理模拟
	on btnStopSim pressed do
	(
		local stopped = false
		
		try(MassFXOps.StopSimulation(); stopped = true)catch()
		if not stopped do try(physx.stopSimulation(); stopped = true)catch()
		
		if not stopped do
		(
			local cmds = #("StopSimulation", "PxStopSimulation", "PauseSimulation")
			for cmd in cmds while not stopped do
				try(macros.run "MassFX" cmd; stopped = true)catch()
		)
		
		if not stopped do
			messageBox "请点击 MassFX 工具栏上的 ■ 停止按钮" title:"提示"
	)
	
	-- 重置物理模拟
	on btnResetSim pressed do
	(
		local reset = false
		
		try(MassFXOps.ResetSimulation(); reset = true)catch()
		if not reset do try(physx.resetSimulation(); reset = true)catch()
		
		if not reset do
		(
			local cmds = #("ResetSimulation", "PxResetSimulation", "ResetWorld", "ResetMassFX")
			for cmd in cmds while not reset do
				try(macros.run "MassFX" cmd; reset = true)catch()
		)
		
		if not reset do
			messageBox "请点击 MassFX 工具栏上的 ↺ 重置按钮" title:"提示"
	)
	
	on btnCreateGround pressed do
	(
		local ground = Plane length:500 width:500 pos:[0,0,0] name:"Ground" wireColor:(color 100 100 100)
		select ground
		try(macros.run "MassFX" "PxRbStaticMod"; messageBox "地面已创建 (静态刚体)" title:"完成")
		catch
		(
			try
			(
				local rbMod = MassFX_RBody()
				addModifier ground rbMod
				try(rbMod.type = 3)catch()
				try(rbMod.RBType = 3)catch()
				messageBox "地面已创建 (静态刚体)" title:"完成"
			)
			catch(messageBox "地面已创建\n请手动设置为静态刚体" title:"提示")
		)
	)
	
	on btnCreateImpact pressed do
	(
		local ball = Sphere radius:20 pos:[0,-100,50] name:"ImpactBall" wireColor:red
		select ball
		try(macros.run "MassFX" "PxRbKinematicMod"; messageBox "撞击球已创建\n请添加位移动画后运行模拟" title:"完成")
		catch
		(
			try
			(
				local rbMod = MassFX_RBody()
				addModifier ball rbMod
				try(rbMod.type = 2)catch()
				try(rbMod.RBType = 2)catch()
				messageBox "撞击球已创建\n请添加位移动画" title:"完成"
			)
			catch(messageBox "撞击球已创建\n请手动设置为运动学刚体" title:"提示")
		)
	)
	
	on btnReset pressed do
	(
		undo "重置破碎" on
		(
			try
			(
				clearPreviewPoints()
				local parts = $*_Part_* as array
				if parts.count > 0 do (delete parts; fracturedParts = #())
				
				if theObject != undefined and not isDeleted theObject do
				(
					unhide theObject
					select theObject
					lblObjName.caption = theObject.name
					btnFracture.enabled = true
				)
				
				try(delete $Ground)catch()
				try(delete $ImpactBall)catch()
				
				updateProgress 0 ""
				messageBox "已重置，可以重新破碎" title:"完成"
			)
			catch(messageBox "重置失败" title:"错误")
		)
	)
)


-- ==================== 一键烘焙蒙皮模块 (修复版) ====================
rollout BakeToSkinTools "一键烘焙蒙皮" width:200 height:195
(
	GroupBox grp1 "动画范围" pos:[5,5] width:190 height:55
	label lbl1 "起始帧:" pos:[10,28] width:45 height:16
	spinner spnStart "" pos:[55,25] width:45 height:16 range:[0,100000,0] type:#integer
	label lbl2 "结束帧:" pos:[105,28] width:45 height:16
	spinner spnEnd "" pos:[150,25] width:45 height:16 range:[0,100000,100] type:#integer
	
	GroupBox grp2 "操作" pos:[5,65] width:190 height:120
	checkbox chkKeepOriginal "保留原碎片" pos:[10,82] checked:true
	button btnBakeToSkin "一键烘焙到蒙皮网格" pos:[10,100] width:180 height:28
	progressBar pbProgress "" pos:[10,132] width:180 height:10 value:0 color:[0,150,0]
	label lblStatus "" pos:[10,145] width:180 height:15
	button btnSelectParts "选择碎片" pos:[10,162] width:85 height:20
	button btnCleanup "清理临时物体" pos:[100,162] width:90 height:20
	
	local breakObjArr = #()
	
	fn updateProgress val msg =
	(
		pbProgress.value = val
		lblStatus.caption = msg
		windows.processPostedMessages()
	)
	
	-- 合并网格并绑定蒙皮 (修复版：使用副本)
	fn BoneToSkin meshArr meshNameArr vertexNumArr =
	(
		local vertexIndexToNodeArr = #()
		
		-- 合并网格
		for index = 2 to meshArr.count do
		(
			if isValidNode meshArr[index] do
				meshop.attach meshArr[1] meshArr[index]
		)
		
		toolMode.coordsys #world
		meshArr[1].pivot = [0,0,0]
		meshArr[1].name = "CombinedMesh_Skinned"
		
		select meshArr[1]
		modPanel.addModToSelection (Skin ()) ui:on
		
		for index = 1 to meshNameArr.count do
		(
			local boneName = meshNameArr[index] + "_Bone"
			local boneNode = getNodeByName boneName
			if boneNode != undefined do
				skinOps.addBone meshArr[1].modifiers[#Skin] boneNode 1
		)
		
		for meshIdx = 1 to meshNameArr.count do
			for vIdx = 1 to vertexNumArr[meshIdx] do
				append vertexIndexToNodeArr meshIdx
		
		local allVertNum = meshop.getNumVerts meshArr[1]
		for index = 1 to allVertNum do
		(
			if index <= vertexIndexToNodeArr.count do
				skinOps.SetVertexWeights meshArr[1].modifiers[#skin] index vertexIndexToNodeArr[index] 1
			if mod index 100 == 0 do
				updateProgress (50 + index as float / allVertNum * 50) ("权重: " + index as string + "/" + allVertNum as string)
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
		local keepOriginal = chkKeepOriginal.checked
		
		undo "一键烘焙蒙皮" on
		(
			try
			(
				updateProgress 0 "创建骨骼..."
				
				-- 统一使用 Root (大写)
				if $Root == undefined do
					Dummy pos:[0,0,0] name:"Root"
				
				local meshNameArr = #()
				local vertexNumArr = #()
				local meshCopies = #()
				
				-- 为每个碎片创建控制骨骼
				for obj in breakObjArr do
				(
					local ctrlName = obj.name + "_Bone"
					local ctrl = Dummy pos:obj.pos name:ctrlName
					ctrl.parent = $Root
					ctrl.scale = [0.5, 0.5, 0.5]
					
					append meshNameArr obj.name
					
					-- 创建副本用于合并（保留原碎片）
					local meshCopy = copy obj
					convertToMesh meshCopy
					append vertexNumArr (meshop.getNumVerts meshCopy)
					append meshCopies meshCopy
				)
				
				updateProgress 15 "烘焙动画..."
				
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
							animate on at time frame
							(
								ctrl.pos = obj.pos
								ctrl.rotation = obj.rotation
							)
						)
					)
					frameCount += 1
					if mod frameCount 5 == 0 do
						updateProgress (15 + frameCount as float / totalFrames * 35) ("烘焙帧: " + frame as string)
				)
				
				updateProgress 50 "合并网格..."
				
				local result = BoneToSkin meshCopies meshNameArr vertexNumArr
				
				-- 隐藏或删除原碎片
				if keepOriginal then
				(
					for obj in breakObjArr do
						try(hide obj)catch()
				)
				else
				(
					for obj in breakObjArr do
						try(delete obj)catch()
				)
				
				updateProgress 100 "完成!"
				select result
				messageBox ("烘焙完成!\n生成: " + result.name + "\n骨骼数: " + meshNameArr.count as string) title:"成功"
			)
			catch
			(
				updateProgress 0 "错误"
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
		undo "清理临时物体" on
		(
			try
			(
				local count = 0
				local bones = $*_Bone as array
				if bones.count > 0 do (delete bones; count += bones.count)
				try(delete $Root; count += 1)catch()
				
				if count > 0 then
					messageBox ("已清理 " + count as string + " 个临时物体") title:"完成"
				else
					messageBox "没有找到需要清理的物体" title:"提示"
			)
			catch(messageBox "清理失败" title:"错误")
		)
	)
)

-- ==================== 动画绑定工具模块 ====================
rollout animationTools "动画绑定工具" width:200 height:240
(
	button btn1 "创建骨骼by物体" pos:[5,5] width:93 height:28
	button btn10 "批量绑定蒙皮" pos:[102,5] width:93 height:28 

	button btn2 "塌陷骨骼动画" pos:[5,36] width:93 height:28
	button btn3 "骨骼父子绑定" pos:[102,36] width:93 height:28	
	 
	button btn4 "清除网格关键帧" pos:[5,67] width:93 height:28
	button btn9 "bone骨骼打直" pos:[102,67] width:93 height:28
	
	button btn5 "<偏移关键帧" pos:[5,98] width:93 height:28
	button btn6 "偏移关键帧>" pos:[102,98] width:93 height:28
	button btn7 "<错位关键帧" pos:[5,129] width:93 height:28
	button btn8 "错位关键帧>" pos:[102,129] width:93 height:28	 

	label lbl1 "错(偏)帧数:" pos:[10,165] width:65 height:16
	spinner spn7 "" pos:[75,162] width:50 height:16 range:[0,1e+006,0] type:#integer	 
	checkbutton ckb2 "选择全部" pos:[130,160] width:65 height:20
	
	label lbl2 "根骨骼名:" pos:[10,190] width:55 height:17
	edittext edt1 "" pos:[65,187] width:130 height:20 text:"Root"
	
	on btn1 pressed do
	(
		undo "创建骨骼" on
		(
			select geometry
			deselect $Bone*
			try(
				local objlist = $selection as array
				if objlist.count == 0 then 
					messagebox "请选择一些要绑定骨骼的模型" beep:false
				else
				(
					-- 统一使用 Root
					local rootName = if edt1.text != "" then edt1.text else "Root"
					local b0 = dummy pos:[0,0,0] name:rootName
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
	)
	
	on btn2 pressed do
	(
		undo "塌陷骨骼动画" on
		(
			select $Bone*
			local objlist = $selection as array
			if objlist.count == 0 then
				messagebox "请选择一些要烘焙动画的骨骼" beep:false
			else
			(
				local forceUpdate = keyboard.shiftPressed
				for bake_obj in objlist do
				(
					local p = undefined
					local old_prs_ctrl = copy bake_obj.transform.controller
					if not forceUpdate then disableSceneRedraw()
					try
					(
						p = Point()
						for i = animationRange.start to animationRange.end do
						(
							if forceUpdate then sliderTime = i
							at time i with animate on p.transform = bake_obj.transform
						)
						bake_obj.transform.controller = transform_script()	
						bake_obj.transform.controller = prs()	
						if not (isGroupMember bake_obj) then bake_obj.parent = undefined
						for i = animationRange.start to animationRange.end do
							at time i with animate on bake_obj.transform = p.transform
						delete p
						p = undefined
						if not forceUpdate then enableSceneRedraw()
					)
					catch
					(
						if p != undefined then delete p
						bake_obj.transform.controller = old_prs_ctrl
						if not forceUpdate then enableSceneRedraw()
					)
				)
			)
		)
	)
	
	on btn3 pressed do
	(	
		undo "骨骼父子绑定" on
		(
			try(
				select $Bone*
				local Bonelist = $selection as array
				if Bonelist.count == 0 then
					messagebox "请选择需要绑定到根骨骼的骨骼" beep:false
				else
				(
					local rootName = if edt1.text != "" then edt1.text else "Root"
					local rootNode = getNodeByName rootName
					if rootNode != undefined then
					(
						for boneA in Bonelist do
							boneA.parent = rootNode
						print("绑定执行完毕")
					)
					else
						messagebox ("找不到根骨骼: " + rootName) beep:false
				)
			)
			catch()
		)
	)
	
	on btn4 pressed do
	(	
		undo "清除网格关键帧" on
		(
			try(
				select geometry
				deselect $Bone*
				local rootName = if edt1.text != "" then edt1.text else "Root"
				local rootNode = getNodeByName rootName
				for i in $ do
				(
					deletekeys i #allKeys
					if rootNode != undefined do i.parent = rootNode
				)
			)
			catch()
		)
	)
	
	on btn5 pressed do
	(	
		undo "偏移关键帧" on
		(
			try(
				if ckb2.state then actionMan.executeAction 0 "40021"
				for i in $ do movekeys i (-1 * spn7.value)
			)
			catch()
		)
	)
	
	on btn6 pressed do
	(	
		undo "偏移关键帧" on
		(
			try(
				if ckb2.state then actionMan.executeAction 0 "40021"
				for i in $ do movekeys i spn7.value
			)
			catch()
		)
	)
	
	on btn7 pressed do
	(	
		undo "错位关键帧" on
		(
			try( 
				if $.count <= 1 then
					messagebox "请选择大于1个物体" beep:false
				else
				(			
					local x = 0
					for i in $ do movekeys i (x += -1 * spn7.value)
				)
			)
			catch()
		)
	)
	
	on btn8 pressed do
	(	
		undo "错位关键帧" on
		(
			try(
				if $.count <= 1 then
					messagebox "请选择大于1个物体" beep:false
				else
				(				
					local x = 0
					for i in $ do movekeys i (x += spn7.value)
				)
			)
			catch()
		)
	)
	
	on btn9 pressed do
	(	
		undo "骨骼打直" on
		(
			try(
				max set key keys
				local objlist = $ as array
				for obj in objlist do
				(
					obj.rotation.controller.X_Rotation.controller.keys[1].value = 0
					obj.rotation.controller.Y_Rotation.controller.keys[1].value = 0
					obj.rotation.controller.Z_Rotation.controller.keys[1].value = 0
				)
			)
			catch()
		)
	)
	
	on btn10 pressed do
	(	
		undo "批量绑定蒙皮" on
		(
			try(
				select geometry
				deselect $Bone*
				macros.run "Modifier Stack" "Convert_to_Poly"
				
				local objlist = $selection as array
				if objlist.count == 0 then 
					messagebox "请选择一些要绑定蒙皮的模型" beep:false
				else
				(
					for obj in objlist do
					(
						modPanel.setCurrentObject obj
						modPanel.addModToSelection (Skin ())
						local children = obj.children
						if children.count > 0 do
							skinOps.addBone obj.modifiers[#Skin] children[1] 1
					)
				)
			)
			catch()
		)
	)
)


-- ==================== 批量设置骨骼尺寸 (修复版) ====================
rollout BatchSetBoneSize "批量设置骨骼尺寸" width:184 height:100
(
	label lbl1 "骨骼宽度:" pos:[10,15] width:60 height:16
	spinner BoneWidth "" pos:[70,12] width:80 height:16 range:[0.1,100,5] type:#float
	label lbl2 "骨骼高度:" pos:[10,40] width:60 height:16
	spinner BoneHeight "" pos:[70,37] width:80 height:16 range:[0.1,100,5] type:#float
	button ModifySize "修改尺寸" pos:[48,65] width:91 height:27
	
	on ModifySize pressed do
	(	
		undo "修改骨骼尺寸" on
		(
			try(
				select $Bone*
				local objlist = $selection as array
				if objlist.count == 0 then
					messagebox "没有找到骨骼" beep:false
				else
				(
					-- 修复: 逐个设置而不是用通配符
					for obj in objlist do
					(
						obj.width = BoneWidth.value
						obj.height = BoneHeight.value
					)
					messagebox ("已修改 " + objlist.count as string + " 个骨骼尺寸") title:"完成"
				)
			)
			catch(messagebox "修改失败" title:"错误")
		)
	)
)

-- ==================== 简化关键帧 ====================
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
		undo "简化关键帧" on
		(
			try(
				local StartFrame = SpnStart.value + 1
				local deleted = 0
				do
				(
					local currentEndFrame = StartFrame + SpnDeleteStep.value - 2
					for currentFrame = StartFrame to currentEndFrame do
					(
						for obj in $ do
						(
							local i = getKeyIndex obj.controller currentFrame
							if i > 0 do (deleteKey obj.controller i; deleted += 1)
						)
					)
				)
				while (StartFrame = currentEndFrame + 2) <= SpnEnd.value
				messagebox ("已删除 " + deleted as string + " 个关键帧") title:"完成"
			)
			catch(messagebox "删除失败" title:"错误")
		)
	)
)

-- ==================== 导出工具模块 (增强版) ====================
rollout ExportTools "导出工具" width:200 height:130
(
	GroupBox grp1 "FBX设置" pos:[5,5] width:190 height:50
	checkbox chkAnim "导出动画" pos:[10,22] checked:true
	checkbox chkBake "烘焙动画" pos:[85,22] checked:true
	checkbox chkEmbed "嵌入媒体" pos:[150,22] checked:false
	
	button btnExportFBX "导出选中为FBX" pos:[10,60] width:180 height:28
	button btnExportAll "导出全部碎片FBX" pos:[10,92] width:180 height:28
	
	fn configureFBXExport exportAnim bakeAnim embedMedia =
	(
		-- 配置FBX导出设置
		try
		(
			FBXExporterSetParam "Animation" exportAnim
			FBXExporterSetParam "BakeAnimation" bakeAnim
			FBXExporterSetParam "EmbedTextures" embedMedia
			FBXExporterSetParam "FileVersion" "FBX201400"
			FBXExporterSetParam "UpAxis" "Z"
			FBXExporterSetParam "Skin" true
			FBXExporterSetParam "Shape" true
		)
		catch()
	)
	
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
			configureFBXExport chkAnim.checked chkBake.checked chkEmbed.checked
			exportFile savePath #noPrompt selectedOnly:true using:FBXEXP
			messageBox ("导出完成!\n" + savePath) title:"成功"
		)
	)
	
	on btnExportAll pressed do
	(
		select $*_Part_*
		if selection.count == 0 do
		(
			-- 尝试选择蒙皮网格
			select $CombinedMesh_Skinned
			if selection.count == 0 do
			(
				messageBox "没有找到碎片或蒙皮网格" title:"提示"
				return()
			)
		)
		
		local savePath = getSaveFileName caption:"保存FBX" types:"FBX(*.fbx)|*.fbx"
		if savePath != undefined do
		(
			-- 同时选择骨骼
			local parts = selection as array
			local bones = $*_Bone as array
			if $Root != undefined do append bones $Root
			
			select parts
			selectMore bones
			
			configureFBXExport chkAnim.checked chkBake.checked chkEmbed.checked
			exportFile savePath #noPrompt selectedOnly:true using:FBXEXP
			messageBox ("导出 " + parts.count as string + " 个物体完成!\n" + savePath) title:"成功"
		)
	)
)

-- ==================== 创建主窗口 ====================
try(closeRolloutFloater globalrollout)catch()
globalrollout = newrolloutfloater "动画破碎工具箱 v1.1" 215 850
addRollout FractureTools globalrollout
addRollout BakeToSkinTools globalrollout
addRollout animationTools globalrollout
addRollout BatchSetBoneSize globalrollout
addRollout SamplifyKeys globalrollout 
addRollout ExportTools globalrollout
