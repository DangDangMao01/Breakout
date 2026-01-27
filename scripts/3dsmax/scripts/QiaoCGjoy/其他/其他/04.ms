(
local PointNodeArray=#() -- 初始点
fn MyCreatePoints_fn = -- 创建原始点。将它们放入一个数组中，这是为localtion点设置的。
(
	
    local PointStore=#(--1-5
                          (matrix3 [0.955839,-0.293891,0] [0.293891,0.955839,0] [0,0,1] [0.841608,-0.821608,25.6638]),
                          (matrix3 [0.041113,-0.999155,0] [0.999155,0.041113,0] [0,0,1] [0.244561,-1.20129,25. 4786]),
                          (matrix3 [0.847059,-0.529556,-0.0453941] [0.528048,0.848201,-0.041475] [0.0604667,0.0111615,0.998108] [0.81342,-0.684149,24.8553]),
                          (matrix3 [0.936878,-0.0410771,-0.347234] [-0.0017712,0.992505,-0.12219] [0.349651,0.115092,0.929784] [0.205935,-1,09814,24.8167]),
                          (matrix3 [0.749808,-0.512963,-0.417919] [0.560874,0.827843,-0.00982254] [0.35101,-0.227035,0.908431] [0.609321,-069138,24.3282]),
                        --6-10
                          (matrix3 [0.672836,-0.718784,-0.175047] [0.731782,0.681376,0.0148918] [0.108569,-0.138116,0.984448] [0.308467,-0.93163,24.2838]),
                          (matrix3 [0.624849,-0.779325,0.0470836] [0.774808,0.611545,-0.160266] [0.0961056,0.136623,0.98595] [0.167356,-1,06457,24.3166]),
                          (matrix3 [0.58367,-0.78937,-0.190326] [0.807462,0.539526,0.238571] [-0.0856352,-0.292928,0.952292] [0.167324,-1,03554,24.2096]),
                          (matrix3 [0.689399,-0.555986,-0.464337] [0.635647,0.771728,0.0196921] [0.347393,-0.30873,0.88544] [0.292917,-0.790374,23,9302]),
                          (matrix3 [0,-0.535233,-0.844705] [0,-0.844704,0.535233] [-1,0,0] [0,-1,16619,25.095]),
                        --11-15
                          (matrix3 [0,-0.999558,-0.0297172] [1,0,0] [0,-0.0297172,0.999558] [0,-1.12522,24.339]),
                          (matrix3 [0,-0.949581,-0.313523] [1,0,0] [0,-0.313523,0.949581] [0,-1.07281,24.191]),
                          (matrix3 [0,-0.6486,-0.76113] [0,-0.76113,0.6486] [-1,0,0] [0,0.349469,24.9486]),
                          (matrix3 [-0.955839,-0.293891,0] [0.293891,-0.955839,0] [0,0,1] [-0.841608,-0.821608,25.6638]),
                          (matrix3 [-0.0411131,-0.999155,0] [0.999155,-0.0411131,0] [0,0,1] [-0.244561,-1.20129,25.4786]),
                        --16-20
                          (matrix3 [-0.847059,-0.529556,-0.0453941] [0.528047,-0.848201,0.0414749] [-0.0604667,0.0111615,0.998108] [-0.81342,-0.684149,24.8553]),
                          (matrix3 [-0.936879,-0.0410774,-0.347234] [-0.00177088,-0.992505,0.12219] [-0.349651,0.115092,0.929784] [-0.205935,-1.09814,24.8167]),
                          (matrix3 [-0.749808,-0.512963,-0.417919] [0.560874,-0.827843,0.0098226] [-0.35101,-0.227035,0.908431] [-0.609321,-0.69138,24.3282]),
                          (matrix3 [-0.672836,-0.718784,-0.175046] [0.731782,-0.681376,-0.0148916] [-0.108569,-0.138115,0.984448] [-0.308467,-0.93163,24.2838]),
                          (matrix3 [-0.624849,-0.779325,0.0470836] [0.774808,-0.611545,0.160266] [-0.0961056,0.136623,0.98595] [-0.167356,-1.06457,24.3166]),
                        --21-22
                          (matrix3 [-0.583671,-0.78937,-0.190326] [0.807462,-0.539526,-0.238571] [0.0856352,-0.292928,0.952292] [-0.167324,-1.03554,24.2096]),
                          (matrix3 [-0.689398,-0.555987,-0.464337] [0.635648,-0.771728,-0.0196922] [-0.347393,-0.30873,0.88544] [-0.292917,-0.790374,23.9302])
						  
                        )



         if PointNodeArray[1] == undefined do
             ( -- if nothing has been created then create the points
			    local TempDummy=dummy boxsize: [1,1,1];  -- create dummy to link stuff to
					TempDummy.pos = [0,0,25]
                     -- rotate TempDummy (angleaxis 180 [0,1,0]
					for i = 1 to PointConnect.count do
				        (
							PointNodeArray[i] = point transform:PointStore[i] size:0.25 box:true cross:false axistripod:true centermarker:false wirecolor:(color 255 255 0)
					    	PointNodeArray[i].rotation.controller=Euler_XYZ(); -- needs EulerXYZ
							PointNodeArray[i].position.controller=Position_XYZ()
					   
					        if PointNodeArray[i].pos[i] < 0 do (PointNodeArray[i].wirecolor=(color 90 255 90))
					        if PointNodeArray[i].pos[i] > 0 do (PointNodeArray[i].wirecolor=(color 90 90 255))
					        if PointNodeArray[i].pos[i] = 0 do (PointNodeArray[i].wirecolor=(color 255 255 0))
	
						    PointNodeArray[i].name = "Guide Point" + (i as string)
							PointNodeArray[i].parent=TempDummy;
						) -- end for
							
				-- if sym_cre.checked then
				-- (
				
					
					local PointConnect=#([1,14],[2,15],[3,16],[4,17],[5,18],[6,19],[7,20],[8,21],[9,22]) -- which points reference chich points
							
						for i =1 to pointConnect.count do -- wire the points to their opposite
								    (
									a= pointConnect [i] [1] -- first in the PointConnect array
									b= pointConnect [i] [2]	
									paramWire.connect PointNodeArray[a].pos.controller[#X_Position] PointNodeArray[b].pos.controller[#X_Position]“-X_Position”
									paramWire.connect PointNodeArray[a].pos.controller[#Z_Position] PointNodeArray[b].pos.controller[#Z_Position]“Z_Position”	
									paramWire.connect PointNodeArray[a].pos.controller[#Y_Position] PointNodeArray[b].pos.controller[#Y_Position]“Y_Position”	
										
									paramWire.connect PointNodeArray[a].pos.controller[#X_Position] PointNodeArray[b].pos.controller[#X_Position]“X_Position”	
									paramWire.connect PointNodeArray[a].pos.controller[#Y_Position] PointNodeArray[b].pos.controller[#Y_Position]“-Y_Position”	
									paramWire.connect PointNodeArray[a].pos.controller[#Z_Position] PointNodeArray[b].pos.controller[#Z_Position]“-Z_Position”	
									) -- end for	
				--)
			) -- end if
		) -- 创建初始点
	)