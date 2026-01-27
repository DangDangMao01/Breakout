rollout layer "BingoTool" width:137 height:207
(
	button 'Cle_Layer' "清空空层" pos:[7,10] width:60 height:25 toolTip:"点击一键清空层级" align:#left
	checkbutton 'Fz_Mod' "冻结模型" pos:[7,70] width:60 height:25 align:#left
	button 'SelEnd' "选择末端" pos:[7,40] width:60 height:25 toolTip:"选中所有Bone末端骨骼" align:#left
	button 'ReNameEnd' "末端命名" pos:[70,40] width:60 height:25 toolTip:"末端Bone骨骼排序命名并加入End层" align:#left
	label 'lab_01' "Label" pos:[13,103] width:131 height:16 align:#left --pos:[36,189]
	button 'check_name' "检查重名" pos:[70,10] width:60 height:25 align:#left --pos:[36,189]
	button 'Euler2TCB' "Eu2TCB" pos:[7,140] width:60 height:25 align:#left
	button 'TCB2Euler' "Eu2TCB" pos:[70,140] width:60 height:25 align:#left
	checkbutton 'HideCS' "隐藏CS" pos:[7,170] width:60 height:25 align:#left
	checkbutton 'HideBone' "隐藏Bone" pos:[70,170] width:60 height:25 align:#left
	
	Local Temlayername = #()
	
		fn findEnds arr = ---选择末端
	(
		ends = for i in arr where (i.children.count == 0) collect i
		return ends
	)
	
	
	
	-----------------------------------------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------------------------------------

	
	on Cle_Layer pressed do
	(
		for i = 1 to LayerManager.count-1 do --i是所有层-1的数值，之所以减1是因为基础层是不能删除的。
		(ilayer = LayerManager.getLayer i  --ilayer是得到i的层数，会先获取第一层
		 layername = ilayer.name --把层的名字给到变量layername
		append Temlayername layername --把层的名字都放进一个空集合中
		)
		for j=1 to Temlayername.count do
		( 
			LayerManager.deleteLayerByName Temlayername[j]--从1到数组数量，依次删除数组内的层。
		)
	)
	-----------------------------------------------------------------------------------------------------------------
	on Fz_Mod changed state do
	(
		if state then
		(
			Mod_Arr=for i in objects where(classof i==Editable_Poly or classof i==Editable_Mesh or classof i==PolymeshObject)collect i
			Mod_Arr.showFrozenInGray = off
			freeze Mod_Arr
		)
		else
		(
			Mod_Arr=for i in objects where(classof i==Editable_Poly or classof i==Editable_Mesh or classof i==PolymeshObject)collect i
			Unfreeze Mod_Arr
			------根据Fz_Mod的两个状态，来冻结或者解冻所有属性为上面3种的物体。
		)
	)
	-----------------------------------------------------------------------------------------------------------------
	on SelEnd pressed do
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
	-----------------------------------------------------------------------------------------------------------------
	on ReNameEnd pressed do
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
	-----------------------------------------------------------------------------------------------------------------
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
	-----------------------------------------------------------------------------------------------------------------
	on Euler2TCB pressed do
    (
	   sel = selection as array
	   for s in sel do
	   (
		s.position.controller=position_XYZ()
		s.rotation.controller=TCB_Rotation()
	   )
    )
    on TCB2Euler pressed do
	(
	   sel = selection as array
       for s in sel do
      (
         s.position.controller=position_XYZ()
		 s.rotation.controller=euler_XYZ()
	  )
	)
	-----------------------------------------------------------------------------------------------------------------
	on HideCS changed state do
	(
		if state then
	    (
		    CS_All=for i in objects where (classof i==Biped_Object ) collect i
		    hide CS_All
		)
		else
		(
			CS_All=for i in objects where (classof i==Biped_Object ) collect i
		    unhide CS_All
		)
	)
	on HideBone changed state do
	(
		if state then
	    (
		    Bone_All=for i in objects where (classof i==BoneGeometry ) collect i
		    hide Bone_All
		)
		else
		(
			Bone_All=for i in objects where (classof i==BoneGeometry ) collect i
		    unhide Bone_All
		)
	)
	-----------------------------------------------------------------------------------------------------------------
	try(destroydialog AlignAniTools)catch()
	rollout AlignAniTools "AlignAniTools by GadRei" width:184 height:220
	(

			GroupBox grp1 "AlignState" pos:[8,104] width:76 height:84
			GroupBox grp2 "TimeRange" pos:[88,100] width:92 height:88
			label lbl1 "PickAlignObj:" pos:[8,8] width:92 height:16
			label lbl2 "PickAlignTarget:" pos:[8,52] width:116 height:16
			label lbl3 "End" pos:[108,136] width:24 height:16
			label lbl4 "Start" pos:[106,116] width:36 height:16
	
			button pkAO "Pick" pos:[8,28] width:168 height:24
			button pkAT "Pick" pos:[8,72] width:168 height:24
			checkbox PC "Position" pos:[16,124] width:64 height:16
			checkbox rc "Rotation" pos:[16,144] width:64 height:16
			checkbox sc "Scale" pos:[16,164] width:64 height:16
	
			spinner StartSp "" pos:[132,116] width:44 height:16 range:[0,100000,0] type:#integer
			spinner EndSp "" pos:[132,136] width:44 height:16 range:[1,99999,100] type:#integer
	
			button Pcr "CurrectRange" pos:[92,160] width:80 height:20
			button Bakebt "Bake!" pos:[12,192] width:164 height:24
			on pkAO pressed do
			(
				if selection.count==1 then
				(
					pkAO.caption=$.name
				)
			)
	            on pkAT pressed do
			(
		           if selection.count==1 then
		        (
				   pkAT.caption=$.name
				)
			)
	
	on AlignAniTools open do
	(
		startsp.value=animationrange.start
		endsp.value=animationrange.end
		pc.state=true
		rc.state=true
		sc.state=true
	)
	on StartSp changed val do
	(
		if startsp.value>=endsp.value then endsp.value=startsp.value+1
	)
	on EndSp changed val do
	(
		if startsp.value>=endsp.value then startsp.value=endsp.value-1
	)
	on Pcr pressed do
	(
		startsp.value=animationrange.start
		endsp.value=animationrange.end
	)
	on Bakebt pressed do
	(
		pobj=getnodebyname pkAO.caption
		tobj=getnodebyname pkAT.caption
		if pobj!=undefined and tobj!=undefined and pobj != tobj then
		(
			for i=startsp.value to endsp.value do
			(
				slidertime=i
				with animate on
				(
					pobj.transform=tobj.transform
					if sc.state== false then
					(
						deletekeys pobj.scale.controller
						)
					if rc.state==false then
					(
						deletekeys pobj.rotation.controller
						)
					if pc.state==false then
					(
						deletekeys pobj.pos.controller
						)
					)
				)
			)
			
		)
    )
)
AllRollout = newRolloutFloater "BingoTool" 170 285
addRollout layer AllRollout
addRollout AlignAniTools AllRollout

Layer.open = false
AlignAniTools.open = false
