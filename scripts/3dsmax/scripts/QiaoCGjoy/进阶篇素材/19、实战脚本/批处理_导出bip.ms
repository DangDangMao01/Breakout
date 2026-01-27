try (  DestroyDialog fileIn_Script)catch() 

global Ms_filepath =""--env地址


rollout Batch_exportbip "Batchbip" width:180 
(
	local files=getfiles (maxfilepath+"*.max")
	local tem_aa=#()
	
	button 'find_files' "V" pos:[6,10] width:160 height:10 align:#left
	edittext 'path_edt1' "" pos:[6,30] width:137 height:19 enabled:true align:#left
	button 'getMAXList' ">>" pos:[148,29] width:20 height:19 align:#left 

	
	checkbutton fileInScript "脚" width:160  toolTip:"批量执行无界面的脚本\n         激活执行"
	
	button process_bt "选中导出bip" width:160  

	button selAll_bt "全选"  pos:[10,103] width:40
	button Unsel_bt "反选"  pos:[55,103] width:40

	button 'batchdo_bt' "批量执行" pos:[100,103] width:70 height:21 
	
	editText searchfile_et "筛选:" width:120 height:19  align:#left across:2
	button get_filename "<<"  toolTip:"获取当前文件名" align:#right
	multiListBox 'max_lbx1' "" pos:[5,152] width:170 height:15 align:#left		
	

	--执行无界面的脚本
	on fileInScript changed state do
	(
		if state then
		(
			createdialog fileIn_Script
		)
		else
		(
			DestroyDialog fileIn_Script
		)
	)		
	
	------------------------------------------------------------------------------------------------------------------------------
	

	on getMAXList pressed do
	(
		tem_aa=#()
		files=getfiles (maxfilepath+"*.max")
		for i in 1 to files.count do
		(
			gg=filenamefrompath(files[i] as string)
			append tem_aa gg
		)	
										----------------读取文档路径里的文件并保存到tem_aa集合中
		max_lbx1.items = tem_aa
		path_edt1.text=maxfilepath
	)
	on max_lbx1 doubleClicked sel do
	(
		loadmaxfile files[sel] quiet:true
	)
	on find_files pressed do
	(
		mfh1 = getSavePath caption:"选择max文件目录:"
			
		if mfh1 != undefined then
		(
			tem_aa=#()
			files=getfiles (mfh1+"\*.max")
			for i in 1 to files.count do
			(
				gg=filenamefrompath(files[i] as string)
				append tem_aa gg
			)
			max_lbx1.items = tem_aa
			path_edt1.text=maxfilepath
		)
	)

	Fn searchMaxFiles_fn fileList str =
	(
		selArray = #()
        numFiles = fileList.items.count
        for x = 1 to numFiles do
        (
			fileName = fileNameFromPath fileList.items[x]
			fileFound = findstring fileName str
			if fileFound != undefined then (append selArray x)
		)
			return selArray
	)
	--------------------------------------------------------------------------------------------------------------------------	
	--Select all
    on selAll_bt pressed do 
	(
       max_lbx1.selection = #{1..max_lbx1.items.count}
    )
		
	Fn UnSelect_fn sel all=
	(
		for i=1 to sel.count do
		(			
			ID_Find = findItem all sel[i]

			deleteItem all ID_Find
			
		)
		
		return all
		
	)
	
	--UnSelect
    on Unsel_bt pressed do 
	(
		list_all = #{1..max_lbx1.items.count} as array
		list_sel = max_lbx1.selection  as array
		
		max_lbx1.selection = UnSelect_fn list_sel list_all
		
    )
	
	--------------------------------------------------------------------------------------------------------------------------
	--以关键词查询
	on searchfile_et entered str do
	(
		if searchfile_et.text != "" then
		(
			max_lbx1.selection = (searchMaxFiles_fn max_lbx1 searchfile_et.text)
		)
	)
	--以关键词查询
	on searchfile_et changed  str do
	(
		if searchfile_et.text != "" then
		(
			max_lbx1.selection = (searchMaxFiles_fn max_lbx1 searchfile_et.text)
		)
		
	)
	
	
	----------------------------------------------------------------------------------------------------------
	--获得当前文件命名
	on get_filename pressed do
	(

		max_filename = filterString maxFileName "."
				
		searchfile_et.text = max_filename[1]
	)
	
	
	
	on batchdo_bt pressed do
	(
			
		if  files != #() then
		(
			for index in max_lbx1.selection do 
			(
				if keyboard.escPressed do (exit)		
			
				loadMaxFile files[index] useFileUnits:true quiet:true

				-------------------------------------------------------------------------------------------------------------------------------
				---------------------------------------------------------------------------------------------------------------------
				--执行无界面的脚本启动
				if fileInScript.checked then	
				(
					if keyboard.escPressed do (exit)
					fileIn Ms_filepath
					
				)	
				-----------------------------------------------------------------------------------------------------------------------------
				-----------------------------------------------------------------------------------------------------------------------------
				
				-----------------------------------------------------------------------------------------------------------------------------
				saveMaxFile files[index]	
				---------------------------------------------------------------------------------------------------------------------			
			)
		)							
	)
	---------------------------------------------------------------------------------------------------------------
	on process_bt pressed do
	(	
		if  files != #() then
		(
			for index in max_lbx1.selection do 
			(
				if keyboard.escPressed do (exit)		
			
				loadMaxFile files[index] useFileUnits:true quiet:true

				-------------------------------------------------------------------------------------------------------------------------------
				---------------------------------------------------------------------------------------------------------------------
				--批量导出bip
				bipedBone = for obj in objects where classOf obj == Biped_Object collect obj
				if bipedBone.count > 0 then 
				(
					for obj in bipedBone do 
					(
						try -- in case twist bone will cause error
							
						if (obj.transform.controller) as string == "Controller:Body" then --找到质心
							(
							-- get biped controller for operation
								biped_ctrl = obj.transform.controller
								
								-- in case of layered animation will cause error
								try
								(
									biped_ctrl.figureMode = false --关掉骨骼编辑模式
								)
								catch()

								activeTimeString = filterString (animationRange as string) " " --获取动画范围帧保存成数组的形式
								startFrame = (replace activeTimeString[2] activeTimeString[2].count 1 "") as integer --获得起始帧数
								endFrame = (replace activeTimeString[3] (activeTimeString[3].count-1) 2 "") as integer --获结束始帧数
								
								
								fileName = maxFilePath+getfilenamefile maxFileName+".bip" --保存在当前的文件夹下bip
								
								biped.saveBipFile biped_ctrl fileName #saveSubAnimControllers  -- for MAX 9
								biped.saveBipFileSegment biped_ctrl fileName startFrame endFrame #saveSubAnimControllers
								-- save action
								-- save twice because of the bug in MAX 9

								/*
								if object_cb.state and ctrl_cb.state then(
									biped.saveBipFile biped_ctrl fileName #saveMaxObjects #saveSubAnimControllers  -- for MAX 9
									biped.saveBipFileSegment biped_ctrl fileName startFrame endFrame #saveMaxObjects #saveSubAnimControllers
								)
								if not object_cb.state and not ctrl_cb.state then(
									biped.saveBipFile biped_ctrl fileName  -- for MAX 9
									biped.saveBipFileSegment biped_ctrl fileName startFrame endFrame
								)
								if not object_cb.state and ctrl_cb.state then(
									biped.saveBipFile biped_ctrl fileName #saveSubAnimControllers  -- for MAX 9
									biped.saveBipFileSegment biped_ctrl fileName startFrame endFrame #saveSubAnimControllers
								)
								if object_cb.state and not ctrl_cb.state then(
									biped.saveBipFile biped_ctrl fileName #saveMaxObjects  -- for MAX 9
									biped.saveBipFileSegment biped_ctrl fileName startFrame endFrame #saveMaxObjects
								)
								*/
							)
							catch()
					)
					
				)	
				free bipedBone

				---------------------------------------------------------------------------------------------------------------------			
			)
		)							
	)
	
	
	---------------------------------------------------------------------------------------------------------------
)
createdialog  Batch_exportbip


-------------------------------------------------------------------------------------------------------------------------------------------------------
rollout fileIn_Script "执行无界面的脚本" width:231 height:60
(
	
	button 'browseMs_bt' "Ms文件:"  width:100 height:21    
    
	edittext 'browseMs_et' ""  width:204 height:17 fieldwidth:200 
	

	on browseMs_bt pressed do
	(
		tmpFilename = getOpenFileName caption:"Env Template File" types:"Env Files (*.ms)|*.ms|" historyCategory:"openfile" initialDir:(getDir #maxroot)
		if tmpFilename != undefined then 
			(
				browseMs_et.text = tmpFilename
				Ms_filepath = tmpFilename
	
			)
			
			
	)
)
