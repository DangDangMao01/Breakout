	--Ç¶Ì×»ñÈ¡		
	Fn getMaxFiles_fn dir = 
	(
		local dir1 = getDirectories (dir + "*")
		
		for d in dir1 do 
		(
			join dir1 (getDirectories (d + "*"))
				
		)
		--print dir1
		local files = #()

		if dir1.count != 1 then
		(
			for f in dir1 do 
			(		
				join files (getFiles (f + "*.max"))
					print f
			)	
		)
		else
		(
			join files (getFiles (dir + "*.max"))
		)
		return files
	)