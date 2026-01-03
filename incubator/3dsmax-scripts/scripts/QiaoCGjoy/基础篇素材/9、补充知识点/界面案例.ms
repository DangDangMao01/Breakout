macroScript QL1
category:"QL Tools"
toolTip:"change_wirecolor"
(
	rollout change_wirecolor "Object Color Changer"
	(
	  colorpicker theColor "Wireframe color:" color:[0,0,255] modal:false
	  on theColor changed new_col do selection.wirecolor = new_col
	)
	createDialog change_wirecolor

)