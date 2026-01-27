rollout test "????????"
(
	button 'btn_' "??ik??"  width:75 height:20
	global star_point =  $point001
	global end_point =  $point002
	global length01 = $bone001.length
	global length02 = $bone002.length
	global sub_length = length01 + length02
	global bone_arry = #($bone002,$bone003)
	
	fn FN_ZeroNode fnTarget = 		--??
	(
		Plist = positionList()		--zero out the pos
		fnTarget.pos.controller = Plist
		Plist.setName 1 "original"
		Plist.Available.controller = position_xyz()
		Plist.setname 2 "animator"
		Plist.active = 2
		
		Rlist = rotation_list()		--zero out the Rot
		fnTarget.rotation.controller = Rlist
		Rlist.setName 1 "original"
		Rlist.available.controller = Euler_xyz()
		Rlist.setname 2 "animator"
		Rlist.active = 2
	)
	fn FN_Create =
	(
		str_exp = "if (length(star_point - end_point) > sub_length,(length(star_point - end_point)-sub_length)*0.5,0)"
		for i = 1 to bone_arry.count do
		(
			FN_ZeroNode bone_arry[i] 
			bone_arry[i].pos.controller[2][1].controller = Float_Expression ()
			bone_arry[i].pos.controller[2][1].controller.AddVectorTarget  "star_point" star_point.pos.controller
			bone_arry[i].pos.controller[2][1].controller.AddVectorTarget  "end_point" end_point.pos.controller
			bone_arry[i].pos.controller[2][1].controller.addScalarConstant "sub_length" sub_length
			bone_arry[i].pos.controller[2][1].controller.setExpression str_exp
		)
	)
	
	on 'btn_' pressed do
	(
		FN_Create()
	)
)
CreateDialog test