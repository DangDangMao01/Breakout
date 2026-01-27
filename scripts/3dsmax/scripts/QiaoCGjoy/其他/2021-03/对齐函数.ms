	fn Align_fn s1 s2 = --对齐物体
	(
		--selection[1] 对齐 selection[2] 
		pos=s2.transform.pos-s1.transform.pos
		rota=(s2.transform.rotation-s1.transform.rotation)as eulerangles
		move s1 pos
		rotate s1 rota
	)
	
	