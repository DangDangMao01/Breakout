-------------------------------------------------------
-------------------AnimationTool-----------------------
------------------Time:2019-09-20----------------------
-------------------Author:乔磊-------------------------
------------------QQ:409856476-------------------------
-------------------------------------------------------


	rollout Filter_Tool "快捷隐藏选择" width:162 
	(
		group "快捷隐藏"
		(
			button 'H_all' "一键隐藏"   height:21  align:#left across:3
			button 'clean_Bone_Name' "!" tooltip:"重置"  
			button 'skinHide' "简捷显示" tooltip:"只显示蒙皮骨骼"  align:#right
		)
		
		group "选择隐藏"
		(
			checkbox 'HideEnd' "隐藏末端"  width:63 height:15 checked:true align:#left
			checkbox 'HideHP' "隐藏HP"  width:58 height:15 checked:true align:#left
			checkbox 'Face_bone' "隐藏表情骨骼"  width:90 height:15 checked:true align:#left
			checkbox 'Face_bone_p' "隐藏表情控制器" width:101 height:15 checked:true align:#left
			checkbox 'mouth_bone' "隐藏嘴部动画" width:101 height:15 checked:true enabled:false align:#left

			button 'HideAll' "执行隐藏"   height:21 
		
		)
		group "过滤显示"
		(
			checkbutton 'Filter_all' "All"   height:20 toolTip:"过滤选择为所有" align:#left across:3
			checkbutton 'Filter_G' "Geometry"   height:20 toolTip:"过滤选择为模型" offset:[-7,0]
			checkbutton 'Filter_B' "Bone"   height:20 toolTip:"过滤选择为骨骼" align:#right
		)		
		group "属性隐藏"
		(
			checkbutton 'UH_CS' "隐藏Biped"   height:21 toolTip:"隐藏所有Biped骨骼" align:#left across:2
			checkbutton 'UH_BN' "隐藏Bone"  height:21 toolTip:"隐藏所有Bone骨骼" align:#right
		)
		

		checkbutton 'Fz_Mdl' "冻结模型"  width:64 height:24 toolTip:"冻结模型" align:#left across:2
		button 'Dis_Box' "box显示" width:64  height:24 toolTip:"将选中的物体外框显示" align:#right
		
		local objSkin  
		local Bone_Name =#()
		local skin_num = 0 				---蒙皮骨骼数
		
		fn alloff01 =
			(
				Filter_all.Checked = off
				Filter_G.Checked = off
				Filter_B.Checked = off			
			)
			
		on H_all pressed do
		(
			hide $*moduan*
			hide $*end*
			hide $*HP*
			hide $*Nub*
				
			hide $*LEyelid*
			hide $*REyelid*
			hide $*LEyeball*
			hide $*REyeball*
									
			hide $*BQ*
			hide $*Mouth_1
									
			hide $*expr_Leyelid_all
			hide $*expr_Reyelid_all
			hide $*Leyebrows*
			hide $*Reyebrows*

			hide $*Mouth_all
			hide $*Nose_all
			hide $*biaoqing*
					
						
			hide $*P_Con*
			hide $*L_Con*	
			hide $*R_Con*	
								
								


			hide $*Con_Point*
			hide $*DCon*
			hide $*DConP*
			hide $*P1_Con*
			hide $*P2_Con*
			hide $*MidPoint*
			hide $*Child_Point*	
			hide $*XCon*
			hide $*XConP*
								

			if( getnodebyname "Mouth_all" exact:true ) != undefined do
			(
				hide #($Mouth_all,$BQ_bone015,$BQ_bone050,$BQ_bone051,$BQ_bone002,$BQ_bone003,$BQ_bone004,$BQ_bone031,$BQ_bone006,$BQ_bone007,$BQ_bone008,$BQ_bone009,$BQ_bone010,$BQ_bone011,$BQ_bone012,$BQ_bone026,$BQ_bone030,$BQ_bone029,$BQ_bone023,$BQ_bone024,$BQ_bone033,$BQ_bone020,$BQ_bone021,$BQ_bone022,$BQ_bone013,$BQ_bone014,$BQ_bone032,$BQ_bone016,$BQ_bone035,$BQ_bone025,$BQ_bone034,$BQ_bone027,$BQ_bone028,$BQ_bone005,$BQ_bone017,$BQ_bone001,$BQ_bone036,$BQ_bone037,$BQ_bone018,$BQ_bone019,$P_Con01,$Mouth_1,$P_Con02,$P_Con02_02,$P_Con03,$BQ_bone055,$BQ_bone056)
			)
	
		)
		
		on clean_Bone_Name pressed do
		(
			Bone_Name =#()
		)

		fn get_Skinbone_fn sele_mode = --得到蒙皮骨骼
		(

			skinOps.RemoveZeroWeights sele_mode
			skin_num = skinOps.GetNumberBones sele_mode
			local TemName =#() 
			local Tem_Name =#()
			for i =1 to skin_num  do    
			(
				TemName = skinOps.GetBoneName objSkin i 1
				try (
						Tem_Name = execute ("$"+TemName)
					)
				catch
					(
						Tem_Name = execute ("$"+"'"+TemName+"'")
					)

				append Bone_Name Tem_Name
				)
		)
		
		
		on skinHide pressed do
		(	
			if selection.count ==1 then
			(	
				max modify mode
				objSkin  = selection[1].modifiers[#Skin]
				get_Skinbone_fn objSkin
				all_bone = for i in $* where classof i == BoneGeometry or classof i == Biped_Object collect i
				select all_bone
				max hide selection
				unhide Bone_Name
				hideByCategory.shapes = true
				hideByCategory.helpers = true
				selectionSets["skin_bone"] = Bone_Name	
			)
			else
			(
				messageBox "选择单个模型 "
			)
				
				
		)
			
	
		on Face_bone changed state do
		(
			if state then
			(
				mouth_bone.checked = true
				mouth_bone.enabled = false		
			)
			else
			(
				mouth_bone.checked = true
				mouth_bone.enabled = true
			)		
		)
	
		
		
		on HideAll pressed do
		(
			max unhide all
			hideByCategory.none()	
			hide $*Nub*
			
			if HideEnd.checked then
			(
		
				hide $*moduan*
			)
				if HideHP.checked then
			(
		
				hide $HP*
			)
			
			if  Face_bone.checked then
			(
				hide $*LEyelid*
				hide $*REyelid*
				hide $*LEyeball*
				hide $*REyeball*
						
				hide $*BQ*
				hide $*Mouth_1
						
				hide $*expr_Leyelid_all
				hide $*expr_Reyelid_all
					--hide $*Leyebrows-all
				hide $*Mouth_all
				hide $*Nose_all
				hide $*biaoqing*
		
					--hide $*Reyebrows-all
				hide $*P_Con*
				hide $*L_Con*	
				hide $*R_Con*	
					
			)
			
			if  Face_bone_p.checked then
			(
				hide $*Con_Point*
				hide $*DCon*
				hide $*DConP*
				hide $*P1_Con*
				hide $*P2_Con*
				hide $*MidPoint*
				hide $*Child_Point*	
				hide $*XCon*
				hide $*XConP*
			)
			if  mouth_bone.checked then
			(
				if( getnodebyname "Mouth_all" exact:true ) != undefined do
				hide #($Mouth_all,$BQ_bone015,$BQ_bone050,$BQ_bone051,$BQ_bone002,$BQ_bone003,$BQ_bone004,$BQ_bone031,$BQ_bone006,$BQ_bone007,$BQ_bone008,$BQ_bone009,$BQ_bone010,$BQ_bone011,$BQ_bone012,$BQ_bone026,$BQ_bone030,$BQ_bone029,$BQ_bone023,$BQ_bone024,$BQ_bone033,$BQ_bone020,$BQ_bone021,$BQ_bone022,$BQ_bone013,$BQ_bone014,$BQ_bone032,$BQ_bone016,$BQ_bone035,$BQ_bone025,$BQ_bone034,$BQ_bone027,$BQ_bone028,$BQ_bone005,$BQ_bone017,$BQ_bone001,$BQ_bone036,$BQ_bone037,$BQ_bone018,$BQ_bone019,$P_Con01,$Mouth_1,$P_Con02,$P_Con02_02,$P_Con03,$BQ_bone055,$BQ_bone056)
			)		
			else
			(
				if( getnodebyname "Mouth_all" exact:true ) != undefined do
				unhide#($Mouth_all,$BQ_bone015,$BQ_bone050,$BQ_bone051,$BQ_bone002,$BQ_bone003,$BQ_bone004,$BQ_bone031,$BQ_bone006,$BQ_bone007,$BQ_bone008,$BQ_bone009,$BQ_bone010,$BQ_bone011,$BQ_bone012,$BQ_bone026,$BQ_bone030,$BQ_bone029,$BQ_bone023,$BQ_bone024,$BQ_bone033,$BQ_bone020,$BQ_bone021,$BQ_bone022,$BQ_bone013,$BQ_bone014,$BQ_bone032,$BQ_bone016,$BQ_bone035,$BQ_bone025,$BQ_bone034,$BQ_bone027,$BQ_bone028,$BQ_bone005,$BQ_bone017,$BQ_bone001,$BQ_bone036,$BQ_bone037,$BQ_bone018,$BQ_bone019,$P_Con01,$Mouth_1,$P_Con02,$P_Con02_02,$P_Con03,$BQ_bone055,$BQ_bone056)
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
				hide $*Nub*
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
				hide $*moduan*
			)
		)
		on Filter_all changed state do
		(
			if state == on then
			(
				alloff01()
				SetSelectFilter 1
				Filter_all.Checked = on
			)
			
		)
		on Filter_G changed state do
		(
			if state == on then
			(
				alloff01() 
				SetSelectFilter 2
		
				Filter_G.Checked = on
			)
			
		)
		on Filter_B changed state do
		(
			if state == on then
			(
				alloff01()
				SetSelectFilter 8
		
				Filter_B.Checked = on
			)
			
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
		)
	)
	createdialog  Filter_Tool
