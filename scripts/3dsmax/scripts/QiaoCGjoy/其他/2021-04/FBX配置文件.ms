fn setFBX=
	(
		--commented out settings left as defualt,  here for future revision purposes, but most likely not needed

		FBXExporterSetParam "Animation" true 
		FBXExporterSetParam "ASCII" false -- binaries are smaller
		FBXExporterSetParam "AxisConversionMethod" "Animation"
		FBXExporterSetParam "BakeAnimation"true 
		-- FBXExporterSetParam "BakeFrameStart" --derived from length of playback range
		-- FBXExporterSetParam "BakeFrameEnd"
		-- FBXExporterSetParam "BakeFrameStep"
		-- FBXExporterSetParam "BakeResampleAnimation"
		FBXExporterSetParam "Cameras" false
		-- FBXExporterSetParam "CAT2HIK"
		-- FBXExporterSetParam "ColladaTriangulate"
		-- FBXExporterSetParam "ColladaSingleMatrix"
		-- FBXExporterSetParam "ColladaFrameRate" 
		FBXExporterSetParam "Convert2Tiff" false
		--FBXExporterSetParam "ConvertUnit" "cm"  --should be Auto if SYSTEM UNITS  are correct
		FBXExporterSetParam "EmbedTextures"false
		FBXExporterSetParam "FileVersion" "FBX201300"
		FBXExporterSetParam "FilterKeyReducer" false --OPTIMIZE PASS  : curve filter stuff
		FBXExporterSetParam "GeomAsBone" false --only real bones should be exporting
		FBXExporterSetParam "GenerateLog" true
		FBXExporterSetParam "Lights" false
		--FBXExporterSetParam "LoadExportPresetFile"--this very code block negates a need for a preset
		FBXExporterSetParam "NormalsPerPoly"false--MoBu setting
		FBXExporterSetParam "PointCache" false--VERTEX ANIMATION
				--http://download.autodesk.com/us/fbx/2013/3ds_Max_FBX_Plug-in_Help/index.html?url=files/GUID-691D1194-AE6E-4EE9-A6A3-F1797D2F3B27.htm,topicNumber=d30e2947
		--FBXExporterSetParam "PopSettings"--for 'one click' operations
		FBXExporterSetParam "Preserveinstances" false--OPTIMIZE PASS  if instances used
		--FBXExporterSetParam "PushSettings--for 'one click' operations
		FBXExporterSetParam "Removesinglekeys"false--OPTIMIZE PASS  if motionless scenes
		--FBXExporterSetParam "Resampling"--for anim curves
		--FBXExporterSetParam "ResetExport"-reverts Loads the Autodesk Media & Entertainment export preset.
		--FBXExporterSetParam "ScaleFactor" 1.0 --should be Auto if SYSTEM UNITS  are correct
		--FBXExporterSetParam "SelectionSet"--VERTEX ANIMATION
		--FBXExporterSetParam "SelectionSetExport"--VERTEX ANIMATION 
		FBXExporterSetParam "Shape" true-- per conv w MG
		FBXExporterSetParam "Skin" true --skined bones is what we're all about
		FBXExporterSetParam "ShowWarnings" false 
		FBXExporterSetParam "SmoothingGroups" true--asked kelsey
		FBXExporterSetParam "SmoothMeshExport" false-- for turbosmooth
		--FBXExporterSetParam "SplitAnimationIntoTakes"-- one anim per file
		FBXExporterSetParam "TangentSpaceExport" false
		FBXExporterSetParam "Triangulate"false
		FBXExporterSetParam "UpAxis" "Y"
		FBXExporterSetParam "UseSceneName" false 
	)
