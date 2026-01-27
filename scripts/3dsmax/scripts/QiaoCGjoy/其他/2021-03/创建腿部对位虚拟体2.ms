rollout Test "创建腿部根对位虚拟体"
(
	local l_pointNodeLeg = #()
	local r_pointNodeLeg = #()
	local l_pointStore = 
	#(    --左腿虚拟体
		(matrix3 [0.052639,0.0644378,-0.996532] [-0.00245872,-0.997905,-0.0646564] [-0.998611,0.00585368,-0.0523702] [9.26485,-2.1575,112.602]),
		(matrix3 [0.0526971,0.113537,-0.992135] [0.000194415,-0.993517,-0.113684] [-0.998611,0.00579796,-0.0523776] [11.6711,0.939788,67.0668]),
		(matrix3 [0,-0.850683,-0.525678] [-2.11549e-07,-0.525678,0.850683] [-1,0,-2.39495e-07] [14.5208,9.58019,13.6917]),
		(matrix3 [0.000577364,-0.958764,-0.284202] [-1.65586e-07,-0.284202,0.958764] [-1,-0.000553509,-0.000164247] [14.5208,-7.89591,2.89231]),
		(matrix3 [0,-0.958765,-0.284202] [6.05299e-06,-0.284202,0.958765] [-1,-1.67523e-06,5.81674e-06] [14.5269,-17.9281,-0.0814842])
	)
	local r_pointStore = 
	#(  --右腿虚拟体
		(matrix3 [-0.0526423,0.0644406,-0.996532] [-0.00240467,0.997905,0.0646564] [0.99861,0.00579999,-0.052377] [-9.265,-2.15749,112.602]),
		(matrix3 [-0.0526025,0.113528,-0.992141] [0.000193745,0.993518,0.113675] [0.998616,0.00578734,-0.0522835] [-11.667,0.935024,67.0662]),
		(matrix3 [4.48692e-05,-0.850684,-0.525678] [-6.12499e-06,0.525678,-0.850684] [1,4.14489e-05,1.83613e-05] [-14.5116,9.58018,13.6917]),
		(matrix3 [0,-0.958765,-0.284202] [5.95585e-06,0.284202,-0.958764] [1,-1.69605e-06,5.66399e-06] [-14.521,-7.89592,2.89231]),
		(matrix3 [0,-0.958765,-0.284202] [5.95585e-06,0.284202,-0.958764] [1,-1.69605e-06,5.66399e-06] [-14.527,-17.9281,-0.0814821])
	)
	fn MyCreatPoints_fn = --创建原始点，将他们放入一个数组中，这是为localtion点设置的
	(

			local TempCircle =Circle radius:50
			TempCircle.name = "con_bodyRoot"		
			TempCircle.pos = [0,0,0]
-- 			   
			for i = 1 to l_pointStore.count do
			(
				---创建左边
				l_pointNodeLeg[i] = Point transform:l_pointStore[i] size:1 box:on cross:off centermarker:off axistripod: off size:10 wirecolor:blue
				l_pointNodeLeg[i].rotation.controller = Euler_xyz()  	-- 创建位置列表
				l_pointNodeLeg[i].position.controller = position_xyz()  	-- 创建旋转列表
				l_pointNodeLeg[i].name = "left_guide_point" + (i as string)
				
				---创建右边边
				r_pointNodeLeg[i] = Point transform:r_pointStore[i] size:1 box:on cross:off centermarker:off axistripod: off size:10 wirecolor:red
				r_pointNodeLeg[i].rotation.controller = Euler_xyz()
				r_pointNodeLeg[i].position.controller = position_xyz()
				r_pointNodeLeg[i].name = "right_guide_point" + (i as string)	  
			)
			
			
			
			
			
			
			
			for x = 1 to l_pointStore.count do
			(
				---创建左边
				l_pointNodeLeg[x] = Point transform:l_pointStore[x] size:1 box:off cross:on centermarker:off axistripod: off size:10 wirecolor:blue
				l_pointNodeLeg[x].rotation.controller = Euler_xyz()  	-- 创建位置列表
				l_pointNodeLeg[x].position.controller = position_xyz()  	-- 创建旋转列表
				l_pointNodeLeg[x].name = "left_par_point" + (x as string)
				hide l_pointNodeLeg[x]
				
				---创建右边边
				r_pointNodeLeg[x] = Point transform:r_pointStore[x] size:1 box:off cross:on centermarker:off axistripod: off size:10 wirecolor:red
				r_pointNodeLeg[x].rotation.controller = Euler_xyz()
				r_pointNodeLeg[x].position.controller = position_xyz()
				r_pointNodeLeg[x].name = "right_par_point" + (x as string)
				hide r_pointNodeLeg[x]
			)
			
			
			$left_guide_point5.parent = $left_par_point5
			$left_guide_point4.parent = $left_par_point4
			$left_guide_point3.parent = $left_par_point3
			$left_guide_point2.parent = $left_par_point2
			$left_guide_point1.parent = $left_par_point1
			
			$left_par_point5.parent = $left_guide_point4
			$left_par_point4.parent = $left_guide_point3
			$left_par_point3.parent = $left_guide_point2
			$left_par_point2.parent = $left_guide_point1
			
			$right_guide_point5.parent = $right_par_point5
			$right_guide_point4.parent = $right_par_point4
			$right_guide_point3.parent = $right_par_point3
			$right_guide_point2.parent = $right_par_point2
			$right_guide_point1.parent = $right_par_point1
						
			$right_par_point5.parent = $right_guide_point4
			$right_par_point4.parent = $right_guide_point3
			$right_par_point3.parent = $right_guide_point2
			$right_par_point2.parent = $right_guide_point1
			
			
			
			
			---左右 链接到  root
			l_pointNodeLeg[1].parent = TempCircle   
			r_pointNodeLeg[1].parent = TempCircle
			
			
			for k = 1 to l_pointNodeLeg.count do
			(
			paramWire.connect l_pointNodeLeg[k].pos.controller[#Y_Position] r_pointNodeLeg[k].pos.controller[#Y_Position] "-Y_Position"
			
			
			)
		
	)
	
	button 'btn_cre' "创建腿部对位虚拟体" width:100 height:25 across:1
	on 'btn_cre' pressed do
	(
		MyCreatPoints_fn()
	)
)
createdialog Test