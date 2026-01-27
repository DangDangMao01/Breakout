(
	saveToPath = @"D:\\"
 	
	grab_viewpBMP = gw.getViewportDib()


	tempBMP = bitmap grab_viewpBMP.width grab_viewpBMP.height
 
	pasteBitmap grab_viewpBMP tempBMP (box2 0 0 grab_viewpBMP.width grab_viewpBMP.height) [0,0] 
 
 
 
	tempBMP.filename = (saveToPath + "MyViewportSnapshot.jpg")
 
	save tempBMP
	close tempBMP
	close grab_viewpBMP
	tempBMP = undefined
	grab_viewpBMP = undefined
	freeSceneBitmaps()
)

