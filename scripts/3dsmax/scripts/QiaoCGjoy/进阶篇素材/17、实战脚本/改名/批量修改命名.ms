-------------------------------------------------------
-------------------AnimationTool-----------------------
------------------Time:2018-05-31----------------------
-------------------Author:乔磊-------------------------
------------------QQ:409856476-------------------------
-------------------------------------------------------

global uev_default_Browse_Directory = "C:/"
global SavedPaths


fn updateSavedPaths a =  
(
	local Tem_new = selectionSets["RenameBone"]
	Save_Path  = SavedPaths + "\RenameBone.ms"
	
	deleteFile Save_Path 
	for i=1 to Tem_new.count do
	(
		setINISetting Save_Path  "改名列表" ("$"+"'"+a[i] as string +"'"+ ".name") ( "\""+Tem_new[i].name as string+"\"")
	)
)	---生成


-----------------------------------------------------------------------------------------------------------------------------
	
-----------------------------------------------------------------------------------------------------------------------------


rollout Rename_bone "Rename " 
(
	label lab_01 "脚本存放位置:" align:#left
	edittext 'edt_manualSearch' "" 
 
	button 'btn_browseSearch' "Browse" toolTip:"选取生成脚本位置"
	button 'Save_OriName' "保存初始命名" toolTip:"选所有需要重命名的物体"
	button 'Cre_Rename' "生成改名脚本"  enabled:false  toolTip:"         修改命名后\n点击生成批量重命名脚本"
	local Tem_ori = #()
	hyperlink lbl_help "帮助" address:"https://www.cgjoy.com/thread-211520-1-1.html" align:#center offset:[0,10]
	
	

-----------------------------------------------------------------------------------------------------------------------------
	
-----------------------------------------------------------------------------------------------------------------------------
	
	

	on btn_browseSearch pressed do
	(
		global SavedPaths = getSavePath "SavedPaths" initialDir:uev_default_Browse_Directory
		if SavedPaths != undefined then 
		(
			edt_ManualSearch.text = SavedPaths
	
		)
	)-----获取保存地址
	
	
	on Save_OriName pressed do
	(
		selectionSets["RenameBone"] = selection
		if selection.count !=0 then
		(
			for i=1 to selection.count do
			(
				append Tem_ori selection[i].name
			)
			 Rename_bone.Cre_Rename.enabled = true
		)
		else
		(
			messagebox "没有选中物体" beep:false
		)
	)-----生成选择物体集合
	
	on Cre_Rename pressed do
	(
		updateSavedPaths Tem_ori 
		
	)---生成批量改名脚本
)Createdialog Rename_bone























