rollout mytools "我的工具"
	
(
	radiobuttons radb_1"只能选择一个："labels:#("A","B","C"") pos: [30,15]columns:1
		
		on radb_1 changed state do
		(
		
		 change # case radb_1.state of
		(
		
		 1:print "选择了A"
		 2:print "选择了B"
		 3:print "选择了C"   		
		)
		
		
		)
	
	
	)
	CreateDialog mytools 200 100