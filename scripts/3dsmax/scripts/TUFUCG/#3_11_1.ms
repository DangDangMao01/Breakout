 rollout mytools "????"
 (
	 
	 
	mapbutton mbt_1"????" width:80 height:30 
	 
	 on mbt_1 picked texmap do
	 (
		 environmentmap = texmap
		 
		 mbt_1.text = "M"
		 
		 
		 print texmap.filename as string
		 
		 
		 
		 )
	 
	 
	 )
	 CreateDialog mytools 100 60