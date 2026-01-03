rollout juan_1"卷展栏_1" category:1
(
	
	)
	
rollout juan_2"卷展栏_2"	category:2
(
	)
	
rollout juan_3"卷展栏_3"category:3
(
	)	
mianban = newRolloutFloater"多栏面板"200 200

addRollout juan_1 mianban
addRollout juan_2 mianban
addRollout juan_3 mianban
	
/*mianban = newRolloutFloater "多栏面板"200 200：
定义一个面板，为新的浮动面板，newRolloutFloater;
它的显示名字叫：“多栏面板”；
	他的宽高尺寸是 200 200 ； 
	addRollout juan_1 mianban:
	把名字叫“juan_1”的面板，添加到前面定义的mianban中；
在栏目rollout 后面，加上“category：数值”，数值越小，分栏排序越靠前。
	6课时