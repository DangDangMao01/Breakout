
rollout test "test"
(
	button btn1 "生成很多球" width:130 height:23
	button btn2 "找特殊层级的物体" width:130 height:23
	local layer_Arr = #()
	fn FN_CreateLayer layerName:"pleae rename....." = 
	(
		newLayerName = layerName
		fnTarget = layerManager.getLayerFromName newLayerName
		if fnTarget == undefined then fnTarget = layerManager.newLayerFromName newLayerName 
		return fnTarget
	)
	fn FN_CreateLayerAndSphere =
	(
		local layer_name = #("特殊层级1","特殊层级2","特殊层级3","层级1","层级2")
		for i = 1 to layer_name.count do
		(
			layer_Arr[i] =  FN_CreateLayer layerName: layer_name[i]
		)
		for i = 1 to 50 do
		(

			r = random 1 10
			x = random -50 50
			y = random -50 50
			z = random -50 50
			a = Sphere radius:r pos:[x,y,z]
			
			l = random 1 5
			layer_Arr[l].addNode a
			a.wirecolor = yellow
		)
	
	)
	on btn1 pressed do
	(
		FN_CreateLayerAndSphere()
	)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----这里找特殊层级的物体---------------
	local normolLayer_Index = #(4,5)
	local normelObject = #()
	
	fn FN_SetSupperObject =
	(
----------------------------------------------------------------------------------------------
---------收集场景钟的所有物体，放进：superObject -----------------------------------------------
		for i = 1 to normolLayer_Index.count do 
		(
			ilayer = layerManager.getLayer normolLayer_Index[i]
			layerName = ilayer.name
			layer = ILayerManager.getLayerObject normolLayer_Index[i]
			layerNodes = refs.dependents layer
			format "Layer: %; nodes: %\n" layerName layerNodes
			for j = 1 to layerNodes.count do
			(
				append normelObject layerNodes[i]
			)
		)
		for i = 1 to normelObject.count do 
		(
			normelObject[i].wirecolor = red
		)			
-- 	  ilayer = layerManager.getLayer 5
-- 	  layerName = ilayer.name
-- 	  layer = ILayerManager.getLayerObject 5
-- 	  layerNodes = refs.dependents layer

-- 		for j = 1 to layerNodes.count do
-- 		(
-- 			print(layerNodes[j])
-- 		)
-- 		for i = 0 to layerManager.count-1 do
-- 		(
-- 		  ilayer = layerManager.getLayer i
-- 		  layerName = ilayer.name
-- 		  layer = ILayerManager.getLayerObject i
-- 		  layerNodes = refs.dependents layer
-- 		  format "Layer: %; nodes: %\n" layerName layerNodes
-- 		)
-- 		for i = 1 to normolLayer_Index.count do
-- 		(
-- 			ilayer = layerManager.getLayer normolLayer_Index[i]
-- 			layer = ILayerManager.getLayerObject normolLayer_Index[i]	
-- 			layerNodes = refs.dependents layer
-- 			append normelObject layer
-- 			 format "Layer: %; nodes: %\n" layerName layerNodes
-- 		)
	)
	on btn2 pressed do
	(
		FN_SetSupperObject()
	)
)
createdialog test