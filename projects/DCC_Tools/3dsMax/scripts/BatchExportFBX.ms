/*
	批量MAX文件导出FBX脚本
	功能：批量打开多个.max文件并导出为FBX
	作者：Kiro
	日期：2025-12-16
*/

rollout BatchExportFBX_Rollout "批量MAX转FBX" width:400 height:420
(
	-- UI 控件
	label lbl_input "MAX文件目录:" align:#left
	edittext edt_input_path "" width:350 across:2 align:#left
	button btn_browse_input "..." width:30 height:20 align:#right
	
	label lbl_output "FBX输出目录:" align:#left
	edittext edt_output_path "" width:350 across:2 align:#left
	button btn_browse_output "..." width:30 height:20 align:#right
	
	checkbox chk_subfolders "包含子文件夹" checked:false
	checkbox chk_keep_structure "保持文件夹结构" checked:true
	
	group "导出选项"
	(
		radiobuttons rdo_export_mode labels:#("导出整个场景", "分别导出每个对象") default:1 columns:2
		checkbox chk_center "导出时居中到原点" checked:false
		checkbox chk_geometry_only "仅导出几何体" checked:true
	)
	
	group "FBX 设置"
	(
		checkbox chk_embed_media "嵌入媒体" checked:false
		checkbox chk_ascii "ASCII格式" checked:false
		dropdownlist ddl_version "FBX版本:" items:#("FBX 2020", "FBX 2019", "FBX 2018", "FBX 2016", "FBX 2014") selection:1 width:150
	)
	
	listbox lst_files "待处理文件:" height:8
	label lbl_count "共 0 个文件" align:#left
	
	progressbar pb_progress value:0 color:green height:15
	label lbl_status "就绪" align:#left
	
	button btn_scan "扫描文件" width:90 height:25 across:4
	button btn_clear "清空列表" width:90 height:25
	button btn_export "开始导出" width:90 height:25
	button btn_cancel "关闭" width:90 height:25
	
	-- 存储文件列表
	local maxFiles = #()
	
	-- 浏览输入文件夹
	on btn_browse_input pressed do
	(
		local folderPath = getSavePath caption:"选择MAX文件目录"
		if folderPath != undefined do
			edt_input_path.text = folderPath
	)
	
	-- 浏览输出文件夹
	on btn_browse_output pressed do
	(
		local folderPath = getSavePath caption:"选择FBX输出目录"
		if folderPath != undefined do
			edt_output_path.text = folderPath
	)
	
	-- 递归获取文件
	fn getMaxFilesRecursive folderPath includeSubfolders =
	(
		local files = #()
		local maxPattern = folderPath + "\\*.max"
		local foundFiles = getFiles maxPattern
		join files foundFiles
		
		if includeSubfolders do
		(
			local subDirs = getDirectories (folderPath + "\\*")
			for subDir in subDirs do
			(
				local subFiles = getMaxFilesRecursive subDir true
				join files subFiles
			)
		)
		return files
	)
	
	-- 扫描文件
	on btn_scan pressed do
	(
		if edt_input_path.text == "" do
		(
			messageBox "请先选择MAX文件目录！" title:"提示"
			return()
		)
		
		maxFiles = getMaxFilesRecursive edt_input_path.text chk_subfolders.checked
		
		-- 更新列表显示
		local displayNames = for f in maxFiles collect (getFilenameFile f)
		lst_files.items = displayNames
		lbl_count.text = "共 " + maxFiles.count as string + " 个文件"
	)
	
	-- 清空列表
	on btn_clear pressed do
	(
		maxFiles = #()
		lst_files.items = #()
		lbl_count.text = "共 0 个文件"
	)
	
	-- 设置FBX导出参数
	fn setupFBXExporter embedMedia:false asciiFormat:false =
	(
		FBXExporterSetParam "SmoothingGroups" true
		FBXExporterSetParam "NormalsPerPoly" false
		FBXExporterSetParam "TangentSpaceExport" true
		FBXExporterSetParam "SmoothMeshExport" false
		FBXExporterSetParam "Preserveinstances" true
		FBXExporterSetParam "GeomAsBone" false
		FBXExporterSetParam "Triangulate" false
		FBXExporterSetParam "Animation" true
		FBXExporterSetParam "BakeAnimation" true
		FBXExporterSetParam "EmbedTextures" embedMedia
		FBXExporterSetParam "ASCII" asciiFormat
		FBXExporterSetParam "ConvertUnit" "cm"
	)
	
	-- 清理文件名
	fn cleanFileName fileName =
	(
		fileName = substituteString fileName ":" "_"
		fileName = substituteString fileName "*" "_"
		fileName = substituteString fileName "?" "_"
		fileName = substituteString fileName "\"" "_"
		fileName = substituteString fileName "<" "_"
		fileName = substituteString fileName ">" "_"
		fileName = substituteString fileName "|" "_"
		return fileName
	)
	
	-- 获取相对路径
	fn getRelativePath fullPath basePath =
	(
		local relativePath = substituteString fullPath basePath ""
		if relativePath[1] == "\\" do relativePath = substring relativePath 2 -1
		return relativePath
	)
	
	-- 确保目录存在
	fn ensureDirectoryExists dirPath =
	(
		if not doesFileExist dirPath do
			makeDir dirPath all:true
	)
	
	-- 导出整个场景
	fn exportWholeScene outputPath centerToOrigin:false geometryOnly:false =
	(
		if geometryOnly do
		(
			select geometry
			if selection.count == 0 do return false
		)
		
		if centerToOrigin and geometryOnly do
		(
			-- 计算场景中心并移动
			local objs = selection as array
			local center = [0,0,0]
			for obj in objs do center += obj.pos
			center /= objs.count
			for obj in objs do obj.pos -= center
		)
		
		if geometryOnly then
			exportFile outputPath #noPrompt selectedOnly:true using:FBXEXP
		else
			exportFile outputPath #noPrompt selectedOnly:false using:FBXEXP
		
		return true
	)
	
	-- 分别导出每个对象
	fn exportEachObject outputFolder baseName centerToOrigin:false =
	(
		local objs = geometry as array
		if objs.count == 0 do return 0
		
		local count = 0
		for obj in objs do
		(
			local originalPos = obj.pos
			if centerToOrigin do obj.pos = [0,0,0]
			
			select obj
			local fileName = cleanFileName (baseName + "_" + obj.name + ".fbx")
			local fullPath = outputFolder + "\\" + fileName
			
			try
			(
				exportFile fullPath #noPrompt selectedOnly:true using:FBXEXP
				count += 1
			)
			catch()
			
			obj.pos = originalPos
		)
		return count
	)
	
	-- 开始批量导出
	on btn_export pressed do
	(
		-- 检查
		if edt_output_path.text == "" do
		(
			messageBox "请先选择FBX输出目录！" title:"提示"
			return()
		)
		
		if maxFiles.count == 0 do
		(
			messageBox "请先扫描MAX文件！" title:"提示"
			return()
		)
		
		-- 设置FBX参数
		setupFBXExporter embedMedia:chk_embed_media.checked asciiFormat:chk_ascii.checked
		
		-- 确保输出目录存在
		ensureDirectoryExists edt_output_path.text
		
		local successCount = 0
		local failCount = 0
		local basePath = edt_input_path.text
		
		-- 禁用自动备份
		local oldAutoBackup = autosave.Enable
		autosave.Enable = false
		
		for i = 1 to maxFiles.count do
		(
			local maxFile = maxFiles[i]
			local fileName = getFilenameFile maxFile
			
			-- 更新进度
			pb_progress.value = (i as float / maxFiles.count) * 100
			lbl_status.text = "处理: " + fileName + " (" + i as string + "/" + maxFiles.count as string + ")"
			
			try
			(
				-- 打开MAX文件（静默模式）
				loadMaxFile maxFile quiet:true
				
				-- 确定输出路径
				local outputFolder = edt_output_path.text
				if chk_keep_structure.checked do
				(
					local relativePath = getRelativePath (getFilenamePath maxFile) basePath
					if relativePath != "" do
					(
						outputFolder = edt_output_path.text + "\\" + relativePath
						ensureDirectoryExists outputFolder
					)
				)
				
				-- 根据模式导出
				if rdo_export_mode.state == 1 then
				(
					-- 导出整个场景
					local fbxPath = outputFolder + "\\" + fileName + ".fbx"
					exportWholeScene fbxPath centerToOrigin:chk_center.checked geometryOnly:chk_geometry_only.checked
					successCount += 1
				)
				else
				(
					-- 分别导出每个对象
					local exported = exportEachObject outputFolder fileName centerToOrigin:chk_center.checked
					successCount += exported
				)
			)
			catch
			(
				failCount += 1
				format "处理失败: % - %\n" maxFile (getCurrentException())
			)
		)
		
		-- 恢复自动备份设置
		autosave.Enable = oldAutoBackup
		
		-- 重置场景
		resetMaxFile #noPrompt
		
		-- 完成
		pb_progress.value = 100
		lbl_status.text = "完成"
		messageBox ("批量导出完成！\n成功: " + successCount as string + "\n失败: " + failCount as string) title:"批量MAX转FBX"
		pb_progress.value = 0
	)
	
	-- 关闭窗口
	on btn_cancel pressed do
	(
		destroyDialog BatchExportFBX_Rollout
	)
)

-- 创建对话框
createDialog BatchExportFBX_Rollout
