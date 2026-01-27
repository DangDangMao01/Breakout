rollout MainParameters "添加基础属性"
(
	global minor_ctrl = $Minor_Controller  --- 次级控制器 ---
	global main_ctrl = $Main_Controller	--- 主控制器 ---
	
	global  listName = #("original","animator","mainCon")
	global str_ExpValue_array = #("posX","posY","posZ","const_max_x","const_min_x","const_max_y","const_min_y","const_max_z","const_min_z","val_max_x","val_min_x","val_max_y","val_min_y","val_max_z","val_min_z")

	--- 添加层级和属性 ---
	--- 为次级控制器添加层级 
	--- original:原始与父层级的偏移值
	--- mainCon: 与主控制器的表达式
	--- animator:  自身动画层
	global FN_AddList,FN_AddParam
	fn FN_AddList = 		
	(
		( ---给次级控制器添加层级 ---
			minor_ctrl.pos.controller = positionlist()
			minor_ctrl.rotation.controller = rotation_list ()

			minor_ctrl.pos.controller.Available.controller = position_xyz()
			minor_ctrl.pos.controller.Available.controller = position_xyz()
			minor_ctrl.rotation.controller.Available.controller = Euler_xyz()
			minor_ctrl.rotation.controller.Available.controller = Euler_xyz()
			for i = 1 to listName.count do
			(
				minor_ctrl.pos.controller.setName i listName[i]
				minor_ctrl.rotation.controller.setName i listName[i]
			)
			minor_ctrl.pos.controller.active = 2
			minor_ctrl.rotation.controller.active = 2
		)
		(	--- 给主控制器添加层级 ---
			main_ctrl.pos.controller = positionlist()
			main_ctrl.rotation.controller = rotation_list ()

			main_ctrl.pos.controller.Available.controller = position_xyz()
			main_ctrl.rotation.controller.Available.controller = Euler_xyz()
			main_ctrl.pos.controller.setName 1 "original"
			main_ctrl.pos.controller.setName 2 "animator"
			main_ctrl.rotation.controller.setName 1 "original"
			main_ctrl.rotation.controller.setName 2 "animator"
			main_ctrl.pos.controller.active = 2
			main_ctrl.rotation.controller.active = 2
			
			--- 添加主控制 3轴向 位移限制 ---
			for i = 1 to 3 do 
			(
				main_ctrl.pos.controller[2][i].controller = float_limit()
				main_ctrl.pos.controller[2][i].controller.upper_limit = 20
				main_ctrl.pos.controller[2][i].controller.lower_limit = -20 			
			)
		)
		
	)
	fn FN_AddParam =
	(
		--- pos 层级 需要的表达式 ---
		pos_str_exp = "if( posX > 0, (posX/const_max_x)*val_max_x, (posX/const_min_x)*val_min_x)+if( posY > 0, (posY/const_max_y)*val_max_y, (posY/const_min_y)*val_min_y)+if( posZ > 0, (posZ/const_max_z)*val_max_z, (posZ/const_min_z)*val_min_z)"
		--- rotation 层级 需要的表达式 ---
		rot_str_exp = "if( posX > 0, degToRad( posX/const_max_x)*val_max_x, degToRad( posX/const_min_x)*val_min_x)+if( posY > 0, degToRad( posY/const_max_y)*val_max_y, degToRad( posY/const_min_y)*val_min_y)+if( posZ > 0, degToRad( posZ/const_max_z)*val_max_z, degToRad( posZ/const_min_z)*val_min_z)"
		
		for i = 1 to 3 do
		(
			--- pos / rotation 添加xyp 三轴向 表达式层级 ---
			minor_ctrl.pos.controller[3][i].controller = Float_Expression ()
			minor_ctrl.rotation.controller[3][i].controller = Float_Expression ()
			for j = 1 to 3 do
			(
				--- pos / rotation 为 xyz 三轴向  添加 变量 控制： 拾取main控制器  xyz 轴 ---
				minor_ctrl.pos.controller[3][i].controller.addScalarTarget str_ExpValue_array[j] main_ctrl.pos.controller[2][j] 
				minor_ctrl.rotation.controller[3][i].controller.addScalarTarget str_ExpValue_array[j] main_ctrl.pos.controller[2][j] 
			)
			for l = 4 to str_ExpValue_array.count do 
			( 
				--- count XYZ： 主控制器 三轴向能移动的最大值，   val XYZ ： 当主控制器 达到最大值时，次级控制希望达到的数值
				--- if( posX > 0, (posX/const_max_x)*val_max_x, (posX/const_min_x)*val_min_x)
				--- (posX/const_max_x)*val_max_x  :  （ 主控制器当前数值 / 主控制器最大值 ) * 次级控制器希望达到的最大值
				--- （ 主控制器当前数值 / 主控制器最大值 )： 主控制器当前 位移的百分比
				minor_ctrl.pos.controller[3][i].controller.AddScalarConstant str_ExpValue_array[l] 0
				minor_ctrl.rotation.controller[3][i].controller.AddScalarConstant str_ExpValue_array[l] 0
			)
			
			--- 写入表达式 ---
			minor_ctrl.pos.controller[3][i].controller.setExpression pos_str_exp
			minor_ctrl.rotation.controller[3][i].controller.setExpression rot_str_exp
			--- 添加次级控制器 list属性中：const_max --- 
			minor_ctrl.pos.controller[3][i].controller.SetScalarConstant "const_max_x" 20
			minor_ctrl.pos.controller[3][i].controller.SetScalarConstant "const_min_x" -20
			minor_ctrl.pos.controller[3][i].controller.SetScalarConstant "const_max_y" 20
			minor_ctrl.pos.controller[3][i].controller.SetScalarConstant "const_min_y" -20
			minor_ctrl.pos.controller[3][i].controller.SetScalarConstant "const_max_z" 20
			minor_ctrl.pos.controller[3][i].controller.SetScalarConstant "const_min_z" -20
	
		)
	)
	button 'btn_addPar' "添加属性" 
	
	on 'btn_addPar' pressed do
	(
		FN_AddList()
		FN_AddParam()
	)
	
)
global driverListName = #()
global list_count 
global FN_refList,FN_setList
(	--- sdk panel ---
	fn FN_refList = 	---刷新list列表-------
	(
		for i = 1  to listName.count do ( driverListName[i] = listName[i] )
	)
	fn FN_setList listCount:#integer strDir:#string  =
	(
		global temp_pos = minor_ctrl.pos.controller[2].value
		temp_rot = minor_ctrl.rotation.controller[2].value
		RotValue = quatToEuler temp_rot
		temp_rot = #point3
		global temp_rot = [RotValue.x,RotValue.y,RotValue.z]
		for i = 1 to 3 do
		(
			minor_ctrl.pos.controller[listCount][i].controller.SetScalarConstant strDir temp_pos[i]
-- 			minor_ctrl.rotation.controller[listCount][i].controller.SetScalarConstant strDir temp_rot[j]	
		)
	)
)
rollout SDK_Panel "SDK  Panel" 
(
	listbox DrivenList "Controller list :"  width:160 height:10
	button btn_upper "Upper" width:45 height:25 across:1
	button btn_right "Right" width:45 height:25 across:3
	button btn_refresh "Ref" width:45 height:25
	button btn_left "Left" width:45 height:25
	button btn_lower "Lower" width:45 height:25 across:1
	button btn_upperX "UpperX" width:55 height:25 across:2
	button btn_lowerX "LowerX" width:55 height:25 
	
	on DrivenList selected sel do ( list_count = sel )
	on btn_refresh pressed do
	(
		FN_refList ()
		DrivenList.items = driverListName
	)
	on btn_upper pressed do
	(
		FN_setList listCount:list_count strDir:"val_max_z" 
	)
	on btn_lower pressed do
	(
		FN_setList listCount:list_count strDir:"val_min_z" 
	)
	on btn_right pressed do
	(
		FN_setList listCount:list_count strDir:"val_min_x" 
	)
	on btn_left pressed do
	(
		FN_setList listCount:list_count strDir:"val_max_x" 
	)
	on btn_upperX pressed do
	(
		FN_setList listCount:list_count strDir:"val_max_x" 
	)
	on btn_lowerX pressed do
	(
		FN_setList listCount:list_count strDir:"val_min_x"
	)
)
global allRollout = newRolloutFloater "test" 205 590
addRollout MainParameters allRollout
addRollout SDK_Panel allRollout
SDK_Panel.open = false