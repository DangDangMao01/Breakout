/* Script: Rockmyworld.ms
* Author:  Luke Pettit
* e-mail:  petluke@gmail.com
* Date:    03/04/2012  v 1.6
* Based on a tutorial by Sascha Henrichs http://saschahenrichs.blogspot.com/
*/
	if rockMeRollout != undefined do destroyDialog rockMeRollout
	try destroyDialog rockMeRollout catch()
	
	(		
		Rollout rockmeRollout "  Rock my world v1.6" --start rollout
		(
			local mTS_rm, mDM1_rm, mDM2_rm, mNGD_rm, mNGD_rm
			group "Object shape" -- sort different buttons etc in groups
			(
				radiobuttons rdo_Oshape labels:#("Planar", "Cylindrical", "Spherical", "Shrink Rap") columns:2 default:1
			) --end group 
									
				group "Itterations"
				(
					spinner spnItt1_rm "TS Iteration: " range:[0, 10, 1] type:#integer
					spinner spnRit_rm"TSR Iteration: " range:[0, 100, 5] type:#integer
				) --end itterations group
						
					group "Displace Basic Shape"
				(
					spinner spnStr1_rm "Strength: " range:[-1000.0,10000.0,130.0] type:#float
					spinner spxOff_rm "X Offset: " range:[1,10000,100] type:#integer
					spinner spzOff_rm "Z Offset: " range:[1,10000,100] type:#integer
					groupBox group1 "Cell Characteristics" pos:[8,209] width:175 height:122
					radiobuttons radBut_rm "" labels:#("Circular", "Chips") default:1 columns:2 across:2 pos:[12, 227]
					checkbox chk_Frac_rm "Fractal" checked:false pos:[122, 228]
					spinner spnItt2_rm "Iterations: " enabled:false range:[1,20,3] type:#integer 
					spinner spcSize_rm "Cell Size: " range:[1.0,10000.0,110.0] type:#float
					spinner spcSpr_rm "Spread: " range:[0.1,10,1.5] type:#float
					spinner spnMidT_rm "Mid Threshold: " range:[0.1,1.0,0.8] type:#float
				) --end  DBS group
					
						group "Displace Medium Details"
						(
							spinner spnStr2_rm "Strength: " range:[-100.0, 100.0, 10.0] type:#float
							spinner spcSize2_rm "Cell Size: " range:[1.0, 1000.0, 100.0] type:#float
						) --end DMD group
									
							group "Noise Grain Detail"
							(
								spinner spnSca_rm "Scale: " range:[1.0, 1000.0, 270.0] type:#float
								spinner spnItt3_rm "Iterations: " range:[1, 100, 6] type:#integer
								spinner spnStr3_rm "StrenghtXYZ: " range:[1.0, 100.0, 30.0] type:#float
							) --end NGD group
								
								group "Noise Fine Detail"
								(
									spinner spnSca2_rm "Scale: " range:[1.0, 1000.0, 100.0] type:#float
									spinner spnItt4_rm "Iterations: " range:[1.0, 100.0, 10.0] type:#float
									spinner spnStr4_rm "StrenghtXYZ: " range:[1.0, 100.0, 10.0] type:#float
								) --end NFD group
							
			button btnRockMe "Rock My World!" toolTip:"Press this button to Rock your world." width:163
			button d_obj "Delete Obj" toolTip:"Press this button to delete the Obj and Modifiers." width:80 across:2 --Button creation
			button dMods "Delete Mods" toolTip:"Press this button to delete the Modifiers." width:80					
			button cExit "Exit" toolTip:"Press this button to close Rock Me!." width:80 across:2
			CheckButton btn_Hlp " Help > " toolTip:"Press this button to get help." width:80
			button btn_Bake	"Open Render to Texture" tooltip:"Open the Render to Texture Dialog" width:163 height:20
						
			label lbl1 "<  Match the objects shape as close as possible here" pos:[195,30] width:350 height:20
			label lbl3 "<  Sets the Turbosmooth Iterations: ( Low 0 - 2 ) ( High = 3 - 6 )" pos:[195,84] width:350 height:20
			label lbl4 "<  Turbosmooth Render Iterations 6 is good. Lower for faster renders" pos:[195,106] width:350 height:20
			label lbl5 "<  Displace strength: Higher for angular effects, Lower for smooth" pos:[195,153] width:350 height:20
			label lbl6"<  X Offset: Treat this like a seed value." pos:[195,172] width:350 height:20
			label lbl7 "<  Z Offset: Treat this like a seed value also." pos:[195,193] width:350 height:20
			label lbl8 "    * Toggle Fractal on: For a more jagged look.\n<  Switch between circular and chips for more variety" pos:[195,215] width:350 height:32
			label lbl9 "<  Fractal Iterations: Increasing this value increases rendering time." pos:[195,249] width:350 height:20
			label lbl10 "<  Cell size: Will depend on obj size as to the results you get" pos:[195,269] width:355 height:20
			label lbl11 "<  Will depend on cell size as to the results you get" pos:[195,290] width:350 height:20 
			label lbl12 "<  Mid Threshold: On Large items lower this to 0.1 for craters" pos:[195,311] width:350 height:20
			label lbl13 "<  Ok, ok move on! There's nothing to see here" pos:[195,358] width:350 height:20
			label lbl14 "<  Low numbers here, give more detail, high numbers smooth things out" pos:[195,378] width:350 height:20
			label lbl15 "<  At the default size only lowering this number makes any difference." pos:[195,424] width:350 height:80
			label lbl2 "     The remaining setting are for fine tuning" pos:[195,440] width:350 height:20
			label lab16 " ----Rock my world v1.6---- " style_sunkenedge:true width:133 height:16 pos:[300,480]
			label lab17 "Script by Luke Pettit" pos:[319,500]
			HyperLink hl1 "Luke Pettit-3d Blog" address:"http://lukepettit-3d.blogspot.com/" color:(color 214 228 153) pos:[322,516]
			label lab18 "-=-=-=-=-=-=-=-=-=-=-=-" pos:[299,530]
			label lab19 "Based on a tutorial by" pos:[315,545]
			label lab20 "Sascha Henrichs" pos:[327,560]
			HyperLink hl2 "saschahenrichs.blogspot.com" address:"http://saschahenrichs.blogspot.com/" color:(color 214 228 153) pos:[298,575]
			label lbl24 "<  Make it so!" pos:[195,585] width:80 height:20
			label lbl25 "<  Delete the object  and/or Delete the modifier stack" pos:[195,610] width:350 height:20
			label lab23 "<  Opens the Render to Texture dialog box." pos:[195,662]					
								
			on btnRockMe pressed do -- runs the script when the button is pressed
			(
				if $ != undefined then 
				(				
					mTS_rm = (turbosmooth iterations:spnItt1_rm.value useRenderIterations:true renderiterations:spnRit_rm.value)
					addModifier $ mTS_rm
					mDM1_rm = (displace name:"Displace Basic Shape" strength:spnStr1_rm.value maptype:2.0)
					addModifier $ mDM1_rm
					mDM2_rm = (displace name:"Displace Medium Details" strength:spnStr2_rm.value maptype:2.0 )
					addModifier $ mDM2_rm
					mNGD_rm =	(Noisemodifier name:"Noise Grain Detail" scale:spnSca_rm.value  fractal:on iterations:spnItt2_rm.value)
					addModifier $ mNGD_rm
					mNGD_rm = (Noisemodifier name:"Noise Fine Detail" scale:spnSca2_rm.value fractal:on iterations:spnItt4_rm.value)
					addModifier $ mNGD_rm
					case rdo_Oshape.state of
					(
						1: [$.Displace_Basic_Shape.maptype = 0, $.Displace_Medium_Details.maptype = 0]
						2: [$.Displace_Basic_Shape.maptype = 1, $.Displace_Medium_Details.maptype = 1]
						3: [$.Displace_Basic_Shape.maptype = 2, $.Displace_Medium_Details.maptype = 2]
						4:	[$.Displace_Basic_Shape.maptype = 3, $.Displace_Medium_Details.maptype = 3]
					)	--end case	
					addModifier $ (FFDBox ())
					setDimensions $.modifiers[#FFD_box__4x4x4] [3,3,2]
					$.Displace_Basic_Shape.map = Cellular()
					$.Displace_Basic_Shape.map.coords.offset = [spxOff_rm.value, 0.0, spxOff_rm.value]
					$.Displace_Basic_Shape.map.cellcolor =  (color 0 0 0)
					$.Displace_Basic_Shape.map.variation  = 5.8
					$.Displace_Basic_Shape.map.divcolor1 =  (color 158 158 158)
					$.Displace_Basic_Shape.map.divcolor2 = (color 112 112 112)
					$.Displace_Basic_Shape.map.type = 0
					$.Displace_Basic_Shape.map.fractal = off
					$.Displace_Basic_Shape.map.iteration = spnItt2_rm.value
					$.Displace_Basic_Shape.map.size = spcSize_rm.value
					$.Displace_Basic_Shape.map.spread = spcSpr_rm.value
					$.Displace_Basic_Shape.map.midthresh = spnMidT_rm.value
					$.Displace_Medium_Details.map = noise()
					$.Displace_Medium_Details.map.type = 1
					$.Displace_Medium_Details.map.size = spcSize2_rm.value
					$.Displace_Medium_Details.map.thresholdHigh = 0.9
					$.Displace_Medium_Details.map.thresholdLow = 0.2
					$.Displace_Medium_Details.map.levels = 10.0
					$.Noise_Grain_Detail.strength = [spnStr3_rm.value, spnStr3_rm.value, spnStr3_rm.value]
					$.Noise_Fine_Detail.strength = [spnStr4_rm.value, spnStr4_rm.value, spnStr4_rm.value]
					
				) else 
				(messageBox "You must have at least one object selected!" title:"Computer says no...")
			)
				on rdo_Oshape changed state do
				(
					if $ != undefined and not isdeleted $ do
					(
						case rdo_Oshape.state of
						(
							1: [$.Displace_Basic_Shape.maptype = 0, $.Displace_Medium_Details.maptype = 0]
							2: [$.Displace_Basic_Shape.maptype = 1, $.Displace_Medium_Details.maptype = 1]
							3: [$.Displace_Basic_Shape.maptype = 2, $.Displace_Medium_Details.maptype = 2]
							4:	[$.Displace_Basic_Shape.maptype = 3, $.Displace_Medium_Details.maptype = 3]
						)	--end case	
					)
				)
				on spnStr1_rm changed val do
				(
					if $ != undefined and not isdeleted $ do
					(
						mDM1_rm.strength = val
					)
				)
				on spnItt1_rm changed val do
				(
					if $ != undefined and not isdeleted $ do
					(
						mTS_rm.iterations = val
					)
				)
					on spnRit_rm changed val do
					(
						if $ != undefined and not isdeleted $ do
						(
							mTS_rm.renderiterations = val
						)
					)
						on spxOff_rm changed val do
						(
							if $ != undefined and not isdeleted $ do
							(
								$.Displace_Basic_Shape.map.coords.offset = [val, 0.0, spzOff_rm.value]
							)
						)
							on spzOff_rm changed val do
							(
								if $ != undefined and not isdeleted $ do
								(
									$.Displace_Basic_Shape.map.coords.offset = [spxOff_rm.value, 0.0, val]
								)
							)
								on radBut_rm changed state do
								(
									if $ != undefined and not isdeleted $ do
									(
										$.Displace_Basic_Shape.map.type = state  - 1
									)
								)
									on chk_Frac_rm changed state do
									(
										if $ != undefined and not isdeleted $ do
										(
											$.Displace_Basic_Shape.map.fractal = state
											if state == on then 
											spnItt2_rm.enabled = true
											else 
											spnItt2_rm.enabled = false
										)
									)
									on spnItt2_rm changed val do
									(
										if $ != undefined and not isdeleted $ do
										(
											$.Displace_Basic_Shape.map.iteration = val
										)
									)
										on spcSize_rm changed val do
										(
											if $ != undefined and not isdeleted $ do
											(
												$.Displace_Basic_Shape.map.size = val
											)
										)
					on spcSpr_rm changed val do
					(
						if $ != undefined and not isdeleted $ do
						(
							$.Displace_Basic_Shape.map.spread = val
						)
					)
						on spnMidT_rm changed val do
						(
							if $ != undefined and not isdeleted $ do
							(
								$.Displace_Basic_Shape.map.midthresh = val
							)
						)
							on spnStr2_rm changed val do
							(
								if $ != undefined and not isdeleted $ do
								(
									mDM2_rm.strength = val
								)
							)
								on spcSize2_rm changed val do
								(
									if $ != undefined and not isdeleted $ do
									(
										$.Displace_Medium_Details.map.size = val
									)
								)
									on spnSca_rm changed val do
									(
										if $ != undefined and not isdeleted $ do
										(
											mNGD_rm.scale = val
										)
									)
										on spnItt3_rm changed val do
										(
											if $ != undefined and not isdeleted $ do
											(
												mNGD_rm.iterations = val
											)
										)
					on spnStr3_rm changed val do
					(
						if $ != undefined and not isdeleted $ do
						(
							$.Noise_Grain_Detail.strength = [val, val, val]
						)
					)
						on spnSca2_rm changed val do
						(
							if $ != undefined and not isdeleted $ do
							(
								mNGD_rm.scale = val	
							)
						)
							on spnItt4_rm changed val do
							(
								if $ != undefined and not isdeleted $ do
								(
									mNGD_rm.iterations = val
								)
							)
								on spnStr4_rm changed val do
								(
									if $ != undefined and not isdeleted $ do
									(
										$.Noise_Fine_Detail.strength = [val, val, val]
									)
								)
									
			on d_obj pressed do -- when delete btn is pressed do...
			(
				if (selection.count>0) then
				(
					for obj in selection do
					(
						delete obj
					) --end for
				) --end if
				else
					(
						messagebox "You must have at least one object selected!" title:"Computer says no..."
					) --end else
			) --end on statement
				
			on dMods pressed do --when delete mods button is pressed
			for obj in selection do
			(
				deleteModifier $ 6
				deleteModifier $ 5
				deleteModifier $ 4
				deleteModifier $ 3
				deleteModifier $ 2
				deleteModifier $ 1
			) --end for
								
				on cExit pressed do --when exit button is pressed
				(
					destroyDialog rockmeRollout
				) --end on
					
				on btn_Hlp changed exb do -- help button
			(
				if exb then
				(
					rockmeRollout.width = 565
					btn_Hlp.caption = "Help <"
				)else
					(
						rockmeRollout.width = 190
						btn_Hlp.caption = "Help >"
					)
			)--end  help on
				
				on btn_Bake pressed do
				try(macros.run "Render" "BakeDialog")catch()
				
		) --end rollout	
											
		createdialog rockMeRollout width:190 height:685 --pos:[1150, 175] 
		addRollout rockMeRollout
)				
							
