	--µİ¹éµ÷ÓÃ		
	fn test num =
	(
		if num == 1 then
		(
			return 1
		)
		else
		(
			return num * test (num-1)	
		)
	
	)
	
