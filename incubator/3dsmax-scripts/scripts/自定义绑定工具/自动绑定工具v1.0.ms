-------------------------------------------------------
--------------------自动绑定工具-----------------------
---------------------V:1.0-----------------------
-------------------Author:当当猫-------------------------
-------------------------------------------------------

global AutoBindToolFloater
try (closeRolloutFloater AutoBindToolFloater) catch()

rollout AutoBindTool "自动绑定工具v1.0"
(
	spinner spnHeight "Biped高度:" range:[1,10000,170] type:#float fieldwidth:60
	spinner spnSeg "骨架参数:" range:[1,200,20] type:#integer fieldwidth:60
	spinner spnZ "Z偏移:" range:[-10000,10000,0] type:#float fieldwidth:60
	checkbox chkAutoHeight "按选择模型自动高度" checked:true
	checkbox chkAtSel "放到选择中心" checked:true
	checkbox chkDeletePrev "创建前删除上一个" checked:false
	button btnCreate "创建Biped" width:200
	button btnBind "绑定Skin到选择模型" width:200
	button btnCreateBind "创建并绑定" width:200
	button btnSelect "选择最近创建" width:200
	button btnDelete "删除最近创建" width:200
	
	local bipRoot = undefined
	
	fn ensureBipedAvailable =
	(
		try (isProperty biped #createNew) catch (false)
	)
	
	fn getBBox nodes =
	(
		local bbMin = undefined
		local bbMax = undefined
		for n in nodes where (n != undefined and isValidNode n) do
		(
			local bb = nodeGetBoundingBox n n.transform
			if (bb != undefined and bb.count == 2) do
			(
				if bbMin == undefined then
				(
					bbMin = bb[1]
					bbMax = bb[2]
				)
				else
				(
					bbMin = [amin bbMin.x bb[1].x, amin bbMin.y bb[1].y, amin bbMin.z bb[1].z]
					bbMax = [amax bbMax.x bb[2].x, amax bbMax.y bb[2].y, amax bbMax.z bb[2].z]
				)
			)
		)
		if bbMin == undefined then undefined else #(bbMin, bbMax)
	)
	
	fn computeHeightAndPos =
	(
		local h = spnHeight.value
		local pos = [0,0,spnZ.value]
		if chkAutoHeight.checked or chkAtSel.checked then
		(
			local nodes = selection as array
			local bb = getBBox nodes
			if bb != undefined then
			(
				local bbMin = bb[1]
				local bbMax = bb[2]
				
				if chkAutoHeight.checked then
				(
					local hh = bbMax.z - bbMin.z
					if hh > 0.001 then h = hh
				)
				
				if chkAtSel.checked then
				(
					local c = (bbMin + bbMax) / 2
					pos = [c.x, c.y, bbMin.z + spnZ.value]
				)
			)
		)
		#(h, pos)
	)
	
	fn deleteBiped rootNode =
	(
		if (rootNode != undefined and isValidNode rootNode) do
		(
			try (delete rootNode) catch()
		)
	)
	
	fn getBipedNodes rootNode =
	(
		if (rootNode == undefined or (isValidNode rootNode) == false) then return #()
		local prefix = rootNode.name + "*"
		for o in objects where (matchPattern o.name pattern:prefix) collect o
	)
	
	fn ensureSkinModifier node =
	(
		if (node == undefined or (isValidNode node) == false) then return undefined
		local m = node.modifiers[#Skin]
		if m == undefined then
		(
			addModifier node (Skin()) before:0
			m = node.modifiers[#Skin]
		)
		m
	)
	
	fn bindSelectionToBiped rootNode =
	(
		if (rootNode == undefined or (isValidNode rootNode) == false) then
		(
			messageBox "请先创建Biped"
			return false
		)
		
		local meshes = for o in selection where (superClassOf o == GeometryClass) collect o
		if meshes.count < 1 then
		(
			messageBox "请选择需要绑定的模型"
			return false
		)
		
		local bones = getBipedNodes rootNode
		if bones.count < 1 then
		(
			messageBox "未找到Biped骨骼节点"
			return false
		)
		
		undo "AutoBind Bind Skin" on
		(
			for obj in meshes do
			(
				local sk = ensureSkinModifier obj
				if sk != undefined then
				(
					for b in bones do
					(
						try (skinOps.addBone sk b 1) catch()
					)
					try (skinOps.RemoveZeroWeights sk) catch()
				)
			)
		)
		true
	)
	
	fn alignBipedToWorld rootNode targetPos =
	(
		if (rootNode == undefined or (isValidNode rootNode) == false) then return false
		try (in coordsys world rootNode.transform = (transMatrix targetPos)) catch()
		try (in coordsys world rootNode.position = targetPos) catch()
		true
	)
	
	fn createBiped =
	(
		if (ensureBipedAvailable()) == false then
		(
			messageBox "当前版本未启用 Character Studio/Biped"
			return undefined
		)
		
		if chkDeletePrev.checked do deleteBiped bipRoot
		
		local hp = computeHeightAndPos()
		local h = hp[1]
		local pos = hp[2]
		local seg = spnSeg.value
		
		undo "AutoBind Create Biped" on
		(
			try
			(
				local created = undefined
				in coordsys world
				(
					created = biped.createNew h seg pos
				)
				bipRoot = created
				try (alignBipedToWorld bipRoot pos) catch()
				select bipRoot
			)
			catch
			(
				messageBox ("创建Biped失败：\n" + (getCurrentException() as string))
			)
		)
		bipRoot
	)
	
	on btnCreate pressed do
	(
		createBiped()
	)
	
	on btnBind pressed do
	(
		bindSelectionToBiped bipRoot
	)
	
	on btnCreateBind pressed do
	(
		createBiped()
		bindSelectionToBiped bipRoot
	)
	
	on btnSelect pressed do
	(
		if (bipRoot != undefined and isValidNode bipRoot) then select bipRoot
	)
	
	on btnDelete pressed do
	(
		undo "AutoBind Delete Biped" on
		(
			deleteBiped bipRoot
			bipRoot = undefined
		)
	)
)

AutoBindToolFloater = newRolloutFloater "自动绑定工具v1.0" 230 330
addRollout AutoBindTool AutoBindToolFloater
