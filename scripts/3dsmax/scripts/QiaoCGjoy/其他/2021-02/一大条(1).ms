rollout unnamedRollout "一大条" 
(
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
	
	           if pointNode[1]= undefined then
		   (
		
		        for i = 1 to pointStore.count do
			(
				pointNode[i] = Point transform:pointStore[i] size:1 box:on cross:off centermarker:off axistripod: off size:10
				pointNode[i].rotation.controller = Euler_xyz()
				pointNode[i].position.controller = position_xyz()


				if pointNode[i].pos[1] <0 do (pointNodeLeg[i].wirecolor = (color 90 255 90))
				if pointNode[i].pos[1] >0 do (pointNodeLeg[i].wirecolor = (color 90 90 255))

				pointNode[i].name = "Guide point" + (i as string)
					
			)				
		   
		   )
	
	
	
         )
	
	
	
	
	

        button 'boneLink' "来吧，一大条" 
	on boneLink pressed  do
(
	
         MyCreatPoints_fn() 


	)
)
CreateDialog unnamedRollout