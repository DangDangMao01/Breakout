rollout unnamedRollout "一大条" 
(
	button 'boneLink' "来吧，一大条" 
	
	local pointNode = #()
	local boneNode = #()
	
	
	local pointStore = #(	
(matrix3 [1,0,0] [0,-1.62921e-07,1] [0,-1,-1.62921e-07] [-86.4524,-5.34346e-07,12.2244]),
(matrix3 [1,0,0] [0,-1.62921e-07,1] [0,-1,-1.62921e-07] [-52.4259,-7.65711e-07,17.5174]),
(matrix3 [1,0,0] [0,-1.62921e-07,1] [0,-1,-1.62921e-07] [-6.80525,-8.5385e-07,19.5338]),
(matrix3 [1,0,0] [0,-1.62921e-07,1] [0,-1,-1.62921e-07] [32.7663,-3.02982e-07,6.93142]),
(matrix3 [1,0,0] [0,-1.62921e-07,1] [0,-1,-1.62921e-07] [74.3542,6.77563e-07,-15.5008]),
(matrix3 [1,0,0] [0,-1.62921e-07,1] [0,-1,-1.62921e-07] [115.186,1.44878e-06,-33.1442]),
(matrix3 [1,0,0] [0,-1.62921e-07,1] [0,-1,-1.62921e-07] [147.196,1.23945e-06,-28.3553])
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
		
				boneNode[1] =  BoneSys.createBone pointNode[1].pos pointNode[2].pos [0,1,0]
				boneNode[1].width =10
				boneNode[1].height =10
				boneNode[1].frontfin =true
				boneNode[1].frontfinsize =1
		
			for x = 2 to pointNode.count-1 do
				(
					
				--boneNode_count =x
				--boneNode_count +=1	
				boneNode[x] = BoneSys.createBone pointNode[x].pos pointNode[x+1].pos [0,1,0]
				boneNode[x].width =10
				boneNode[x].height =10
				boneNode[x].frontfin =true
				boneNode[x].frontfinsize =1
				boneNode[x].parent = boneNode[x-1]
			    --boneNode[x].name = #("aaaa","bbbb","ccccc")

				)	

           for j = 1 to boneNode.count do
			(

				boneNode[j].pos.controller = position_Constraint()
				boneNode[j].pos.controller.appendTarget pointNode[j] 100
				

				boneNode[j].rotation.controller = LookAt_constraint()
				boneNode[j].rotation.controller.appendTarget pointNode[j+1] 100
                boneNode[j].rotation.controller.lookat_vector_length=0  
				boneNode[j].rotation.controller.upnode_world=false
				boneNode[j].rotation.controller.pickupNode=pointNode[j]	
				
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