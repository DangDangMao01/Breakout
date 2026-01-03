global autorigwin

try(destroydialog autorigwin) catch()


rollout one_Rollout "一" width:368 height:164
(
	label one "嘿嘿" align:#center
)rollout two_Rollout "二" width:368 height:164
(
	label two "嘎嘎" align:#center
)
rollout three_Rollout "三" width:368 height:164
(
	label three "哇哇" align:#center
)
rollout four_Rollout "四" width:368 height:164
(
	label four "哈哈" align:#center
)

---------------------主窗口

rollout autorigmain "小测试" width:400 height:800
(
	subRollout 'subarea' "steps windows" pos:[10,60] width:380 height:580 align:#left
	
	button 'btnOne' "一" pos:[105,10] width:40 height:43 align:#left
	button 'btnTwo' "二" pos:[150,10] width:40 height:43 align:#left
	button 'btnThree' "三" pos:[195,10] width:40 height:43 align:#left
	button 'btnFour' "四" pos:[240,10] width:40 height:43 align:#left

	
----------------------当打开脚本
	
	on autorigmain open do
	(
		AddSubRollout autorigmain.subarea one_Rollout
		AddSubRollout autorigmain.subarea two_Rollout
		AddSubRollout autorigmain.subarea three_Rollout
		AddSubRollout autorigmain.subarea four_Rollout
		subarea.rollouts[1].open=false
		subarea.rollouts[3].open=false
		subarea.rollouts[4].open=false
	)
	
	on btnOne pressed do
	(
	 for o in subarea.rollouts do o.open=false
		subarea.rollouts[1].open=true
	)
	
	on btnTwo pressed do
	(
	 for o in subarea.rollouts do o.open=false
		subarea.rollouts[2].open=true
	)
	
	on btnThree pressed do
	(
	 for o in subarea.rollouts do o.open=false
		subarea.rollouts[3].open=true
	)
	
	on btnFour pressed do
	(
	 for o in subarea.rollouts do o.open=false
		subarea.rollouts[4].open=true
	)
)

autorigwin = autorigmain
createdialog autorigwin