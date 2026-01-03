-------------------------------------------------------
-------------------AnimationTool-----------------------
------------------Time:2018-10-16----------------------
-------------------Author:乔磊-------------------------
------------------QQ:409856476-------------------------
-------------------------------------------------------

global uev_default_Browse_Directory = "C:/"
global SavedPaths


fn updateSavedPaths a =  
(

	Save_Path  = SavedPaths + "\链接关系.ms"
	

	deleteFile Save_Path 
	for i=1 to selection.count do
	(
		setINISetting Save_Path  "链接列表" ("$"+"'"+selection[i].name as string +"'"+ ".parent") ( "$"+"'"+a[i] as string+"'")
	)
)	---生成


-----------------------------------------------------------------------------------------------------------------------------
	
-----------------------------------------------------------------------------------------------------------------------------


rollout Record_Link "记录链接关系 " 
(
	label lab_01 "脚本存放位置:" align:#left
	edittext 'edt_manualSearch' "" 
 
	button 'btn_browseSearch' "Browse" toolTip:"选取生成脚本位置"
	
	button 'Rec_Link' "生成链接脚本"   toolTip:"选择需要记录链接关系的骨骼"
	local Tem_parent = #()
	hyperlink lbl_help "帮助" address:"https://www.cgjoy.com/forum.php?mod=viewthread&tid=215577&page=1&extra=#pid10592912" align:#center offset:[0,10]
	
	

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
	
	
	on Rec_Link pressed do
	(
		if selection.count != 0 then
		(
			for i=1 to selection.count do
			(
				if selection[i].parent !=undefined then
				(
					tem =selection[i].parent.name	
				)
				else
				(
					tem =""
				)
				
				append Tem_parent tem
			)
		)
		else
			(
				messageBox "请选择需要记录的骨骼 "       
			)
		
		updateSavedPaths Tem_parent
		
	)---生成批量改名脚本
)Createdialog  Record_Link























