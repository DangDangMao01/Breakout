------------工具箱--------------
----------Author:jiaojiao-----------




(
	
    try(destroydialog jiaojiaoTool__Box)catch()	
	
--------函数----------------
	(
		fn layerclean_fn=
		(
			local deletelayername=#()
			layer0=layermanager.getlayer 0
			layer0.current=true
			for i=1 to layermanager.count-1 do
			(
				ilayer=layermanager.getlayer i
				layername=ilayer.name
				append deletelayername layername
			)
			for l in deletelayername do
			(
				layermanager.deletelayerbyname l
			)
		)
		
		fn arrayclean_fn=
		(
			for s=selectionsets.count to 1 by -1 do
			(
				deleteitem selectionsets s
			)
		)
	)
	

 	local LastSubRollout = 1
 	
-------小UI------------------
	(
		rollout process_window "操作范围" 
		(
			radiobuttons rb_window labels:#("继承关系","选择物体","全部") columns:3 default:2
		)
		
		rollout quickrename "快速命名"
		(
			button bn_ex "EX" width:100 across:2
			button bn_high "High" width:100
			button bn_Lod "Lod" width:100 across:2
			button bn_Lv3 "Lv3" width:100 
			
		)
		rollout findname "查找替换"
		(
			button bn_xiatospace "下划线转空格" width:100  across:2
			button bn_spacetoxia "空格转下划线" width:100
			label lb_findname "搜索字符：" pos:[20,35]
			edittext et_findname "" pos:[65,35] width:160
			label lb_tihuanname "替换字符：" pos:[20,60]
			edittext et_tihuanname "" pos:[65,60] width:160
			button bn_tihuan "替换" width:100 align:#center
		)
		
		rollout prefix_suffix "前缀后缀"
		(
			label lb_prefix "前  缀：" pos:[25,5]
			edittext et_prefix "" pos:[65,5] width:160
			label lb_suffix "后  缀：" pos:[25,30]
			edittext et_suffix "" pos:[65,30] width:160
			button bn_add "添加" across:2 width:100
			button bn_remove "移除" width:100
		)
		
		rollout Special_name "特殊命名"
		(
			label lb_basename "基础命名：" pos:[20,5]
			edittext et_basename "" pos:[65,5] width:160
			button bn_sp01 "pRj_" width:50 across:5 
			button bn_sp02 "pMj_" width:50
			button bn_sp03 "pDj_" width:50
			button bn_sp04 "pBj_" width:50
			button bn_sp05 "pYj_" width:50
		)
		
		rollout serial_number "编号命名"
		(
			
			edittext et_number "Number:" pos:[65,5] width:100 align:#center
			
			edittext et_step "Step:" pos:[65,30] width:100 align:#center
			button bn_number "命名" align:#center width:100
		)
		
		rollout bonename "骨骼快速命名"
		(
			button bn_bipname "CS骨骼重置命名" width:100 across:2
			button bn_endname "end根骨命名" width:100 
			
		)
		
		rollout checkname "检查重命名"
		(
			button bn_checkname "检查重命名" width:100 align:#center
		)
		
		
		rollout fileclean "文件整理"---bingo-----
		(
			button bn_layerclean "删除空层" width:100 across:2
			button bn_arrayclean "删除集合" width:100 
			button bn_fileclean "文件整理" width:100 across:2 
			button bn_bonematclean "清除骨骼材质" width:100
			
			
			
			on bn_layerclean pressed do
			(
				layerclean_fn()
			)
			
			on bn_arrayclean pressed do
			(
				arrayclean_fn()
			)
			
			on bn_fileclean pressed do
			(
				scenepathname=maxfilepath+maxfilename------获取当前文件路径和名字
				scenename=getfilenamefile scenepathname----------从中获取文件名
				if scenename.count!=0 then
				(
					fsn=findstring scenename "("-----------寻找文件名中“（”
					if fsn !=undefined then------------如果文件名中有“（”则返回数字，不等于undefined
					(
						newname=substring scenename 1 ((fsn as integer)-1)----------则删掉括号及其内容，得到新名字
					)
					else
					(
						newname=scenename
					)
					 fnewn=findstring newname "@"-------------------寻找新文件名中有“@”
				
					if fnewn !=undefined then----------------------再次判断文件名中是否有“@”，有则返回数字
					(
						mesh2name=substring newname 1 ((fnewn as integer) - 1)-------------删掉@后内容，得到新名字即为这个文件里内容的正确名字
					)
					else
					(
						mesh2name=newname
					)
					
					f2n=findstring mesh2name "_Cloth"
					if f2n != undefined then 
					(
						meshname=substring mesh2name 1 ((f2n as integer)-1)
					)
					else
					(
						meshname=mesh2name
					)
					print meshname

				)
				
				else
				(
					messagebox "请保存文件"
					return meshname
				)
				
		---------------------------------------------------------------------------
				delete $'particle view*'
				 
				
				arrayclean_fn()
				 
		---------------------------------------------------------------------------
				local sc_camera=#()
				sc_camera=for c in objects where (classof c==targetobject or classof c==Targetcamera or classof c==freecamera) collect c
				 if sc_camera.count!=0 do
				(
					cameralayername=(meshname as string) + "_camera"
					cameralayer=layermanager.newlayerfromname cameralayername
					cameralayer=layermanager.getlayerfromname cameralayername
					for i in sc_camera do
					(
						cameralayer.addnode i
					)
					
					
				)
				 
		--------------------------------------------------------------------------------
				local sc_bip=#()
				sc_bip=for b in objects where (classof b==biped_object)collect b
				if sc_bip.count!=0 do
				(
					biplayername=(meshname as string) + "_BIP"
					biplayer=layermanager.newlayerfromname biplayername
					biplayer=layermanager.getlayerfromname biplayername
					for i in sc_bip do
					(
						biplayer.addnode i
					)
					selectionsets["BIP"]=sc_bip
				)
				 
		-----------------------------------------------------------------------------------------
				local sc_bone=#()
				sc_bone=for o in objects where (classof o==bonegeometry)collect o
				if sc_bone.count!=0 do
				(
					bonelayername=(meshname as string) + "_bone"
					bonelayer=layermanager.newlayerfromname bonelayername
					bonelayer=layermanager.getlayerfromname bonelayername	
					for i in sc_bone do
					(
						bonelayer.addnode i
					)
					selectionsets["Bone"]=sc_bone
				)
				
				
		----------------------------------------------------------------------------------------
				local sc_helper=#()
				helpername=#("TX_Shoot","TX_Middle","TX_Foot_R","TX_Foot_L","TX_Xiong","TX_Tou","TX_Hand_R","TX_Hand_L","TX_Eye_R","TX_Eye_L")
				
				for h=1 to helpername.count do
				(
					hname=helpername[h]
					
					for i in objects where (i.name==helpername[h]) do
					(
						append sc_helper i
					)
					
				)
				
				for i in $*TX_Guadian* do
				(
					append sc_helper i
				)
				
				if sc_helper.count!=0 do
				(
					helperlayername=(meshname as string) + "_helpers"
					helperlayer=layermanager.newlayerfromname helperlayername
					helperlayer=layermanager.getlayerfromname helperlayername
					for p in sc_helper do
					(
						helperlayer.addnode p
					)
				)
				
		------------------------------------------------------------------------------------------
				local sc_guadian=#()
				sc_guadian=for i in $*TX_Weapon* where (classof i==point or classof i==helper)collect i
				if sc_guadian.count!=0 do
				(
					guadianlayername=(meshname as string) + "_Guadian"
					guadianlayer=layermanager.newlayerfromname guadianlayername
					guadianlayer=layermanager.getlayerfromname guadianlayername
					for g in sc_guadian do
					(
						guadianlayer.addnode g
					)
				)
				
		---------------------------------------------------------------------------------------------
				lodmeshname=meshname + "_Lod"
				lv3meshname=meshname + "_Lv3"
				local sc_highmesh=#()
				local sc_lodmesh=#()
				local sc_lv3mesh=#()
				local sc_mesh=#()
				
				
				
				for i in execute ("$"+"*"+meshname+"*") do
				(
					
						append sc_mesh i
					
				)
				
				
				
				
				
				for lo in sc_mesh do 
				(
					if lo.name==lodmeshname do
					(
						append sc_lodmesh lo
						a=finditem sc_mesh lo
						deleteitem sc_mesh a
					)
				)
				
				for lv in sc_mesh do 
				(
					if lv.name==lv3meshname do
					(
						append sc_lv3mesh lv
						a=finditem sc_mesh lv
						deleteitem sc_mesh a
					)
				)
				
				sc_highmesh=sc_mesh
				
			
				if sc_highmesh.count!=0 do
				(
					highlayername=(meshname as string) 
					highlayer=layermanager.newlayerfromname highlayername
					highlayer=layermanager.getlayerfromname highlayername
					for h in sc_highmesh do
					(
						highlayer.addnode h
					)
				)
				
				if sc_lodmesh.count!=0 do
				(
					lodlayername=(meshname as string) + "_Lod"
					lodlayer=layermanager.newlayerfromname lodlayername
					lodlayer=layermanager.getlayerfromname lodlayername
					for lo in sc_lodmesh do
					(
						lodlayer.addnode lo
					)
				)
				
				if sc_lv3mesh.count!=0 do
				(
					lv3layername=(meshname as string) + "_Lv3"
					lv3layer=layermanager.newlayerfromname lv3layername
					lv3layer=layermanager.getlayerfromname lv3layername
					for lv in sc_lv3mesh do
					(
						lv3layer.addnode lv
					)
				)
				
		-------------------------------------------------------------------------------------------------
				local sc_end=#()
				sc_end=for i in objects where (classof i==bonegeometry and i.children.count==0)collect i

				
				for i in sc_end do
				(
					iparent=i.parent
					if classof iparent==biped_object do
					(
						a=finditem sc_end i
						deleteitem sc_end a
						append sc_bone i
						bonelayer=layermanager.getlayerfromname bonelayername
						bonelayer.addnode i
					)
				)

				for n in $*nub* do
				(
					append sc_end n
				)
				
				if sc_end.count!=0 do
				(
					endlayername=(meshname as string) + "_ends"
					endlayer=layermanager.newlayerfromname endlayername
					endlayer=layermanager.getlayerfromname endlayername
					for d in sc_end do
					(
						endlayer.addnode d
					)
				)
				
				
		-----------------------------------------------------------------------------------------------------------------
				local facebone=#()
				for i in $*eye* do
				(
					if classof i==bonegeometry do
					(
						append facebone i
					)
				)
				
				for i in $*mouth* do
				(
					if classof i==bonegeometry do
					(
						append facebone i
					)
				)
				
				if facebone!=0 do
				(
					facebonelayername=(meshname as string) + "_facebone"
					facebonelayer=layermanager.newlayerfromname facebonelayername
					facebonelayer=layermanager.getlayerfromname facebonelayername
					for f in facebone do
					(
						facebonelayer.addnode f
					)
				)
				
				
		------------------------------------------------------------------------------------------------------------
				layerclean_fn()
				
		------------------------------------------------------------------------------------------------------
				messagebox "请检查其他模型是否删除"
			)
			
			on bn_bonematclean pressed do
			(
				for i in objects where classof i==Biped_Object or classof i==BoneGeometry do
				(
					i.material=undefined
				)
			)
			
			
			
			
		
		)
		
		rollout meshguifan "模型规范化"
		(
			button bn_localrotate "轴向矫正" width:100 across:2
			button bn_resetxform "重置变换" width:100
			button bn_collapse "命令塌陷" width:100 across:2
			button bn_cleanUV "清除多UV" width:100 
			
			
		
		)
		
		rollout bonetool "通用工具"
		(
			button bn_xyztotcb "XYZ--TCB" width:100 across:2
			button bn_tcbtoxyz "TCB--XYZ" width:100
			button bn_freezetransform "冻结变换" width:100 across:2
			button bn_transformtozero "Transform to Zero" width:100
			button bn_parent "父子链接" width:100 across:2 toolTip:"依次选取物体"
		)
		
		rollout bipedcreate "CS骨骼创建"
		(
			checkbox cb_arms "Arms" width:100 align:#center  checked:true
			spinner sp_neck "Neck Links:" width:100 range:[1,25,1] type:#integer align:#center
			spinner sp_spine "Spine Links:" width:100 range:[1,25,3] type:#integer align:#center
			spinner sp_leg "Leg Links:" width:100 range:[3,4,3] type:#integer align:#center
			spinner sp_tail "Tail Links:" width:100 range:[0,25,0] type:#integer align:#center
			spinner sp_ponytail1 "Ponytail1 Links:" width:100 range:[0,25,0] type:#integer align:#center
			spinner sp_Ponytail2 "Ponytail2 Links:" width:100 range:[0,25,0] type:#integer align:#center
			spinner sp_fingers "Fingers:" width:100 range:[0,5,5] type:#integer align:#center
			spinner sp_fingerlinks "Finger Links:" width:100 range:[1,4,3] type:#integer align:#center
			spinner sp_Toes "Toes:" width:100 range:[1,5,1] type:#integer align:#center
			spinner sp_toelinks "Toe Links:" width:100 range:[1,3,1] type:#integer align:#center
			label lb_props "Props:" across:4
			checkbox cb_prop1 "1"  checked:False
			checkbox cb_prop2 "2"  checked:False
			checkbox cb_prop3 "3"  checked:False
			spinner sp_height "Height:" width:100 range:[0.001,1000,180]  align:#center
			spinner sp_upperarm "Upper Arm:" width:100 range:[0,10,0] type:#integer align:#center
			spinner sp_forerarm "Forerarm:" width:100 range:[0,10,0] type:#integer align:#center
			spinner sp_thigh "Thigh:" width:100 range:[0,10,0] type:#integer align:#center
			spinner sp_calf "Calf:" width:100 range:[0,10,0] type:#integer align:#center
			edittext et_bipedname "Name:" text:"Bip001" align:#center width:180
			button bn_bipedcreate "Create" align:#center width:150
		)
		
		rollout bonecreate "Bone骨骼快速创建"
		(
			group "裙摆"
			(
				button bn_qianqun "前裙摆" width:100 across:2
				button bn_houqun "后裙摆" width:100 
				button bn_zuoqianqun "左前裙摆" width:100 across:2
				button bn_youqianqun "右前裙摆" width:100 
				button bn_zuohouqun "左后裙摆" width:100 across:2
				button bn_youhouqun "右后裙摆" width:100
			)
			
			group "头发"
			(
				button bn_zuoliuhai "左刘海" width:100 across:2
				button bn_youliuhai "右刘海" width:100 
				button bn_gaomawei "高马尾" width:100 across:2
				button bn_changpijian "长披肩" width:100 
			)
			
			group "其他"
			(
				button bn_zuoxiuzi "左袖子" width:100 across:2
				button bn_youxiuzi "右袖子" width:100 
				button bn_zuojiandai "左肩带" width:100 across:2
				button bn_youjiandai "右肩带" width:100 
				button bn_zuoxiong "左胸" width:100 across:2
				button bn_youxiong "右胸" width:100 
				button bn_zuojianjia "左肩甲" width:100 across:2
				button bn_youjianjia "右肩甲" width:100 
			)
			group ""
			(
				button bn_root "Root创建" width:100 across:2
				button bn_end "批量创建ends" width:100 
				button bn_mirrorbone "骨骼镜像" width:100 across:2
			)
			
		)
		
		rollout helpercreate "挂点创建"
		(
			button bn_helpercreate "一键生成挂点" width:150
		)
		
		rollout yushebone "预设骨骼创建"
		(
			group ""
			(
				dropdownlist ddl_yushebone "预设骨骼列表:" items:#("男时装","女时装")
				button bn_yushecreate "创建" width:150
			)
			group""
			(
				edittext et_yushebone "预设骨骼名：" width:200
				button bn_shengchengyushe "生成预设" width:150
			)
		)
		
		rollout constraints "约束"
		(
			group "单约束"
			(
				button bn_pos "位置约束"  width:100  toolTip:"依次选取物体" across:2
				button bn_rot "方向约束" width:100  toolTip:"依次选取物体"
			)
			
			group "双约束"
			(
			spinner sp_helpsize "控制器尺寸:"  range:[0.01,100,1] scale:0.1  align:#left
			colorPicker cp_helpColor "控制器颜色:"  color:[0,255,0] modal:false  align:#left  
			edittext et_helpname "控制器命名"  width:150  align:#left 
			button bn_poslook "位置注视约束"  width:100  toolTip:"依次选取物体" across:2
			button bn_posrot "位置方向约束"  width:100  toolTip:"依次选取物体" 
			)
			
			group "Link约束"
			(
				button bn_linktoobject "Link to Object"  width:100  toolTip:"依次选取物体" across:2
				button bn_linktoworld "Link to World"  width:100  
			)
			
		)
		
		rollout mirrorcontrol "镜像"
		(
			radiobuttons rb_mirror1 labels:#("Position","Rotation","Scale") columns:3 default:1
			radiobuttons rb_mirror2 labels:#("X","Y","Z") columns:3 default:1
			button bn_mirrorduiqi "镜像对齐"  width:100  toolTip:"依次选取物体" across:2
			button bn_mirrorkongzhi "镜像控制"  width:100  toolTip:"依次选取物体"
		)
	
	)
	
 	
-------UI列表------------------
 	ToolBox_Rollouts = #(
 		#("  通  用  ",#(fileclean,meshguifan,bonetool)),
 		#("  命  名  ",#(process_window,quickrename,findname,prefix_suffix,Special_name,serial_number,bonename,checkname)),
 		#("  骨  骼  ",#(bipedcreate,bonecreate,helpercreate,yushebone)),
 		#("  绑  定  ",#(constraints,mirrorcontrol)),
		#("  蒙  皮  ",#(constraints))	
 	)	
 	

-------大UI----------------------
	rollout jiaojiaoTool__Box "工具箱" 
	(
		dotNetControl dn_tabs "System.Windows.Forms.TabControl" height:20 width:300 align:#left
		subRollout theSubRollout width:270 height:450 align:#center
				
		on dn_tabs Selected itm do
		(
			if LastSubRollout != (itm.TabPageIndex+1) do --do not update if the same tab clicked twice
			(
				for subroll in ToolBox_Rollouts[LastSubRollout][2] do
				removeSubRollout theSubRollout subroll
				for subroll in ToolBox_Rollouts[LastSubRollout = itm.TabPageIndex+1][2] do	
				addSubRollout theSubRollout subroll
			) 
		)--end tabs clicked		
				
		on jiaojiaoTool__Box open do
		(
			for aTab in ToolBox_Rollouts do
			(
				dn_tabs.TabPages.add aTab[1]
			)
			for subroll in ToolBox_Rollouts[1][2] do 
			(
				
				addSubRollout theSubRollout subroll	
			)
			
			
				
		)
	)

	
--------功能-----------
	
	
	
	
	createDialog jiaojiaoTool__Box 300 500
)
