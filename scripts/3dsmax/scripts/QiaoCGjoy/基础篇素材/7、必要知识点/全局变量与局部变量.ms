
	global a="全局变量"

rollout unnamerollout "全局变量与局部变量" 
(
	
	button 'do_gl' "全局变量" 
	button 'do_lo' "局部变量" 	
	
	--global a="全局变量"
		
	on do_gl pressed do
	(
		
		print a
							
	)
	on do_lo pressed do
	(
		local a ="局部变量" 
		print a
							
	)	
) createDialog unnamerollout


