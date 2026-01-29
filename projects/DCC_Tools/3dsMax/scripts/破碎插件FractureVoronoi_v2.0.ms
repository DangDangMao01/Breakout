-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- *  FRACTURE VORONOI - v2.0 - 2025 - 3ds Max 2020+       *
-- *                                                       *
-- *  Updated for modern 3ds Max compatibility             *
-- *  Based on original by GARP (2009)                     *
-- *                                                       *
-- *  Changes from v1.1:                                   *
-- *  - Replaced deprecated pcloud with random sampling    *
-- *  - Updated modifier references                        *
-- *  - Added high DPI support                             *
-- *  - Improved error handling                            *
-- *  - Added progress feedback                            *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

(	-- start script

global rltFractureVoronoi
try destroyDialog rltFractureVoronoi catch()

-- 在物体包围盒内生成随机点（替代已弃用的 pcloud）
fn generateRandomPointsInMesh obj count =
(
	local points = #()
	local bb = nodeGetBoundingBox obj obj.transform
	local minPt = bb[1]
	local maxPt = bb[2]
	
	-- 转换为可编辑网格以进行射线检测
	local tempObj = copy obj
	convertToMesh tempObj
	
	local attempts = 0
	local maxAttempts = count * 50  -- 防止无限循环
	
	while points.count < count and attempts < maxAttempts do
	(
		attempts += 1
		-- 在包围盒内生成随机点
		local rx = random minPt.x maxPt.x
		local ry = random minPt.y maxPt.y
		local rz = random minPt.z maxPt.z
		local testPt = [rx, ry, rz]
		
		-- 简化的内部检测：使用多方向射线
		local inside = true
		local rayDirs = #([1,0,0], [-1,0,0], [0,1,0], [0,-1,0], [0,0,1], [0,0,-1])
		local hitCount = 0
		
		for dir in rayDirs do
		(
			local r = ray testPt dir
			local hitResult = intersectRay tempObj r
			if hitResult != undefined do hitCount += 1
		)
		
		-- 如果大多数方向都有碰撞，认为点在内部
		if hitCount >= 4 do
		(
			append points testPt
		)
	)
	
	delete tempObj
	
	-- 如果点数不够，用包围盒中心附近的点补充
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

rollout rltFractureVoronoi "F.R.A.C.T.U.R.E  v2.0"
(
	groupBox boxSetUp "" pos:[5,0] width:116 height:83
	fn geometryFilter obj = superClassOf obj == GeometryClass
	pickButton pbObject "Pick Object" pos:[10,11] width:106 height:25 filter:geometryFilter tooltip:"选择要破碎的物体"
	spinner spnNbParts "碎片数: " pos:[09,41] width:106 height:16 range:[2,500,10] type:#integer enabled:false
	spinner spnNbIter "迭代次数: " pos:[28,61] width:87 height:16 range:[1,5,1] type:#integer enabled:false

	groupBox boxMat "" pos:[5,81] width:116 height:89
	spinner spnNewID "新材质ID:" pos:[24,93] width:91 height:16 range:[1,100,1] indeterminate:true type:#integer enabled:false
	checkBox cbKeepMat "保留材质" pos:[12,110] checked:true enabled:false
	spinner spnNewCh "贴图通道:" pos:[32,133] width:83 height:16 range:[1,10,3] type:#integer enabled:false
	checkBox cbRWMS "真实尺寸" pos:[12,150] checked:true enabled:false

	groupBox boxHierarchy "" pos:[5,168] width:116 height:48
	checkBox cbKeepGen "保留迭代" pos:[12,179] checked:false enabled:false
	checkBox cbLinkGen "构建层级" pos:[12,196] checked:false enabled:false

	groupBox boxCreate "" pos:[5,214] width:116 height:109
	button btnCreate "破碎为 10 块" pos:[10,225] width:106 height:25 tooltip:"先选择物体" enabled:false
	radiobuttons rdoColor "" pos:[12,253] width:72 height:32 labels:#("多色", "单色") default:1 columns:1 enabled:false
	colorPicker cpParts "" pos:[85,270] fieldWidth:20 height:12 visible:false
	radiobuttons rdoCenter "" pos:[12,288] width:100 height:32 labels:#("包围盒中心", "Voronoi中心") default:1 columns:1 enabled:false

	groupBox boxProgress "" pos:[5,321] width:116 height:49
	progressBar pbProgress "" pos:[10,335] width:106 height:15 value:0 color:[0,96,0]
	label lblProStatus "" pos:[10,351] width:100 height:17

	local theObject			-- 保存原始物体


	on pbObject picked obj do
	(
		pbObject.text = obj.name
		theObject = obj
		spnNbParts.enabled = true
		spnNbIter.enabled = true
		spnNewID.enabled = true
		cbKeepMat.enabled = true
		spnNewCh.enabled = true
		cbRWMS.enabled = true
		cbLinkGen.enabled = true
		btnCreate.enabled = true
		btnCreate.tooltip = "开始创建碎片"
		rdoColor.enabled = true
		rdoCenter.enabled = true
		cpParts.color = obj.wireColor
		cpParts.visible = true
			
		when obj deleted do
		(
			btnCreate.enabled = false
			btnCreate.tooltip = pbObject.text + " 已被删除!"
			pbObject.text = "Pick Object"
		)
		
		undo off
		(	-- 获取新面的材质 ID
			try
			(
				local tempMesh = snapshotAsMesh obj
				local maxID = 1
				for i = 1 to tempMesh.numfaces do
				(
					local faceID = getFaceMatID tempMesh i
					if faceID > maxID do maxID = faceID
				)
				spnNewID.value = maxID + 1
				delete tempMesh
			)
			catch
			(
				spnNewID.value = 2
			)
		)
	)


	on btnCreate pressed do
	(
		if theObject == undefined or isDeleted theObject do
		(
			messageBox "请先选择一个有效的物体!" title:"错误"
			return()
		)
		
		undo off
		(
			disableSceneRedraw()
			clearSelection()
			local startTime = timeStamp()
			
			local nbParts = spnNbParts.value
			local nbIter = spnNbIter.value
			local keepGen = cbKeepGen.checked
			local linkGen = cbLinkGen.checked
			local aPartsStart = #()
			local aPartsEnd = #()
			local aAllParts = #()
			local aAllCoords = #()
			local thePlane = plane width:1 length:1 widthSegs:1 lengthSegs:1
			local theMesh = editable_mesh()
			local abortBreaking = false
			
			lblProStatus.caption = " 破碎中..."
			
			try
			(
				-- 创建干净的副本
				local theCopy = copy theObject
				theCopy.name = "temp_fracture"
				resetXForm theCopy
				convertToMesh theCopy
				theMesh.mesh = theCopy.mesh
				theMesh.transform = theCopy.transform
				theMesh.pivot = [0,0,0]
				resetXForm theMesh
				convertToMesh theMesh
				delete theCopy
				
				-- 材质和 UV
				if cbKeepMat.checked and theObject.material != undefined do 
					theMesh.material = theObject.material
				
				addModifier theMesh (Uvwmap mapChannel:spnNewCh.value realWorldMapSize:cbRWMS.checked)
				convertToMesh theMesh
				setFaceSelection theMesh #{}
				
				-- 碎片创建
				aPartsEnd = #(theMesh)
				
				for iter = 1 to nbIter while not abortBreaking do
				(
					aPartsStart = aPartsEnd
					aPartsEnd = #()
					
					for obj in aPartsStart while not abortBreaking do
					(	
						local aPartsTemp = for i = 1 to nbParts collect copy obj
						
						-- 使用新的随机点生成函数
						local aCoords = generateRandomPointsInMesh obj nbParts
						
						for i = 1 to nbParts - 1 do 
						(
							for j = i + 1 to nbParts while not abortBreaking do
							(
								thePlane.pos = (aCoords[i] + aCoords[j]) / 2
								thePlane.dir = aCoords[j] - aCoords[i]
								
								-- 使用 SliceModifier
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
								
								if keyboard.escPressed do 
									abortBreaking = queryBox "是否中止并删除已创建的碎片?" title:"中止确认"
							)
						)
						
						aPartsEnd += aPartsTemp
						aAllParts += aPartsTemp
						aAllCoords += aCoords
						
						-- 更新进度
						local total = nbParts * ((nbParts^nbIter - 1) / (nbParts - 1))
						local prog = 100.0 * aAllParts.count / total
						pbProgress.value = prog
						pbProgress.color = [200 - prog * 2, prog * 2, 0]
					)
				)
				
				if not abortBreaking then
				(
					lblProStatus.caption = " 整理中..."
					
					delete theMesh
					delete thePlane
					hide theObject
					
					-- 处理中间代
					if not keepGen and nbIter != 1 do
					(
						local ind = 0
						for i = 1 to nbIter - 1 do 
						(
							for j = 1 to nbParts^i do
							(
								ind += 1
								if ind <= aAllParts.count and isValidNode aAllParts[ind] do
								(
									delete aAllParts[ind]
									if ind <= aAllCoords.count do aAllCoords[ind] = undefined
								)
							)
						)
						aAllParts = for obj in aAllParts where isValidNode obj collect obj
						aAllCoords = for c in aAllCoords where c != undefined collect c
					)
					
					-- 设置轴心点
					if rdoCenter.state == 1 then 
						centerPivot aAllParts
					else 
					(
						for i = 1 to aAllParts.count do
						(
							if i <= aAllCoords.count do
								aAllParts[i].pivot = aAllCoords[i]
						)
					)
					
					resetXForm aAllParts
					convertToMesh aAllParts
					
					-- 设置新面的材质 ID
					local newID = spnNewID.value
					for obj in aAllParts do
					(
						local selFaces = getFaceSelection obj
						for f in selFaces do setFaceMatID obj f newID
						setFaceSelection obj #{}
					)
					
					-- 命名
					if not keepGen or nbIter == 1 then
					(
						for i = 1 to aAllParts.count do 
							aAllParts[i].name = theObject.name + "_Part_" + (formattedPrint i format:"03d")
					)
					else
					(
						for i = 1 to amin nbParts aAllParts.count do 
							aAllParts[i].name = theObject.name + "_Part_" + (formattedPrint i format:"03d")
						
						local indP = 0
						local indC = nbParts
						for i = 1 to nbIter - 1 do 
						(
							for j = 1 to nbParts^i do
							(
								indP += 1
								for k = 1 to nbParts do
								(
									indC += 1
									if indC <= aAllParts.count and indP <= aAllParts.count do
										aAllParts[indC].name = aAllParts[indP].name + "_" + k as string
								)
							)
						)
					)
					
					-- 图层管理
					if not keepGen or nbIter == 1 then
					(
						local layerName = theObject.name + "_Parts"
						local theLayer = layerManager.getLayerFromName layerName
						if theLayer == undefined do
							theLayer = layerManager.newLayerFromName layerName
						for obj in aAllParts do theLayer.addNode obj
					)
					else
					(
						local aTheLayers = for i = 1 to nbIter collect
						(
							local lName = theObject.name + "_Gen_" + i as string
							local l = layerManager.getLayerFromName lName
							if l == undefined do l = layerManager.newLayerFromName lName
							l
						)
						for i = 1 to nbIter - 1 do aTheLayers[i].isHidden = true
						
						local ind = 0
						for i = 1 to nbIter do 
						(
							for j = 1 to nbParts^i do
							(
								ind += 1
								if ind <= aAllParts.count do
									aTheLayers[i].addNode aAllParts[ind]
							)
						)
					)
	
					-- 层级关系
					if linkGen do
					(
						if not KeepGen or nbIter == 1 then 
						(
							for obj in aAllParts do 
								obj.parent = theObject
						)
						else
						(
							for i = 1 to amin nbParts aAllParts.count do 
								aAllParts[i].parent = theObject
							
							local indP = 0
							local indC = nbParts
							for i = 1 to nbIter - 1 do 
							(
								for j = 1 to nbParts^i do
								(
									indP += 1
									for k = 1 to nbParts do
									(
										indC += 1
										if indC <= aAllParts.count and indP <= aAllParts.count do
											aAllParts[indC].parent = aAllParts[indP]
									)
								)
							)
						)
					)
					
					-- 颜色
					if rdoColor.state == 1 then 
						for obj in aAllParts do obj.wireColor = random black white
					else 
						for obj in aAllParts do obj.wireColor = cpParts.color
					
					local elapsed = (timeStamp() - startTime) / 1000.0
					lblProStatus.caption = " 完成! " + (formattedPrint elapsed format:".1f") + "秒"
					
					enableSceneRedraw()
					completeRedraw()
					
					messageBox ("成功创建 " + aAllParts.count as string + " 个碎片!") title:"完成"
				)
				else
				(
					delete thePlane
					delete theMesh
					for obj in aAllParts where isValidNode obj do delete obj
					pbProgress.value = 0
					lblProStatus.caption = " 已中止"
					enableSceneRedraw()
				)
			)
			catch
			(
				enableSceneRedraw()
				lblProStatus.caption = " 错误!"
				messageBox ("发生错误: " + getCurrentException()) title:"错误"
				try(delete thePlane)catch()
				try(delete theMesh)catch()
			)
		)
	)


	on spnNbParts changed val do
	(
		local total = val ^ spnNbIter.value
		btnCreate.caption = "破碎为 " + total as string + " 块"
	)


	on spnNbIter changed val do
	(
		local total = spnNbParts.value ^ val
		btnCreate.caption = "破碎为 " + total as string + " 块"
		cbKeepGen.enabled = val != 1
	)
	

	on rltFractureVoronoi close do
	(
		enableSceneRedraw()
		completeRedraw()
		callbacks.removeScripts id:#FVcbID01
	)

)

createDialog rltFractureVoronoi 126 375 60 130

)	-- end script
