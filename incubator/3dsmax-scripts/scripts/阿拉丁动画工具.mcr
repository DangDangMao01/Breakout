 rollout animationTools "阿拉丁动画工具" width:200 height:400
 (
 	button btn1 "创建骨骼by物体" pos:[1,2] width:98 height:44
 	button btn10 "批量绑定蒙皮"pos:[101,2] width:97 height:44 

	button btn2 "塌陷骨骼动画" pos:[3,48] width:96 height:44 toolTip:""
 	button btn3 "骨骼父子绑定"pos:[102,48] width:97 height:44	
	 
 	button btn4 "清除网格关键帧"pos:[4,94] width:95 height:44
 	button btn9 "bone骨骼打直"pos:[101,94] width:97 height:44
	
 	button btn5 "<偏移关键帧" pos:[4,140] width:94 height:44
 	button btn6 "偏移关键帧>" pos:[101,140] width:96 height:44
 	button btn7 "<错位关键帧" pos:[4,187] width:94 height:44
 	button btn8 "错位关键帧>" pos:[101,187] width:94 height:44	 
-- 	(		
 	spinner spn7 "错(偏)帧数" pos:[23,236] width:80 height:16 range:[0,1e+006,0] type:#integer	 
	checkbutton ckb2 "选择全部物体" pos:[106,234] width:86 height:20
	
	label lbl1 "根骨骼" pos:[16,257] width:40 height:17
 	edittext edt1 "" pos:[63,255] width:123 height:23
	
 	on btn1 pressed do
 	(
		select geometry
		deselect $Bone*
 		try(
 			objlist = $selection as array
 			if objlist.count == 0 then 
 				(
 					messagebox "拉神提示不要搞设计40中年危机没饭吃:请选择一些要绑定骨骼的模型 " beep:false
 				)
 			else
 			(
--  			b0 = boneSys.createBone [0,0,0] [0,0,0] [0,0,1]
				b0 = dummy pos:[0,0,0]
				b0.name="root"
 				for obj in objlist do --选择的阵列完成
 				(
 			in obj aaa = boneSys.createBone obj.pos obj.pos [0,0,1]
 				   aaa .parent = obj
 				)
 			)--else 
		--清除些firetool的解算残余
		delete $Bone001.Parent
		delete $Bone001
		delete SpaceWarps
 		)--try
 	catch()
 	)--btn1
 	on btn2 pressed do
 	(
			select $Bone*
		
 			objlist = $selection as array
 				--提示如果没选择物体				
 			if objlist.count == 0 then (
 			messagebox "阿拉提示自学成才回家别打游戏:请选择一些要烘焙动画的骨骼"beep:false
 			--format "MB Collapse: No object selected\n"
 			)
 			--开始塌陷
 					local forceUpdate = keyboard.shiftPressed -- if SHIFT is pressed when the macro is called, a viewport redraw is enforced for each timestep to ensure a full update of all controllers
 					if forceUpdate then format "MB Collapse: Enforcing full viewport update. This might be slow but will ensure proper updating of all controllers\n"
 					
 			--objlist = $selection as array
 					for bake_obj in objlist do (	-- for every select object do
 						format "MB Collapse: Collapsing transformation of object %\n" bake_obj.name
 						local p = undefined
 						local old_prs_ctrl = copy bake_obj.transform.controller		-- store old controller for catch()
 						with undo on (
 							if not forceUpdate then disableSceneRedraw();	-- not using redraw context for max4 compatibility
 							-- disableSceneRedraw is problematic as not all scripted controllers are updated!
 							try (
 								p = Point()			-- create temp point object
 								-- copy global transform of source object into temp object
 								for i = animationRange.start to animationRange.end do (
 									if forceUpdate then sliderTime = i	-- set slider time to force a global update of all animation data
 									at time i (
 										with animate on p.transform = bake_obj.transform
 									)
 								)
 								-- kill old transform controller and assign new, clean one
 								bake_obj.transform.controller = transform_script()	
 								bake_obj.transform.controller = prs()	
 								
 								if not (isGroupMember bake_obj) then bake_obj.parent = undefined	-- unlink if not in a group
 								-- copy temp object animation back into source object
 								for i = animationRange.start to animationRange.end do (
 									at time i (
 										with animate on	bake_obj.transform = p.transform
 									)
 								)
 								delete p			-- delete temp point obj
 								p = undefined
 								if not forceUpdate then enableSceneRedraw()
 							)--try
 						catch(
 							format "coder zsz:mobile 13713612334 : Fatal error - exiting\n"
 										if p!=undefined then delete p
 										bake_obj.transform.controller = old_prs_ctrl
 										if not forceUpdate then enableSceneRedraw()
 							  )-- catch				
 						)--with undo
 					)--for bake_obj
 			--塌陷结束
 		)--btn2
 	on btn3 pressed do
 	(	
 	try(
 	-- 	if edt1.text!=""then for i in $selection do i.name = uniquename edt1.text
		select $Bone*
 		Bonelist = $selection as array
 			--提示如果没选择物体				
 		if Bonelist.count == 0 then (
 		messagebox "阿拉提示不要在电脑面前久坐:请选择需要绑定到根骨骼的骨骼"beep:false
 		) 		
 	--if
 		else
 			(
 		for boneA in Bonelist do --选择的阵列完成
 				(
 	--  			in boneA $.parent = $+i.name
 				in boneA $.parent = $root
 			print("绑定执行完毕")
 				--$Bone001
 				)	
 			)--else 
 	)--try
 	catch()
 	)--btn3
 	on btn4 pressed do
 	(	
 		try(
			select geometry
			deselect $Bone*
 			for i in $ do (
 				deletekeys $ #allKeys
				$.parent = $root
 			)
 		)--try
 	catch()
 	)--btn4 偏移关键帧>
 	on btn5 pressed do
 	(	
 		try(
 			if (ckb2.state==true)then (
 		actionMan.executeAction 0 "40021"
 			)
 	-- 			print(ckb2.state)
 			for i in $ do (
 				movekeys i (-1*spn7.value)
 			)
 		)--try
 	catch()
 	)--btn5 <偏移关键帧
 	on btn6 pressed do
 	(	
 		try(
 			if (ckb2.state==true)then (
 			actionMan.executeAction 0 "40021"
 			)
 			for i in $ do (
 				movekeys i (spn7.value)
 			)
 		)--try
 	catch()
 	)--btn6 偏移关键帧>	
	
 	on btn7 pressed do
 	(	
 		try( 
 		if ($.count<=1) then (messagebox "请选择大于1个物体"beep:false)
 	else
 	(			
 		x=0
 		for i in $ do (
 			movekeys i (X+= -1*spn7.value)
 		)			
 	)
 	--print (-1*spn7.value) 
 		)--try
 	catch()
 		)--btn7 <错位关键帧
	
 	on btn8 pressed do
 	(	
 		try(
 		if ($.count<=1) then (messagebox "请选择大于1个物体" beep:false)	
 	else
 	(				
 		x=0
 		for i in $ do (
 			movekeys i (X+=spn7.value)			
 		)
 	)		
 		--print (spn7.value) 							
 	     )--try
 	catch()
 	)--btn8 错位关键帧>
	
 	on btn9 pressed do
 	(	
 		try(
 		max set key keys
 		objlist = $ as array
 		for obj in objaddlist do
 		(
 		obj.rotation.controller.X_Rotation.controller.keys[1].value = 0
 		obj.rotation.controller.Y_Rotation.controller.keys[1].value = 0
 		obj.rotation.controller.Z_Rotation.controller.keys[1].value = 0
 		)
 	-- 			deleteKeys $ #allKeys
 	     )--try
 	catch()
		 
 	)--btn9 打直bone骨骼>
	
	 	on btn10 pressed do
 	(	
 		try(
			select geometry
			deselect $Bone*
		--转刚体为几何体
		macros.run "Modifier Stack" "Convert_to_Poly"
			
			objlist = $selection as array
 			if objlist.count == 0 then 
 				(
 					messagebox "拉神提示不要搞设计40中年危机没饭吃:请选择一些要绑定蒙皮的模型 " beep:false
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
 			)--else 
			
 	     )--try
 	catch()
 	)--btn10 批量绑定蒙皮>
 )
 
 
 
 
rollout BatchSetBoneSize "批量设置bone骨骼尺寸" width:184 height:250
(
	button ModifySize "修改尺寸" pos:[48,65] width:91 height:27
	spinner BoneWidth "骨骼宽度" pos:[28,12] width:123 height:16 	
	spinner BoneLength "骨骼长度" pos:[27,37] width:123 height:16 
	
	on ModifySize pressed do
	(	
		try(
			select $Bone*
			objlist = $selection as array
			for obj in objlist do --选择的阵列完成
			   (
			 $Bone*.width = BoneWidth.value
			 $Bone*.height = BoneLength.value
		   )
	   )
	   catch("打印失败\n")	
   )
   
)
rollout SetConstraint "设置约束" width:182 height:520
(
----------------------------------位移约束------------------------------------		
	GroupBox grp20 "位移约束" pos:[3,2] width:172 height:62	
	
	edittext addpos "添加位移约束" pos:[11,17] width:155 height:21 enabled:true
	button loadPosConst "载入位移约束" pos:[0,68] width:78 height:20
	
-----------------------	
	edittext posTarget "位移约束目标" pos:[12,39] width:155 height:21 enabled:true
	button loadposTarget "载入位束目标" pos:[79,68] width:77 height:20		
	button ok1 "ok" pos:[157,68] width:10 height:23
---------------------------------lookat约束------------------------------------	
	GroupBox grp19 "lookAt约束" pos:[3,88] width:172 height:93
	edittext addlookat "添加旋转约束" pos:[9,105] width:155 height:21 enabled:true
	button loadRotConst "载入旋转约束" pos:[0,184] width:78 height:20
------------------------	
	edittext lookatTarget "旋转束目标" pos:[9,130] width:155 height:21 enabled:true	
	
	button loadRotTarget "载入转束目标" pos:[79,184] width:77 height:20		
	button ok2 "ok" pos:[157,184] width:10 height:23
------------------------	
	spinner lookatlength "旋转约束长度" pos:[19,157] width:148 height:16 range:[0,100000,100] type:#integer
----------------------------------target Axis------------------------------------
	GroupBox grp1 "target Axis" pos:[4,209] width:174 height:61
	radiobuttons targetAxis "" pos:[14,239] width:97 height:16 labels:#("X", "Y", "Z") default:1 columns:3
	checkbox chk21 "翻转" pos:[119,237] width:46 height:26		
		
		
---------------------------------Upnode Control------------------------------
	GroupBox grp2 "Upnode Control" pos:[4,275] width:174 height:61
	radiobuttons UpnodeControl "" pos:[40,295] width:114 height:32 labels:#("LookAt", "Axis Aligment") default:1 columns:1 rows:2
----------------------------------源坐标轴-------------------------------	
	GroupBox grp3 "源坐标轴" pos:[4,342] width:174 height:55
	radiobuttons SourceAxis "" pos:[11,366] width:97 height:16 labels:#("X", "Y", "Z") default:1 columns:3
	
	checkbox chk30 "翻转" pos:[121,363] width:46 height:26		
	
-------------------------------对齐到Upnode轴------------------------------	
	GroupBox grp4 "对齐到Upnode轴" pos:[4,400] width:174 height:53
	radiobuttons AlignUpnodeAxis "" pos:[40,428] width:97 height:16 labels:#("X", "Y", "Z") default:1 columns:3
---------------------------------------------------------------------------
	button Extude "执行约束设置" pos:[18,460] width:141 height:20
-------------------/////////////////////////////////////-----------------	

on loadPosConst pressed do
	(
		try(
		addpos.text= $.name
			)
		catch()	
	)
on loadposTarget pressed do
	(
		try(
		posTarget.text= $.name
			)
		catch()	
	)	
on loadRotConst pressed do
	(
		try(
		addlookat.text= $.name
			)
		catch()	
	)
on loadRotTarget pressed do
	(
		try(
		lookatTarget.text= $.name
			)
		catch()	
	)
on ok1 pressed do --ok1执行的命令
	(
		try(
		addpos1 = addpos.text
		addpos2 = getnodebyname addpos1		
		
		posTarget1 = posTarget.text
		posTarget2 = getnodebyname posTarget1

		addpos2.pos.controller = Position_Constraint ()		
		A = addpos2.pos.controller
		A.appendtarget posTarget2 50			
			)
		catch("位移约束执行失败")		
	)
on ok2 pressed do --ok2执行的命令
	(
		try(
		addlookat1 = addlookat.text
		addlookat2 = getnodebyname addlookat1
		
		lookatTarget1 =lookatTarget.text
		lookatTarget2 = getnodebyname lookatTarget1

		addlookat2.rotation.controller = LookAt_Constraint ()		
		B = addlookat2.rotation.controller
		B.appendtarget lookatTarget2 50 
			
		B.lookat_vector_length = lookatlength.value
		
		B.target_axis = targetAxis.state
		print(targetAxis.state)
		B.upnode_ctrl = UpnodeControl.state
		print(UpnodeControl.state)
		B.StoUP_axis = SourceAxis.state	
		print(SourceAxis.state)
		B.upnode_axis = AlignUpnodeAxis.state
		print(AlignUpnodeAxis.state)	
			)
		catch("旋转约束执行失败")	
	)
	  
on Extude pressed do(
	try(
		addpos1 = addpos.text
		addpos2 = getnodebyname addpos1		
		
		posTarget1 = posTarget.text
		posTarget2 = getnodebyname posTarget1
	
		addlookat1 = addlookat.text
		addlookat2 = getnodebyname addlookat1
		
		lookatTarget1 =lookatTarget.text
		lookatTarget2 = getnodebyname lookatTarget1
 		
		addpos2.pos.controller = Position_Constraint ()		
		A = addpos2.pos.controller
		A.appendtarget posTarget2 50
		
		addlookat2.rotation.controller = LookAt_Constraint ()		
		B = addlookat2.rotation.controller
		B.appendtarget lookatTarget2 50 

		B.lookat_vector_length = lookatlength.value
		
		B.target_axis = targetAxis.state
		print(targetAxis.state)
		B.upnode_ctrl = UpnodeControl.state
		print(UpnodeControl.state)
		B.StoUP_axis = SourceAxis.state	
		print(SourceAxis.state)
		B.upnode_axis = AlignUpnodeAxis.state
		print(AlignUpnodeAxis.state)
		)
	catch(	
		print("错误")			
		)
	)
)
rollout PrintVertexAnimToBone "打印顶点动画到骨骼" width:184 height:160
(
	GroupBox grp8 "要绑定顶点的mesh名" pos:[3,5] width:179 height:149 
	GroupBox grp9 "要打印动画的骨骼名" pos:[5,60] width:175 height:94
	button createBoneBySelvertex "根据选择顶点创建骨骼" pos:[21,30] width:148 height:29

	spinner StartFrame "起始帧" pos:[35,80] width:57 height:16 range:[0,100000,0] type:#integer
	spinner EndFrame "结束帧" pos:[115,80] width:57 height:16 range:[0,100000,10] type:#integer
	button printer "《打印关键帧》" pos:[24,110] width:148 height:29
-------------------------\\\\\\\\\\\\\\\\\\\\\\\\--------------------
	fn averageSelVertPositionA obj =
	(
		obj=$
		verts = $.selectedVerts
		p = Point3 0 0 0
		for v in verts do
		(
			p += v.pos
		)
		p = p/verts.count		
		return p 
	)
	fn averageSelVertPositionB obj =
	(
		verts = obj.selectedVerts
		p = Point3 0 0 0
		for v in verts do
		(
			p += v.pos
		)
		p = p/verts.count		
		return p 
	)		
-----------	
	on createBoneBySelvertex pressed do
	(
		try(
		averageSelVertPositionA $
		print(p)
		b0 = boneSys.createBone p [0,0,0] [1,0,0]
		b0.length=5
		b0.wirecolor = color 255 204 0
			)
		catch()	
	)
	
	on printer pressed do
	(
-- 		try(
			sliderTime = 0f --把时间初始化位0，从0开始跑
		
			for i=StartFrame.value to EndFrame.value+1 do
			(
			max tool animmode
			set animate on
			averageSelVertPositionB obj			
			b0.pos = p
			sliderTime =i --时间开始一帧一帧跑。				
			i=i+1			
			)
-- 		)
-- 		catch("打印失败\n")	
	)
)
rollout SamplifyKeys "简化关键帧" width:200 height:107
(

	GroupBox grp1 "Animation Range" pos:[4,-2] width:186 height:102
	spinner spnStart "开始帧" pos:[16,14] width:80 height:16 range:[-100000,100000,0] type:#integer across:2
	spinner spnEnd "结束帧" pos:[112,13] width:67 height:16 range:[-100000,100000,80] type:#integer
	spinner SpnDeleteStep "跳帧" pos:[16,36] width:80 height:16 range:[1,50,5] type:#integer 
 
 
	button BtnDeleteFrames "删除关键帧" pos:[50,65] width:80 height:31 toolTip:"根据设置项删除一些关键帧"

	on BtnDeleteFrames pressed do
	(
		try(

				StartFrame = SpnStart.value +1
				
				do
				(
					currentEndFrame = StartFrame + SpnDeleteStep.value - 2
					for currentFrame = StartFrame to currentEndFrame do
					(
						print currentFrame
						for obj in $ do
						(
							i = getKeyIndex obj.controller currentFrame
							if i > 0 then deleteKey  obj.controller  i -- maybe faster to collect all the keys into an array then delete them all in one go
						)
					)
				)
				while ( StartFrame = currentEndFrame + 2 )<= SpnEnd.value

		)
		catch("biped root not found\n")
	)
)
-------------------------------------------------------------	
globalrollout = newrolloutfloater "阿拉丁动画工具" 200 800
addRollout animationTools globalrollout
addRollout BatchSetBoneSize globalrollout
addRollout SetConstraint globalrollout 
addRollout PrintVertexAnimToBone globalrollout
addRollout SamplifyKeys globalrollout 
-------------------------------------------------------------------------
