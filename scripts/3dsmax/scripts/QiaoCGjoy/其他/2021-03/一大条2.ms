rollout unnamedRollout "一大条" 
(
	button 'boneLink' "来吧，一大条" 
	
	local pointNode = #()
	local boneNode = #()
	
	
	local pointStore = #(	
							(matrix3 [1,0,0] [0,-1.62921e-07,1] [0,-1,-1.62921e-07] [-89.4756,-4.26918e-07,9.76674]),
							(matrix3 [1,0,0] [0,-1.62921e-07,1] [0,-1,-1.62921e-07] [-32.0872,-4.42499e-07,10.1232]),
							(matrix3 [1,0,0] [0,-1.62921e-07,1] [0,-1,-1.62921e-07] [29.5786,-4.89241e-07,11.1925]),
							(matrix3 [1,0,0] [0,-1.62921e-07,1] [0,-1,-1.62921e-07] [81.9767,-4.89241e-07,11.1925]),
							(matrix3 [1,0,0] [0,-1.62921e-07,1] [0,-1,-1.62921e-07] [143.642,-4.7366e-07,10.8361]),
							(matrix3 [1,0,0] [0,-1.62921e-07,1] [0,-1,-1.62921e-07] [207.447,-4.42499e-07,10.1232]),
							(matrix3 [1,0,0] [0,-1.62921e-07,1] [0,-1,-1.62921e-07] [281.972,-4.42499e-07,10.1232])
						) 	

	fn MyCreatPoints_fn =
	(
		if pointNode[1]== undefined then
		(
		
			for i = 1 to pointStore.count do
			(
				pointNode[i] = Point transform:pointStore[i] size:1 box:on cross:off centermarker:off axistripod: off size:10
				pointNode[i].rotation.controller = Euler_xyz()
				pointNode[i].position.controller = position_xyz()

				if pointNode[i].pos[1] <0 do (pointNode[i].wirecolor = (color 90 255 90))
				if pointNode[i].pos[1] >0 do (pointNode[i].wirecolor = (color 90 90 255))

				pointNode[i].name = "Guide_point" + (i as string)
					
			)				
		   
		)
		
		
		
		for x = 1 to pointNode[i] do
		(
		
			boneNode[x] = BoneSys.createBone pointNode[x].pos pointNode[x-1].pos [0,1,0]
			boneNode[x].width =10
			boneNode[x].height =10
			boneNode[x].frontfin =true
			oneNode[x].frontfinsize =1
			
		)
		
			/*
			tempBone01 = BoneSys.createBone $Guide_point1.pos $Guide_point2.pos [0,1,0]
			tempBone01.width =10
			tempBone01.height =10
			tempBone01.frontfin =true
			tempBone01.frontfinsize =1
		
			tempBone02 = BoneSys.createBone $Guide_point2.pos $Guide_point3.pos [0,1,0]
			tempBone02.width =10
			tempBone02.height =10
			tempBone02.frontfin =true
			tempBone02.frontfinsize =1
		
			tempBone03 = BoneSys.createBone $Guide_point3.pos $Guide_point4.pos [0,1,0]
			tempBone03.width =10
			tempBone03.height =10
			tempBone03.frontfin =true
			tempBone03.frontfinsize =1
		
		
			tempBone04 = BoneSys.createBone $Guide_point4.pos $Guide_point5.pos [0,1,0]
			tempBone04.width =10
			tempBone04.height =10
			tempBone04.frontfin =true
			tempBone04.frontfinsize =1
			
			
		
			tempBone05 = BoneSys.createBone $Guide_point5.pos $Guide_point6.pos [0,1,0]
			tempBone05.width =10
			tempBone05.height =10
			tempBone05.frontfin =true
			tempBone05.frontfinsize =1
		
			tempBone06 = BoneSys.createBone $Guide_point6.pos $Guide_point7.pos [0,1,0]
			tempBone06.width =10
			tempBone06.height =10
			tempBone06.frontfin =true
			tempBone06.frontfinsize =1
		*/

	)
	
	on boneLink pressed  do
	(

         MyCreatPoints_fn() 


	)	
	


)
CreateDialog unnamedRollout