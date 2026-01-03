rollout layer "Layer" 
(
	button 'Cle_layer' "清空层集"  width:60 height:21 toolTip:"一键清除空集以及所有层" align:#left across:2
	checkbutton 'Fz_Mdl' "冻结模型"  width:60 height:21  
	
	local TemlayerName =#()
		
	--------------------------------------------------------------------------------------------------------------
	
	--------------------------------------------------------------------------------------------------------------

	on Cle_layer pressed do
	(
		for i =1 to LayerManager.count-1 do
		(
		 ilayer = layerManager.getLayer i
		 layerName = ilayer.name
		append TemlayerName layerName
		)
		for j=1 to TemlayerName.count do 
		(
			LayerManager.deleteLayerByName TemlayerName[j]
		)
		--selectionSets.count
		for n=selectionSets.count to 1 by -1 do 
		(	
			deleteItem selectionSets selectionSets[n]
		)
		
	)
	
	--------------------------------------------------------------------------------------------------------------------------------------------------
	
	on Fz_Mdl changed state do
	(
		if state then
		(
			Mod_Arr=for i in objects where(classof i==Editable_Poly or classof i==Editable_mesh or classof i==PolyMeshObject)collect i
			Mod_Arr.showFrozenInGray = off
			freeze Mod_Arr
		)
		else
		(
			Mod_Arr=for i in objects where(classof i==Editable_Poly or classof i==Editable_mesh or classof i==PolyMeshObject)collect i
			unfreeze Mod_Arr
		)		
	)---冻结
	--------------------------------------------------------------------------------------------------------------------------------------------------
)
Createdialog layer

