-------------------------------------------------------
-------------------AnimationTool-----------------------
------------------Time:2017-10-11----------------------
-------------------Author:ÇÇÀÚ-------------------------
------------------QQ:409856476-------------------------
-------------------------------------------------------

rollout fr "Get motion" width:162 height:120
(
   
	global lastend=100;
	global laststart=0;
	global num=0
	
	Timer tmr1 "Timer" pos:[0,0] width:24 height:24 interval:100 
 
	spinner startnum "" pos:[8,8] width:56 height:16 range:[-99999,99999,0] type:#integer scale:1 
 
	label lbl1 "To" pos:[68,8] width:15 height:16 
 
	spinner endnum "" pos:[82,8] width:56 height:16 range:[-99999,99999,0] type:#integer scale:1 
 
	editText timenum "Frames=" pos:[18,30] width:105 height:17
	
	edittext Sp1 "V =" pos:[8,54] width:60 height:17
	
    edittext Len1 "L=" pos:[74,54] width:60 height:17
	
	button Cl1 "clean" pos:[50,80] width:44 height:20


	on fr open do
	(

	startnum.value=animationRange.start
	endnum.value=animationRange.end  
	)
	
	
	on tmr1 tick do
	
	(	 
		if laststart!=animationRange.start or lastend!=animationRange.end then 
		(
			startnum.value=animationRange.start
			endnum.value=animationRange.end
			laststart=animationRange.start;
			lastend=animationRange.end;
		)	
		laststart=animationRange.start;
		lastend=animationRange.end;
		num=(animationRange.end-animationRange.start)as float/ticksperframe
		timenum.text=num as string
	
	)
	on Cl1 pressed do
	(
		Sp1.text = ""
		Len1.text = ""
		
	)
	

	on Sp1 changed text do
		(
			
			Len1.text = ((Sp1.text as float) * ( num / 30))as string
		)
		
	on Len1 changed text do
		(
			Sp1.text = ((Len1.text as float)/( num /30))as string
		)	  
	
	
	on startnum changed range do
	    (	
			animationRange = Interval animationRange.end startnum.value
			num=(animationRange.end-animationRange.start)as float/ticksperframe
			timenum.text=num as string
            Len1.text = ((Sp1.text as float) * ( num / 30))as string
		)			
	on endnum changed range do
	    (
			animationRange = Interval animationRange.start endnum.value
			num=(animationRange.end-animationRange.start)as float/ticksperframe
			timenum.text=num as string
            Len1.text = ((Sp1.text as float) * ( num / 30))as string
		)			

	
)	
CreateDialog fr