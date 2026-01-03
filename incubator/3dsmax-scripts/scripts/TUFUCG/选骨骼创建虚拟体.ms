rollout unanedRollout "无标题" width:162 height:300
(
	spinner spn6 "长" pos:[6,26] width:105 height:16
	spinner spn7 "宽" pos:[7,52] width:104 height:16
	spinner spn8 "高" pos:[5,77] width:107 height:16
	button zhixing "开始" pos:[27,121] width:93 height:81
	
	local a =0.0
	local b =0.0
	local c =0.0
	on spn6 changed range do
		(
		 a=spn6.value
		)
	on spn7 changed range do
	    (
		 b=spn7.value
		)
	on spn8 changed range do
	    (
		c=spn8.value
		)
	on zhixing pressed  do
	(
		if selection.count==0 then
		  (
		  messagebox "请选择至少一根骨骼！"
		  )
		else
		(
			
			for i in 1 to selection.count  do Dummy transform:(matrix3 [a,0,0] [0,0,b] [0,c,0] [0,0,0]) isSelected:on  prefix:"dummy"
		)
	)
)
CreateDialog unanedRollout