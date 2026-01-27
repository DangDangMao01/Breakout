tempBone=#()
for i=1 to selection.count do
(
	tempBone[i] =BoneSys.createBone  [0,0,0] [0,100,0] [0,0,0]
	tempBone[i].width=10
	tempBone[i].height=10
	tempBone[i].frontfin=true
	tempBone[i].frontfinsize=1	
	tempBone[i].transform =selection[i].transform
	tempBone[i].name = uniquename "bone"
	tempBone[i].boneScaleType=#squash
)