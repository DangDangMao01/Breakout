rollout test "Create Controller"width:250 height:750
(
	group "Controller Group "
	(
		button btn_imageButton1 width:40 height:40 across:5
		button btn_imageButton2 width:40 height:40 
		button btn_imageButton3 width:40 height:40 
		button btn_imageButton4 width:40 height:40 
		button btn_imageButton5 width:40 height:40 
		button btn_imageButton6 width:40 height:40 across:5
		button btn_imageButton7 width:40 height:40 
-- 		button btn_imageButton8 width:40 height:40 
-- 		button btn_imageButton9 width:40 height:40 
-- 		button btn_imageButton10 width:40 height:40 
	)

	local arrowCurve_arr = #([-2.5,0,0], [-2.5,0,5], [2.5,0,5], [2.5,0,0], [5,0,0], [0,0,-5], [-5,0,0], [-2.5,0,0])
	local moveCurve_arr =#([0,5,0],[-2,3,0],[-1,3,0],[-1,1,0],[-3,1,0],[-3,2,0],[-5,0,0],[-3,-2,0],[-3,-1,0],[-1,-1,0],[-1,-3,0],[-2,-3,0],[0,-5,0],[2,-3,0],[1,-3,0],[1,-1,0],[3,-1,0],[3,-2,0],[5,0,0],[3,2,0],[3,1,0],[1,1,0],[1,3,0],[2,3,0])
	local crownCurve_arr = #([-3.35037,-4.6114,2],[-2.93892,-4.04509,0],[-1.54508,-4.75528,0],[-1.76139,-5.42102,2],[5.50391e-06,-5.7,2],[4.828e-06,-5,0],[1.54509,-4.75528,0],[1.7614,-5.42102,2],[3.35038,-4.61139,2],[2.93893,-4.04508,0],[4.04509,-2.93892,0],[4.6114,-3.35037,2],[5.42102,-1.76139,2],[4.75528,-1.54508,0],[5,0,0],[5.7,0,2],[5.42102,1.7614,2],[4.75528,1.54508,0],[4.04508,2.93893,0],[4.6114,3.35038,2],[3.35038,4.6114,2],[2.93893,4.04508,0],[1.54508,4.75528,0],[1.7614,5.42102,2],[-2.49155e-07,5.7,2],[-2.18557e-07,5,0],[-1.54509,4.75528,0],[-1.7614,5.42102,2],[-3.35038,4.6114,2],[-2.93893,4.04508,0],[-4.04509,2.93893,0],[-4.6114,3.35038,2],[-5.42102,1.7614,2],[-4.75528,1.54508,0],[-5,-1.62921e-06,0],[-5.7,-1.8573e-06,2],[-5.42102,-1.7614,2],[-4.75528,-1.54509,0],[-4.04508,-2.93893,0],[-4.61139,-3.35038,2])
	local cubeCurve_arr = #([-5,5,5], [-5,5,-5], [-5,-5,-5], [-5,-5,5], [5,-5,5], [5,-5,-5], [-5,-5,-5], [-5,5,-5], [5,5,-5], [5,-5,-5], [5,-5,5], [5,5,5], [5,5,-5], [5,5,5], [-5,5,5], [-5,-5,5])
	local diamondCurve_arr = #([0,0,10],[-5,5,5],[-5,-5,5],[0,0,10],[5,-5,5],[-5,-5,5],[5,-5,5],[5,5,5],[0,0,10],[-5,5,5],[5,5,5],[5,5,-5],[-5,5,-5],[-5,5,5],[-5,5,-5],[-5,-5,-5],[-5,-5,5],[5,-5,5],[5,-5,-5],[-5,-5,-5],[5,-5,-5],[5,5,-5],[0,0,-10],[-5,5,-5],[0,0,-10],[5,-5,-5],[-5,-5,-5],[0,0,-10])
	local singleRotateCurve_arr = #([-2.10018,4.84163,0],[-3.70502,4.52401,0],[-3.31377,4.13482,0],[-4.13482,3.31377,0],[-4.76084,2.32965,0],[-5.15989,1.21441,0],[-5.3,-4.76837e-07,0],[-5.15988,-1.21441,0],[-4.76084,-2.32965,0],[-4.13482,-3.31377,0],[-3.31377,-4.13482,0],[-2.32965,-4.76084,0],[-1.21441,-5.15989,0],[0,-5.3,0],[1.21441,-5.15989,0],[2.32965,-4.76084,0],[3.31377,-4.13482,0],[4.13482,-3.31377,0],[4.76084,-2.32965,0],[5.15988,-1.21441,0],[5.3,0,0],[5.15989,1.21441,0],[4.76084,2.32965,0],[4.13482,3.31377,0],[3.31377,4.13482,0],[3.70502,4.52401,0],[2.10018,4.84163,0],[2.56179,3.22103,0],[2.93863,3.66672,0],[3.66672,2.93863,0],[4.22188,2.06592,0],[4.57575,1.07693,0],[4.7,0,0],[4.57575,-1.07693,0],[4.22188,-2.06592,0],[3.66672,-2.93863,0],[2.93863,-3.66672,0],[2.06592,-4.22188,0],[1.07693,-4.57575,0],[0,-4.7,0],[-1.07693,-4.57575,0],[-2.06592,-4.22188,0],[-2.93863,-3.66673,0],[-3.66672,-2.93863,0],[-4.22188,-2.06592,0],[-4.57575,-1.07693,0],[-4.7,-4.17233e-07,0],[-4.57575,1.07693,0],[-4.22188,2.06592,0],[-3.66673,2.93863,0],[-2.93863,3.66672,0],[-2.56179,3.22103,0])
	fn FN_Cre_BaseLine _pos:[0,0,0] _scale:1 kont_arr:#array _wirecolor:red _name:"tempName" =
	(
		ss = splineShape pos:[0,0,0]
		addnewSpline ss
		for i = 1 to kont_arr.count do
		(
			addKnot ss 1 #corner #line kont_arr[i]
		)
		close ss 1
		ss.pos = _pos
		updateShape ss
		addmodifier ss (xform())
		ss.xform.gizmo.scale = [_scale,_scale,_scale]
		converttosplineshape ss
		ss.wirecolor = _wirecolor
		ss.name = uniquename  (_name)
	)
	fn FN_AttachSplines sp splines: =   --ºÏ²¢Splines
	(
		convertToSplineShape sp
		for s in splines where s != sp do
		(
			addandweld sp (converttosplineshape s) -1		
		)
		return sp
	)
	fn FN_sphereCurve _name:"sphereCurve" _wirecolor:red =
	(
		cre_a = Circle radius:5 transform:(matrix3 [0,-1,0] [0,0,1] [-1,0,0] [0,0,0]) isSelected:on
		max modify mode
		macros.run "Modifier Stack" "Convert_to_Spline"
		cre_b = copy cre_a
		Rotate cre_b (eulerangles 0 0 90)
		cre_c = copy cre_a
		Rotate cre_c (eulerangles 0 90 0)
		splObjsArr = #(cre_a,cre_b,cre_c)
		baseCtrl = FN_attachSplines splObjsArr[1] splines:splObjsArr
		baseCtrl.name =  uniquename  (_name)
		baseCtrl.parent = basePoint
		baseCtrl.wirecolor = _wirecolor
		return baseCtrl
	)

	local theButtons = 
	#(
		btn_imageButton1, btn_imageButton2, btn_imageButton3, btn_imageButton4, btn_imageButton5,
		btn_imageButton6, btn_imageButton7
	)

	fn updateButtons =
	(
		local str_path = "C:\Users\Administrator\Desktop\Curves\\"
		local str_pic_array = 
		#(
			"ArrowCurve.png","MoveControl.png","CrownCurve.png","CubeCurve.png","Diamond.png",
			"SingleRotateControl.png","SphereControl.png"
		)
		for i = 1 to theButtons.count do
		(
			global temp_pic_path = str_path + str_pic_array[i]
			print(temp_pic_path)
			theButtons[i].images  = #(temp_pic_path,undefined,1,1,1,1,1)
		)
	)
	on test open do 
	(
		updateButtons()
	)
	
	on btn_imageButton1 pressed do
	(
		FN_Cre_BaseLine _scale:1 kont_arr:arrowCurve_arr _name:"arrowCurve"
	)
	on btn_imageButton2 pressed do
	(
		FN_Cre_BaseLine _scale:1 kont_arr:moveCurve_arr _name:"moveCurve"
	)
	on btn_imageButton3 pressed do
	(
		FN_Cre_BaseLine _scale:1 kont_arr:crownCurve_arr _name:"crownCurve"
	)
	on btn_imageButton4 pressed do
	(
		FN_Cre_BaseLine _scale:1 kont_arr:cubeCurve_arr _name:"cubeCurve"
	)
	on btn_imageButton5 pressed do
	(
		FN_Cre_BaseLine _scale:1 kont_arr:diamondCurve_arr _name:"diamondCurve"
	)
	on btn_imageButton6 pressed do
	(
		FN_Cre_BaseLine _scale:1 kont_arr:singleRotateCurve_arr _name:"singleRotateCurve"
	)
	on btn_imageButton7 pressed do
	(
		FN_sphereCurve()
	)

)
createdialog test

