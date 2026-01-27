rollout mytools "????"
(
	
	pickbutton pkb_1 "????" width: 80  height:30
	
	on pkb_1 picked obj do
	(
		messagebox( "????:" - obj.name)
		
		print obj
		)
	)
	CreateDialog mytools 100 60