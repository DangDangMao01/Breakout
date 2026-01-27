--------FBX导出--------


(

	try(destroydialog FBXExport_mjj)catch()
	try(destroydialog SVNPEIZHI_mjj)catch()

	local filepath=""
	local pichulifilepath=""
	local mfp=""
	local mfn=""
	local skinbone=#()
	local bonearray=#()
	local layernodes=#()
	local exportpath=""
	local exportnode=#()
	local exporthelper=#()
	local mff=""
	local shuchudir=#()
	local files=#()
	local animbonearray=#()
	local sc_end#()
	local datainipath=(getDir #plugCfg) + "\\" + "SVNFBXINI.ini"
	

	local svnpath=""
	local svncheck=true 
	local svn_files=#()

	rollout svnpeizhi_mjj "SVN路径配置" width:400 height:100
	(
		edittext et_svnmulu "导出地址：" pos:[10,20] width:300
		button bn_selectsvnmulu "<<<" pos:[325,18] width:50 tooltip:"只需找到Client目录"
		button bn_set "设  置" width:150 pos:[125,60] height:30
		
		on bn_selectsvnmulu pressed do
		(
			svnpath=getsavepath caption:"选择SVN文件夹目录："
			try
			(
				if svnpath!="" or svnpath!=undefined then
				(
					et_svnmulu.text=svnpath
				)
			)
			catch()
			
		)
		on bn_set pressed do
		(
			if svnpath!="" then
			(
				setIniSetting datainipath "Directories" "thesvnpath" svnpath
				destroydialog svnpeizhi 
			)
			else
			(
				svnpath=getsavepath caption:"选择SVN文件夹目录："
			)
			
		)
	)
	
	fn getFilesRecursive root pattern =
	(
		dir_array = GetDirectories (root+"/*")
		for d in dir_array do
		(	
			join dir_array (GetDirectories (d+"/*"))
		)
		svn_files = #()
		
		for f in dir_array do
		(
			join svn_files (getFiles (f + pattern))
		)
		return svn_files
	)


	fn maxfilename_fn =
	(
		mfn=""
		mfn=maxfilename
		if mfn!="" or mfn !=undefined then 
		(
			mfnc=mfn.count 
			mfn=replace mfn (mfnc-3)  4 ""
		)
		return mfn
	)

	fn findnamechange_fn thename thefindstring =
	(
		fnn=findstring thename thefindstring
		if fnn !=undefined then------------如果文件名中有“（”则返回数字，不等于undefined
	    (
	    	
		    thename=substring thename 1 ((fnn as integer)-1)----------则删掉括号及其内容，得到新名字
		)
		else
		(
		    thename=thename
		)
		return thename 
	)

	fn removeunskinbone_fn objmesh =
	(
		
		skinbone=#()
		bonearray=#()
		stmodifiers=objmesh.modifiers
		stmstr=stmodifiers as string
		isskin=findstring stmstr "skin"
		if isskin!=undefined then
		(
			max modify mode
			objskin=objmesh.modifiers[#skin]
			skinops.removezeroweights objskin
			skin_num=skinops.getnumberbones objskin
			
			bonearray=#{1..skin_num}
			skinverts=#{1..(skinops.getnumbervertices objskin)}
			for i=1 to skinverts.count do
			(
				vertsweightbone=skinops.getvertexweightcount objskin i
						
				for b=1 to vertsweightbone do
				(
					skinboneid=skinops.getvertexweightboneid objskin i b
					
					append skinbone skinboneid
				)
			)
			skinbone=makeuniquearray skinbone
			skinbone=sort skinbone
			bonearray=bonearray as array
			
			for i=bonearray.count to 1 by -1 do
			(
				a=finditem skinbone bonearray[i]
				if a==0 then
				(
					modPanel.setCurrentObject objSkin
					skinops.removebone objskin i
				)
			)
		)

				
	)


	fn getlayernodes_fn thelayername =
	(
		layernodes=#()
		layercount=LayerManager.count 
		maxfilename_fn()
		mfn=findnamechange_fn mfn "("
		mfn=findnamechange_fn mfn "_Cloth"
		mfn=findnamechange_fn mfn "@Skin"
		for i=0 to layercount-1 do 
		(
			layeri=LayerManager.getlayer i 
			layername=layeri.name 
			
			highlayername=mfn + thelayername 
			if layername==highlayername then
			(
				
				layer =ilayermanager.getlayerobject i 
				layernodes=refs.dependents layer
				
			)
			
		)
		if layernodes.count!=0 then
		(
			themesh=for i in layernodes where (classOf i==Editable_mesh or classOf i ==Editable_Poly or classOf i==PolyMeshObject)collect i 
			layernodes=themesh 
			
		)
		return layernodes 
	)


	fn exporthelper_fn =
	(
		exporthelper=#()
		helpername=#("TX_Shoot","TX_Middle","TX_Foot_R","TX_Foot_L","TX_Xiong","TX_Tou","TX_Hand_R","TX_Hand_L","TX_Eye_R","TX_Eye_L")
				
		for h=1 to helpername.count do
		(
			if (getNodeByName helpername[h] exact:true)!=undefined then 
			(
				he=getNodeByName helpername[h]
				append exporthelper he 
			)
			
		) 

		for i in $*TX_Guadian* do
		(
			if classof i==Dummy or classOf i==point then
			(
				append exporthelper i
			)
		)

		for i in $*TX_Weapon* do
		(
			if classof i==Dummy or classOf i==point then
			(
				append exporthelper i
			)
		)
		return exporthelper
	)


	fn getmeshbone_fn =
	(
		exportnode=#()
		bonename=#()
		print layernodes 
		if layernodes.count!=0 then
		(
			for i=1 to  layernodes.count  do
			(
				a=layernodes[i]
				append exportnode a 
				select a
				removeunskinbone_fn $
				stmodifiers=$.modifiers
				stmstr=stmodifiers as string
				isskin=findstring stmstr "skin"
				if isskin!=undefined then
				(
					max modify mode
					objskin=$.modifiers[#skin]
					skinops.removezeroweights objskin
					skin_num=skinops.getnumberbones objskin
					for i=1 to skin_num do
					(
						aname=skinops.getbonename objskin i 1
						append bonename aname 

					)
				)			
			)
			clearSelection()
			bonename=makeuniquearray bonename
			if bonename.count !=0 then
			(
				for i=1 to bonename.count do 
				(
					bo=getNodeByName bonename[i]
					append exportnode bo 
				)
			)
		)
		
		return exportnode
	)


	fn maxfilefbxdir_fn =
	(
		mfp=maxfilepath
		if mfp!="" then
		( 
			mff=mfp+"FBX"
			print mff
			makedir mff all:false 
		)
		
		return mff 
	)

	fn exportpath_fn thestring=
	(
		exportpath=""
		mfp=maxfilepath 
		if mfp=="" then
		(
			messageBox "请保存文件！ "
		)
		else
		(
			if FBXExport_mjj.et_mulu.text=="" then
			(
				maxfilefbxdir_fn()
				append shuchudir mff 
				exportpath=mff +"\\" +mfn +thestring+ ".fbx"
			)
			else
			(
				a=FBXExport_mjj.et_mulu.text
				append shuchudir a
				exportpath=a +"\\"+mfn+thestring +".fbx"
			)
		)
		return exportpath
	)

	fn skinexportset_fn =
	(
		FBXExporterSetParam "ResetExport"
		FBXExporterSetParam "Animation" False
		FBXExporterSetParam "Cameras" False
	)

	Fn getMaxFiles_fn dir = 
	(	
		dir1 = getDirectories (dir + "*")
		if dir1.count != 1  then
		(
			for d in dir1 do 
			(
				join dir1 (getDirectories (d + "*"))	
			)
			files = #()
			for f in dir1 do 
			(	
				a=getFiles (f + "*.max")
				join files a
			)	
		)
		else
		(
			files = #()
			a=getFiles (dir + "*.max")
			join files a
		)	
		return files
	)

	fn deletechongfu_fn a b =
	(
		if a.count!=0 then
		(
			for i in a do
			(
				n=finditem b i
				if n!=0 then
				(
					print n
					deleteitem b n
				)
			)
		)
		
		return b
	)


	fn animboneexport_fn =
	(
		animbonearray=#()
		sc_end=#()
		animbonearray=for i in execute"$/*.../*" where (classof i==BoneGeometry or classOf i==Biped_Object )collect i		
		sc_end=for i in objects where (classof i==bonegeometry and i.children.count==0 and classof i.parent!=biped_object)collect i
		for n in $*nub* do
		(
			append sc_end n
		)
		exporthelper_fn()
		if exporthelper.count!=0 then
		(
			for i in exporthelper do
			(
				append animbonearray i
			)
		)
		animbonearray=makeuniquearray animbonearray
		return animbonearray
	)

	fn animexportpath_fn =
	(
		maxfilename_fn()
		exportpath=""
		mfp=maxfilepath 
		if mfp=="" then
		(
			messageBox "请保存文件！ "
		)
		else
		(
			if FBXExport_mjj.et_mulu.text=="" then
			(
				maxfilefbxdir_fn()
				append shuchudir mff 
				exportpath=mff +"\\" +mfn+ ".fbx"
			)
			else
			(
				a=FBXExport_mjj.et_mulu.text
				append shuchudir a
				exportpath=a +"\\"+mfn +".fbx"
			)
		)
		return exportpath
	)

	fn animexportfbxset_fn =
	(
		FBXExporterSetParam "ResetExport"
		FBXExporterSetParam "Skin" False
		FBXExporterSetParam "Cameras" False
	)

	fn bakeanimfbxset_fn =
	(
		startframe=animationRange.start
		startframe=startframe as string 
		startframe=replace startframe startframe.count 1 ""
		startframe=startframe as integer
		endframe=animationRange.end
		endframe=endframe as string 
		endframe=replace endframe endframe.count 1 ""
		endframe=endframe as integer
		FBXExporterSetParam "ResetExport"
		FBXExporterSetParam "Skin" False
		FBXExporterSetParam "Cameras" False
		FBXExporterSetParam "Bakeanimation" True
		FBXExporterSetParam "BakeFrameStart" startframe
		FBXExporterSetParam "BakeFrameEnd" endframe
		FBXExporterSetParam "BakeFrameStep" 1
		FBXExporterSetParam "BakeResampleAnimation" True
	)
	

	rollout FBXExport_mjj "FBX导出" 
	(

		group ""
		(
			edittext et_mulu "导出地址：" pos:[10,20] width:400
			button bn_selectmulu "<<<" pos:[420,18]
			button bn_clearmulu "清 空 路 径" pos:[490,18] 
			edittext et_pichulimulu "文件地址：" pos:[10,50] width:400
			button bn_selectpichulimulu "<<<" pos:[420,48] 
				
			button bn_shuchumulu "打开输出文件夹" pos:[480,48]

		)

			groupbox  gb_file "文件列表" pos:[5,85] width:320 height:300
			label lb_maxfile "max文件数量："  pos:[20,105]
			label lb_maxfilenum "0" pos:[100,105]
			MultiListBox mb_maxfile pos:[15,130] width:300 height:16
			button bn_allselect "全  选" pos:[20,355] width:70
			button bn_unselect "反  选" pos:[90,355] width:70
			button bn_cleanlist "清  空" pos:[160,355]width:70
			button bn_deletesel "删  除" pos:[230,355]width:70
		
			groupbox  gb_export "FBX导出" pos:[340,85] width:250 height:300
			button bn_high "High模型蒙皮信息输出" pos:[365,110] width:200 height:30
			button bn_lod "Lod模型蒙皮信息输出" pos:[365,150] width:200 height:30
			button bn_lv3 "Lv3模型蒙皮信息输出" pos:[365,190] width:200 height:30
			button bn_mesh "三档模型蒙皮信息输出" pos:[365,230] width:200 height:30
			button bn_anim "当前动画输出" pos:[365,270] width:200 height:30
			button bn_bakeanim "当前动画塌陷输出" pos:[365,310] width:200 height:30
			checkbox cb_svnmulu " FBX 同 步 保 存 到 主 干" pos:[400,350] checked:true 
			

		on FBXExport_mjj open do
		(

			if (doesFileExist datainipath)==false then
			(
				createdialog svnpeizhi_mjj

			)
			
		)


		on  bn_clearmulu pressed do
		(
			et_mulu.text=""
			if (doesFileExist datainipath)==false then
			(
				createdialog svnpeizhi_mjj

			)

		)

		on bn_shuchumulu pressed do
		(
			if shuchudir.count !=0 then 
			(
				shuchudir=makeuniquearray shuchudir
				for i in shuchudir do
				(
					ShellLaunch "explorer.exe" i
				)
			)


		)

		on cb_svnmulu changed thestate do
		(
			svncheck=thestate


		)


		



		on bn_selectmulu pressed do
		(
			filepath=""
			filepath=getsavepath caption:"选择导出文件夹目录："
			try
			(
				if filepath!="" or filepath!= undefined then 
				(
					et_mulu.text =filepath 

				)
			)
			catch()
			
		)


		on bn_selectpichulimulu pressed do
		(
			local filesname=#()
			pichulifilepath=""
			pichulifilepath=getsavepath caption:"选择批处理文件夹目录："
			try
			(
				if pichulifilepath!="" or pichulifilepath!= undefined then 
				(
					et_pichulimulu.text =pichulifilepath 
					a=pichulifilepath+"\\"
					getMaxFiles_fn a
					if files.count!=0 then
					(
						for i in files do
						(
							filename=filenameFromPath i
							append filesname filename
						)
						
					)

					mb_maxfile.items=filesname
					b=mb_maxfile.items.count
					lb_maxfilenum.text= b as string 
				)
			)
			catch()

		)


		on bn_cleanlist pressed do
		(
			mb_maxfile.items=#()
			b=mb_maxfile.items.count
			lb_maxfilenum.text= b as string
		)

		on bn_allselect pressed do
		(
			if mb_maxfile.items.count!=0 then
			(
				
				a=mb_maxfile.items.count
				mb_maxfile.selection=#{1..a}
			)
		)

		on bn_unselect pressed do
		(
			if mb_maxfile.items.count!=0 then
			(
				n=mb_maxfile.items.count
				a=#{1..n} as array
				b=mb_maxfile.selection
				c=deletechongfu_fn b a
				print c
				mb_maxfile.selection=c
			)
		)

		on mb_maxfile doubleclicked sel do
		(
			

			loadmaxfile files[sel] quiet:true
		)


		


		on bn_high pressed do 
		(
			if mb_maxfile.selection.count==0 then
			(

				a=maxfilename
				if a=="" then
				(
					messageBox "请保存文件！  "
				)
				else 
				(

					shuchudir=#()
					getlayernodes_fn ""
					if layernodes.count!=0 then 
					(
						clearSelection()
						getmeshbone_fn()
						exporthelper_fn()
						clearSelection()
						if exporthelper.count!=0 then
						(
							for i in exporthelper do
							(
								append exportnode i 
							)
						)
						select exportnode
						exportpath_fn ""
						skinexportset_fn()

						exportfile exportPath  #noPrompt selectedOnly:true using:#FBXEXP
						clearSelection()
						if svncheck==true then
						(
							svnpath=getIniSetting datainipath "Directories" "thesvnpath" 
							fa=findstring svnpath "Client"
							if fa!=undefined then
							(
								svnpath=substring svnpath 1 (fa-1)
								svnpath=svnpath+"Client\\proj.unity\\Assets\\ResourceAB\\Character"
								thefbxname=filenamefrompath exportpath 
								ar=getFilesRecursive svnpath thefbxname
								if ar.count!=0 then
								(
									for i=1 to ar.count do
									(
										deletefile ar[i]
										copyfile exportpath ar[i]
									)
								)

							)
						)
					)
				)
			)
			else
			(
				for i in mb_maxfile.selection do 
				(
					if keyboard.escPressed do (exit)
					loadMaxFile files[i] useFileUnits:true quiet:true
					shuchudir=#()
					getlayernodes_fn ""
					if layernodes.count!=0 then 
					(
						clearSelection()
						getmeshbone_fn()
						exporthelper_fn()
						clearSelection()
						if exporthelper.count!=0 then
						(
							for i in exporthelper do
							(
								append exportnode i 
							)
						)
						select exportnode
						exportpath_fn ""
						skinexportset_fn()
						exportfile exportPath  #noPrompt selectedOnly:true using:#FBXEXP
						clearSelection()
					)
					savemaxfile files[i]
					if svncheck==true then
					(
						svnpath=getIniSetting datainipath "Directories" "thesvnpath" 
						a=findstring svnpath "Client"
						if a!=undefined then
						(
							svnpath=substring svnpath 1 a-1
							svnpath=svnpath+"Client\\proj.unity\\Assets\\ResourceAB\\Character"
							thefbxname=filenamefrompath exportpath 
							ar=getFilesRecursive svnpath thefbxname
							if ar.count!=0 then
							(
								for i=1 to ar.count do
								(
									deletefile ar[i]
									copyfile exportpath ar[i]
								)
							)
						)
					)
				)
			)
		)

		on bn_lod pressed do 
		(
			if mb_maxfile.selection.count==0 then
			(
				a=maxfilename
				if a=="" then
				(
					messageBox "请保存文件！  "
				)
				else 
				(
					shuchudir=#()
					getlayernodes_fn "_Lod"
					if layernodes.count!=0 then 
					(
						clearSelection()
						getmeshbone_fn()
						exporthelper_fn()
						clearSelection()
						if exporthelper.count!=0 then
						(
							for i in exporthelper do
							(
								append exportnode i 
							)
						)
						select exportnode
						exportpath_fn "_Lod"
						skinexportset_fn()
						exportfile exportPath  #noPrompt selectedOnly:true using:#FBXEXP
						clearSelection()
					)
				)
			)
			else
			(
				for i in mb_maxfile.selection do 
				(
					if keyboard.escPressed do (exit)
					loadMaxFile files[i] useFileUnits:true quiet:true
					shuchudir=#()
					getlayernodes_fn "_Lod"
					if layernodes.count!=0 then 
					(
						clearSelection()
						getmeshbone_fn()
						exporthelper_fn()
						clearSelection()
						if exporthelper.count!=0 then
						(
							for i in exporthelper do
							(
								append exportnode i 
							)
						)
						select exportnode
						exportpath_fn "_Lod"
						skinexportset_fn()
						exportfile exportPath  #noPrompt selectedOnly:true using:#FBXEXP
						clearSelection()
					)
					savemaxfile files[i]
				)
			)
		)

		on bn_lv3 pressed do 
		(
			if mb_maxfile.selection.count==0 then
			(
				a=maxfilename
				if a=="" then
				(
					messageBox "请保存文件！  "
				)
				else 
				(
					shuchudir=#()
					getlayernodes_fn "_Lv3"
					if layernodes.count!=0 then 
					(
						clearSelection()
						getmeshbone_fn()
						exporthelper_fn()
						clearSelection()
						if exporthelper.count!=0 then
						(
							for i in exporthelper do
							(
								append exportnode i 
							)
						)
						select exportnode
						exportpath_fn "_Lv3"
						skinexportset_fn()
						exportfile exportPath  #noPrompt selectedOnly:true using:#FBXEXP
						clearSelection()
					)
				)
			)
			else
			(
				for i in mb_maxfile.selection do 
				(
					if keyboard.escPressed do (exit)
					loadMaxFile files[i] useFileUnits:true quiet:true
					shuchudir=#()
					getlayernodes_fn "_Lv3"
					if layernodes.count!=0 then 
					(
						clearSelection()
						getmeshbone_fn()
						exporthelper_fn()
						clearSelection()
						if exporthelper.count!=0 then
						(
							for i in exporthelper do
							(
								append exportnode i 
							)
						)
						select exportnode
						exportpath_fn "_Lv3"
						skinexportset_fn()
						exportfile exportPath  #noPrompt selectedOnly:true using:#FBXEXP
						clearSelection()
					)
					savemaxfile files[i]
				)
			)
		)

		on bn_mesh pressed do
		(
			if mb_maxfile.selection.count==0 then
			(
				a=maxfilename
				if a=="" then
				(
					messageBox "请保存文件！  "
				)
				else 
				(
					shuchudir=#()
					getlayernodes_fn ""
					if layernodes.count!=0 then 
					(
						clearSelection()
						getmeshbone_fn()
						exporthelper_fn()
						clearSelection()
						if exporthelper.count!=0 then
						(
							for i in exporthelper do
							(
								append exportnode i 
							)
						)
						select exportnode
						exportpath_fn ""
						skinexportset_fn()
						exportfile exportPath  #noPrompt selectedOnly:true using:#FBXEXP
						clearSelection()
					)
					getlayernodes_fn "_Lod"
					if layernodes.count!=0 then 
					(
						clearSelection()
						getmeshbone_fn()
						exporthelper_fn()
						clearSelection()
						if exporthelper.count!=0 then
						(
							for i in exporthelper do
							(
								append exportnode i 
							)
						)
						select exportnode
						exportpath_fn "_Lod"
						skinexportset_fn()
						exportfile exportPath  #noPrompt selectedOnly:true using:#FBXEXP
						clearSelection()
					)
					getlayernodes_fn "_Lv3"
					if layernodes.count!=0 then 
					(
						clearSelection()
						getmeshbone_fn()
						exporthelper_fn()
						clearSelection()
						if exporthelper.count!=0 then
						(
							for i in exporthelper do
							(
								append exportnode i 
							)
						)
						select exportnode
						exportpath_fn "_Lv3"
						skinexportset_fn()
						exportfile exportPath  #noPrompt selectedOnly:true using:#FBXEXP
						clearSelection()
					)
				)
			)
			else
			(
				shuchudir=#()
				getlayernodes_fn ""
				if layernodes.count!=0 then 
				(
					clearSelection()
					getmeshbone_fn()
					exporthelper_fn()
					clearSelection()
					if exporthelper.count!=0 then
					(
						for i in exporthelper do
						(
							append exportnode i 
						)
					)
					select exportnode
					exportpath_fn ""
					skinexportset_fn()
					exportfile exportPath  #noPrompt selectedOnly:true using:#FBXEXP
					clearSelection()
				)
				getlayernodes_fn "_Lod"
				if layernodes.count!=0 then 
				(
					clearSelection()
					getmeshbone_fn()
					exporthelper_fn()
					clearSelection()
					if exporthelper.count!=0 then
					(
						for i in exporthelper do
						(
							append exportnode i 
						)
					)
					select exportnode
					exportpath_fn "_Lod"
					skinexportset_fn()
					exportfile exportPath  #noPrompt selectedOnly:true using:#FBXEXP
					clearSelection()
				)
				getlayernodes_fn "_Lv3"
				if layernodes.count!=0 then 
				(
					clearSelection()
					getmeshbone_fn()
					exporthelper_fn()
					clearSelection()
					if exporthelper.count!=0 then
					(
						for i in exporthelper do
						(
							append exportnode i 
						)
					)
					select exportnode
					exportpath_fn "_Lv3"
					skinexportset_fn()
					exportfile exportPath  #noPrompt selectedOnly:true using:#FBXEXP
					clearSelection()
				)
			)

		)

		on bn_anim pressed do
		(
			if mb_maxfile.selection.count==0 then
			(
				a=maxfilename
				if a=="" then
				(
					messageBox "请保存文件！  "
				)
				else 
				(
					shuchudir=#()
					animbonearray=#()
					sc_end=#()
					a=maxfilename
					find1=findstring a "@Skin"
					find2=findstring a "@"
					if find1==undefined or find2!=undefined then
					(
						animboneexport_fn()
						select animbonearray
					)
					animexportpath_fn()
					animexportfbxset_fn()
					exportfile exportPath  #noPrompt selectedOnly:true using:#FBXEXP
				)
			)
			else
			(
				for i in mb_maxfile.selection do 
				(
					if keyboard.escPressed do (exit)
					loadMaxFile files[i] useFileUnits:true quiet:true
					shuchudir=#()
					animbonearray=#()
					sc_end=#()
					a=maxfilename
					find1=findstring a "@Skin"
					find2=findstring a "@"
					if find1==undefined or find2!=undefined then
					(
						animboneexport_fn()
						select animbonearray
					)
					animexportpath_fn()
					animexportfbxset_fn()
					exportfile exportPath  #noPrompt selectedOnly:true using:#FBXEXP
					savemaxfile files[i]
				)
			)

		)

		on bn_bakeanim pressed do 
		(
			if mb_maxfile.selection.count==0 then
			(
				a=maxfilename
				if a=="" then
				(
					messageBox "请保存文件！  "
				)
				else 
				(
					shuchudir=#()
					animbonearray=#()
					sc_end=#()
					a=maxfilename
					find1=findstring a "@Skin"
					find2=findstring a "@"
					if find1==undefined or find2!=undefined then
					(
						animboneexport_fn()
						select animbonearray
					)
					animexportpath_fn()
					bakeanimfbxset_fn()
					exportfile exportPath  #noPrompt selectedOnly:true using:#FBXEXP
				)
			)
			else
			(
				for i in mb_maxfile.selection do 
				(
					if keyboard.escPressed do (exit)
					loadMaxFile files[i] useFileUnits:true quiet:true
					shuchudir=#()
					animbonearray=#()
					sc_end=#()
					a=maxfilename
					find1=findstring a "@Skin"
					find2=findstring a "@"
					if find1==undefined or find2!=undefined then
					(
						animboneexport_fn()
						select animbonearray
					)
					animexportpath_fn()
					bakeanimfbxset_fn()
					exportfile exportPath  #noPrompt selectedOnly:true using:#FBXEXP
					savemaxfile files[i]
				)
			)
		)

	)
	createdialog FBXExport_mjj 600 400

	


)



