-------------------------------------------------------
-------------------AnimationTool-----------------------
------------------Time:2016-10-11----------------------
-------------------Author:乔磊-------------------------
------------------QQ:409856476-------------------------
-------------------------------------------------------



	Default_Setting		=		#()
	Data_Path 			= 		"e:\Data_File.txt"
	Data_File 			= 		Openfile Data_Path
	
	fn FnPrint =
	( 
	undo off
		( 	
			Data_File = CreateFile Data_Path
			print Default_Setting to:Data_File
			close Data_File
		)
	)----------------创建数据文件----------------
		
	fn FnRead =
    (
	undo off
		(		
			Data_File = Openfile Data_Path 	
			try	Default_Setting[1]= readValue Data_File
			catch Default_Setting[1] = false
			if  Data_File==undefined then
			(
				Default_Setting[1]			=		false
				Default_Setting[2]			=		false
				Default_Setting[3]			=		false
				Default_Setting[4] 			=		false
				FnPrint()
			)
			else
			(
				i=2
				while not(eof Data_File) do
				(
					Default_Setting[i]= readValue Data_File
					i+=1
				)
			)
			close Data_File
		)			
	)----------------读取规则----------------
	FnRead()


	
	
rollout ar "Multiple" width:142 height:265
(

	
	
	GroupBox grp1 "Mesh" pos:[4,3] width:118 height:95

	
	
	button Del_H "Delete particle view" pos:[7,19] width:110 height:20 toolTip:"删除场景中的particle view"

	checkbutton Fz_Mdl "Freeze obj" pos:[7,40] width:110 height:24 toolTip:"冻结模型"
	
	button Bac_Cull "B_Cull" pos:[7,67] width:52 height:24 toolTip:"将选中的物体背面消隐"
	button Dis_Box "D_Box" pos:[64,67] width:52 height:24 toolTip:"将选中的物体外框显示"
	
	
	GroupBox grp2 "Weight" pos:[4,106] width:118 height:60

	
	
	button rzw "Remove zero weight" pos:[7,127] width:110 height:24 toolTip:"取消权重值为0的点" 
 
 
 
	
	
	button GetNumberBones "start" pos:[7,194] width:110 height:20 toolTip:"至少需要选择一个模型"

	edittext BoneNumber "Number:" pos:[11,228] width:100 height:20
	groupBox grp15 "skin" pos:[4,172] width:118 height:85
    local num = 0
 
 
    
	

	
	

	
	
	
	on Del_H pressed do
	(
	
		delete $'particle view*'
	
	)
	
	
	on Fz_Mdl changed state do
	(
		if state then
		(
			Mod_Arr=for i in objects where(classof i==Editable_Poly or classof i==Editable_mesh or classof i==PolyMeshObject)collect i
			Mod_Arr.showFrozenInGray = off
			freeze Mod_Arr
		)
		else
		(
			Mod_Arr=for i in objects where(classof i==Editable_Poly or classof i==Editable_mesh or classof i==PolyMeshObject)collect i
			unfreeze Mod_Arr
		)		
	)
	
	on Bac_Cull pressed do
	(
		if selection.count ==0 then 
			(
				messagebox "至少需要选择一个对象" beep:false
			)
		else
			(
			max backface cull toggle
			)
	)----------------actionMan.executeAction 0 "275"
	
	on Dis_Box pressed do
	(
		if selection.count ==0 then 
			(
				messagebox "至少需要选择一个对象" beep:false
			)
		else
			(
				max box mode selected
			)
	)----------------actionMan.executeAction 0 "274"
	
	on rzw pressed do
	(
	
	    animate off
		try
			(
				skinOps.RemoveZeroWeights $.modifiers[#Skin]
				)
				catch
	
					(
	
						)
	
	)
	on GetNumberBones pressed do
	(
	
		  
	    for i in selection do num += skinOps.GetNumberBones i.modifiers[#skin]
	    BoneNumber.text= num as string
	 	num = 0
		
		
	)
)----------------模型工具----------------
	
	
	
	
	
	
rollout bR "Material" width:158 height:96
	
(
	button cbm "ClearBoneMaterial " pos:[4,15] width:110 height:20 toolTip:"清除骨骼材质"	
	button dem1 "Remove sel material" pos:[4,54] width:110 height:20 toolTip:"移除选中物体的材质"

	on cbm pressed do

	(
		
	    for i in $* where classof i == BoneGeometry or classof i == Biped_Object do i.material = undefined

	)

	on dem1 pressed do

		(
		try
		(
			for a in selection do

			(
	

				a.material = undefined

			)

		)
	
		catch

			false

	)
)----------------材质工具----------------

rollout cR "Find Name"
(	
	button btn_rename2 "Initialize Bone" pos:[4,5] width:116 height:24 toolTip:"选中的Bone骨骼名称初始化\n         若需命名递增\n          请双击根骨"
	label name1 "      Find:" pos:[4,93] width:50 height:20
	label name2 "Replace:" pos:[4,117] width:50 height:20
	edittext nam1 "" pos:[46,89] width:72 height:20
	edittext nam2 "" pos:[46,115] width:72 height:20
	button start_rename "Change Name" pos:[4,140] width:116 height:36 toolTip:"为选中的物体替换字符"
	edittext base_name "Prefix:" text:"xx_" pos:[14,35] width:104 height:20
	button Add_prefix "Add a prefix" pos:[4,60] width:116 height:24 toolTip:"为选中的物体添加前缀"
	
	on Add_prefix pressed do
	(
		if selection.count ==0 then
			(
				messagebox "至少需要选择一个对象" beep:false
			) 
		else
			(
				if base_name.text != "" then
				for i in selection do i.name = base_name.text + i.name  --uniquename base_name.text
			)
	)
	
	on btn_rename2 pressed do
	(
		if selection.count ==0 then
		(
			messagebox "至少需要选择一节Bone" beep:false
		)
		else
		(
			for i in selection do
			(
				if classOf i == bonegeometry then
				(
					i.name = uniquename  "Bone"
				)
			)
		)
	)
	
	on start_rename pressed do
	(
		if selection.count ==0 then
		(
			messagebox "至少需要选择一个对象" beep:false
		)
		else
		(
			xx1=nam1.text
			xx2=nam2.text
			
			for j in selection do
				(
					aa=j.name
					cc=0
					for i=1 to aa.count do
						if aa[i]==xx1[1] then
						(
							cc+=1
							yy=i+1
							for bb=2 to xx1.count do
							(
								if aa[yy]==xx1[bb] then
									cc+=1
								else
									cc=0
									yy+=1
							)
							
							if cc==xx1.count then
								(
									zz=1
									qq=aa.count-i-xx1.count
									rr=i+xx1.count
									ee=aa[rr]
									ss=aa[1]
									for zz=2 to i-1 do
										ss=ss+aa[zz]
									for ww=1 to qq do
										(											
											rr+=1
											ee=ee+aa[rr]
										)
									if i>1 then
										(
											if (aa.count-i)>=xx1.count then
												tt=ss+xx2+ee
											else tt=ss+xx2
											j.name=tt
										)
									if i==1 then
										(
											if aa.count==xx1.count then
												tt=xx2
											if aa.count>xx1.count then
												tt=xx2+ee
											j.name=tt
										)
								)
						)
				)
		)
	)
)----------------命名工具----------------

rollout dR "Animat" width:163 height:483
(
	GroupBox grp10 "Skin Pose" pos:[3,0] width:118 height:46
	button Set_as "Setting" pos:[7,16] width:52 height:24 toolTip:"选择的Bone设置为蒙皮姿态"
	button Assume "Assume" pos:[64,16] width:52 height:24 toolTip:"选择的Bone采用蒙皮姿态"
	GroupBox grp11 "Curve property" pos:[3,48] width:118 height:73
	button Fre_tra "Fre Tra" pos:[7,64] width:52 height:24 toolTip:"将当前位置设置为初始位置"
	button Tra_zero "To Zero" pos:[64,64] width:52 height:24 toolTip:"回到初始位置"
	button Fre_rot "Fre Rot" pos:[7,91] width:52 height:24 toolTip:"将当前旋转设置为初始旋转"
	button Rot_zero "To Zero" pos:[64,91] width:52 height:24 toolTip:"回到初始旋转"
	GroupBox grp5 "Bone Tool" pos:[3,123] width:118 height:100
	button selBone_btn "Sel Bone" pos:[7,139] width:52 height:24 toolTip:"选中所有Bone骨骼"
	button selEnd_btn "Sel End" pos:[64,139] width:52 height:24 toolTip:"  选中所有Bone骨骼的末端骨骼\n                  注意!!!\n若场景内存在只有一节骨骼的情况\n          该骨骼将会被选中"
	button Sel_CS "Sel Biped" pos:[7,166] width:52 height:24 toolTip:"选中所有Biped骨骼"
	checkbutton UH_ALL "Hide All" pos:[64,166] width:52 height:24 toolTip:"隐藏所有骨骼"
	checkbutton UH_CS "Hide Biped" pos:[7,193] width:52 height:24 toolTip:"隐藏所有Biped骨骼"
	checkbutton UH_BN "Hide Bone" pos:[64,193] width:52 height:24 toolTip:"隐藏所有Bone骨骼"

	GroupBox grp7 "Bone_Del_Keys" pos:[3,223] width:118 height:100
	checkbox Pos_chk "Del Pos" pos:[8,239] width:66 height:15 toolTip:"删除Bone移动帧"
	checkbox Rot_chk "Del Rot" pos:[8,261] width:66 height:15 toolTip:"删除Bone旋转帧"
	checkbox Scale_chk "Del Scale" pos:[8,283] width:66 height:15 toolTip:"删除Bone缩放帧"
	checkbox Sel_chk "Del Select" pos:[8,302] width:66 height:15 toolTip:"删除Bone所选帧上的以上参数"
	button OK_btn "Del" pos:[82,239] width:34 height:78 toolTip:"删除所选中的参数"
	GroupBox grp8 "key Tool" pos:[3,325] width:118 height:88
	checkbox Pos_chk1 "Pos" pos:[8,341] width:56 height:15 checked:true toolTip:"K移动帧"
	checkbox Rot_chk1 "Rot" pos:[8,363] width:56 height:15 checked:true toolTip:"K旋转帧"
	button OK_btn1 "Perform" pos:[60,341] width:56 height:40 toolTip:"根据最后一个所选中的物体进行打key\n                  !!!注意!!!\n   不要使用浏览器选中最后一个对象"
	button keyBip_btn "Biped All Key" pos:[7,384] width:110 height:24 toolTip:"为所选中的biped物体打全key\n            !!!注意!!!\n       此操作无法撤销"
	
	button btn111 "Clean" pos:[25,441] width:67 height:21 toolTip:"清除Bone上不能删除的层\n           !!!注意!!!\n  Bone动画必须全部塌陷\n       层此操作无法撤销" 
	GroupBox grp111 "Clean and save" pos:[3,417] width:113 height:59




	fn findEnds arr =
	(
		ends = for i in arr where (i.children.count == 0) collect i
		return ends
	)
	


	
	
	
	fn Default_IO IO_Class=
	(
		if IO_Class == "Input" do
		(
			try 
			(
				Pos_chk.checked				= 		Default_Setting[1]
				Rot_chk.checked				= 		Default_Setting[2]
				Scale_chk.checked 			= 		Default_Setting[3]
				Sel_chk.checked				=		Default_Setting[4]
			)	
		catch()
	
		)
		if IO_Class == "Output" do
		(
			Default_Setting[1] 			=		Pos_chk.checked
			Default_Setting[2] 			=		Rot_chk.checked
			Default_Setting[3] 			=		Scale_chk.checked
			Default_Setting[4]			= 		Sel_chk.checked
		)
	)
	
		
	fn delRot a =
	(
		deselectKeys a
		selectKeys a.rotation.controller 
		deleteKeys a #selection 
	)
		
	fn delPos b =
	(
		deselectKeys b
		selectKeys b.pos.controller 
		deleteKeys b #selection 
	)
		
	fn delScale c =
	(
		deselectKeys c
		selectKeys c.scale.controller 
		deleteKeys c #selection 
	)
		
	on Set_as pressed do
	(
		if selection.count ==0 then 
		(
			messagebox "You need to select a object at least" beep:false
		)
		else
		(
			macros.run "Characters" "SetSkinPose"
		)
	)
	on Assume pressed do
	(
		if selection.count ==0 then 
		(
			messagebox "You need to select a object at least" beep:false
		)
		else
		(
			macros.run "Characters" "AssumeSkinPose"
		)
	)
	on Fre_tra pressed do
	(
		macros.run "Animation Tools" "FreezeTransform"
	)
	on Tra_zero pressed do
	(
		macros.run "Animation Tools" "TransformToZero"
	)
	on Fre_rot pressed do
	(
		macros.run "Animation Tools" "FreezeRotation"	
	)
	on Rot_zero pressed do
	(
		macros.run "Animation Tools" "RotationToZero"
	)
	on selBone_btn pressed do
	(
		undo on
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
	)
	on selEnd_btn pressed do
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
	on Sel_CS pressed do
	(
		CS_All=for i in objects where (classof i==Biped_Object and (i.controller as string)!="Controller:Footsteps") collect i
		select CS_All
	)
	on UH_ALL changed state do
	(
		if state then
		(
			CS_All=for i in objects where (classof i==Biped_Object or classof i == Dummy) collect i
			hide CS_All
			Bn_All=for i in objects where (classof i==BoneGeometry) collect i
			hide Bn_All
		)
		else
		(
			CS_All=for i in objects where (classof i==Biped_Object or classof i == Dummy) collect i
			unhide CS_All
			Bn_All=for i in objects where (classof i==BoneGeometry) collect i
			unhide Bn_All
		)
	)
	on UH_CS changed state do
	(
		if state then
		(
			CS_All=for i in objects where (classof i==Biped_Object or classof i == Dummy) collect i
			hide CS_All
		)
		else
		(
			CS_All=for i in objects where (classof i==Biped_Object or classof i == Dummy) collect i
			unhide CS_All
		)
	)
	on UH_BN changed state do
	(
		if state then
		(
			Bn_All=for i in objects where (classof i==BoneGeometry) collect i
			hide Bn_All
		)
		else
		(
			Bn_All=for i in objects where (classof i==BoneGeometry) collect i
			unhide Bn_All
		)
	)
	on OK_btn pressed do
	(
		objKeys = selection as array
		undo on
		(
			if Sel_chk.checked then
			(
				if Rot_chk.checked  do			
				(
				for f = 1 to objKeys.count do (deleteKeys objKeys[f].rotation.controller #selection)
				)
					
				if Pos_chk.checked  do
				(
				for g = 1 to objKeys.count do (deleteKeys objKeys[g].pos.controller #selection)
				)
					
				if Scale_chk.checked  do
				(
				for h = 1 to objKeys.count do (deleteKeys objKeys[h].scale.controller #selection)
				)
			)
			else
			(
				if Rot_chk.checked  do			
				(
				for j = 1 to objKeys.count do delRot objKeys[j]
				)
					
				if Pos_chk.checked  do
				(
				for k = 1 to objKeys.count do delPos objKeys[k]
				)
					
				if Scale_chk.checked  do
				(
				for l = 1 to objKeys.count do delScale objKeys[l]
				)
			)
		)
	)
	on OK_btn1 pressed do
	(
		try
		(
			undo on
			(
				lastObjNum = selection.count
				lastObj = selection[lastObjNum]
				--biped??
				if (classof lastObj) == Biped_Object then
				(
					if lastObj.name == lastObj.controller.rootName then
					(
						bipedKeys_COM_ver = lastObj[3][1].keys
						bipedKeys_COM_hor = lastObj[3][2].keys
						--for p = 1 to bipedKeys_COM_hor.count do appendkey bipedKeys_COM_ver bipedKeys_COM_hor[p]
						bipedKeys_COM_trun = lastObj[3][3].keys
							
						--deselect selection[lastObjNum]
							
						if Pos_chk1.checked do
						(
							for i = 1 to bipedKeys_COM_ver.count do
							(
								sliderTime = bipedKeys_COM_ver[i].time
								max set key all position
							)
							for q = 1 to bipedKeys_COM_hor.count do
							(
								sliderTime = bipedKeys_COM_hor[q].time
								max set key all position
							)
						)
						if Rot_chk1.checked do
						(
							for i = 1 to bipedKeys_COM_trun.count do
							(
								sliderTime = bipedKeys_COM_trun[i].time
								max set key all rotation
							)
						)					
					)
					else
					(
						bipedKeys = lastObj[3].keys
							
						for i = 1 to bipedKeys.count do
						(
							sliderTime = bipedKeys[i].time
							if Pos_chk1.checked do
							(
								max set key all position
							)
							if Rot_chk1.checked do
							(
								max set key all rotation
							)
						)
					)
				)
				else
				(
					--????	
					lastObjKeys_pos = lastObj[3][1].keys
					lastObjKeys_rot = lastObj[3][2].keys
						
					if Pos_chk1.checked do
					(
						for i = 1 to lastObjKeys_pos.count do
						(
							sliderTime = lastObjKeys_pos[i].time
							max set key all position
						)
					)
					if Rot_chk1.checked do
					(
						for i = 1 to lastObjKeys_rot.count do
						(
							sliderTime = lastObjKeys_rot[i].time
							max set key all rotation
						)
					)
				)
			)
		)
	catch()
	)
	on keyBip_btn pressed do
	(
		try
		(
			for i = animationRange.start to animationRange.end do
			(
				biped.addNewKey $.transform.controller i
			)
		)catch()
	)
	
	on btn111 pressed do
	(
		try (
			t=trackviewnodes;n=t[#Max_MotionClip_Manager];
			deleteTrackViewController t n.controller;
			)
		catch ""
		delete $'particle view*';
		(getproperty trackviewnodes.Anim_Layer_Control_Manager.controller #animlayers).count=0
	
	    max file save -- all-clear，save
	
        --DestroyDialog cleanandsave
	)
	
	
)


rollout eR "Bip" width:168 height:168
(
	global  obj_r_lag  
	global  obj_xyz_lag 
	global  obj_tcb_lag 
	button btn_SelectAnimMaxFile "Start" pos:[22,26] width:77 height:21 toolTip:"           批量套用动画\n先选择导出的bip要保存的地址\n  再选择需要导入的Skin文件"
	--checkbox chk1 "Save MAX Objects" pos:[19,14] width:13 height:14
	--label lbl12 "Save MAX Objects" pos:[41,14] width:113 height:18
	
	local exportobjects = false
	
	GroupBox grp28 "Batch Export Bip" pos:[8,6] width:110 height:55
	
	GroupBox grp1 "Setting" pos:[8,66] width:110 height:43
	button obj_r "Res" pos:[14,85] width:30 height:18 toolTip:"         重置属性为XYZ属性\n 重置后将无法保留原始动画信息"
	button obj_xyz "XYZ" pos:[44,85] width:30 height:18 toolTip:"将选择的骨骼属性转为XYZ"
	button obj_tcb "TCB" pos:[74,85] width:30 height:18 toolTip:"将选择的骨骼属性转为TCB"
	
	GroupBox grp228 "Clear CS Group" pos:[8,109] width:110 height:55 
	button Btn_BipedCopyCollectToClear "ClearCSGroup" pos:[22,129] width:77 height:21 toolTip:"清空Copy中的CS集合"
	
	
	
	
	
	
	on btn_SelectAnimMaxFile pressed do
	(
		
		outPath = getSavePath caption:"Save Files To..." initialDir:maxfilepath
		AnimMaxFilePath = getFilenamePath outPath
		AnimMaxFilePath += "max\\" 
		makeDir AnimMaxFilePath all:true
		SkinFile = getOpenFileName caption:"Open Skin File" types:"3ds Max(*.max)"
		Files = getFiles (maxfilepath + "*.max")
		for i in Files do
		(
			loadMaxFile i useFileUnits:true quiet:true	
			AnimRangeTmp = animationrange
			FinalPath = outPath
			FinalPath += "//"
			FinalPath += getFilenameFile i
			FinalPath += ".bip"
			if $bip001 != undefined then
			(
				AnimMaxFilePathTmp = AnimMaxFilePath
				AnimMaxFilePathTmp += getFilenameFile i
				AnimMaxFilePathTmp += ".max"
				if exportobjects then
				(
					biped.saveBipFileSegment $bip001.controller FinalPath animationrange.start animationrange.end #saveMaxObjects
				)
				else
				(
					biped.saveBipFileSegment $bip001.controller FinalPath animationrange.start animationrange.end
				)
				loadMaxFile SkinFile useFileUnits:true quiet:true	
				biped.loadBipFile $bip001.controller FinalPath
				animationrange = AnimRangeTmp
				saveMaxFile AnimMaxFilePathTmp
			)
			AnimMaxFilePathTmp = ""
		)
	)
	on obj_r pressed do
	(
	       for o in selection do
	           (
	              o.controller = transform_script ()   
				  o.controller = prs()
			   )
	)
	on obj_xyz pressed do
	(
	       for o in selection do
	           (
	              o.position.controller =Position_XYZ()
			      o.rotation.controller =Euler_XYZ()
	           )
	)
	on obj_tcb pressed do
	(
		   for o in selection do
			   (
	              o.position.controller =TCB_Position()
	              o.rotation.controller =TCB_Rotation()
			    )
	
	)------------XYZchangeTCB---------

    on Btn_BipedCopyCollectToClear pressed do
	(
		try
		(
			local BipedCOM_Array = #()
			for tObj in ( Objects as array ) where ClassOf tObj == Biped_Object do 
			(
				local TempBipedCOM = Biped.GetNode tObj #Vertical
				if (FindItem BipedCOM_Array TempBipedCOM) == 0 do append BipedCOM_Array tObj 
			)
			for tCom in BipedCOM_Array do Biped.DeleteAllCopyCollections tCom.controller 
		)
		Catch
		(
			print "Error"
		)
	)	
	
)

rollout fr "Get motion" width:162 height:120
(
	
	
	--spinner endnum "" pos:[82,8] width:56 height:16 range:[-99999,99999,0] type:#integer scale:1 
 
	editText timenum "Frames=" pos:[8,5] width:110 height:17
	
	edittext Sp1 "V =" pos:[15,28] width:80 height:17
	
    edittext Len1 "L =" pos:[15,50] width:80 height:17
	
	button Cl1 "clean" pos:[50,80] width:44 height:20

	
	
	on fr open do
	(
		timenum.text=num as string
		t = num
	)
	
	
	on Cl1 pressed do
	(
		Sp1.text = ""
		Len1.text = ""
		
	)
	

	on Sp1 changed text do
		(
			if t != num then
	           (
		           timenum.text=num as string
		           t = num
	               Len1.text = ((Sp1.text as float) * ( num / 30))as string
			   )
			else
			   (
			       Len1.text = ((Sp1.text as float) * ( num / 30))as string
			   )
		)
		
	on Len1 changed text do
		(
			if t != num then
	           (
		           timenum.text=num as string
		           t = num
				   Sp1.text = ((Len1.text as float)/( num /30))as string
			   )
			else 
			   (
				   Sp1.text = ((Len1.text as float)/( num /30))as string
			   )
		)	  
	
	
	
		
	on startnum changed range do
	    (	
			animationRange = Interval animationRange.end startnum.value
			num=(animationRange.end-animationRange.start)as float/ticksperframe
			timenum.text=num as string
            Len1.text = ((Sp1.text as float) * ( num / 30))as string
		)			
	on endnum changed range do
	    (
			animationRange = Interval animationRange.start endnum.value
			num=(animationRange.end-animationRange.start)as float/ticksperframe
			timenum.text=num as string
            Len1.text = ((Sp1.text as float) * ( num / 30))as string
		)			
	

)




	try(DestroyDialog myrollout) catch()

rollout myrollout "AnimationTool" width:152 height:124
(
		global lastend=100;
		global laststart=0;
		global timescan=1;
		global num=0;
		
	Timer tmr1 "Timer" pos:[0,0] width:24 height:24 interval:100 
	radiobuttons rdo1 "" pos:[12,5] width:141 height:16 labels:#("1/4x", "1/2x", "1x") default:3 columns:3 
	spinner startnum "" pos:[8,28] width:56 height:16 range:[-99999,99999,0] type:#integer scale:1 
	label lbl1 "To" pos:[68,28] width:15 height:16 
	spinner endnum "" pos:[82,28] width:56 height:16 range:[-99999,99999,0] type:#integer scale:1 

	checkbutton g "All" pos:[10,57] width:40 height:20  toolTip:"过滤选择为所有" 
	checkbutton h "Geometry" pos:[50,57] width:54 height:20  toolTip:"过滤选择为模型"
	checkbutton i "Bone" pos:[104,57] width:40 height:20  toolTip:"过滤选择为骨骼"
	
	checkbutton a "Multiple" pos:[10,81] width:44 height:20  toolTip:"模型" 
	checkbutton b "Material" pos:[54,81] width:44 height:20 toolTip:"材质" 
	checkbutton c "Name" pos:[98,81] width:44 height:20 toolTip:"命名" 
	checkbutton d "Animat" pos:[10,101] width:44 height:20 toolTip:"动画"
	checkbutton e "Bip" pos:[54,101] width:44 height:20 toolTip:"骨骼"
	checkbutton f "Motion" pos:[98,101] width:44 height:20 toolTip:"计算输出位移"
	subRollout sub_Rollout "" pos:[5,126] width:0 height:0 
	

	
	
	

		
	
	on myrollout open do
	(
	timeConfiguration.playbackSpeed=3
	temptime = localTime as string
	temps=filterString temptime ":"
	lastsecond=temps[2] as integer
	tempst=animationRange.start as integer
	startnum.value=animationRange.start
	endnum.value=animationRange.end  
	)
	
	on rdo1 changed stat do
	(
		timeConfiguration.playbackSpeed=stat
	)
	/*
	on startnum entered do
	(
		animationRange = Interval animationRange.end startnum.value
	)
	on endnum entered do
	(
		animationRange = Interval animationRange.start endnum.value
	)
	*/
	
	on tmr1 tick do
	if timescan==1 then
	(	 
		if laststart!=animationRange.start or lastend!=animationRange.end then 
		(
			startnum.value=animationRange.start
			endnum.value=animationRange.end
			laststart=animationRange.start;
			lastend=animationRange.end;
		)	
		laststart=animationRange.start;
		lastend=animationRange.end;
		changebipname=""
		num=(animationRange.end-animationRange.start)as float/ticksperframe --获取帧数
	)
	
    on startnum changed range do
	    (	
			animationRange = Interval animationRange.end startnum.value
			num=(animationRange.end-animationRange.start)as float/ticksperframe
			--timenum.text=num as string
           -- Len1.text = ((Sp1.text as float) * ( num / 30))as string
		)			
	on endnum changed range do
	    (
			animationRange = Interval animationRange.start endnum.value
			num=(animationRange.end-animationRange.start)as float/ticksperframe
			fr.timenum.text = num as string
			--timenum.text=num as string
            --Len1.text = ((Sp1.text as float) * ( num / 30))as string
		)			

	
	
	
	fn alloff a =
		(
			a.Checked = off
			b.Checked = off
			c.Checked = off
			d.Checked = off
			e.Checked = off
			f.Checked = off
			removeSubRollout myrollout.sub_Rollout aR
			removeSubRollout myrollout.sub_Rollout bR
			removeSubRollout myrollout.sub_Rollout cR
			removeSubRollout myrollout.sub_Rollout dR
			removeSubRollout myrollout.sub_Rollout eR
			removeSubRollout myrollout.sub_Rollout fR
		)
		
	fn alloff01 b =
		(
			g.Checked = off
			h.Checked = off
			i.Checked = off			
		)
		on g changed state do
	(
		if state == on then
		(
			alloff01 b
			SetSelectFilter 1
			g.Checked = on
		)
		
	)
		on h changed state do
	(
		if state == on then
		(
			alloff01 b
			SetSelectFilter 2

			h.Checked = on
		)
		
	)
		on i changed state do
	(
		if state == on then
		(
			alloff01 b
			SetSelectFilter 8

			i.Checked = on
		)
		
	)
	
	on a changed state do
	(
		if state == on then
		(
			alloff a
			myrollout.height = 415
			myrollout.sub_Rollout.height = 415
			myrollout.sub_Rollout.width = 138
			a.Checked = on
			addSubRollout myrollout.sub_Rollout aR
		)
		else
		(
			myrollout.height -= 289
			myrollout.sub_Rollout.height -= 289
			removeSubRollout myrollout.sub_Rollout aR
		)
	)
	on b changed state do
	(
		if state == on then
		(
			alloff a
			myrollout.height = 234
			myrollout.sub_Rollout.height = 234
			myrollout.sub_Rollout.width = 138
			b.Checked = on
			addSubRollout myrollout.sub_Rollout bR
		)
		else
		(
			myrollout.height -= 110
			myrollout.sub_Rollout.height -= 110
			removeSubRollout myrollout.sub_Rollout bR
		)
	)
	on c changed state do
	(
		if state == on then
		(
			alloff a
			myrollout.height = 334
			myrollout.sub_Rollout.height = 334
			myrollout.sub_Rollout.width = 138
			c.Checked = on
			addSubRollout myrollout.sub_Rollout cR
		)
		else
		(
			myrollout.height -= 210
			myrollout.sub_Rollout.height -= 210
			removeSubRollout myrollout.sub_Rollout cR
		)
	)
	on d changed state do
		(
			if state == on then
			(
				alloff a
				myrollout.height = 634
				myrollout.sub_Rollout.height = 634
				myrollout.sub_Rollout.width = 138
				d.Checked = on
				addSubRollout myrollout.sub_Rollout dR
			)
			else
			(
				myrollout.height -= 510
				myrollout.sub_Rollout.height -= 510
				removeSubRollout myrollout.sub_Rollout dR
			)
		)
	on e changed state do
		(
			if state == on then
			(
				alloff a
				myrollout.height = 327
				myrollout.sub_Rollout.height = 324
				myrollout.sub_Rollout.width = 138
				e.Checked = on
				addSubRollout myrollout.sub_Rollout eR
			)
			else
			(
				myrollout.height -= 203
				myrollout.sub_Rollout.height -= 203
				removeSubRollout myrollout.sub_Rollout eR
			)
		)
		on f changed state do
		(
			if state == on then
			(
				alloff a
				myrollout.height = 260
				myrollout.sub_Rollout.height = 260
				myrollout.sub_Rollout.width = 138
				f.Checked = on
				addSubRollout myrollout.sub_Rollout fR
			)
			else
			(
				myrollout.height -= 135
				myrollout.sub_Rollout.height -= 135
				removeSubRollout myrollout.sub_Rollout fR
			)
		)
)
CreateDialog myrollout