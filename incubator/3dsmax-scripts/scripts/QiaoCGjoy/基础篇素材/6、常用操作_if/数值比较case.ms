rollout if_do "数值比较" 
(
	spinner a_vel "a" type:#float scale:0.05 range:[0,9999999,0] align:#center
	spinner b_vel "b" type:#float scale:0.05 range:[0,9999999,0] align:#center
	
	button 'do_if' "开始比较"  
	
	local a =0.0
	local b =0.0
	
	on a_vel changed range do
	(
		a = a_vel.value
	)
		
	on b_vel changed range do
	(
		b = b_vel.value
	)	
	
	on do_if pressed do
	(
		case of
		(
			(a<b):messagebox "a小于b" beep:false
			(a>b):messagebox "a大于b" beep:false
			(a==b):messagebox "a等于b" beep:false
								
		)
	)	
) createDialog if_do


