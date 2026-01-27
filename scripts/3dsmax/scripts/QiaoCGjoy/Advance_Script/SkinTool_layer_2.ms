rollout layer "layer" width:200 height:250
(
	button 'Cle_layer' "???? " width:60 height:21 toolTip 
	
	local TemlayerName =#()
	
	-------------------------------------------------------------------
	-----------------------------------------------------------------------------
	on Cle_layer pressed do
	(
	
	for i = 1 to LayerManager.count-1 do --????????????
	(
		ilayer = layerManager.getLayer i
		layerName = ilayer.name
		append TemlayerName layerName --???????????????
		
		)
		
		for  j = 1 to TemlayerName.count do 
		(
			LayerManager.deleteLayerByName TemlayerName [j]--??????????
			)
			--selectionSets.count
			for n=selectionSets.count to 1 by -1 do
			(
				deleteItem selectionSets selectionSets[n]--????????
				
				)
	
	)
)
	)
)
	Createdialog lay