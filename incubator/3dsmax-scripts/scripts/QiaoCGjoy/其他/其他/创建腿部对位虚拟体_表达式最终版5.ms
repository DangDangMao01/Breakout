rollout Legref "自定义腿部"
(

----------------------------------------------------------------------------------------------------------
	-----------------------------------------按钮--------------------------------------------------
	button 'btn_cre' "创建腿部对位" 
	button 'btn_legCreat' "创建腿部系统" 
	
-----------------------------------------------------------------------------------------------------------
----------------------------------------------局部变量-----------------------------------------	
	
	
	
	local l_pointNodeLeg = #()  --腿部参考虚拟体
	local r_pointNodeLeg = #()  --腿部参考虚拟体
	
	local l_pointNodeLegR = #()  
	local r_pointNodeLegR = #()
	
	local l_RefBone = #()
	local r_RefBone = #()
	
	
	local l_legBone = #()
	local r_legBone = #()
	
	local  l_legAnkleLoc = #()    --左脚脚踝坐标
	local  r_legAnkleLoc = #()    --右脚脚踝坐标
	
	local  l_legAnkleLocR = #()    --左脚脚踝坐标父级别
	local  r_legAnkleLocR = #()    --右脚脚踝坐标父级别

	
	local 	l_legBoneName = #("BN_upperLeg_L","BN_knee_L","BN_lowerLeg_L","BN_ankle_L","BN_tip_L")
	local 	r_legBoneName = #("BN_upperLeg_R","BN_knee_R","BN_lowerLeg_R","BN_ankle_R","BN_tip_R")
	
	
	
	local l_legikPointPar =#() --ik虚拟体骨骼
	local r_legikPointPar =#() --ik虚拟体骨骼
	
	local l_legfkcon =#() --fk控制器
	local r_legfkcon =#() --fk控制器
	
	
	
	local 	l_legfkPointParName = #("Hp_upperLegFK_L","HP_kneeFK_L","HP_lowerLeg_L","HP_ankleFK_L","HP_toeFK_L","HP_tieFK_L")
	local 	r_legfkPointParName = #("HP_upperLegFK_R","HP_kneeFK_R","HP_lowerLeg_R","HP_ankleFK_R","HP_toeFK_R","HP_toeFK_R")
	
	
	local 	l_legfkConName = #("Con_upperLegFK_L","Con_kneeFK_L","Con_lowerLegFK_L","Con_ankleFK_L","Con_toeFK_L","Con_toeFK_L")
	local 	r_legfkConName = #("Con_upperLegFK_R","Con_kneeFK_R","Con_lowerLegFK_R","Con_ankleFK_R","Con_toeFK_R","Con_toeFK_R")
	
	local 	l_legikHpName = #("HP_upperLegIK_L","HP_kneeIK_L","HP_lowerLegIK_L","HP_ankleIK_L")
	local 	r_legikHpName = #("HP_upperLegIK_R","HP_kneeIK_R","HP_lowerLegIK_R","HP_ankleIK_R")
	
	
	local l_footIkConName = #("Con_footIk_L","Con_ballIk_L","Con_outIk_L","Con_in_Ik_L","Con_tipIK_L","Con_toe_L")
	local r_footIkConName = #("Con_footIk_R","Con_ballIk_R","Con_outIk_R","Con_in_Ik_R","Con_tipIK_R","Con_toe_R")
	
	local 	ikHpSovName = #("HP_armIKSov_R","HP_armIKSov_L","HP_legIKSov_R","HP_legIKSov_L") --IK极向量虚拟体名字
	

	
	
	
---------------------------------------------------------------------------------------------------------	
-------------------------------------------------------定义坐标旋转函数-------------------------------------------
fn Align_fn s1 s2 = --对齐物体
 (
  --selection[1] 对齐 selection[2] 
  pos=s2.transform.pos-s1.transform.pos
  rota=(s2.transform.rotation-s1.transform.rotation)as eulerangles
  move s1 pos
  rotate s1 rota
 )

fn RotatePivotOnly obj rotation = 
(
 local rotValInv=inverse (rotation as quat)
 animate off in coordsys local obj.rotation*=RotValInv
 --obj.objectoffsetpos*=RotValInv
 obj.objectoffsetrot*=RotValInv
)

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
					#Meters:0.5
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
		(matrix3 [0.0526409,0.0644319,-0.996533] [-0.00240618,-0.997905,-0.0646478] [-0.998611,0.00580093,-0.0523756] [11.5077,0.587708,70.1434]),
		(matrix3 [0.0526917,0.113538,-0.992135] [0.000197083,-0.993517,-0.113686] [-0.998611,0.00579479,-0.0523724] [11.8345,1.29188,63.9901]),
		(matrix3 [0.00279471,-0.986714,-0.162444] [-0.0526225,-0.162365,0.985327] [-0.998611,0.00579451,-0.0523771] [14.5208,9.58019,13.6917]),
		(matrix3 [0.000577072,-0.958764,-0.284202] [-1.91703e-07,-0.284202,0.958765] [-1,-0.000553419,-0.000164288] [14.5208,-7.89591,2.89231]),
		(matrix3 [0,-0.958765,-0.284202] [6.05299e-06,-0.284202,0.958765] [-1,-1.67523e-06,5.81674e-06] [14.5269,-17.9281,-0.0814842])
	)
	local r_pointStore = 
	#(  --右腿虚拟体
		(matrix3 [-0.0525477,0.064321,-0.996545] [-0.00241103,0.997913,0.0645364] [0.998616,0.00579395,-0.0522831] [-9.26501,-2.15749,112.602]),
		(matrix3 [-0.0525486,0.0643206,-0.996545] [-0.0024108,0.997912,0.064536] [0.998615,0.00579375,-0.0522838] [-11.5039,0.582968,70.1429]),
		(matrix3 [-0.0525964,0.113528,-0.992142] [0.000194579,0.993518,0.113675] [0.998616,0.00578582,-0.0522775] [-11.8301,1.28708,63.9895]),
		(matrix3 [-0.00279114,-0.986698,-0.162538] [-0.0525298,0.162459,-0.985316] [0.998616,0.00578793,-0.0522845] [-14.5116,9.58019,13.6917]),
		(matrix3 [-0.000577133,-0.958764,-0.284202] [-4.9679e-07,0.284202,-0.958764] [1,-0.0005533,-0.000164516] [-14.521,-7.89591,2.89231]),
		(matrix3 [0,-0.958765,-0.284202] [5.95585e-06,0.284202,-0.958764] [1,-1.69605e-06,5.66399e-06] [-14.527,-17.9281,-0.0814821])
	)
	local l_ankleLoc = ------左脚脚踝水平坐标，后跟、脚侧定位坐标
	#(
			(matrix3 [1.3411e-07,5.41592e-07,-0.999999] [-7.39004e-07,-1,0] [-1,7.3621e-07,-5.7742e-07] [14.5208,9.58019,13.6916]),
			(matrix3 [-1.54883e-07,-1,4.33684e-07] [5.58794e-06,0,1] [-1,1.52088e-07,5.14462e-06] [14.5268,15.6966,-0.431988]),
			(matrix3 [-1.54883e-07,-1,4.33684e-07] [5.58794e-06,0,1] [-1,1.52088e-07,5.14462e-06] [22.9544,-6.53825,-0.432021]),
			(matrix3 [-1.54883e-07,-1,4.33684e-07] [5.58794e-06,0,1] [-1,1.52088e-07,5.14462e-06] [6.41007,-6.53824,-0.431932]),
			(matrix3 [-6.3172e-07,-1,4.69384e-07] [-5.38015e-06,0,1] [-1,6.28926e-07,-5.82347e-06] [14.5269,-17.9281,-0.0815156]),
			(matrix3 [-2.21345e-06,-0.958764,-0.284203] [-5.65459e-06,-0.284203,0.958764] [-1,3.72643e-06,-5.23568e-06] [14.5208,-7.89591,2.89229])

	)
	
	local r_ankleLoc = ------右脚脚踝水平坐标，后跟、脚侧定位坐标
	#(
			(matrix3 [-2.02507e-05,-0.00138091,-0.999999] [0,0.999999,-0.00138122] [1,0,-2.01985e-05] [-14.5209,9.58024,13.6916]),
			(matrix3 [-1.73791e-07,-1,4.65315e-07] [5.97538e-06,-1.48429e-07,-1] [1,-1.47223e-07,6.02753e-06] [-14.527,15.6966,-0.431987]),
			(matrix3 [4.52136e-07,-1,4.65302e-07] [-5.94555e-06,-1.4843e-07,-1] [1,4.78702e-07,-5.8934e-06] [-22.954,-6.53824,-0.432016]),
			(matrix3 [0,-1,4.65312e-07] [-5.94555e-06,-1.4843e-07,-1] [1,0,-5.8934e-06] [-6.41001,-6.53822,-0.431927]),
			(matrix3 [-6.39758e-07,-1,4.76837e-07] [5.08229e-06,-4.7684e-07,-1] [1,-6.39755e-07,5.08229e-06] [-14.527,-17.9281,-0.0814441]),
			(matrix3 [-2.21345e-06,-0.958764,-0.284203] [4.7875e-06,0.284203,-0.958764] [1,-3.48e-06,4.40434e-06] [-14.521,-7.89589,2.89234])

	)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------腿部对位虚拟体和骨骼函数-----------------------------------------------------------------------------------------
	fn MyCreatPoints_fn = --创建原始点，将他们放入一个数组中，这是为localtion点设置的
	(

		
		
			local TempCircle =Circle radius:50
			TempCircle.name = "con_bodyRoot"		
			TempCircle.pos = [0,0,0]
		    TempCircle.scale.controller = ScaleXYZ()
-- 			   
			for i = 1 to l_pointStore.count do
			(
				---创建左边
				l_pointNodeLeg[i] = Point transform:l_pointStore[i] size:unitis_value box:on cross:off centermarker:off axistripod: off  wirecolor:blue
				l_pointNodeLeg[i].rotation.controller = Euler_xyz()  	
				l_pointNodeLeg[i].position.controller = position_xyz()
				l_pointNodeLeg[i].scale.controller = ScaleXYZ ()				
				l_pointNodeLeg[i].name = "left_guide_point" + (i as string)
				
				--setInheritanceFlags l_pointNodeLeg #{1,2,3,4,5,6} --关闭缩放继承
				
				---创建右边边
				r_pointNodeLeg[i] = Point transform:r_pointStore[i] size:unitis_value box:on cross:off centermarker:off axistripod: off  wirecolor:red
				r_pointNodeLeg[i].rotation.controller = Euler_xyz()
				r_pointNodeLeg[i].position.controller = position_xyz()
				r_pointNodeLeg[i].name = "right_guide_point" + (i as string)	  
			)
			
			
			    --setInheritanceFlags r_pointNodeLeg #{1,2,3,4,5,6}
			
			
			
			
			for x = 1 to l_pointStore.count do
			(
				---创建左边
				l_pointNodeLegR[x] = Point transform:l_pointStore[x] size:unitis_value box:off cross:on centermarker:off axistripod: off size:10 wirecolor:blue
				l_pointNodeLegR[x].rotation.controller = Euler_xyz()  
				l_pointNodeLegR[x].position.controller = position_xyz()  	
				l_pointNodeLegR[x].name = "left_par_point" + (x as string)
				
				--setInheritanceFlags l_pointNodeLegR #{1,2,3,4,5,6}  --关闭缩放继承
				hide l_pointNodeLegR[x]
				
				---创建右边边
				r_pointNodeLegR[x] = Point transform:r_pointStore[x] size:unitis_value box:off cross:on centermarker:off axistripod: off size:10 wirecolor:red
				r_pointNodeLegR[x].rotation.controller = Euler_xyz()
				r_pointNodeLegR[x].position.controller = position_xyz()
				r_pointNodeLegR[x].name = "right_par_point" + (x as string)
				
				--setInheritanceFlags r_pointNodeLegR #{1,2,3,4,5,6} --关闭缩放继承
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
				
				

				--镜像位移
				r_pointNodeLeg[k].pos.controller = Position_Expression ()
				r_pointNodeLeg[k].pos.controller.AddVectorTarget "pos" l_pointNodeLeg[k].pos.controller
				r_pointNodeLeg[k].pos.controller.setExpression "[pos.x , -pos.y ,pos.z]"
				
				--镜像缩放
				r_pointNodeLeg[k].scale.controller = Scale_Expression ()
				r_pointNodeLeg[k].scale.controller.AddScalarTarget "sclx" l_pointNodeLeg[k].scale.controller.X_Scale.controller
				r_pointNodeLeg[k].scale.controller.setExpression "[sclx , 1 ,1]"

				
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
			
				l_RefBone[6] = BoneSys.createBone [0,0,0][0,0,0][0,0,0]
				l_RefBone[6].width =unitis_value*2
				l_RefBone[6].height =unitis_value*2
				l_RefBone[6].frontfin =true
				l_RefBone[6].frontfinsize =unitis_value*2
			    l_RefBone[6].transform = l_pointNodeLeg[6].transform

			
			
				r_RefBone[6] = BoneSys.createBone [0,0,0][0,0,0][0,0,0]
				r_RefBone[6].width =unitis_value*2
				r_RefBone[6].height =unitis_value*2
				r_RefBone[6].frontfin =true
				r_RefBone[6].frontfinsize =unitis_value*2
			    r_RefBone[6].transform = r_pointNodeLeg[6].transform
	
			
			
			
			
			
			
			
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
				
				
				l_RefBone[6].parent = l_RefBone[5]
				r_RefBone[6].parent = r_RefBone[5]
			
			
			for j = 1 to 5 do
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
			
				l_RefBone[6].pos.controller = position_Constraint()
				l_RefBone[6].pos.controller.appendTarget l_pointNodeLeg[6] 100

			
				l_RefBone[6].rotation.controller = Orientation_Constraint()
				l_RefBone[6].rotation.controller.appendTarget l_pointNodeLeg[6] 100
			
				r_RefBone[6].pos.controller = position_Constraint()
				r_RefBone[6].pos.controller.appendTarget r_pointNodeLeg[6] 100
			
				r_RefBone[6].rotation.controller = Orientation_Constraint()
				r_RefBone[6].rotation.controller.appendTarget r_pointNodeLeg[6] 100
			
			
			
			
			for anP = 1 to l_ankleLoc.count do
			(
				l_legAnkleLocR[anP] = Point transform:l_ankleLoc[anP] size:(unitis_value*10) box:off cross:on centermarker:off axistripod: off  wirecolor:yellow
				l_legAnkleLocR[anP].rotation.controller = Euler_xyz()  	
				l_legAnkleLocR[anP].position.controller = position_xyz()
				l_legAnkleLocR[anP].scale.controller = ScaleXYZ ()				
				l_legAnkleLocR[anP].name = "leftFoot_loc_pointP" + (an as string)

				
				
				r_legAnkleLocR[anP] = Point transform:r_ankleLoc[anP] size:(unitis_value*10) box:off cross:on centermarker:off axistripod: off  wirecolor:yellow
				r_legAnkleLocR[anP].rotation.controller = Euler_xyz()  	
				r_legAnkleLocR[anP].position.controller = position_xyz()
				r_legAnkleLocR[anP].scale.controller = ScaleXYZ ()				
				r_legAnkleLocR[anP].name = "rightFoot_loc_pointP" + (an as string)


				

			)
			
			
			for an = 1 to l_ankleLoc.count do
			(
				l_legAnkleLoc[an] = Point transform:l_ankleLoc[an] size:(unitis_value*10) box:on cross:off centermarker:off axistripod: off  wirecolor:yellow
				l_legAnkleLoc[an].rotation.controller = Euler_xyz()  	
				l_legAnkleLoc[an].position.controller = position_xyz()
				l_legAnkleLoc[an].scale.controller = ScaleXYZ ()				
				l_legAnkleLoc[an].name = "leftFoot_loc_point" + (an as string)

				
				
				r_legAnkleLoc[an] = Point transform:r_ankleLoc[an] size:(unitis_value*10) box:on cross:off centermarker:off axistripod: off  wirecolor:yellow
				r_legAnkleLoc[an].rotation.controller = Euler_xyz()  	
				r_legAnkleLoc[an].position.controller = position_xyz()
				r_legAnkleLoc[an].scale.controller = ScaleXYZ ()				
				r_legAnkleLoc[an].name = "rightFoot_loc_point" + (an as string)


				

			)
			
			
			for js = 2 to (l_legAnkleLoc.count) do
			(
				--parentCount = js  --父物体count
				--childCount = js + 1 	--子物体count
				l_legAnkleLocR[js].parent = l_legAnkleLoc[1]
				r_legAnkleLocR[js].parent = r_legAnkleLoc[1]
				l_legAnkleLoc[js].parent = l_legAnkleLocR[js]
				r_legAnkleLoc[js].parent = r_legAnkleLocR[js]
			)
			
			
			
				l_legAnkleLoc[1].parent = l_legAnkleLocR[1]
				r_legAnkleLoc[1].parent = r_legAnkleLocR[1]
				l_legAnkleLocR[1].parent = l_pointNodeLeg[4]
				r_legAnkleLocR[1].parent = 	r_pointNodeLeg[4]
			

		
			for ks = 1 to l_legAnkleLoc.count do
			(
			
				

				--直接用[数字]来代替XYZ坐标
				r_legAnkleLoc[ks].rotation.controller[1].controller = Float_Expression ()
				r_legAnkleLoc[ks].rotation.controller[1].controller.AddScalarTarget "RotX" l_legAnkleLoc[ks].rotation.controller[1]
				r_legAnkleLoc[ks].rotation.controller[1].controller.setExpression "-RotX" 

				
				r_legAnkleLoc[ks].rotation.controller[2].controller = Float_Expression ()
				r_legAnkleLoc[ks].rotation.controller[2].controller.AddScalarTarget "RotY" l_legAnkleLoc[ks].rotation.controller[#Y_Rotation]
				r_legAnkleLoc[ks].rotation.controller[2].controller.setExpression "RotY" 

				r_legAnkleLoc[ks].rotation.controller[3].controller = Float_Expression ()
				r_legAnkleLoc[ks].rotation.controller[3].controller.AddScalarTarget "RotZ" l_legAnkleLoc[ks].rotation.controller[#Z_Rotation]
				r_legAnkleLoc[ks].rotation.controller[3].controller.setExpression "-RotZ" 				
				
				

				--镜像位移
				r_legAnkleLoc[ks].pos.controller = Position_Expression ()
				r_legAnkleLoc[ks].pos.controller.AddVectorTarget "pos" l_legAnkleLoc[ks].pos.controller
				r_legAnkleLoc[ks].pos.controller.setExpression "[pos.x , -pos.y ,pos.z]"
				

				
			)
			
			
			hide l_legAnkleLocR
			hide r_legAnkleLocR
			
			
			
			
			
				----------------------------腿部IK相关控制器曲线------------------------------------------------------
/*fn IkSov_fn Ppos:[0,0,0] Pscale:1 Pname:"Conctrl" = 
(*/
  cc = splineShape pos:[0,0,0]
addnewSpline cc
addKnot cc 1 #corner #line [0, 0, 0]
addKnot cc 1 #corner #line [0, 23.646, 0]
addKnot cc 1 #corner #line [3.941, 15.764, 0]
addKnot cc 1 #corner #line [-3.941, 15.764, 0]
addKnot cc 1 #corner #line [0, 23.646, 0]
addKnot cc 1 #corner #line [0, 15.764, -3.941]
addKnot cc 1 #corner #line [0, 15.764, 3.941]
addKnot cc 1 #corner #line [0, 23.646, 0]
Close cc 1

	--cc.pos = Ppos--
    updateshape cc
		addmodifier cc(xform())
		cc.xform.gizmo.scale = [1,1,1]
        converttosplineshape cc
		cc.scale.controller = ScaleXYZ()
        cc.name = "Con_legIkUplod_L"			
		Select cc
		maxOps.cloneNodes $ cloneType:#copy newNodes:&nnl  
	    select nnl
		$.name="Con_legIkUplod_R"
		maxOps.cloneNodes $ cloneType:#copy newNodes:&nnl  
	    select nnl
		$.name="Con_armIkUplod_L"
		maxOps.cloneNodes $ cloneType:#copy newNodes:&nnl  
	    select nnl
		$.name="Con_armIkUplod_R"
--)--
			
			local legikHPsov=#()
			for sov = 1 to 4 do
			(
			
			legikHPsov[sov] =  Point pos:[0, 23.646, 0] size:unitis_value box:off cross:on centermarker:off axistripod: off  wirecolor:blue
			legikHPsov[sov].name = ikHpSovName[sov]  		
			)
			legikHPsov[1].parent = $Con_armIkUplod_R
			legikHPsov[2].parent = $Con_armIkUplod_L
			legikHPsov[3].parent = $Con_legIkUplod_R
			legikHPsov[4].parent = $Con_legIkUplod_L
			
			
			
			$Con_legIkUplod_L.transform  = l_RefBone[1].transform
			$Con_legIkUplod_R.transform  = r_RefBone[1].transform
			$Con_legIkUplod_L.parent  = l_pointNodeLeg[1]
			$Con_legIkUplod_R.parent  = r_pointNodeLeg[1]
			in coordsys local Rotate $Con_legIkUplod_R(EulerAngles 0 0 180)
			--in coordsys local RotatePivotOnly $Con_legIkUplod_R (EulerAngles 0 0 -180)

			
	

		)
-------------------------------------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------创建腿部系统------------------------------------------------------------------------------------
	Fn MylegSysT_fn =
	(
			rootSC = $con_bodyRoot.scale.controller.X_Scale.controller.value/100
		
		
-----------------------------创建左右腿骨骼
			l_legBone[1] = BoneSys.createBone l_pointNodeLeg[1].pos l_pointNodeLeg[2].pos [0,1,0] 
			l_legBone[1].width =unitis_value*2*rootSC
			l_legBone[1].height =unitis_value*2*rootSC

			l_legBone[1].transform  = l_RefBone[1].transform
		    l_legBone[1].name = l_legBoneName[1]
		
			r_legBone[1] = BoneSys.createBone r_pointNodeLeg[1].pos r_pointNodeLeg[2].pos [0,1,0] 
			r_legBone[1].width =unitis_value*2*rootSC
			r_legBone[1].height =unitis_value*2*rootSC
			r_legBone[1].transform  = r_RefBone[1].transform
		    r_legBone[1].name = r_legBoneName[1]
		

		
		
		
		

		for t =2 to (l_pointNodeLeg.count-1)  do
		(
			l_legBone[t] = BoneSys.createBone l_pointNodeLeg[t].pos l_pointNodeLeg[t+1].pos [0,1,0] 
			l_legBone[t].width =unitis_value*2*rootSC
			l_legBone[t].height =unitis_value*2*rootSC

			l_legBone[t].transform  = l_RefBone[t].transform
		    l_legBone[t].name = l_legBoneName[t]
			
			r_legBone[t] = BoneSys.createBone r_pointNodeLeg[t].pos r_pointNodeLeg[t+1].pos [0,1,0] 
			r_legBone[t].width =unitis_value*2*rootSC
			r_legBone[t].height =unitis_value*2*rootSC

			r_legBone[t].transform  = r_RefBone[t].transform
		    r_legBone[t].name = r_legBoneName[t]
		)
		
		------------------------------------------重置根节点------------------------
		-----------------------脚部IK控制器------------		
			local l_footIkCon = #()
			local r_footIkCon = #()
		--------------左脚ik脚踝控制器
			l_footIkCon[1] = splineShape pos:[0,0,0]
			addnewSpline l_footIkCon[1]
			addKnot l_footIkCon[1] 1 #corner #line [-8.06468,10.8449,-8.19175]
			addKnot l_footIkCon[1] 1 #corner #line [-7.17992e-07,19.2557,-3.79952]
			addKnot l_footIkCon[1] 1 #corner #line [8.06468,10.8449,-8.19175]
			addKnot l_footIkCon[1] 1 #corner #line [4.45856e-07,-6.4259,-8.36056]

			Close l_footIkCon[1] 1

			updateshape l_footIkCon[1]
			addmodifier l_footIkCon[1](xform())
			l_footIkCon[1].xform.gizmo.scale = [1,1,1]
			converttosplineshape l_footIkCon[1]
			l_footIkCon[1].name = l_footIkConName[1]
			l_footIkCon[1].transform = l_legAnkleLoc[1].transform								
				
			in coordsys local Rotate l_footIkCon[1] (EulerAngles 0 90 0)
		    in coordsys local RotatePivotOnly l_footIkCon[1] (EulerAngles 0 -90 0)
				
				
				
		---------------------------右脚ik脚踝控制器		
				
			r_footIkCon[1] = splineShape pos:[0,0,0]
			addnewSpline r_footIkCon[1]
			addKnot r_footIkCon[1] 1 #corner #line [-8.19175,-10.8449,-8.06468]
			addKnot r_footIkCon[1] 1 #corner #line [-3.79953,-19.2557,5.24025e-06]
			addKnot r_footIkCon[1] 1 #corner #line [-8.19176,-10.8449,8.06468]
			addKnot r_footIkCon[1] 1 #corner #line [-8.36056,6.4259,-3.26421e-06]

			Close r_footIkCon[1] 1

			updateshape r_footIkCon[1]
			addmodifier r_footIkCon[1](xform())
			r_footIkCon[1].xform.gizmo.scale = [1,1,1]
			converttosplineshape r_footIkCon[1]
			r_footIkCon[1].name = r_footIkConName[1]			
			r_footIkCon[1].transform = r_legAnkleLoc[1].transform
				
			--in coordsys local Rotate r_footIkCon[1] (EulerAngles 180 90 0)
		    --in coordsys local RotatePivotOnly r_footIkCon[1] (EulerAngles -180 -90 0)

				
		in coordsys local RotatePivotOnly l_footIkCon[1] (EulerAngles 180 90 0)
		in coordsys local RotatePivotOnly r_footIkCon[1] (EulerAngles 0 90 0)
		
		
		for ft = 2 to l_legAnkleLoc.count do
		(
			l_footIkCon[ft] =Circle radius:(unitis_value*10)  transform:l_legAnkleLoc[ft].transform
			l_footIkCon[ft].name = l_footIkConName[ft]
			l_footIkCon[ft].wirecolor = (color 255 7 7)

			r_footIkCon[ft] =Circle radius:(unitis_value*10)  transform:r_legAnkleLoc[ft].transform
			r_footIkCon[ft].name = r_footIkConName[ft]
			r_footIkCon[ft].wirecolor = (color 0 0 255)				
		)		
				
			
		
		
		---------------------------------------------------------------		
		
		
		
		ResetXForm $con_bodyRoot
		maxops.CollapseNodeTo $con_bodyRoot 1 on
		ResetXForm l_footIkCon[1]
		maxops.CollapseNodeTo l_footIkCon[1] 1 on
		ResetXForm r_footIkCon[1]
		maxops.CollapseNodeTo r_footIkCon[1] 1 on
		
		
		
		for ftp = 1 to (l_legAnkleLoc.count-1) do
			(
				footparentCount = ftp  --父物体count
				footchildCount = ftp + 1 	--子物体count
				l_footIkCon[footchildCount].parent = l_footIkCon[footparentCount]
				r_footIkCon[footchildCount].parent = r_footIkCon[footparentCount]

			)
		
		
		
		ankRotL = Rectangle length:(unitis_value *20*rootSC) width:(unitis_value *20*rootSC) cornerRadius:(unitis_value *5*rootSC) transform:$BN_ankle_L.transform isSelected:on wirecolor:red
		ankRotL.name = "Con_ballIK_L"		
		ankRotL.pos = $BN_tip_L.pos
		ankRotL.parent = l_footIkCon[5]
		in coordsys local Rotate $Con_ballIK_L (EulerAngles 0 90 0)
		in coordsys local RotatePivotOnly $Con_ballIK_L (EulerAngles 0 -90 0)
			
		ankRotL.rotation.controller = rotation_list()
		ankRotL.rotation.controller.setName 1 "zero"
		ankRotL.rotation.controller.Available.controller = Euler_xyz()
		ankRotL.rotation.controller.active = 2
			
				
		ankRotR = Rectangle length:(unitis_value *20*rootSC) width:(unitis_value *20*rootSC) cornerRadius:(unitis_value *5*rootSC) transform:$BN_ankle_R.transform isSelected:on wirecolor:blue
		ankRotR.name = "Con_ballIK_R"		
		ankRotR.pos = $BN_tip_R.pos
		ankRotR.parent = r_footIkCon[5]
		in coordsys local Rotate $Con_ballIK_R (EulerAngles 0 90 0)
		in coordsys local RotatePivotOnly $Con_ballIK_R (EulerAngles 0 -90 0)
		
		ankRotR.rotation.controller = rotation_list()
		ankRotR.rotation.controller.setName 1 "zero"
		ankRotR.rotation.controller.Available.controller = Euler_xyz()
		ankRotR.rotation.controller.active = 2
			
		$Con_footIk_L.parent = $con_bodyRoot
		$Con_footIk_R.parent = $con_bodyRoot
			
			
		for ip = 1 to l_footIkCon.count do
		(
			
			l_footIkCon[ip].rotation.controller = rotation_list()
			l_footIkCon[ip].rotation.controller.setName 1 "zero"
			l_footIkCon[ip].rotation.controller.Available.controller = Euler_xyz()
			l_footIkCon[ip].rotation.controller.active = 2
			
			l_footIkCon[ip].position.controller = position_list()
			l_footIkCon[ip].position.controller.setName 1 "zero"
			l_footIkCon[ip].position.controller.Available.controller = Position_XYZ ()
			l_footIkCon[ip].position.controller.active = 2
			
			
			
			r_footIkCon[ip].rotation.controller = rotation_list()
			r_footIkCon[ip].rotation.controller.setName 1 "zero"
			r_footIkCon[ip].rotation.controller.Available.controller = Euler_xyz()
			r_footIkCon[ip].rotation.controller.active = 2
			
			r_footIkCon[ip].position.controller = position_list()
			r_footIkCon[ip].position.controller.setName 1 "zero"
			r_footIkCon[ip].position.controller.Available.controller = Position_XYZ ()
			r_footIkCon[ip].position.controller.active = 2
		)
			
		


		delete l_pointNodeLeg
		delete r_pointNodeLeg 
		delete l_pointNodeLegR
		delete r_pointNodeLegR	
		delete l_RefBone
		delete r_RefBone 	
        delete l_legAnkleLoc
        delete r_legAnkleLoc
        delete l_legAnkleLocR	
        delete r_legAnkleLocR

--------------------------------创建IK虚拟体骨骼------------------------------------------------------	
			l_legikPointPar[1] =  Point transform:l_legBone[1].transform size:unitis_value box:off cross:on centermarker:off axistripod: off  wirecolor:blue
			l_legikPointPar[1].rotation.controller = Euler_xyz()  	
			l_legikPointPar[1].position.controller = position_xyz()
			l_legikPointPar[1].name = l_legikHpName[1]    
			
			r_legikPointPar[1] =  Point transform:r_legBone[1].transform size:unitis_value box:off cross:on centermarker:off axistripod: off  wirecolor:blue
			r_legikPointPar[1].rotation.controller = Euler_xyz()  	
			r_legikPointPar[1].position.controller = position_xyz()
			r_legikPointPar[1].name = r_legikHpName[1]  


		for f = 2 to (l_pointNodeLeg.count-2) do
        (

			l_legikPointPar[f] =  Point transform:l_legBone[f].transform size:unitis_value box:off cross:on centermarker:off axistripod: off  wirecolor:blue
			l_legikPointPar[f].rotation.controller = Euler_xyz()  	
			l_legikPointPar[f].position.controller = position_xyz()
			l_legikPointPar[f].name = l_legikHpName[f]
			
			l_legikPointPar[f].parent = l_legikPointPar[f-1]
			
			r_legikPointPar[f] =  Point transform:r_legBone[f].transform size:unitis_value box:off cross:on centermarker:off axistripod: off  wirecolor:red
			r_legikPointPar[f].rotation.controller = Euler_xyz()  	
			r_legikPointPar[f].position.controller = position_xyz()
			r_legikPointPar[f].name = r_legikHpName[f]
			
			
			r_legikPointPar[f].parent = r_legikPointPar[f-1]
			
			
		)
		
		
----------------------------------------------------极向量控制器及坐标调整------------------------------------------------------------------		
		
			$Con_legIkUplod_L.transform  = l_legBone[1].transform
			$Con_legIkUplod_R.transform  = r_legBone[1].transform
			in coordsys local Rotate $Con_legIkUplod_R(EulerAngles 0 0 180)
			in coordsys local RotatePivotOnly $Con_legIkUplod_R (EulerAngles 0 0 -180)
			vicHP = $HP_legIKSov_R.pos.controller[2].value
			in coordSys parent $HP_legIKSov_R.pos = [0,-vicHP,0] 
				
			
			ik_LlegChanin = IKSys.ikChain $HP_upperLegIK_L $HP_ankleIK_L "IKHISolver"
			ik_LlegChanin.transform.controller.VHTarget = $HP_legIKSov_L
			ik_LlegChanin.transform.controller.posThresh = 0.001
			ik_LlegChanin.transform.controller.rotThresh = 0.001
		    ik_LlegChanin.parent = $Con_ballIK_L
		
		
			ik_RlegChanin = IKSys.ikChain $HP_upperLegIK_R $HP_ankleIK_R "IKHISolver"
			ik_RlegChanin.transform.controller.VHTarget = $HP_legIKSov_R
			ik_RlegChanin.transform.controller.posThresh = 0.001
			ik_RlegChanin.transform.controller.rotThresh = 0.001
			ik_RlegChanin.parent = $Con_ballIK_R
		

	-----------------------------------创建左腿FK控制器--------------------------------------------------------------------		
			l_legfkcon[1] =Circle radius:(unitis_value*10*rootSC)  transform:l_legBone[1].transform
			l_legfkcon[1].name = l_legfkConName[1]
			l_legfkcon[1].scale.controller = ScaleXYZ()
			l_legfkcon[1].wirecolor = (color 255 7 7)

		
	-----------------------------------创建右腿FK控制器--------------------------------------------------------------------			
			r_legfkcon[1] =Circle radius:(unitis_value*10*rootSC)  transform:r_legikPointPar[1].transform
			r_legfkcon[1].name = r_legfkConName[1]
			r_legfkcon[1].wirecolor = (color 0 0 255)
			
		
		for c = 2 to r_legBone.count do
		(   

------------------------------------左腿FK控制器------------	
			l_legfkcon[c] =Circle radius:(unitis_value*10*rootSC)  transform:l_legBone[c].transform
			l_legfkcon[c].name = l_legfkConName[c]			
			l_legfkcon[c].scale.controller = ScaleXYZ()	
			l_legfkcon[c].wirecolor = (color 255 7 7)


			-----------右腿FK控制器-------------			
			
			r_legfkcon[c] =Circle radius:(unitis_value*10*rootSC)  transform:r_legBone[c].transform
			r_legfkcon[c].name = r_legfkConName[c]
			r_legfkcon[c].scale.controller = ScaleXYZ()	
			r_legfkcon[c].wirecolor = (color 0 0 255)
		)

		------------------------控制器坐标整体旋转	
			in coordsys local Rotate l_legfkcon (EulerAngles 0 90 0)
            in coordsys local RotatePivotOnly l_legfkcon (EulerAngles 0 -90 0)	
		    in coordsys local Rotate r_legfkcon (EulerAngles 0 90 0)
            in coordsys local RotatePivotOnly $Con_ankleFK_R (EulerAngles 0 -90 0)
		
		
			in coordsys local Rotate l_legfkcon[4] (EulerAngles 0 90 0)
            in coordsys local RotatePivotOnly l_legfkcon[4] (EulerAngles 0 -90 0)	
		    in coordsys local Rotate r_legfkcon[4] (EulerAngles 0 90 0)
            in coordsys local RotatePivotOnly r_legfkcon (EulerAngles 0 -90 0)
		
		    $Con_toeFK_R.transform = $Con_toe_R.transform
		
		    $Con_ankleFK_L.transform = l_footIkCon[1].transform
			--in coordsys local Rotate  $Con_ankleFK_L (EulerAngles 0 90 0)
			$Con_ankleFK_R.transform = r_footIkCon[1].transform
			--in coordsys local Rotate  $Con_ankleFK_R (EulerAngles 0 90 0)
		
-----------------------------------------FK控制器归零----------		
		for fp = 2 to r_legBone.count do
		(
			cc = fp  --父物体count
			cc += fp
			l_legfkcon[fp].parent=l_legfkcon[fp-1]
			r_legfkcon[fp].parent=r_legfkcon[fp-1]
			
			l_legfkcon[fp].rotation.controller = rotation_list()
			l_legfkcon[fp].rotation.controller.setName 1 "zero"
			l_legfkcon[fp].rotation.controller.Available.controller = Euler_xyz()
			l_legfkcon[fp].rotation.controller.active = 2
			
			l_legfkcon[fp].position.controller = position_list()
			l_legfkcon[fp].position.controller.setName 1 "zero"
			l_legfkcon[fp].position.controller.Available.controller = Position_XYZ ()
			l_legfkcon[fp].position.controller.active = 2
			
			r_legfkcon[fp].rotation.controller = rotation_list()
			r_legfkcon[fp].rotation.controller.setName 1 "zero"
			r_legfkcon[fp].rotation.controller.Available.controller = Euler_xyz()
			r_legfkcon[fp].rotation.controller.active = 2
			
			r_legfkcon[fp].position.controller = position_list()
			r_legfkcon[fp].position.controller.setName 1 "zero"
			r_legfkcon[fp].position.controller.Available.controller = Position_XYZ ()
			r_legfkcon[fp].position.controller.active = 2	
			
			
			
		)

		
			l_legfkcon[3].rotation.controller.Euler_XYZ.controller[3].controller = Float_Expression ()
			l_legfkcon[3].rotation.controller.Euler_XYZ.controller[3].AddScalarTarget "RotZ" l_legfkcon[2].rotation.controller.Euler_XYZ.controller[3]
			l_legfkcon[3].rotation.controller.Euler_XYZ.controller[3].controller.setExpression "RotZ*0.5" 
		
		
			r_legfkcon[3].rotation.controller.Euler_XYZ.controller[3].controller = Float_Expression ()
			r_legfkcon[3].rotation.controller.Euler_XYZ.controller[3].AddScalarTarget "RotZ" r_legfkcon[2].rotation.controller.Euler_XYZ.controller[3]
			r_legfkcon[3].rotation.controller.Euler_XYZ.controller[3].controller.setExpression "RotZ*0.5" 


		
	----------------------------------------------------------------------给腿部骨骼做约束------------------------------------------------------------	
		


		for cons = 1 to (l_legBone.count-1) do
		(
			
			-----------位置约束---------------------
			l_legBone[cons].pos.controller = position_Constraint()
			l_legBone[cons].pos.controller.appendTarget l_legfkcon[cons] 50
			l_legBone[cons].pos.controller.appendTarget l_legikPointPar[cons] 50
			l_legBone[cons].pos.controller.relative = on   --------------打开偏移
				
			
			r_legBone[cons].pos.controller = position_Constraint()
			r_legBone[cons].pos.controller.appendTarget r_legfkcon[cons] 50
			r_legBone[cons].pos.controller.appendTarget r_legikPointPar[cons] 50
			r_legBone[cons].pos.controller.relative = on
		
			
			---------------旋转约束----------------------------------
			l_legBone[cons].rotation.controller = Orientation_Constraint()
			l_legBone[cons].rotation.controller.appendTarget l_legfkcon[cons] 50
			l_legBone[cons].rotation.controller.appendTarget l_legikPointPar[cons] 50
			
			l_legBone[cons].rotation.controller.relative = on
			
			r_legBone[cons].rotation.controller = Orientation_Constraint()
			r_legBone[cons].rotation.controller.appendTarget r_legfkcon[cons] 50
			r_legBone[cons].rotation.controller.appendTarget r_legikPointPar[cons] 50
			
			r_legBone[cons].rotation.controller.relative = on
			
			
		)
		
			l_legBone[5].pos.controller = position_Constraint()
			l_legBone[5].pos.controller.appendTarget l_legfkcon[5] 50
			l_legBone[5].pos.controller.appendTarget $Con_toe_L 50
			l_legBone[5].pos.controller.relative = on
		
			r_legBone[5].pos.controller = position_Constraint()
			r_legBone[5].pos.controller.appendTarget r_legfkcon[5] 50
			r_legBone[5].pos.controller.appendTarget $Con_toe_R 50
			r_legBone[5].pos.controller.relative = on
				
			
			
			l_legBone[5].rotation.controller = Orientation_Constraint()
			l_legBone[5].rotation.controller.appendTarget l_legfkcon[5] 50
			l_legBone[5].rotation.controller.appendTarget $Con_toe_L 50
			
			l_legBone[5].rotation.controller.relative = on
			
			r_legBone[5].rotation.controller = Orientation_Constraint()
			r_legBone[5].rotation.controller.appendTarget r_legfkcon[5] 50
			r_legBone[5].rotation.controller.appendTarget $Con_toe_R 50
			
			r_legBone[5].rotation.controller.relative = on





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