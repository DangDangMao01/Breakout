rollout mytools "????"
(	
    slider sld_1 "??:" range:[0,360,0]
	
	angle ang_1 "" pos:[20,60]
	
	angle ang_2 "" pos:[120,60] degrees:45 color :(color 50 150 20) range: [0,90,45]
	
	spinner sp_1 "????:"range:[0,360,0]
	
	
	on sld_1 changed val do
		(
			
			ang_1.degrees = ang_2.degrees = sp_1.value = val
			
			print val
		)	
	
)
CreateDialog mytools 200 160
