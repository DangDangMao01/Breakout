rollout jp_Facial_Tool "表情绑定第1课"
(
	Group "表情：请按流程创建"
	(
		button Cre_Points "创建初始点" width:100 height:22 enabled:true toolTip:"调节蓝色点，绿点镜像对齐"
		button CreateBones "创建骨骼" width:100 height:22 enabled:true toolTip:"点击创建表情骨骼"
		----button CreateControls “创建控制器” idth:100 height:22 enabled:false toolTip:"创建控制器及约束关系"
	)
	
	Group "链接：此为非流程操作"
	(
		pickButton link_bone "选取链接骨骼" enabled:false
		
	)
	
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	---- 定义变量初始值
	local PointNodeArray = #()  ---- 初始点
	local NodeforSelection = #()  ---- 节点列表的选择集
	local BoneNodeArray = #()
	local ChildPoints = #()
	local MidPoints = #()
	local Small_3_Controllers = #()
	
	fn MyCreatePoints_fn = ----创建原始点，将它们放入一个数组中，这是为localtion点设置的
	( 
		Local PointStore = #(
			--1-5
			(matrix3 [-0.75471,-0.656059,0] [0,1.49012e-07,1] [-0.656059,0.75471,-2.5332e-07] [-4.17625,-7.78465,184.164]),
			(matrix3 [-0.438371,-0.898794,5.47618e-07] [-3.1665e-07,6.23986e-07,1] [-0.898794,0.438371,-5.53206e-07] [-2.98312,-8.84338,184.211]),
			(matrix3 [-0.104528,-0.994522,1.46976e-07] [-4.34928e-07,1.28173e-07,1] [-0.994522,0.104528,-4.13507e-07] [-1.44151,-9.28397,183.442]),
			(matrix3 [1.29254e-07,-0.866026,0.5] [-3.36723e-07,0.5,0.866026] [-1,-3.40934e-07,-2.08731e-07] [-3.13794,-7.47525,182.594]),
			(matrix3 [1.47832e-07,-1,1.4901e-07] [-4.32466e-07,1.19211e-07,1] [-1,-1.90979e-07,-3.96467e-07] [-3.13794,-7.47525,182.594]),
						
			--6-10
			(matrix3 [-3.72529e-07,-0.866025,-0.5] [-4.17233e-07,-0.5,0.866025] [-1,3.27826e-07,0] [-3.13794,-7.47525,182.594]),
			(matrix3 [-0.104528,-0.994522,1.46976e-07] [-4.34928e-07,1.28173e-07,1] [-0.994522,0.104528,-4.13507e-07] [-1.09448,-9.36826,179.442]),
			(matrix3 [-0.939693,-0.34202,0] [-1.91852e-07,3.98606e-07,1] [-0.34202,0.939693,-4.99189e-07] [-4.10513,-5.77045,177.289]),
			(matrix3 [-0.422618,-0.906308,3.69735e-07] [-3.20375e-07,5.1735e-07,1] [-0.906308,0.422618,-6.29574e-07] [-0.860886,-9.29183,176.883]),
			(matrix3 [-0.731354,-0.681998,3.48547e-07] [-3.11993e-07,7.55303e-07,1] [-0.681998,0.731354,-7.62753e-07] [-1.57071,-8.42199,176.47]),
						
			--11-15
			(matrix3 [-0.438371,-0.898794,5.47618e-07] [-3.1665e-07,6.23986e-07,1] [-0.898794,0.438371,-5.53206e-07] [-0.773758,-9.09763,176.154]),
			(matrix3 [-0.44407,-0.871536,-0.207911] [0.200835,-0.322962,0.924857] [-0.873194,0.368945,0.318453] [-2.19856,-7.71925,174.771]),
			(matrix3 [0,-0.699624,-0.714511] [-1.49012e-07,-0.714511,0.699624] [-1,-1.56462e-07,-2.38419e-07] [0,-2.22895,179.714]),
			(matrix3 [-1.78814e-07,0.469472,0.882948] [-2.98023e-07,0.882948,-0.469472] [-1,-2.38419e-07,0] [0,-11.5439,179.153]),
			(matrix3 [1.47832e-07,-1,1.4901e-07] [-4.32466e-07,1.19211e-07,1] [-1,-1.90979e-07,-3.96467e-07] [0,-9.69181,176.924]),
					   
			--16-20
			(matrix3 [1.47832e-07,-1,1.4901e-07] [-4.32466e-07,1.19211e-07,1] [-1,-1.90979e-07,-3.96467e-07] [0,-9.47898,176.103]),
			(matrix3 [0,-0.945518,-0.325568] [-1.21989e-06,-0.325568,0.945519] [-1,2.77273e-07,-1.07746e-06] [0,-9.04332,173.748]),
			(matrix3 [0.754709,-0.656059,0] [-1.88127e-07,-3.44589e-07,1] [-0.656059,-0.75471,-3.65078e-07] [4.17607,-7.78465,184.164]),
			(matrix3 [0.438371,-0.898794,1.72114e-07] [-5.53206e-07,0,1] [-0.898794,-0.438371,-3.94881e-07] [2.98302,-8.84338,184.211]),
			(matrix3 [0.104529,-0.994522,1.63668e-07] [-3.1339e-07,1.27271e-07,1] [-0.994522,-0.104529,-2.63331e-07] [1.44202,-9.28397,183.442]),
						
			--21-25
			(matrix3 [1.29254e-07,-0.866026,0.5] [-3.36723e-07,0.5,0.866026] [-1,-3.40934e-07,-2.08731e-07] [3.13802,-7.47525,182.594]),
			(matrix3 [1.47832e-07,-1,1.4901e-07] [-4.32466e-07,1.19211e-07,1] [-1,-1.90979e-07,-3.96467e-07] [3.13802,-7.47524,182.594]),
			(matrix3 [-3.72529e-07,-0.866025,-0.5] [-4.17233e-07,-0.5,0.866025] [-1,3.27826e-07,0] [3.13802,-7.47524,182.594]),
			(matrix3 [0.104529,-0.994522,1.63668e-07] [-3.1339e-07,1.27271e-07,1] [-0.994522,-0.104529,-2.63331e-07] [1.09401,-9.36826,179.442]),
			(matrix3 [0.939693,-0.34202,0] [-1.94048e-07,-2.98023e-07,1] [-0.34202,-0.939693,-3.42727e-07] [4.10501,-5.77045,177.288]),
						
			--26-29
			(matrix3 [0.731354,-0.681998,0] [-3.50177e-07,-4.47035e-07,1] [-0.681998,-0.731354,-5.06639e-07] [1.571,-8.42199,176.47]),
			(matrix3 [0.422618,-0.906308,-2.12342e-07] [-5.56931e-07,-4.16301e-07,1] [-0.906308,-0.422619,-6.09085e-07] [0.861008,-9.29183,176.883]),
			(matrix3 [0.438371,-0.898794,0] [-5.51343e-07,-3.40864e-07,1] [-0.898794,-0.438371,-6.74278e-07] [0.774002,-9.09764,176.154]),
			(matrix3 [0.44407,-0.871536,-0.207912] [-0.200834,-0.322963,0.924857] [-0.873194,-0.368945,-0.318452] [2.19901,-7.71924,174.771])
			
			
		)
			
		if PointNodeArray[1] == undefined do
		( -- if nothing has been created then create the points
		  local TempDummy = dummy boxsize:[8,8,8]; --create dummy to link stuff to
				TempDummy.pos = [0,0,178.8]
				---rotate TempDummy (angleaxis 180 [0,1,0])
		  for i=1 to PointStore.count do
		  (
			  PointNodeArray[i] = point transform:PointStore[i] size:0.25 box:true  cross:false  axistripod:true centermarker:false Wirecolor:(color 255 255 0)
			  PointNodeArray[i].rotation.controller=Euler_XYZ(); -- needs EulerXYZ
			  PointNodeArray[i].position.controller=Position_XYZ()
			   
			  if PointNodeArray[i].pos[1] < 0 do (PointNodeArray[i].wirecolor=(color 90 255 90))
			  if PointNodeArray[i].pos[1] > 0 do (PointNodeArray[i].wirecolor=(color 90 90 255))
			  if PointNodeArray[i].pos[1] == 0 do (PointNodeArray[i].wirecolor=(color 255 255 0))
				  
			  PointNodeArray[i].name = "Guide Point" + (i as string)
			  PointNodeArray[i].parent = TempDummy
		   )----end for
		   
		   ----if sym_cre.checked then
		   ----(
				
				local PointConnect=#([1,18],[2,19],[3,20],[4,21],[5,22],[6,23],[7,24],[8,25],[9,26],[10,27],[11,28],[12,29]) ----which points reference which points
				
				for i=1 to PointConnect.count do  ----wire the points to their opposite
				(
					a = PointConnect [i] [1]  ----first inthe PointConnect array
					b = PointConnect [i] [2] 
					paramWire.connect PointNodeArray[a].pos.controller[#X_Position] PointNodeArray[b].pos.controller[#X_Position] "-X_Position"
					paramWire.connect PointNodeArray[a].pos.controller[#Y_Position] PointNodeArray[b].pos.controller[#Y_Position] "Y_Position"
					paramWire.connect PointNodeArray[a].pos.controller[#Z_Position] PointNodeArray[b].pos.controller[#Z_Position] "Z_Position"
					
					paramWire.connect PointNodeArray[a].rotation.controller[#X_Rotation] PointNodeArray[b].rotation.controller[#X_Rotation] "X_Rotation"
					paramWire.connect PointNodeArray[a].rotation.controller[#Y_Rotation] PointNodeArray[b].rotation.controller[#Y_Rotation] "Y_Rotation"
					paramWire.connect PointNodeArray[a].rotation.controller[#Z_Rotation] PointNodeArray[b].rotation.controller[#Z_Rotation] "Z_Rotation"
				)  ----end for
			----)
				
		)----end if
	)
	
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	
	fn ZeroNode_fn NodeToZero =  ----至零加属性
	(
		Plist = positionList()  -----Zero out the Pos
		NodeToZero.pos.controller = Plist
		Plist.setName 1 "Zero"
		Plist.available.controller = position_xyz()
		Plist.active = 2
		Plist.setname 2 "PositionXYZ"
		
		Rlist = rotationList()  ------Zero out the Rot
		NodeToZero.rotation.controller = Rlist
		Rlist.setName 1 "Zero"
		Rlist.available.controller = Euler_xyz()
		Rlist.active = 2
		Rlist.setname 2 "EulerXYZ"
	)
	

	fn MyCreateChildPoints =  ---- 创建点的控制器
	(
		layera = layermanager.newLayerfromName "Child Point"
		layera = LayerManager.getLayerFromName "Child Point"
		
		for i=1 to PointNodeArray.count do  ---- 在点的最近创建控制对象
		(
			ChildPoints[i] = Point centermarker:false axistripod:false cross:false box:true wireColor:[255,0,0]  ---- create points
			ChildPoints[i].size = 0.3 
			ChildPoints[i].rotation.controller = Euler_XYZ();  ---- needs EulerXYZ
			ChildPoints[i].position.controller = Position_XYZ()
			temptransform = PointNodeArray[i].transform
			ChildPoints[i].transform = temptransform
			ChildPoints[i].name = "Child Point" + (i as string)
			
			
			layera.addNode ChildPoints[i]
			
		) ---- end for
		
		
		
		layera = layermanager.newLayerfromName "Mid Point"
		layera = LayerManager.getLayerFromName "Mid Point"
		
		for i=1 to PointNodeArray.count do  ---- 创建中间点
		(
			MidPoints[i] = Point centermarker:false axistripod:false cross:false box:true wireColor:[227,153,153]  ---- create points
			MidPoints[i].size = 0.15 
			MidPoints[i].rotation.controller = Euler_XYZ();  ---- needs EulerXYZ
			MidPoints[i].position.controller = Position_XYZ()
			temptransform = PointNodeArray[i].transform
			MidPoints[i].transform = temptransform
			MidPoints[i].name = "MidPoint" + (i as string)
			ChildPoints[i].parent = MidPoints[i]
			ZeroNode_fn ChildPoints[i]
			layera.addNode MidPoints[i]
			
		) ---- end for
	)
	
	fn Mycontrol Ppos:[0,0,0] Pscale:1 Pname:"control" =  ---- 控制器图标创建
	(
		ss = SplineShape pos:[0,0,0]
		addNewSpline ss
		addKnot ss 1 #corner #line [0,-0.15,0]
		addKnot ss 1 #corner #line [0,-0.1,0.06]
		addKnot ss 1 #corner #line [0,-0.1,0.02]
		addKnot ss 1 #corner #line [0,-0.02,0.02]
		addKnot ss 1 #corner #line [0,-0.02,0.1]
		addKnot ss 1 #corner #line [0,-0.06,0.1]
		addKnot ss 1 #corner #line [0,0,0.15]
		addKnot ss 1 #corner #line [0,0.06,0.1]
		addKnot ss 1 #corner #line [0,0.02,0.1]
		addKnot ss 1 #corner #line [0,0.02,0.02]
		addKnot ss 1 #corner #line [0,0.1,0.02]
		addKnot ss 1 #corner #line [0,0.1,0.06]
		addKnot ss 1 #corner #line [0,0.15,0]
		addKnot ss 1 #corner #line [0,0.1,-0.06]
		addKnot ss 1 #corner #line [0,0.1,-0.02]
		addKnot ss 1 #corner #line [0,0.02,-0.02]
		addKnot ss 1 #corner #line [0,0.02,-0.1]
		addKnot ss 1 #corner #line [0,0.06,-0.1]
		addKnot ss 1 #corner #line [0,0,-0.15]
		addKnot ss 1 #corner #line [0,-0.06,-0.1]
		addKnot ss 1 #corner #line [0,-0.02,-0.1]
		addKnot ss 1 #corner #line [0,-0.02,-0.02]
		addKnot ss 1 #corner #line [0,-0.1,-0.02]
		addKnot ss 1 #corner #line [0,-0.1,-0.06]
		close ss 1
			
		ss.pos = Ppos
		updateShape ss
		addmodifier ss (xform())
		ss.xform.gizmo.scale = [Pscale,Pscale,Pscale]
		ss .name = uniquename Pname
		converttosplineshape ss

	)  ----MyControl


	
	fn make_3_con ID =   ---- 3控制关系建立
	(
		local Id = ID as string
		local Seltem = #()
		Seltem[1] = execute ("$" + "'" + "Child Point" + Id + "'")
		Seltem[2] = execute ("$" + "'" + "XCon" + Id + "'")
		Seltem[3] = execute ("$" + "'" + "XConP" + Id + "'")
		
		paramWire.connect Seltem[2].pos.controller[#PositionXYZ] Seltem[1].pos.controller[#PositionXYZ] "PositionXYZ"
		paramWire.connect Seltem[2].rotation.controller[#EulerXYZ] Seltem[1].rotation.controller[#EulerXYZ] "EulerXYZ"
		
		Seltem[3].pos.controller = position_list()
		PosCon = position_constraint()   ----创建位置约束
		Seltem[3].pos.controller.Available.controller = PosCon
		PosCon.appendTarget Seltem[1] 100
		PosCon.relative = on
			
		paramWire.connect Seltem[2].pos.controller[#PositionXYZ] Seltem[2].pos.controller[#PositionXYZ] "PositionXYZ*-1"
			
		Seltem[3].pos.controller = rotation_list()
		RosCon = Orientation_constraint()   ----创建方向约束
		Seltem[3].rotation.controller.Available.controller = PosCon
		RosCon.appendTarget Seltem[1] 100
		RosCon.relative = on
	) 
	
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	on Cre_Points pressed do
	(
		with undo off
		(
			if PointNodeArray.count == 0 do
			(
				MyCreatePoints_fn() --创建原始点
			)
		)
	)
	
	on CreateBones pressed do
	(
		MyCreateChildPoints()  ---- 创建点的控制器
		
		/*
		---- 建立3控制关系
		local Small_3_Controllers = #(1,2,3,4,5,6,7,8,9,10,11,12,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29) ---- 剔除大控制器编号
		for i=1 to Small_3_Controllers.count do
		(
			--local num = Small_3_Controllers[i]
			
			make_3_con Small_3_Controllers[i]
		
		)
			
		
		
		(
			local num = 3
			local tempTrans			
			tempTrans = selection[1].transform
			p = point size:0.5 box:true  cross:false  axistripod:false  centermarker:false Wirecolor:(color 27 177 27);
			P.name = "DConP" + (num as string)
			P.transform = TempTrans
			
			in coordsys p (p.pos = [1,0,0])  ---- 在p的相对坐标下偏移
			tempTrans = p.transform   ----子节点
			----append DConP_Control p   ----收集DConlP控制器
			----layerb.addNode p  ----加入集合
			
			sc = Mycontrol Pscale:2;  ---- Create small controller 创建小型控制器
			sc.transform = tempTrans;
			sc.name = "DConP" + (num as string)
			sc.wirecolor = (color 225 198 87)   ---- color it
			sc.parent = p
			ZeroNode_fn sc
	
		)		
		
		
		
*/
		

	
		
		
	)
	
	
) CreateDialog jp_Facial_Tool