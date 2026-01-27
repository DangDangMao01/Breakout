try (destroydialog delete_ca) catch()
rollout delete_ca "删除场景中的CustAttribute" width:170 
(		
	button but "删除"width:98 height:32 toolTip:"删除场景中的CustAttribute" align:#center
	fn deleteCustAttributeInstances ca_class = 
	(
		cas = getclassinstances ca_class
		deleted = [cas.count, 0]
		for ca in cas do
		(
			owner = custattributes.getowner ca
			if isvalidobj owner do
			(
				n = finditem owner.custattributes ca
				if (n > 0) do 
				(
					deleteitem owner.custattributes n
					deleted[2] += 1
				)
			)
		)
		deleted
	)
	fn clean_ca x =
	(
	 z=1
	 c=1  
	 while z !=undefined do
	 (
	  z = custattributes.getdef x c
	  if z != undefined then
	  (
	   format "% %\n" z.name (custattributes.getdefdata z)
	   c=c+1
	  )
	 )
	 while (c!=0) do
	 (
	  z = custattributes.getdef x c
	  if z != undefined then
	  (
	   if  (custattributes.getdefdata z)==undefined then
	   (
		custAttributes.delete x z
	   )
	  )
	  c=c-1
	 )
	)
	on but pressed do(
	deleteCustAttributeInstances SimpleFaceData 
	clean_ca(rootscene)
	clean_ca(meditmaterials)
	clean_ca(rootscene.Anim_Layer_Control_Manager)
	)
)
createDialog delete_ca	fgcolor:(color 7 254 254)