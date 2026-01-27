/*
Script: RockMaker2.5.ms
Author:  Luke Pettit
e-mail:  petluke@gmail.com
Date:  01/09/2010-06/04/2011  v 2.1
Date:	17/07/2011 v 2.5
Based on a tutorial by Sascha Henrichs http://saschahenrichs.blogspot.com/
All my thanks to miauu on scriptsot for all his help with the presets
I'd been stuck for ages
*/
---------------------------------------------------------------------------------------------------------------------------
if ((rockRollout != undefined) and (rockRollout.isDisplayed)) do (destroyDialog rockRollout)
---------------------------------------------------------------------------------------------------------------------------
RockMakerIniFile = getFilenamePath (getSourceFileName()) + "/rockMaker.ini"
if doesFileExist RockMakerIniFile then
	global RockMakerAllSavedPresets = (readValue ((getINISetting RockMakerIniFile "Presets" "names") as stringStream))
else
(
	setIniSetting RockMakerIniFile "Presets" "names" (#("--Select preset--") as string)
	global RockMakerAllSavedPresets = (readValue ((getINISetting RockMakerIniFile "Presets" "names") as stringStream))
)

rollout rockRollout "Rock Maker v2.5" width:360 height:385
( 
	local mRoc, mTurb, mTS, mDM1, mDM2, mNGD, mNFD
	spinner spn_Size "Rock Size: " pos:[58,24] width:110 height:16 range:[1,1000,100] type:#float
	spinner spn_Segs "Segments: " pos:[58,46] width:110 height:16 range:[1,10,5] type:#integer
	spinner spnItt1 "TS Iteration: " pos:[58,68] width:110 height:16 range:[0,10,3] type:#integer
	spinner spnRit "TSR Iteration: " pos:[58,89] width:110 height:16 range:[0,100,6] type:#integer
	GroupBox grSize "Rock size" pos:[8,8] width:168 height:107
 
	GroupBox grDis "Displace Basic Shape" pos:[184,8] width:168 height:206
	spinner spnStr1 "Strength: " pos:[235,24] width:110 height:16 range:[-1000,10000,130] type:#float
	spinner spxOff "X Offset: " pos:[235,47] width:110 height:16 range:[1,10000,100] type:#integer
	spinner spzOff "Z Offset: " pos:[235,69] width:110 height:16 range:[1,10000,100] type:#integer
	radiobuttons radBut "" pos:[208,89] width:58 height:32 labels:#("Circular", "Chips") default:1 columns:1 across:1
	checkbox chkFrac "Fractal " pos:[279,94] width:57 height:15 checked:false
	spinner spnItt4 "Iterations: " pos:[235,124] width:110 height:16 enabled:false range:[1,100,3] type:#integer 
	spinner spcSize "Cell Size: " pos:[235,146] width:110 height:16 range:[1,10000,110] type:#float
	spinner spcSpr "Spread: " pos:[235,168] width:110 height:16 range:[0.1,10,1.5] type:#float
	spinner spnMidT "Mid Threshold: " pos:[235,190] width:110 height:16 range:[0.1,1,0.8] type:#float
 
	GroupBox grp1 "Displace Medium Details" pos:[8,120] width:168 height:64
	spinner spnStr2 "Strength: " pos:[58,137] width:110 height:16 range:[-1000,1000,30] type:#float
	spinner spcSize2 "Cell Size: " pos:[58,160] width:110 height:16 range:[1,1000,100] type:#float
 
	GroupBox grp2 "Noise Grain Detail" pos:[8,190] width:168 height:90
	spinner spnSca "Scale: " pos:[58,208] width:110 height:16 range:[1,1000,270] type:#float
	spinner spnItt2 "Iterations: " pos:[58,232] width:110 height:16 range:[1,100,6] type:#integer 
	spinner spnStr3 "StrenghtXYZ: " pos:[58,256] width:110 height:16 range:[1,100,30] type:#float
 
	GroupBox grp3 "Noise Fine Detail" pos:[8,288] width:168 height:89
	spinner spnSca2 "Scale: " pos:[58,305] width:110 height:16 range:[1,1000,100] type:#float
	spinner spnItt3 "Iterations: " pos:[58,328] width:110 height:16 range:[1,100,10] type:#float
	spinner spnStr4 "StrenghtXYZ: " pos:[58,352] width:110 height:16 range:[1,100,10] type:#float
 
	button dRock "Delete Rock" pos:[185,219] width:70 height:20 toolTip:"Press this button to delete the Rock" 
	button btn_pivot "Pivot C/B" pos:[260,219] width:75 height:20  toolTip:"Press this button to place the pivot to the base or centre"
	button btn_pHelp "?" width:13 pos:[340,219] height:20 toolTip:"Pivot help"
	button btnRockMe "Rock Me!" pos:[185,243] width:167 height:25 toolTip:"Press this button to create a Rock" --Button creation		
	button lpRock "Make Low Poly" pos:[185,272] width:80 height:20 toolTip:"Make low poly rock from selection"
	button btn_Bake "RTT" pos:[272,272] width:80 height:20 toolTip:"Open the Render to Texture Dialog"
	button cAbout "About" pos:[185,297] width:80 height:18 toolTip:"About" 
	button cExit "Exit" pos:[272,297] width:80 height:18 toolTip:"Press this button to close the Rock Maker" 
	label lbl_no1 "=====================" pos:[185,317]
	dropdownList LoadPresets "" items:RockMakerAllSavedPresets pos:[185,333] width:167 height:10
	button btn_DelPreset "Delete Presets"pos:[185,359] width:78 height:18 toolTip:"Delete presets"
	button btn_SavePresets "Save Presets" pos:[272,359] width:78 height:18 toolTip:"Save presets"
 
	on btnRockMe pressed do
	(
		for obj in selection do 
		(
			delete obj
		)
		mRoc = box length:spn_Size.value width:spn_Size.value height:spn_Size.value pos:[0.0, 0.0, 0.0] \
		lengthsegs:spn_Segs.value widthsegs:spn_Segs.value heightsegs:spn_Segs.value isSelected:true 
		mRoc.mapcoords = true
		mRoc.name = uniqueName "Rock"
		mRS = (spherify())
		addModifier mRoc mRS
		mTS = (turbosmooth iterations:spnItt1.value useRenderIterations:true renderiterations:spnRit.value)
		addModifier mRoc mTS
		mDM1 = (displace name:"Displace Basic Shape" strength:spnStr1.value maptype:2.0)
		addModifier mRoc mDM1
		mDM2 = (displace name:"Displace Medium Details" strength:spnStr2.value maptype:2.0 )
		addModifier mRoc mDM2
		mNGD =	(Noisemodifier name:"Noise Grain Detail" scale:spnSca.value  fractal:on iterations:spnItt2.value)
		addModifier mRoc mNGD
		mNFD = (Noisemodifier name:"Noise Fine Detail" scale:spnSca2.value fractal:on iterations:spnItt3.value)
		addModifier mRoc mNFD
		addModifier mRoc (FFDBox ())
		setDimensions mRoc.modifiers[#FFD_box__4x4x4] [2,2,3]
		mDM1.Gizmo.position = [0,0,spn_Size.value/2]
		mDM2.Gizmo.position = [0,0,spn_Size.value/2]
		mRoc.Displace_Basic_Shape.length = spn_Size.value
		mRoc.Displace_Basic_Shape.width = spn_Size.value 
		mRoc.Displace_Basic_Shape.height = spn_Size.value
		mRoc.Displace_Basic_Shape.map = Cellular()
		mRoc.Displace_Basic_Shape.map.coords.offset = [spxOff.value, 0.0, spxOff.value]
		mRoc.Displace_Basic_Shape.map.cellcolor =  (color 0 0 0)
		mRoc.Displace_Basic_Shape.map.variation  = 5.8
		mRoc.Displace_Basic_Shape.map.divcolor1 =  (color 158 158 158)
		mRoc.Displace_Basic_Shape.map.divcolor2 = (color 112 112 112)
		mRoc.Displace_Basic_Shape.map.type = 0
		mRoc.Displace_Basic_Shape.map.fractal = off
		mRoc.Displace_Basic_Shape.map.iteration = spnItt4.value
		mRoc.Displace_Basic_Shape.map.size = spcSize.value
		mRoc.Displace_Basic_Shape.map.spread = spcSpr.value
		mRoc.Displace_Basic_Shape.map.midthresh = spnMidT.value
		mRoc.Displace_Medium_Details.length = spn_Size.value
		mRoc.Displace_Medium_Details.width = spn_Size.value 
		mRoc.Displace_Medium_Details.height = spn_Size.value
		mRoc.Displace_Medium_Details.map = noise()
		mRoc.Displace_Medium_Details.map.type = 1
		mRoc.Displace_Medium_Details.map.size = spcSize2.value
		mRoc.Displace_Medium_Details.map.thresholdHigh = 0.9
		mRoc.Displace_Medium_Details.map.thresholdLow = 0.2
		mRoc.Displace_Medium_Details.map.levels = 10.0
		mRoc.Noise_Grain_Detail.strength = [spnStr3.value, spnStr3.value, spnStr3.value]
		mRoc.Noise_Fine_Detail.strength = [spnStr4.value, spnStr4.value, spnStr4.value]
	)
 
-----------------------------------------------------------------------------------------------------------------------------
 
	on spn_Size changed val do
	(
		if mRoc != undefined and not isdeleted mRoc do
		(
			mRoc.length = mRoc.width = mRoc.height = val
			mRoc.Displace_Basic_Shape.length = val
			mRoc.Displace_Basic_Shape.width = val
			mRoc.Displace_Basic_Shape.height = val
			mRoc.Displace_Medium_Details.length = val
			mRoc.Displace_Medium_Details.width = val
			mRoc.Displace_Medium_Details.height = val
			mDM1.Gizmo.position = [0,0,val/2]
			mDM2.Gizmo.position = [0,0,val/2]
		)
	)
		on spnStr1 changed val do
		(
			if mRoc != undefined and not isdeleted mRoc do
			(
				mDM1.strength = val
			)
		)
			on spn_Segs changed val do
			(
				if mRoc != undefined and not isdeleted mRoc do
				(
					mRoc.lengthsegs = mRoc.widthsegs = mRoc.heightsegs = val
				)
			)
				on spnItt1 changed val do
				(
					if mRoc != undefined and not isdeleted mRoc do
					(
						mTS.iterations = val
					)
				)
					on spnRit changed val do
					(
						if mRoc != undefined and not isdeleted mRoc do
						(
							mTS.renderiterations = val
						)
					)
	on spxOff changed val do
	(
		if mRoc != undefined and not isdeleted mRoc do
		(
			mRoc.Displace_Basic_Shape.map.coords.offset = [val, 0.0, spzOff.value]
		)
	)
		on spzOff changed val do
		(
			if mRoc != undefined and not isdeleted mRoc do
			(
				mRoc.Displace_Basic_Shape.map.coords.offset = [spxOff.value, 0.0, val]
			)
		)
			on radBut changed state do
			(
				if mRoc != undefined and not isdeleted mRoc do
				(
					mRoc.Displace_Basic_Shape.map.type = state - 1
				)
			)
				on chkFrac changed state do
				(
					if mRoc != undefined and not isdeleted mRoc do
					(
						mRoc.Displace_Basic_Shape.map.fractal = state
						if state == on then 
						spnItt4.enabled = true
						else 
						spnItt4.enabled = false
					)
				)
					on spnItt4 changed val do
					(
						if mRoc != undefined and not isdeleted mRoc do
						(
							mRoc.Displace_Basic_Shape.map.iteration = val
						)
					)
						on spcSize changed val do
						(
							if mRoc != undefined and not isdeleted mRoc do
							(
								mRoc.Displace_Basic_Shape.map.size = val
							)
						)
	on spcSpr changed val do
	(
		if mRoc != undefined and not isdeleted mRoc do
		(
			mRoc.Displace_Basic_Shape.map.spread = val
		)
	)
		on spnMidT changed val do
		(
			if mRoc != undefined and not isdeleted mRoc do
			(
				mRoc.Displace_Basic_Shape.map.midthresh = val
			)
		)
			on spnStr2 changed val do
			(
				if mRoc != undefined and not isdeleted mRoc do
				(
					mDM2.strength = val
				)
			)
				on spcSize2 changed val do
				(
					if mRoc != undefined and not isdeleted mRoc do
					(
						mRoc.Displace_Medium_Details.map.size = val
					)
				)
						on spnSca changed val do
						(
							if mRoc != undefined and not isdeleted mRoc do
							(
								mNGD.scale = val
							)
						)
							on spnItt2 changed val do
							(
								if mRoc != undefined and not isdeleted mRoc do
								(
									mNGD.iterations = val
								)
							)
	on spnStr3 changed val do
	(
		if mRoc != undefined and not isdeleted mRoc do
		(
			mRoc.Noise_Grain_Detail.strength = [val, val, val]
		)
	)
		on spnSca2 changed val do
		(
			if mRoc != undefined and not isdeleted mRoc do
			(
				mNFD.scale = val	
			)
		)
			on spnItt3 changed val do
			(
				if mRoc != undefined and not isdeleted mRoc do
				(
					mNFD.iterations = val
				)
			)
				on spnStr4 changed val do
				(
					if mRoc != undefined and not isdeleted mRoc do
					(
						mRoc.Noise_Fine_Detail.strength = [val, val, val]
					)
				)
		on dRock pressed do -- when btn is pressed do...
		(
			if (selection.count>0) then
			(
				for obj in selection do
				(
					delete obj
				)
			)
			else
				(
					messagebox "You must have at least one Rock selected!" title:"Computer says no..." beep:false
				) 
		)
 
		on cExit pressed do
		(
			destroyDialog rockRollout
		)
			on btn_pivot pressed do
			(
				if mRoc != undefined and not isdeleted mRoc then
				(
					ResetPivot mRoc
					CenterPivot mRoc
					for i in selection do 
						(
							i.pivot = [i.pivot.x, i.pivot.y, i.min.z]
						)        
					mRoc.pos = [0,0,0]
				)else (messagebox "You must have at least one Rock selected!" title:"Computer says no..." beep:false)
			)
			on btn_pHelp pressed do
			(
				messageBox "The Pivot C/B button works in two ways\n\n1. If the rock is not selected then it will centre the pivot to the rock\n    and centre the rock to pos:[0,0,0]\n\n2. If the rock is selected it will place the pivot to the bottom\n    of the rock and centre the rock to pos:[0,0,0]" title:"petluke@gmail.com" beep:false
			)
 
 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
	on btn_SavePresets pressed do
	(	
		rollout editTextSaveP "Save Presets"
		(
			local presetName = undefined
			editText edittxt_prst_name "" bold:true 
			button btn_SavePrst "Save"
 
			on editTextSaveP open do
			(
				RockMakerAllSavedPresets = (readValue ((getINISetting RockMakerIniFile "Presets" "names") as stringStream))
			)					
 
			on edittxt_prst_name entered txt do
			(
				if txt != "" then 
				(
					presetName = txt as string
				)
			)
 
			on btn_SavePrst pressed do
			(
				if RockMakerAllSavedPresets.count !=0 then
					store = RockMakerAllSavedPresets
				else
					store = #() as array

					append store presetName
				
					setIniSetting RockMakerIniFile "Presets" "names" (store as string)
					setIniSetting RockMakerIniFile presetName "spn_Size" (spn_Size.value as string)
					setIniSetting RockMakerIniFile presetName "spn_Segs" (spn_Segs.value as string)
					setIniSetting RockMakerIniFile presetName "spnItt1" (spnItt1.value as string)
					setIniSetting RockMakerIniFile presetName "spnRit" (spnRit.value as string)
					setIniSetting RockMakerIniFile presetName "spnStr1" (spnStr1.value as string)
					setIniSetting RockMakerIniFile presetName "spxOff" (spxOff.value as string)
					setIniSetting RockMakerIniFile presetName "spzOff" (spzOff.value as string)
					setIniSetting RockMakerIniFile presetName "radBut" (radBut.state as string)
					setIniSetting RockMakerIniFile presetName "chkFrac" (chkFrac.state as string)
					setIniSetting RockMakerIniFile presetName "spnItt4" (spnItt4.value as string)
					setIniSetting RockMakerIniFile presetName "spcSize" (spcSize.value as string)
					setIniSetting RockMakerIniFile presetName "spcSpr" (spcSpr.value as string)
					setIniSetting RockMakerIniFile presetName "spnMidT" (spnMidT.value as string)
					setIniSetting RockMakerIniFile presetName "spnStr2" (spnStr2.value as string)
					setIniSetting RockMakerIniFile presetName "spcSize2" (spcSize2.value as string)
					setIniSetting RockMakerIniFile presetName "spnSca" (spnSca.value as string)
					setIniSetting RockMakerIniFile presetName "spnItt2" (spnItt2.value as string)
					setIniSetting RockMakerIniFile presetName "spnStr3" (spnStr3.value as string)
					setIniSetting RockMakerIniFile presetName "spnSca2" (spnSca2.value as string)
					setIniSetting RockMakerIniFile presetName "spnItt3" (spnItt3.value as string)
					setIniSetting RockMakerIniFile presetName "spnStr4" (spnStr4.value as string)
					RockMakerAllSavedPresets = (readValue ((getINISetting RockMakerIniFile "Presets" "names") as stringStream))
					rockRollout.LoadPresets.items = RockMakerAllSavedPresets

				destroydialog editTextSaveP
			)				
		)
		createdialog editTextSaveP
	) 		
		on btn_DelPreset pressed do
		(
			prstToDelName = LoadPresets.selected
			prstToDelNumb = LoadPresets.selection
 
			if prstToDelNumb > 1 then
			(
				RockMakerAllSavedPresets = (readValue ((getINISetting RockMakerIniFile "Presets" "names") as stringStream))
				delIniSetting RockMakerIniFile prstToDelName
				deleteItem RockMakerAllSavedPresets prstToDelNumb
				setIniSetting RockMakerIniFile "Presets" "names" (RockMakerAllSavedPresets as string)
				LoadPresets.items = RockMakerAllSavedPresets
				LoadPresets.selection = prstToDelNumb-1
				newPrstToShow = prstToDelNumb-1
				RockMakerAllSavedPresets = (readValue ((getINISetting RockMakerIniFile "Presets" "names") as stringStream))
				if prstToDelNumb != 2 then
				(
					print newPrstToShow
				)
			)
		)		
		on LoadPresets selected itm do
		(			
			if itm != 1 then
			(				
				spn_Size.value = ((getINISetting RockMakerIniFile RockMakerAllSavedPresets[itm] "spn_Size") as integer)
				spn_Segs.value = ((getINISetting RockMakerIniFile RockMakerAllSavedPresets[itm] "spn_Segs") as integer)
				spnItt1.value = ((getINISetting RockMakerIniFile RockMakerAllSavedPresets[itm] "spnItt1") as integer)
				spnRit.value = ((getINISetting RockMakerIniFile RockMakerAllSavedPresets[itm] "spnRit") as integer)
				spnStr1.value = ((getINISetting RockMakerIniFile RockMakerAllSavedPresets[itm] "spnStr1") as integer)
				spxOff.value = ((getINISetting RockMakerIniFile RockMakerAllSavedPresets[itm] "spxOff") as integer)
				spzOff.value = ((getINISetting RockMakerIniFile RockMakerAllSavedPresets[itm] "spzOff") as integer)
				radBut.state = (readValue ((getIniSetting RockMakerIniFile RockMakerAllSavedPresets[itm] "radBut") as stringStream))
				chkFrac.state = (readValue ((getIniSetting RockMakerIniFile RockMakerAllSavedPresets[itm] "chkFrac") as stringStream))
				spnItt4.value = ((getINISetting RockMakerIniFile RockMakerAllSavedPresets[itm] "spnItt4") as integer)
				spcSize.value = ((getINISetting RockMakerIniFile RockMakerAllSavedPresets[itm] "spcSize") as integer)
				spcSpr.value = ((getINISetting RockMakerIniFile RockMakerAllSavedPresets[itm] "spcSpr") as integer)
				spnMidT.value = ((getINISetting RockMakerIniFile RockMakerAllSavedPresets[itm] "spnMidT") as integer)
				spnStr2.value = ((getINISetting RockMakerIniFile RockMakerAllSavedPresets[itm] "spnStr2") as integer)
				spcSize2.value = ((getINISetting RockMakerIniFile RockMakerAllSavedPresets[itm] "spcSize2") as integer)
				spnSca.value = ((getINISetting RockMakerIniFile RockMakerAllSavedPresets[itm] "spnSca") as integer)
				spnItt2.value = ((getINISetting RockMakerIniFile RockMakerAllSavedPresets[itm] "spnItt2") as integer)
				spnStr3.value = ((getINISetting RockMakerIniFile RockMakerAllSavedPresets[itm] "spnStr3") as integer)
				spnSca2.value = ((getINISetting RockMakerIniFile RockMakerAllSavedPresets[itm] "spnSca2") as integer)
				spnItt3.value = ((getINISetting RockMakerIniFile RockMakerAllSavedPresets[itm] "spnItt3") as integer)
				spnStr4.value = ((getINISetting RockMakerIniFile RockMakerAllSavedPresets[itm] "spnStr4") as integer)
			)			
		)
 
-------------------------------------------------------------------------------------------------------------------------------------------
 
	on lpRock pressed do --make low poly Rock, clone Rock and unwrap and add projection modifier
	(
	try(
			max modify mode
			theBox = mRoc
			theCopy = copy theBox --create a copy of the first box, store in a variable
			theCopy.name = uniquename (theBox.name + "Copy") --rename the copy
			theCopy.modifiers[#TurboSmooth].iterations = 0
			convertToPoly theCopy
			select theCopy
			theUnw = Unwrap_UVW () 
			addModifier theCopy theUnw
			modPanel.setCurrentObject theCopy.modifiers[#Unwrap_UVW]
			SubObjectlevel = 1 
			theCopy.modifiers[#unwrap_uvw].unwrap2.setIgnoreBackFaceCull off
			theCopy.modifiers[#unwrap_uvw].unwrap6.selectVerticesByNode #{1..730} $
			theCopy.modifiers[#unwrap_uvw].unwrap2.fitRelax 50 0.1
			theCopy.modifiers[#unwrap_uvw].unwrap2.packNoParams()
			theCopy.modifiers[#unwrap_uvw].unwrap6.selectVerticesByNode #{1..730} $
			theCopy.modifiers[#unwrap_UVW].unwrap2.scaleSelectedCenter 0.98 0
			theProj = ProjectionMod() --create a projection modifier
			addModifier theCopy theProj
			theProj.addObjectNode theBox
			theProj.autowrapCage()
			theProj.addRegisteredProjectionType 1
			theProj.projectProjectionType 1
		)catch()
	)
 
	on btn_Bake pressed do try(macros.run "Render" "BakeDialog")catch()
 
	on cAbout pressed do 
	(	
		messageBox "Script by Luke Pettit\nhttp://lukepettit-3d.blogspot.com\n\nBased on the Sascha Henrichs Tutorial\nhttp://saschahenrichs.blogspot.com/\n\nPresets by Miauu\nKostadin Kotev\nmiau_u@yahoo.com " title:"petluke@gmail.com" beep:false
	)
)
createdialog rockRollout style:#(#style_toolwindow, #style_sysmenu) pos:[810, 130]
	
