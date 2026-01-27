-------------------------------------------------------
-------------------AnimationTool-----------------------
------------------Time:2018-11-25----------------------
-------------------Author:乔磊-------------------------
------------------QQ:409856476-------------------------
-------------------------------------------------------

/*
首先你能反编译看到我说的这些那你肯定比我屌 好用的反编译求分享
JiRts_Anim_Tools_Bar v3.0
---------------------------------------
Description:
Very Usefull to Control Your Animation 妈的中文意思就是为了方便！操！就是这么暴躁！
---------------------------------------
Patchwork By :JiRt 中文意思就是这脚本是老子东拼西凑花了点儿小心思整合到一起的，也有自己写的功能！干！
QQ:1588441
Email : JiRt@QQ.com
---------------------------------------
加密
encryptscript "C:\Program Files\Autodesk\3ds Max 2016\scripts\JiRts_Anim_Tools_Bar_v1.0.ms" version:1.0
---------------------------------------
修改时间:2015年10月10日14:35:44
增加了很多功能 不表述
去除了刷新模型
*/
---------------------------------------



/*2017-12-26
JiRts_Anim_Tools_Bar v_Joe.10

2018-1-20
joe_JiRts_Anim_Tools_Bar_v3.1_bate
---------------------------------------
2018-6-11
全新版本
joe_JiRts_Anim_Tools_Bar_v3.2_bate
---------------------------------------
2018-11-25
全新版本
joe_JiRts_Anim_Tools_Bar_v3.6_bate

*/






    if atime != undefined do
    (
        try(
            cui.unRegisterDialogBar atime;destroydialog  atime
            )catch()
    )

    rollout roll_about "About" width:210
    (
            label lab_dw "V_Joe.3.6 by Joe 海贼 -2018/11/25"
            hyperlink lbl_01 "检查更新" address:"https://github.com/4698to/Joetime.linetool.bar" align:#Center
			hyperlink lbl_02 "查看说明" address:"https://www.cgjoy.com/thread-216687-1-1.html" align:#Center
            button btn_units "卸载"		align:#Center

            on btn_units pressed do
            (
            	try(
    		  		filein (getdir #userScripts + "\\joe_scripts\\joe_Unist_JiRts_Anim_Toolbar.ms")
    	   		)catch(print"no find")
            )

    )

    rollout atime "JiRts_Anim_Tools_Bar v_Joe.10" width:1800 height:30
    (
    	button	btn_close				"!"				pos:[0,5]		width:8		height:24   toolTip:"关闭工具栏"
    	button	btn_ReStartMax			"?"			pos:[8,5]		width:24	height:24	toolTip:"重启MAX"
    	button  btn_ReSet				"?"			pos:[32,5]		width:24	height:24	toolTip:"打开自定义目录"
    	button	btn_RunSpt				"R"			    pos:[56,5]		width:24	height:24	toolTip:"Updates"
        --button btn_opendir  "O"                         pos:[80,5]      width:24    height:24   toolTip:"打开自定义目录"
    ----------------------------------------------------------------------------------------------------------------------------
        --预留按键                 --按键上显示的字符   位置             宽            高           鼠标提示    false不启用按键  true 启用
        button btn_customize_1         "..."           pos:[130,5]     width:40    height:20   toolTip:"..."   enabled:false
        button btn_customize_2         "..."            pos:[170,5] width:40    height:20   toolTip:"..."   enabled:false
        button btn_customize_3         "..."           pos:[210,5]    width:40    height:20   toolTip:"..."   enabled:false
        button btn_customize_4         "..."           pos:[250,5]    width:40    height:20   toolTip:"..."   enabled:false
        button btn_customize_5         "..."           pos:[290,5]    width:40    height:20   toolTip:"..."   enabled:false
    ----------------------------------------------------------------------------------------------------------------------------

        button  btn_customize_6                "..."      pos:[360,5]     width:40    height:20   toolTip:"" enabled:false
    	button	btn_customize_7			"..."		pos:[400,5]		width:40	height:20	toolTip:"" enabled:false
    	button	btn_customize_8				"..."		pos:[440,5]		width:40	height:20 enabled:false
    	button 	btn_customize_9				"..."		pos:[480,5]		width:40 	height:20     toolTip:"" enabled:false
    	button  btn_customize_10			"..."		pos:[520,5]			width:40 	height:20 toolTip:"" enabled:false

    	button  btn_customize_11	    "..."		pos:[590,5]			width:40 	height:20 toolTip:"" enabled:false


    	button	btn_customize_12			""			pos:[630,5]		width:40	height:20	toolTip:"" enabled:false
    	button	btn_customize_13		""			pos:[670,5]		width:40	height:20	toolTip:"" enabled:false
    	button	btn_customize_14			""			pos:[710,5]		width:40	height:20	toolTip:"" enabled:false
    	button	btn_customize_15		""			pos:[750,5]		width:40	height:20	toolTip:"" enabled:false
    	button	btn_customize_16			""		pos:[790,5]		width:40	height:20	toolTip:"" enabled:false


    	--checkbox	chb_Lock			""				pos:[930,5]		width:30	height:24	checked:true	toolTip:"锁定对象"
    	--label	lbl1					"锁定"			pos:[902,8]		width:28	height:24

    	

    	button	btn_Boxmode				"[ Box ]"		pos:[860,5]	width:50	height:20	toolTip:"显示为外框"
		checkbutton btn_FzMdl	"[冻结]" pos:[910,5] width:50 height:20 toolTip:"" toolTip:"冻结模型"
		
    	checkbutton	btn_UHCS		"[ Bip ]"		pos:[960,5]	width:50	height:20	toolTip:"隐藏显示BIP"
    	checkbutton	btn_UHBN		"[ Bone ]"		pos:[1010,5]	width:50	height:20	toolTip:"隐藏显示Bone"
		
		button btn_CLE "[ Clean ]" pos:[1060,5]	width:50	height:20 toolTip:"清除空集以及垃圾空点"
		
		button btn_LINK "[链接]" pos:[1110,5] width:50 height:20 toolTip:"选择的物体链接给最后一个物体" 
		
		button btn_mode "[ReXF]" pos:[1160,5] width:50 height:20 toolTip:"模型快速ResetXForm" 
		
		global lastend=100
		global laststart=0


    	--spinner	spn1				"Start:"		pos:[1215,8]	width:50	height:20	range:[-1e+008,1e+008,0]	type:#integer scale:1
    	--spinner	spn2				"End:"			pos:[1298,8]	width:50	height:20	range:[-1e+008,1e+008,100]	type:#integer scale:1


    	button  btn_custom_dir_1 "..." pos:[1210,5]  width:40 	height:20 enabled:false
    	--button  btn_custom_dir_2 "..." pos:[1250,5]  width:40 	height:20 enabled:false
    	--button  btn_custom_dir_3 "..." pos:[1290,5]  width:40 	height:20 enabled:false
    	-------------------------------
    	label l_playSpeed "1x"  width:26 height:20 pos:[1270,5] align:#right --style_sunkenedge:true
    	slider sp_playSpeed "" pos:[1300,-8] range:[1,5,3] orient:#horizontal ticks:1 type:#integer width:80 height:30
		

		
		Timer tmr1 "Timer" pos:[0,0] width:24 height:24 interval:100 
 
		spinner startnum "" pos:[1390,5] width:56 height:16 range:[-99999,99999,0] type:#integer scale:1 
	 
		label lbl1 "To" pos:[1450,5] width:15 height:16 
	 
		spinner endnum "" pos:[1460,5] width:56 height:16 range:[-99999,99999,100] type:#integer scale:1 
		
		

    	-------------------------------
    	global Custom_Script_Dir = (getdir #Scripts +"\\JoeTools\\")
        global time_tool
    ----------------------------------------------------------------------------
		on atime open do
		(
			

			if laststart!=animationRange.start or lastend!=animationRange.end then 
			(
				startnum.value=animationRange.start
				endnum.value=animationRange.end  
				
			)
			else
			(
				startnum.value=laststart
				endnum.value=lastend 
				
			)
		)
		
		on tmr1 tick do
	
		(	 

			if laststart!=animationRange.start or lastend!=animationRange.end then 
			(
				startnum.value=animationRange.start
				endnum.value=animationRange.end
				laststart=animationRange.start;
				lastend=animationRange.end;
				
			)	
			laststart=animationRange.start;
			lastend=animationRange.end;

		)
		
		
		on startnum changed range do
	    (	
			
			if startnum.value < animationRange.end then
			(
				animationRange = Interval animationRange.end startnum.value
			)
			else
			(
				
				endnum.value =startnum.value+1
				
				animationRange = Interval endnum.value startnum.value
			)
			
			
			
		)			
		on endnum changed range do
	    (
			
			if animationRange.start < endnum.value then
			(
				animationRange = Interval animationRange.start endnum.value
			)
			else
			(
				
				startnum.value = endnum.value-1
				
				animationRange = Interval startnum.value endnum.value
			)
			 
		)	
		
		
	
        struct tool_fn
        (
            Custom_Script_list=#(),
            fn reset_btn =
            (
                for i=1 to 16 do
                (
                    execute ("atime.btn_customize_" + (i as string) +".enabled = "+"false" ) --设置按钮停用
                    execute ("atime.btn_customize_" + (i as string) +".text =\"\" ") --设置按钮字符
                    execute ("atime.btn_customize_" + (i as string) +".toolTip =\"\" ")--
                                    --设置按钮提示
                )
            ),
            fn creat_cust_roll a_dir_string =
            (--李骅
                CustomScriptFiles = getFiles (a_dir_string + "*.*")
                --定义面板头尾字符
                Dialog_Start = "try DestroyDialog CustomScript catch()\n rollout CustomScript \"自定义工具集合\" \n(\n  label lbl1 \"\"\n  button OpenCustomDir \"Open\" width:50 height:20 toolTip:\"打开自定义目录\" offset:[0,-14] \n  on OpenCustomDir pressed do (ShellLaunch \"explorer.exe\"  Custom_Script_Dir )\n "
                Dialog_End = " )\n createDialog CustomScript"

                --开始计算生成的面板字符串
                CustomScriptDialog = Dialog_Start
                 --根据取得的文件数量进行循环处理
                for i = 1 to CustomScriptFiles.count do
                (
                    --取得按钮名字字符串
                    CustomButton_text = getfilenamefile CustomScriptFiles[i]  --按钮字符
                    if CustomButton_text.count > 16 do  --限制文件名长度
                    (
                        CustomButton_text = substring CustomButton_text 1 15
                    )
                    CustomButton = "btn_" + (i as string) --按钮
                    --将按钮和执行语句添加进面板字符串
                    CustomScriptDialog += "  button " + CustomButton + " \"" + CustomButton_text + "\"\n"
                    CustomScriptDialog += "  on "+ CustomButton +" pressed do" + " (filein \""+ CustomScriptFiles[i] +"\")\n"
                )
                --面板字符串收尾
                CustomScriptDialog += Dialog_End
                --执行面板字符串
                try execute CustomScriptDialog
                catch
                (
                    ShellLaunch "explorer.exe" Custom_Script_Dir
                    messagebox "文件调用出错,请检查文件是否合乎规范！\n\n脚本文件名不支持除字母数字之外的其它字符！"

                )

                try
                (
                    CustomScriptDialog_Pos = GetDialogPos CustomScript
                    SetDialogPos CustomScript (CustomScriptDialog_Pos  - [200,0])
                )
                catch()
            ),
        ----------------------------------------------------------------------------
            fn get_custom_dir =
            (
                global custom_dir_1 =""
                global custom_dir_2 =""
                global custom_dir_3 =""
                a_dir = GetDirectories (Custom_Script_Dir+"/*")
                if a_dir.count != 0 do
                (
                    for i=1 to a_dir.count do
                    (try (
                        if i > 3 do exit
                        execute  ("custom_dir_" + (i as string) +" = @" +"\"" +(a_dir[i])+"\"")

                        b_string = filterString (a_dir[i]) "\\"
                        execute ("atime.btn_custom_dir_" + (i as string) +".text = \""+ (b_string[(b_string.count)]) +"\"")

                        execute ("atime.btn_custom_dir_" + (i as string) +".enabled = "+"true" )
                        )catch()
                    )
                )
            ),
        ----------------------------------------------------------------------------
        	fn get_custtom_file a_index =
        	(
                /*
                --GetDirectories (Custom_Script_Dir+"/*")
        		global Custom_Script_Files = getFiles (Custom_Script_Dir + "*.*")
        		if Custom_Script_Files.count >= a_index then
        		(

        			--local a_string =  "custom_btn_" + (a_index as string) +" = " + "\""+Custom_Script_Files[a_index]+ "\""
        			local a_string =  Custom_Script_Files[a_index]
        			--execute a_string
        			return a_string
        		)
        		else
                (
                    return undefined
                )
                */
                if (time_tool.Custom_Script_list.count !=0) and (time_tool.Custom_Script_list.count >= a_index) then
                (
                    --local a_string =  "custom_btn_" + (a_index as string) +" = " + "\""+Custom_Script_Files[a_index]+ "\""
                    local a_string =  time_tool.Custom_Script_list[a_index]
                    if a_string != undefined then
                    (
                        return a_string.file_0
                    )
                    else(return undefined)
                    --execute a_string
                )
               else(return undefined)
        	),
        ----------------------------------------------------------------------------
        	fn reset_custom_btn =
        	(
        		time_tool.Custom_Script_list=#()
        		Custom_Script_Files = getFiles (Custom_Script_Dir + "*.*")
        		if Custom_Script_Files.count != 0 do
        		(

        			struct btn_custom (
                        index,
        				file_0
        			    --text_2,
        			    --toolTip_3
        			)

        			for i=1 to Custom_Script_Files.count do
        			(    try
                        (
        				    local tem_string = btn_custom()
                            if i > 16 do exit
                            if (findString (Custom_Script_Files[i]) "_") != undefined do--then
                            (
                				local a_string = filterString (getfilenamefile (Custom_Script_Files[i])) "_"
                				index = a_string[1] as integer
                                if (index != undefined) and (index <= 16) then
                                (
                                    tem_string.index = index
                                )
                                else ( continue )
                                --tem_string.index = a_string[1]

                				tem_string.file_0 = Custom_Script_Files[i]
                				--tem_string.text_2 = a_string[2]
                				--tem_string.toolTip_3 = a_string[3]
                                time_tool.Custom_Script_list[index] = tem_string
                				--append Custom_Script_list tem_string

                                execute ("atime.btn_customize_" + a_string[1] +".enabled = "+"true" ) --设置按钮启用
                                execute ("atime.btn_customize_" + a_string[1] +".text = "+ "\""+(a_string[2]) +"\"")
                                if a_string.count >2 do
                                (
                                        execute ("atime.btn_customize_" + a_string[1] +".toolTip = "+"\""+(a_string[3])+"\"")--
                                    --设置按钮提示
                                )
                            )
                            /*
        				    else
                            (

            					execute ("atime.btn_customize_" + (i as string) +".enabled = "+"true" ) --设置按钮启用
            					execute ("atime.btn_customize_" + (i as string) +".text = "+ "\""+(a_string[2]) +"\"") --设置按钮字符
            					if a_string.count >2 do
            					(
                                        execute ("atime.btn_customize_" + (i as string) +".toolTip = "+"\""+(a_string[3])+"\"")--
                                    --设置按钮提示
            					)
                            )*/
        				)catch()
        			)
        		)
        	)
        )
    ----------------------------------------------------------------------------
    	on atime open do
    	(
    		time_tool.reset_custom_btn()
            time_tool.get_custom_dir()
    	)
        ----------------------------------------------------------

    	---------------------------------
    	on sp_playSpeed changed val do (

            stopAnimation()
    		case of	(
    			(val == 1):	(l_playSpeed.text="1/4x"; timeConfiguration.playbackSpeed = 1; playAnimation immediateReturn:true)
    			(val == 2):	(l_playSpeed.text="1/2x"; timeConfiguration.playbackSpeed = 2; playAnimation immediateReturn:true)
    			(val == 3):	(l_playSpeed.text="  1x"; timeConfiguration.playbackSpeed = 3; playAnimation immediateReturn:true)
    			(val == 4):	(l_playSpeed.text="  2x"; timeConfiguration.playbackSpeed = 4; playAnimation immediateReturn:true)
    			(val == 5):	(l_playSpeed.text="  4x"; timeConfiguration.playbackSpeed = 5; playAnimation immediateReturn:true)
    		)
    	)
    	----------checkbutton
    	on btn_close pressed do	----------close bar
    	 (

            try(cui.UnRegisterDialogBar atime)catch()
            try(destroyDialog atime)catch()
    	 )

    	on btn_ReStartMax pressed do	----------
    	 (
    	 	if checkForSave() then (
    			shellLaunch (getdir #maxroot+"\\3dsmax.exe") (maxfilepath+maxfilename)
    			quitmax #noPrompt
    		)
    	 	else ()
    	 )


    	on btn_RunSpt pressed do	---------- Updates
    	 (
            CreateDialog roll_about
            time_tool.reset_btn()
            time_tool.reset_custom_btn()
    	 )

    	on btn_Boxmode pressed do	----------
    	 (
            --if selection.count == 1 then
            --(
                try
                (
         	        max box mode selected
         	    )catch()
           -- )
        )
         ------------------------------------------
        on btn_FzMdl changed state do
        (
			if state then
			(
				Mod_Arr=for i in objects where(classof i==Editable_Poly or classof i==Editable_mesh or classof i==PolyMeshObject)collect i
				Mod_Arr.showFrozenInGray = off
				freeze Mod_Arr
			)
			else
			(
				Mod_Arr=for i in objects where(classof i==Editable_Poly or classof i==Editable_mesh or classof i==PolyMeshObject)collect i
				unfreeze Mod_Arr
			)	
        )
         ------------------------------------------

    	on btn_UHCS changed state do	----------隐藏CS
    	(
    		if state then
    		(
    			--CS_All=for i in objects where (classof i==Biped_Object or classof i == Dummy) collect i
    			local CS_All=for i in objects where (classof i==Biped_Object ) collect i
    			hide CS_All
    		)
    		else
    		(
    			--CS_All=for i in objects where (classof i==Biped_Object or classof i == Dummy) collect i
    			local CS_All=for i in objects where (classof i==Biped_Object ) collect i
    			unhide CS_All
    		)
    	)


    	on btn_UHBN changed state do	----------隐藏BONE
    	(
    		if state then
    		(
    			Bn_All=for i in objects where (classof i==BoneGeometry ) collect i
    			hide Bn_All
    		)
    		else
    		(
    			Bn_All=for i in objects where (classof i==BoneGeometry ) collect i
    			unhide Bn_All
    		)
    	)
		
		------------------------------------------
		fn deleteCustAttributeInstances ca_class = 
		(
			cas = getclassinstances ca_class
			deleted = [cas.count, 0]
			for ca in cas do
			(
				owner = custattributes.getowner ca
				if isvalidobj owner do
				(
					n = finditem owner.custattributes ca
					if (n > 0) do 
					(
						deleteitem owner.custattributes n
						deleted[2] += 1
					)
				)
			)
			deleted
		)
		fn clean_ca x =
		(
		 z=1
		 c=1  
		 while z !=undefined do
		 (
		  z = custattributes.getdef x c
		  if z != undefined then
		  (
		   format "% %\n" z.name (custattributes.getdefdata z)
		   c=c+1
		  )
		 )
		 while (c!=0) do
		 (
		  z = custattributes.getdef x c
		  if z != undefined then
		  (
		   if  (custattributes.getdefdata z)==undefined then
		   (
			custAttributes.delete x z
		   )
		  )
		  c=c-1
		 )
		)

		on btn_CLE pressed do
		(	
					
			undo on
			
			(
				local TemlayerName =#()
				
				for i =1 to LayerManager.count-1 do
				(
				 ilayer = layerManager.getLayer i
				 layerName = ilayer.name
				append TemlayerName layerName
				)
				for j=1 to TemlayerName.count do 
				(
					LayerManager.deleteLayerByName TemlayerName[j]
				)
				--selectionSets.count
				/*
				for n=selectionSets.count to 1 by -1 do 
				(	
					deleteItem selectionSets selectionSets[n]
				)
				*/
				laji =for i in objects where (classof i==Point and i.pos.z==0 and i.size==0.01  ) collect i
				laji.name="lajidx"
				delete laji
				--删除病毒虚拟体
				delete $'particle view*'
				--删除空点				
				deleteCustAttributeInstances SimpleFaceData 
				clean_ca(rootscene)
				clean_ca(meditmaterials)
				clean_ca(rootscene.Anim_Layer_Control_Manager)
				
			)

		)	
		
		---------------------------------------------
		
		on btn_LINK pressed do
		(
			if (selection.count >=2 )then
			(			
				for i=1 to selection.count-1 do
				(
					$selection[i].parent = $selection[selection.count]
					--selection[i].transform=selection[selection.count].transform
				)		
			)
			else
			(
				messagebox "请依次选择链接物体" beep:false
			)
		
		)
		
		------------------------------------------------
		
		on btn_mode pressed do
		(
			for i=1 to selection.count do
			(
				ResetXForm selection[i]
				maxOps.CollapseNodeTo selection[i] 1 off
		
			)
				
		)---塌陷
		
		
		
		-------------------------------------------
    	on btn_ReSet pressed do	----------重置max
    	(
            if (doesFileExist Custom_Script_Dir) then
            (
                ShellLaunch "explorer.exe" Custom_Script_Dir
            )
            else
            (
                makeDir Custom_Script_Dir
                ShellLaunch "explorer.exe" Custom_Script_Dir
            )
    	 	--max reset file
    	)


    ----------------------------------------------------------------------------------------------------------------

        on btn_customize_1 pressed do
        (
        	local b_string =  time_tool.get_custtom_file 1
        	if b_string != undefined do
        	(
        		--execute b_string
    		   	try
    		   	(
    				--filein custom_btn_1
    				filein b_string
    				--doesFileExist CustomScriptFiles[1]
    		   	)catch(print"no find customize_01 script")
    		)
        )

        on btn_customize_2 pressed do (
        	local b_string =  time_tool.get_custtom_file 2
        	if b_string != undefined do
        	(
    		   	try
    		   	(
    				filein b_string
    		   	)catch(print"no find customize_01 script")
    		)
        )

        on btn_customize_3 pressed do (
        	local b_string =  time_tool.get_custtom_file 3
        	if b_string != undefined do
        	(
    		   	try
    		   	(
    				filein b_string
    		   	)catch(print"no find customize_01 script")
    		)
        )

        on btn_customize_4 pressed do (
        	local b_string =  time_tool.get_custtom_file 4
        	if b_string != undefined do
        	(
    		   	try
    		   	(
    				filein b_string
    		   	)catch(print"no find customize_01 script")
    		)
        )
        on btn_customize_5 pressed do (
        	local b_string =  time_tool.get_custtom_file 5
        	if b_string != undefined do
        	(
    		   	try
    		   	(
    				filein b_string
    		   	)catch(print"no find customize_01 script")
    		)
        )
        on btn_customize_6 pressed do (
        	local b_string =  time_tool.get_custtom_file 6
        	if b_string != undefined do
        	(
    		   	try
    		   	(
    				filein b_string
    		   	)catch(print"no find customize_01 script")
    		)
        )
        on btn_customize_7 pressed do (
        	local b_string =  time_tool.get_custtom_file 7
        	if b_string != undefined do
        	(
    		   	try
    		   	(
    				filein b_string
    		   	)catch(print"no find customize_01 script")
    		)
        )
        on btn_customize_8 pressed do (
        	local b_string =  time_tool.get_custtom_file 8
        	if b_string != undefined do
        	(
    		   	try
    		   	(
    				filein b_string
    		   	)catch(print"no find customize_01 script")
    		)
        )
        on btn_customize_9 pressed do (
        	local b_string =  time_tool.get_custtom_file 9
        	if b_string != undefined do
        	(
    		   	try
    		   	(
    				filein b_string
    		   	)catch(print"no find customize_01 script")
    		)
        )
        on btn_customize_10 pressed do (
        	local b_string =  time_tool.get_custtom_file 10
        	if b_string != undefined do
        	(
    		   	try
    		   	(
    				filein b_string
    		   	)catch(print"no find customize_01 script")
    		)
        )
        on btn_customize_11 pressed do (
        	local b_string =  time_tool.get_custtom_file 11
        	if b_string != undefined do
        	(
    		   	try
    		   	(
    				filein b_string
    		   	)catch(print"no find customize_01 script")
    		)
        )
        on btn_customize_12 pressed do (
        	local b_string =  time_tool.get_custtom_file 12
        	if b_string != undefined do
        	(
    		   	try
    		   	(
    				filein b_string
    		   	)catch(print"no find customize_01 script")
    		)
        )
        on btn_customize_13 pressed do (
        	local b_string =  time_tool.get_custtom_file 13
        	if b_string != undefined do
        	(
    		   	try
    		   	(
    				filein b_string
    		   	)catch(print"no find customize_01 script")
    		)
        )
        on btn_customize_14 pressed do
        (
        	local b_string =  time_tool.get_custtom_file 14
        	if b_string != undefined do
        	(
    		   	try
    		   	(
    				filein b_string
    		   	)catch(print"no find customize_01 script")
    		)
        )
        on btn_customize_15 pressed do
        (
        	local b_string =  time_tool.get_custtom_file 15
        	if b_string != undefined do
        	(
    		   	try
    		   	(
    				filein b_string
    		   	)catch(print"no find customize_01 script")
    		)
        )
        on btn_customize_16 pressed do
        (
        	local b_string =  time_tool.get_custtom_file 16
        	if b_string != undefined do
        	(
    		   	try
    		   	(
    				filein b_string
    		   	)catch(print"no find customize_01 script")
    		)
        )
        on btn_custom_dir_1 pressed do
        (
        	if custom_dir_1 !="" do
            (
                time_tool.creat_cust_roll custom_dir_1
            )
        )
        on btn_custom_dir_2 pressed do
        (
        	if custom_dir_2 !="" do
            (
                time_tool.creat_cust_roll custom_dir_1
            )
        )
        on btn_custom_dir_3 pressed do
        (
        	if custom_dir_3 !="" do
            (
                time_tool.creat_cust_roll custom_dir_1
            )
        )
    )

time_tool = atime.tool_fn()
createdialog atime style:#(#style_titlebar, #style_border, #style_sysmenu, #style_minimizebox)
cui.RegisterDialogBar atime style:#(#cui_dock_bottom, #cui_floatable, #style_toolwindow)
cui.DockDialogBar atime #cui_dock_bottom
--cui.getExpertMode()
--updateToolbarButtons()
