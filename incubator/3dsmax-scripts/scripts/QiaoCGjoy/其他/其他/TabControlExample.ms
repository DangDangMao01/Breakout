(
 	global VFBTabs 
 	try(destroyDialog VFBTabs)catch()
 	
 	local LastSubRollout = 1
 	
 	rollout VFBTabsRollout01 "Rollout 01"
 	(
 		spinner spn_spinner "Spinner"
 	)
 	rollout VFBTabsRollout02 "Rollout 02"
 	(
 		button btn_button "Button"
 	)
 	rollout VFBTabsRollout03 "Rollout 03"
 	(
 		label lbl_label "This is some text"
 	)
 	rollout VFBTabsRollout04 "Rollout 04"
 	(
 		colorpicker clr_picker "Color Picker"
 	)
 	rollout VFBTabsRollout05 "Rollout 05"
 	(
 		checkbox chk_box "Checkbox"
 	)
 	
 	VFBTabs_Rollouts = #(
 		#("Global Options",#(VFBTabsRollout01)),
 		#("GI & Skylight",#(VFBTabsRollout02)),
 		#("Raytracer",#(VFBTabsRollout03)),
 		#("Blurries Manager",#(VFBTabsRollout04))
 	)	
 	
 	rollout VFBTabs "VFB-Tabs"
 	(
 			dotNetControl dn_tabs "System.Windows.Forms.TabControl" height:20 width:420 align:#left
 			subRollout theSubRollout width:658 height:190 align:#center
 			
 			on dn_tabs Selected itm do
 			(
 				if LastSubRollout != (itm.TabPageIndex+1) do --do not update if the same tab clicked twice
 				(
 					for subroll in VFBTabs_Rollouts[LastSubRollout][2] do
 						removeSubRollout theSubRollout subroll
 					for subroll in VFBTabs_Rollouts[LastSubRollout = itm.TabPageIndex+1][2] do	
 						addSubRollout theSubRollout subroll
 				) 
 			)--end tabs clicked		
 			
 			on VFBTabs open do
 			(
 				for aTab in VFBTabs_Rollouts do
 				(
 					dn_tabs.TabPages.add aTab[1]
 				)
 				for subroll in VFBTabs_Rollouts[1][2] do 
 					addSubRollout theSubRollout subroll				
 			)
 	)
 
 	createDialog VFBTabs 658 190
 )