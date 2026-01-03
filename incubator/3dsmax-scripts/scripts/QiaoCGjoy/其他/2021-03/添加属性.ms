modPanel.addModToSelection (EmptyModifier ()) ui:on
IK_FK_Switcher_Custom_attribute = attributes custom_Attributes
(
	rollout IKSwitchRollout "IK/FK Switch"
	(
		checkbox 'ikfkCH' "ikfk"  align:#left
		button ui_IK2FK "IK --> FK" align:#left
		button ui_FK2IK "FK --> IK" align:#left
	
		on ikfkCH changed State do
		(	
			if State =on then
			(
			$Point003.pos.controller.Position_Constraint.controller.weight[1] = 0
			$Point003.pos.controller.Position_Constraint.controller.weight[2] = 100
			)
			else
			(
			$Point003.pos.controller.Position_Constraint.controller.weight[1] = 100
			$Point003.pos.controller.Position_Constraint.controller.weight[2] = 0
			)

		)
	)
)

CustAttributes.add $.modifiers[1] IK_FK_Switcher_Custom_attribute
