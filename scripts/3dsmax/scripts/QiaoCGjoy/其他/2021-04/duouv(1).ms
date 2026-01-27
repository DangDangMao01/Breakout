--------------------模型多UV清除-----------------------
-------------------Time:2021/02/23-----------------
---------------------Author:jiaojiao------------------


(

	try(destroydialog UVWclear_mjj)catch()

	local channelID_array=#()
	local bit_array=#{}
	local files=#()
	local sc_mesh=#()
	local headmesh=#()
	local mf=#()

	fn deletechongfu_fn a b =
	(
		for i in a do
		(
			n=finditem b i
			if n!=0 or n!=undefined then
			(
				deleteitem b n
			)
		)
		return b
	)

	fn getchannelID num=
	(
		channelID_array=#()
		bit_array=#{}
		b=#()
		c=#()
		endnum=num-1
		bit_array=#{2..endnum}
		a=bit_array as array
		join b a
		
		join b #(-2,-1,0)
		
		c=sort b
		for i = c.count to 1 by -1 do
		(
			append channelID_array c[i]
		)
		
		return channelID_array
	)

	fn getchannelID1 num=
	(
		channelID_array=#()
		bit_array=#{}
		b=#()
		c=#()
		endnum=num-1
		bit_array=#{2..endnum}
		a=bit_array as array
		join b a
		
		join b #(-2,-1)
		
		c=sort b
		for i = c.count to 1 by -1 do
		(
			append channelID_array c[i]
		)
		
		return channelID_array
	)

	fn clearUV3_fn themesh=
	(
		
		for t in channelID_array do
		(
			numverts=try(polyop.getNumMapverts themesh t)catch()
			if numverts!=undefined then
			(
				addmodifier themesh (UVW_mapping_clear mapid:t) before:3
				maxOps.CollapseNodeTo themesh 2 off
			)
		)
	)

	fn clearUV1_fn themesh=
	(
		
		for t in channelID_array do
		(
			numverts=try(polyop.getNumMapverts themesh t)catch()
			if numverts!=undefined then
			(
				addmodifier themesh (UVW_mapping_clear mapid:t)
				maxOps.CollapseNodeTo themesh 1 off
			)
		)
	)

	fn getMaxFiles_fn dir = 
	(
			
		dir1 = GetDirectories (dir+"/*")
		for d in dir1 do
		(	
			join dir1 (GetDirectories (d+"/*"))
		)
		files = #()
		
		for f in dir1 do
		(
			join files (getFiles (f +"*.max"))
		)

		return files
	)
	
	fn clearsceneuv_fn =
	(
		sc_mesh=#()
		headmesh=#()
		
		sc_mesh=for i in objects where (classof i==Editable_Poly or classof i==Editable_mesh or classof i==PolyMeshObject)collect i
		
		if sc_mesh.count!=0 then
		(
			for i in sc_mesh do
			(
				
				meshname=i.name
				
				s=findstring meshname "head"
				if s!=undefined then
				(
					append headmesh i
					
					
				)
				
			)
			
			for i in headmesh do
			(
				n=finditem sc_mesh i
				
				deleteitem sc_mesh n
			)
			
			
		)	
			
		if headmesh.count!=0 then
		(
			for i in headmesh do
			(
				if i.modifiers.count==0 then
				(
							
					channel_num=polyop.getNumMaps i
					getchannelID1 channel_num
							
					clearUV1_fn i
							
							
				)
				else 
				(
							
					channel_num=polyop.getNumMaps i
					getchannelID1 channel_num
							
					clearUV3_fn i
				)
			)
			if sc_mesh.count!=0 then
			(
				for i in sc_mesh do
				(
					if i.modifiers.count==0 then
					(
						
						channel_num=polyop.getNumMaps i
						getchannelID channel_num
						
						clearUV1_fn i
						
						
					)
					else 
					(
						
						channel_num=polyop.getNumMaps i
						getchannelID channel_num
						
						clearUV3_fn i
					)
				)
			)
			
		)
		else 
		(
			if sc_mesh.count!=0 then
			(
				for i in sc_mesh do
				(
					if i.modifiers.count==0 then
					(
						channel_num=polyop.getNumMaps i
						getchannelID channel_num
						clearUV1_fn i

					)
					else 
					(
						channel_num=polyop.getNumMaps i
						getchannelID channel_num
						
						clearUV3_fn i
					)
				)
			)
		)
	)
	
		
	rollout UVWclear_mjj "模型多UV清除" 
	(
			
		button bn_uvwclear "清除多UV" width:100 height:30 tooltip:"一键清除场景中所有模型多余的UV通道"
		button bn_getfiles "选择文件夹" width:150 height:30 tooltip:"选择批量执行的文件夹目录"
		edittext et_file "" width:130 height:20 align:#left pos:[45,80]
		button bn_maxfile ">>" width:20 height:20 align:#right tooltip:"选择当前max文件目录" pos:[180,80]
		button bn_allfileclearUV "批量执行" width:150 height:30 tooltip:"当前列表选择的max文件执行清理模型多UV" pos:[50,110]
		button bn_allselect "全选" width:70 height:20  pos:[50,150]
		button bn_unselect "反选" width:70 height:20 pos:[130,150]
		label lb_shaixuan "筛选：" align:#left across:2 pos:[35,183]
		edittext et_shaixuan width:150 height:20 pos:[70,180]
		multilistbox mb_maxfile width:200 height:15 align:#center
		on bn_uvwclear pressed do
		(
			clearsceneuv_fn()
		)
		
		on bn_getfiles pressed do
		(
			mfp=getsavepath caption:"选择MAX文件夹目录："
			
			try
			(
				if mfp!="" or mfp!=undefined then
				(
					filename=#()
					mf=#()
					mf=getMaxFiles_fn mfp
					et_file.text=mfp
					
					if mf.count!=0 then
					(
						for i=1 to mf.count do
						(
							a=filenamefrompath mf[i]
							append filename a
						)
						mb_maxfile.items=filename
						
					)
					else
					(
						messagebox "当前文件夹没有MAX文件！    "
					)
				)
			)catch()
			
		)
		
		on bn_maxfile pressed do
		(
			mfp1=maxfilepath
			print mfp1
			
			if mfp1 ==""  then
			(
				messagebox "当前场景未保存    "
			)
			else 
			(
				
				filename=#()
				mf=#()
				mf=getMaxFiles_fn mfp1
				print mf
				et_file.text=mfp1
				
				
				if mf.count!=0 then
				(
					for i=1 to mf.count do
					(
						a=filenamefrompath mf[i]
						append filename a
					)
					mb_maxfile.items=filename
					
				)
			)
		)
		
		on bn_allfileclearUV pressed do
		(
			
			if mf!=#() then
			(
				for i in mb_maxfile.selection do 
				(
					if keyboard.escPressed do (exit)
					loadMaxFile mf[i] useFileUnits:true quiet:true
					
					clearsceneuv_fn()
					
					
					
					savemaxfile mf [i]
				)
			)
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
			loadmaxfile mf[sel] quiet:true
		)
	)
	createdialog UVWclear_mjj
)