rollout Legref "自定义腿部"
(

----------------------------------------------------------------------------------------------------------
	-----------------------------------------按钮--------------------------------------------------
	button 'btn_cre' "创建腿部对位" 
	button 'btn_legCreat' "创建腿部系统" 
	
-----------------------------------------------------------------------------------------------------------
----------------------------------------------局部变量-----------------------------------------	
	
	
	
	local l_pointNodeLeg = #()
	local r_pointNodeLeg = #()
	
	local l_pointNodeLegR = #()
	local r_pointNodeLegR = #()
	
	local l_RefBone = #()
	local r_RefBone = #()
	
	
	local l_legBone = #()
	local r_legBone = #()
	
	local 	legBoneName = #("BN_upperLeg_L","BN_knee_L","BN_lowerLeg_L","BN_ankle_L","BN_tip_L")
---------------------------------------------------------------------------------------------------------	
	------------------------------------------场景判定函数----------------------------------------------
	fn max_units = --获得场景单位			
	(
		
			case units.DisplayType of
			(
				#Generic:
				(
					Case units.SystemType of
					(
					#Inchse: "In"
					#Feet:"ft"
					#Miles:"miles"
					#Millimeters :"milim"
					#Centimeters:"centi"
					#Meters:"meters"
					#Kilometers:"kilometers"
					)
				)
				#metric:
				(
					Case units.MetricType of
					(
					#Millimeters :100
					#Centimeters:1
					#Meters:0.05
					#Kilometers:0.001

					)
				)

				#US:
				(
					Case units.USType of
					(
					#Frac_In:"frac_In"
					#Dec_In:"dec_In"
					#Frac_Ft:"frac_ft"
					#Dec_Ft:"dec_IFt"
					#Ft_Frac_In:"ft_frac"
					#Ft_Dec_In:"ft_dec"

					)
				)
			)	
		
	)
	
				 local unitis_value = max_units()  --获取场景尺寸
-------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------腿部坐标值----------------------------------------------------------------------------------------	
	local l_pointStore = 
	#(    --左腿虚拟体
		(matrix3 [0.0526416,0.0644327,-0.996532] [-0.00240568,-0.997905,-0.0646485] [-0.99861,0.00580053,-0.0523764] [9.26485,-2.1575,112.602]),
		(matrix3 [0.0526967,0.113537,-0.992135] [0.000196498,-0.993517,-0.113684] [-0.99861,0.00579587,-0.0523773] [11.5077,0.587707,70.1434]),
		(matrix3 [0.0526228,0.162365,-0.985326] [0.00279342,-0.986714,-0.162444] [-0.998611,0.0057959,-0.052377] [11.8345,1.29188,63.9901]),
		(matrix3 [0,-0.850683,-0.525678] [-2.98023e-07,-0.525678,0.850684] [-1,0,-3.27826e-07] [14.5208,9.58019,13.6917]),
		(matrix3 [0.000577072,-0.958764,-0.284202] [-1.91703e-07,-0.284202,0.958765] [-1,-0.000553419,-0.000164288] [14.5208,-7.89591,2.89231]),
		(matrix3 [0,-0.958764,-0.284202] [5.88819e-06,-0.284202,0.958765] [-1,-1.79897e-06,5.56705e-06] [14.5269,-17.9281,-0.0814817])
	)
	local r_pointStore = 
	#(  --右腿虚拟体
		(matrix3 [-0.0525477,0.064321,-0.996545] [-0.00241103,0.997913,0.0645364] [0.998616,0.00579395,-0.0522831] [-9.26501,-2.15749,112.602]),
		(matrix3 [-0.052603,0.113528,-0.992141] [0.000193821,0.993518,0.113675] [0.998615,0.0057873,-0.0522841] [-11.5039,0.582965,70.1429]),
		(matrix3 [-0.0525295,0.162459,-0.985316] [0.00279166,0.986699,0.162538] [0.998615,0.00578731,-0.0522843] [-11.8301,1.28708,63.9895]),
		(matrix3 [4.49377e-05,-0.850684,-0.525678] [-5.96046e-06,0.525678,-0.850684] [1,4.12539e-05,1.85352e-05] [-14.5116,9.58018,13.6917]),
		(matrix3 [-0.000577133,-0.958764,-0.284202] [-4.9679e-07,0.284202,-0.958764] [1,-0.0005533,-0.000164516] [-14.521,-7.89591,2.89231]),
		(matrix3 [-1.59846e-07,-0.958764,-0.284202] [5.70214e-06,0.284202,-0.958764] [1,-1.88097e-06,5.40438e-06] [-14.527,-17.9281,-0.0814769])
	)
	
	
	-------------------------------------------------------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------腿部对位虚拟体和骨骼函数-----------------------------------------------------------------------------------------
	fn MyCreatPoints_fn = --创建原始点，将他们放入一个数组中，这是为localtion点设置的
	(

		
		
			local TempCircle =Circle radius:50
			TempCircle.name = "con_bodyRoot"		
			TempCircle.pos = [0,0,0]
-- 			   
			for i = 1 to l_pointStore.count do
			(
				---创建左边
				l_pointNodeLeg[i] = Point transform:l_pointStore[i] size:unitis_value box:on cross:off centermarker:off axistripod: off  wirecolor:blue
				l_pointNodeLeg[i].rotation.controller = Euler_xyz()  	
				l_pointNodeLeg[i].position.controller = position_xyz()  	
				l_pointNodeLeg[i].name = "left_guide_point" + (i as string)
				
				---创建右边边
				r_pointNodeLeg[i] = Point transform:r_pointStore[i] size:unitis_value box:on cross:off centermarker:off axistripod: off  wirecolor:red
				r_pointNodeLeg[i].rotation.controller = Euler_xyz()
				r_pointNodeLeg[i].position.controller = position_xyz()
				r_pointNodeLeg[i].name = "right_guide_point" + (i as string)	  
			)
			
			
			
			
			
			
			
			for x = 1 to l_pointStore.count do
			(
				---创建左边
				l_pointNodeLegR[x] = Point transform:l_pointStore[x] size:unitis_value box:off cross:on centermarker:off axistripod: off size:10 wirecolor:blue
				l_pointNodeLegR[x].rotation.controller = Euler_xyz()  
				l_pointNodeLegR[x].position.controller = position_xyz()  	
				l_pointNodeLegR[x].name = "left_par_point" + (x as string)
				hide l_pointNodeLegR[x]
				
				---创建右边边
				r_pointNodeLegR[x] = Point transform:r_pointStore[x] size:unitis_value box:off cross:on centermarker:off axistripod: off size:10 wirecolor:red
				r_pointNodeLegR[x].rotation.controller = Euler_xyz()
				r_pointNodeLegR[x].position.controller = position_xyz()
				r_pointNodeLegR[x].name = "right_par_point" + (x as string)
				hide r_pointNodeLegR[x]
			)
			




			for j = 1 to (l_pointNodeLeg.count-1) do
			(
				parentCount = j  --父物体count
				childCount = j + 1 	--子物体count
				l_pointNodeLegR[childCount].parent = l_pointNodeLeg[parentCount]
				r_pointNodeLegR[childCount].parent = r_pointNodeLeg[parentCount]
				l_pointNodeLeg[childCount].parent = l_pointNodeLegR[childCount]
				r_pointNodeLeg[childCount].parent = r_pointNodeLegR[childCount]
			)

						
			
			---左右 链接到  root
			l_pointNodeLeg[1].parent  = l_pointNodeLegR[1]
			r_pointNodeLeg[1].parent  = r_pointNodeLegR[1]
			l_pointNodeLegR[1].parent = TempCircle   
			r_pointNodeLegR[1].parent = TempCircle




			
			
			for k = 1 to l_pointNodeLeg.count do
			(
			
				

				--直接用[数字]来代替XYZ坐标
				r_pointNodeLeg[k].rotation.controller[1].controller = Float_Expression ()
				r_pointNodeLeg[k].rotation.controller[1].controller.AddScalarTarget "RotX" l_pointNodeLeg[k].rotation.controller[1]
				r_pointNodeLeg[k].rotation.controller[1].controller.setExpression "-RotX" 

				
				--正常的xyz旋转
				r_pointNodeLeg[k].rotation.controller.Y_Rotation.controller = Float_Expression ()
				r_pointNodeLeg[k].rotation.controller.Y_Rotation.controller.AddScalarTarget "RotY" l_pointNodeLeg[k].rotation.controller[#Y_Rotation]
				r_pointNodeLeg[k].rotation.controller.Y_Rotation.controller.setExpression "RotY" 

				r_pointNodeLeg[k].rotation.controller.Z_Rotation.controller = Float_Expression ()
				r_pointNodeLeg[k].rotation.controller.Z_Rotation.controller.AddScalarTarget "RotZ" l_pointNodeLeg[k].rotation.controller[#Z_Rotation]
				r_pointNodeLeg[k].rotation.controller.Z_Rotation.controller.setExpression "-RotZ" 				
				
				

				
				r_pointNodeLeg[k].pos.controller = Position_Expression ()
				r_pointNodeLeg[k].pos.controller.AddVectorTarget "pos" l_pointNodeLeg[k].pos.controller
				r_pointNodeLeg[k].pos.controller.setExpression "[pos.x , -pos.y ,pos.z]"
				
				/* 参数链接
				paramWire.connect l_pointNodeLeg[k].pos.controller[#X_Position] r_pointNodeLeg[k].pos.controller[#X_Position] "X_Position"
				paramWire.connect l_pointNodeLeg[k].pos.controller[#Y_Position] r_pointNodeLeg[k].pos.controller[#Y_Position] "-Y_Position"
				paramWire.connect l_pointNodeLeg[k].pos.controller[#Z_Position] r_pointNodeLeg[k].pos.controller[#Z_Position] "Z_Position"
				*/
				
			)
		
				l_RefBone[1] = BoneSys.createBone l_pointNodeLeg[1].pos l_pointNodeLeg[2].pos [0,1,0]
				l_RefBone[1].width =unitis_value*2
				l_RefBone[1].height =unitis_value*2
				l_RefBone[1].frontfin =true
				l_RefBone[1].frontfinsize =unitis_value*2
			
			
				r_RefBone[1] = BoneSys.createBone r_pointNodeLeg[1].pos r_pointNodeLeg[2].pos [0,1,0]
				r_RefBone[1].width =unitis_value*2
				r_RefBone[1].height =unitis_value*2
				r_RefBone[1].frontfin =true
				r_RefBone[1].frontfinsize =unitis_value*1
			for x = 2 to l_pointNodeLeg.count-1 do
				(
		
				l_RefBone[x] = BoneSys.createBone l_pointNodeLeg[x].pos l_pointNodeLeg[x+1].pos [0,1,0]
				l_RefBone[x].width =unitis_value*2
				l_RefBone[x].height =unitis_value*2
				l_RefBone[x].frontfin =true
				l_RefBone[x].frontfinsize =unitis_value*1
			    l_RefBone[x].parent = l_RefBone[x-1]
					
				r_RefBone[x] = BoneSys.createBone r_pointNodeLeg[x].pos r_pointNodeLeg[x+1].pos [0,1,0]
				r_RefBone[x].width =unitis_value*2
				r_RefBone[x].height =unitis_value*2
				r_RefBone[x].frontfin =true
				r_RefBone[x].frontfinsize =unitis_value*1
			    r_RefBone[x].parent = r_RefBone[x-1]
				)
			
			
			for j = 1 to l_RefBone.count do
			(

				l_RefBone[j].pos.controller = position_Constraint()
				l_RefBone[j].pos.controller.appendTarget l_pointNodeLeg[j] 100

				r_RefBone[j].pos.controller = position_Constraint()
				r_RefBone[j].pos.controller.appendTarget r_pointNodeLeg[j] 100
				
				
				
				l_RefBone[j].rotation.controller = LookAt_constraint()
				l_RefBone[j].rotation.controller.appendTarget l_pointNodeLeg[j+1] 100
                l_RefBone[j].rotation.controller.lookat_vector_length=0  
				l_RefBone[j].rotation.controller.upnode_world=false
				l_RefBone[j].rotation.controller.pickupNode=l_pointNodeLeg[j]	
				
				
				
				r_RefBone[j].rotation.controller = LookAt_constraint()
				r_RefBone[j].rotation.controller.appendTarget r_pointNodeLeg[j+1] 100
                r_RefBone[j].rotation.controller.lookat_vector_length=0  
				r_RefBone[j].rotation.controller.upnode_world=false
				r_RefBone[j].rotation.controller.pickupNode=r_pointNodeLeg[j]
				
				
			)
	)
	
-------------------------------------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------创建腿部骨骼------------------------------------------------------------------------------------
	Fn MylegSysT_fn =
	(
		

			l_legBone[1] = BoneSys.createBone l_pointNodeLeg[1].pos l_pointNodeLeg[2].pos [0,1,0] 
			l_legBone[1].width =unitis_value*2
			l_legBone[1].height =unitis_value*2
			l_legBone[1].frontfin =true
			l_legBone[1].frontfinsize =unitis_value*2
			l_legBone[1].transform  = l_RefBone[1].transform
		    l_legBone[1].name = legBoneName[1]
		
		
		for s =2 to l_pointNodeLeg.count -1 do
		(
			l_legBone[s] = BoneSys.createBone l_pointNodeLeg[s].pos l_pointNodeLeg[s+1].pos [0,1,0] 
			l_legBone[s].width =unitis_value*2
			l_legBone[s].height =unitis_value*2
			l_legBone[s].frontfin =true
			l_legBone[s].frontfinsize =unitis_value*2
			l_legBone[s].transform  = l_RefBone[s].transform
		    l_legBone[s].name = legBoneName[s]	
			print s
         		
			
		)
	)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------	
	
	
	
	on 'btn_cre' pressed do
	(
		MyCreatPoints_fn()
	)
	on 'btn_legCreat' pressed do
	(
		MylegSysT_fn()
	)
	
)

createdialog Legref