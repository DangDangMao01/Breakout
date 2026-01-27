rollout layer "Layer" 
(
	button 'Cle_layer' "清空层集" pos:[13,3] width:60 height:21 toolTip:"一键清除空集以及所有层" align:#left 
 	
	local TemlayerName =#()

	--------------------------------------------------------------------------------------------------------------
	
	on Cle_layer pressed do
	(
		for i =1 to LayerManager.count-1 do --首先获取到所有层的名字。
		(
		 ilayer = layerManager.getLayer i
		 layerName = ilayer.name
		append TemlayerName layerName  --将层的名字都放入一个空集合中。
		)
		for j=1 to TemlayerName.count do 
		(
			LayerManager.deleteLayerByName TemlayerName[j]--按照层的命名去删除
		)
		--selectionSets.count
		for n=selectionSets.count to 1 by -1 do 
		(	
			deleteItem selectionSets selectionSets[n] --删除所有集合
		)
	)
)
Createdialog layer

