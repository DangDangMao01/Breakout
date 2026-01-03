rollout unnamedRollout "一大条" 
(
	button 'boneLink' "来吧，一大条" 
	
	local pointNode = #()
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

				pointNode[i].name = "Guide point" + (i as string)
					
			)				
		   
		)
		
		
		
		tempBone = #()   
		tempBone[1] = BoneSys.createBone selection[1].pos selection[2].pos [0,1,0]
		tempBone[1].width =10
		tempBone[1].height =10
		tempBone[1].frontfin =true
		tempBone[1].frontfinsize =1
		for x= 2 to spointStore.count-1 do
			(
				tempBone[x] = BoneSys.createBone selection[i].pos selection[i + 1].pos [0,1,0]
				tempBone[x].width =10
				tempBone[x].height =10
				tempBone[x].frontfin =true
				tempBone[x].frontfinsize =1
				tempBone[x].parent =tempBone[i - 1]
			)
		
		
		
		
		
		
		
		
		

	)
	
	on boneLink pressed  do
	(

         MyCreatPoints_fn() 


	)	
	


)
CreateDialog unnamedRollout