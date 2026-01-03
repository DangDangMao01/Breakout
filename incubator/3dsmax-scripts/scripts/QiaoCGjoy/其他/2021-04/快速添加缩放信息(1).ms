-------------------------------------------------------
-------------------AnimationTool-----------------------
------------------Time:2017-10-11----------------------
-------------------Author:ÇÇÀÚ-------------------------
------------------QQ:409856476-------------------------
-------------------------------------------------------

rollout myrollout "CS¹Ç÷ÀËõ·Å" width:161 height:115
(
	button Get_Bones "Ñ¡È¡CS¹Ç÷À " pos:[34,41] width:97 height:20 toolTip:"Ñ¡È¡¹Ç÷À"
	
     
	on Get_Bones pressed do
	(
	
		for i=1 to selection.count do
		(
			selection[i].transform.controller.Biped_SubAnim.controller.BipScaleList.controller.Available.controller = ScaleXYZ ()

		)
	     		
	    
		
	)
)
	createdialog myrollout
	
	

