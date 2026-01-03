	
	tempBone=#()

	tempBone[1] =BoneSys.createBone  selection[1].pos selection[2].pos [0,1,0]
	tempBone[1].width=10
	tempBone[1].height=10
	tempBone[1].frontfin=true
	tempBone[1].frontfinsize=1	
	for i=2 to selection.count-1 do
	(
		tempBone[i] =BoneSys.createBone  selection[i].pos selection[i+1].pos [0,1,0]
		tempBone[i].width=10
		tempBone[i].height=10
		tempBone[i].frontfin=true
		tempBone[i].frontfinsize=1		
		tempBone[i].parent= tempBone[i-1]
	)