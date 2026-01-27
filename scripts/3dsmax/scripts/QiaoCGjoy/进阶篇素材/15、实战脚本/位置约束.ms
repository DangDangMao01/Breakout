
rollout Pos_Constraint "位置约束"
(
	button Pos_Con "位置约束"  toolTip:"依次选取三个物体" 
	
	on Pos_Con pressed do
	(

		pts=#()

		for i=2 to selection.count-1 do
		(
			a=selection[i]
			a.pos.controller=position_list ()	
			PosCon=position_constraint()  ---创建位置约束
			a.pos.controller.Available.controller=PosCon			
			PosCon.appendTarget selection[i-1] 50	
			PosCon.appendTarget selection[i+1] 50	
			PosCon.relative = on
			a.pos.controller.Available.controller= Position_XYZ ()
			lst = a.pos.controller
			lst.SetActive 3

		)
		
	)
)
	createdialog Pos_Constraint