try(destroydialog unnamedRollout) catch()
rollout unnamedRollout "Cloth转Morpher" width:225 height:169
(
	button 'ToPoly' "ClothToPoly" pos:[131,27] width:77 height:35 align:#left
	button 'btn2' "ToMopher" pos:[134,92] width:72 height:36 align:#left
	spinner 'spl' "数量" pos:[17,18] width:55 height:16 type:#integer scale:1 align:#left
	spinner 'spn3' "间隔帧" pos:[12,50] width:45 height:16 range:[1,10,3] type:#integer scale:1 align:#left
	spinner 'TimeLenth' "动画总长度" pos:[8,106] width:55 height:16 range:[0,200,8] type:#integer scale:1 align:#left
	label '1'"1：输入动画总时间长度"
	label '2'"2:输入间隔帧"
	progressbar doit_prog color:red align:#left height:15 width:120 offset:[35,-90] 
	
	local portArray=#()
	fn timelenth_fn =
	(
		spl.value=TimeLenth.value/spn3.value+1
	)
	----参数设置-------------------------------------------------------------------------------------------
		on TimeLenth changed val do
	(
	try
		(
			spl.value = TimeLenth.value/spn3.value+1 
			--thePainterInterface.maxStr = q1.value
			)
		catch()
	)
	/*如需双向数值变化启用
	on q1 changed val do
	(
		try
			(
				q.value = TimeLenth.value/spn3.value+1 
				--thePainterInterface.maxStr = q.value
				)
				catch()
		)
	*/
		-----参数设置end------------------------------------------------------------------------------------------
	on ToPoly pressed do 
	(
		--timelenth_fn()
		for time in 0 to TimeLenth.value by spn3.value do
		(
			print time
			sliderTime = time
			IniPos = [30,0,0]
			--slidertime = i
			maxOps.CloneNodes selection cloneType:#copy newNodes:&new
			--convertToPoly new
			maxOps.CollapseNode new[1] false --塌陷修改器，不返回提示

			
			i2Ini = (currentTime as float)/ticksPerFrame
			move new[1] [IniPos.x*i2Ini,IniPos.y,0.5]
			
			append portArray new[1]
		)

	)
	-----------------------------------------------------------------------------------------------
	on btn2 pressed do
	(		
			select portArray[1]
	
			modPanel.addModToSelection (Morpher ()) ui:on --添加Morpher
			for j=1 to portArray.count-1 do
			(
				WM3_MC_BuildFromNode portArray[1].morpher j portArray[j+1]
			)

	)
 )
CreateDialog unnamedRollout
