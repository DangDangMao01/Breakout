rollout change_wirecolor "Object Color Changer"
(
	colorpicker theColor "Wireframe color:" color:[0,0,255] nodal:false
	on theColor changed new_col do selection.wircolor = new_col
	)
	createDialog change_wirecolor