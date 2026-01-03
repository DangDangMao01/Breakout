
rollout a "Wire Colorizer"
(
	
	colorpicker cl01 ""  pos:[40,5] width:35 height:30  color:[0,0,0] 
	button btn01 "Set" pos:[44,40] width:30 height:30 

	colorpicker cl02 ""  pos:[80,5] width:35 height:30  color:[10,10,10] 
	button btn02 "Set" pos:[84,40] width:30 height:30 
	
	colorpicker cl03 ""  pos:[120,5] width:35 height:30  color:[20,20,20] 
	button btn03 "Set" pos:[124,40] width:30 height:30 
	
	colorpicker cl04 ""  pos:[160,5] width:35 height:30  color:[30,30,30] 
	button btn04 "Set" pos:[164,40] width:30 height:30 
	
	colorpicker cl05 ""  pos:[200,5] width:35 height:30  color:[50,50,50] 
	button btn05 "Set" pos:[204,40] width:30 height:30 
	
	colorpicker cl06 ""  pos:[240,5] width:35 height:30  color:[80,80,80] 
	button btn06 "Set" pos:[244,40] width:30 height:30 
	
	colorpicker cl07 ""  pos:[280,5] width:35 height:30  color:[150,150,150] 
	button btn07 "Set" pos:[284,40] width:30 height:30 
	
	colorpicker cl08 ""  pos:[320,5] width:35 height:30  color:[200,200,200] 
	button btn08 "Set" pos:[324,40] width:30 height:30

	colorpicker cl09 ""  pos:[360,5] width:35 height:30  color:[255,255,255]  
	button btn09 "Set" pos:[364,40] width:30 height:30 
	
	
	colorpicker cl10 ""  pos:[5,5] width:25 height:22  color:[0,0,0] 
	
	button btn10 "ID" pos:[9,28] width:21 height:21
	button btn11 "Rnd" pos:[9,50] width:30 height:20 
	
	on btn11 pressed do
	(
		colorA = random 0 254
		colorB = random 0 254
		colorC = random 0 254
		cl01.color =[colorA,colorB,colorC]
		colorA = random 0 254
		colorB = random 0 254
		colorC = random 0 254
		cl02.color =[colorA,colorB,colorC]
		colorA = random 0 254
		colorB = random 0 254
		colorC = random 0 254
		cl03.color =[colorA,colorB,colorC]
		colorA = random 0 254
		colorB = random 0 254
		colorC = random 0 254
		cl04.color =[colorA,colorB,colorC]
		colorA = random 0 254
		colorB = random 0 254
		colorC = random 0 254
		cl05.color =[colorA,colorB,colorC]
		colorA = random 0 254
		colorB = random 0 254
		colorC = random 0 254
		cl06.color =[colorA,colorB,colorC]
		colorA = random 0 254
		colorB = random 0 254
		colorC = random 0 254
		cl07.color =[colorA,colorB,colorC]
		colorA = random 0 254
		colorB = random 0 254
		colorC = random 0 254
		cl08.color =[colorA,colorB,colorC]
		colorA = random 0 254
		colorB = random 0 254
		colorC = random 0 254
		cl09.color =[colorA,colorB,colorC]
	)
		
	on btn10 pressed do
	(
		cl01.color =black
		cl02.color =white
		cl03.color =gray
		cl04.color =red
		cl05.color =green
		cl06.color =blue
		cl07.color =yellow
		cl08.color =orange
		cl09.color =brown
	)
	
	on cl10 changed col do
	(
		cl01.color = black
		theColor = cl10.color
		theColor.value = col.value
		cl02.color = theColor /132
		

		cl03.color = theColor /64
		
		cl04.color = theColor /32
		cl05.color = theColor/16
		cl06.color = theColor/8
		cl07.color = theColor/4
		cl08.color = theColor/2
		cl09.color = theColor
	)
	
	
	on btn01 pressed do ( selection.wirecolor = cl01.color )
	on btn02 pressed do ( selection.wirecolor = cl02.color )
	on btn03 pressed do ( selection.wirecolor = cl03.color )
	on btn04 pressed do ( selection.wirecolor = cl04.color )
	on btn05 pressed do ( selection.wirecolor = cl05.color )
	on btn06 pressed do ( selection.wirecolor = cl06.color )
	on btn07 pressed do ( selection.wirecolor = cl07.color )
	on btn08 pressed do ( selection.wirecolor = cl08.color )
	on btn09 pressed do ( selection.wirecolor = cl09.color )
	
)
createDialog a width:420 height:75 