-- fn FN_Cre_Spline name:"" Pos:[0,0,0] VertexArr:#array =
-- (
-- 	
-- )
fn FN_Get_SplineKnotPos fnTarget:undefined =
(
	splineKnotPos = #()
	knotCount = numKnots fnTarget 1
	for i = 1 to knotCount do
	(
		splineKnotPos[i] getKnotPoint fnTarget 1 i
	)
	print(splineKnotPos)
)
-- a = numknots $

-- local sp = splineShape()
-- addnewSpline sp
-- addKnot sp 1 #corner #line [20,10,0]
-- addKnot sp 1 #corner #line [-20,11,0]
-- addKnot sp 1 #corner #line [-20,-11,0]
-- addKnot sp 1 #corner #line [20,-10,0]
-- close sp 1
-- updateShape sp
-- select sp
-- subobjectlevel = 1
-- setKnotSelection sp 1 #(1,4) keep:false 
-- weldSpline sp 21.0

-- lineKnot_Count = numknots $
-- subobjectlevel = 1
-- a  = setKnotSelection sp 1 #(1)
-- a.pos

rollout test "test"
(
	fn FN_Get_SplineKnotPos fnTarget:undefined =
	(
		global splineKnotPos = #()
		knotCount = numKnots fnTarget 1
		for i = 1 to knotCount do
		(
			splineKnotPos[i] =  getKnotPoint fnTarget 1 i
		)
		print(splineKnotPos)
	)
	fn Fn_Cre_Line _name:"ctrl" _pos:[0,0,0] _scale:1 kont_arr:#array  = --十字控制器
	(
		ss = splineShape pos:[0,0,0]
		addnewSpline ss
		for i = 1 to splineKnotPos.count do
		(
			addKnot ss 1 #corner #line kont_arr[i]
		)
-- 		close ss 1
		ss.pos = _pos
		updateShape ss
		addmodifier ss (xform())
		ss.xform.gizmo.scale = [_scale,_scale,_scale]
		converttosplineshape ss
-- 		ss.name = _name
-- 		ss.wirecolor = _wirecolor
	)

	button 'btn_getKonts'  "获得点坐标"  width:75 height:20
	button 'btn_creLine'  "创建曲线"  width:75 height:20
	on 'btn_getKonts' pressed do
	(
		 FN_Get_SplineKnotPos fnTarget:selection[1]
	)
	
	on 'btn_creLine' pressed do
	(
		print(splineKnotPos)
		kont_array = #([17.5349,9.57591,0], [35.9268,-23.4507,0], [4.1264,-24.3269,0], [-9.64285,9.85369,0])
		Fn_Cre_Line _name:"ctrl" _pos:[0,0,0] _scale:1 kont_arr:splineKnotPos
	)
)
createdialog  test















