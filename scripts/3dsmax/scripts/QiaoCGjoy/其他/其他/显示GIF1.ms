(
	global rol_
	try(destroyDialog rol_)catch()
	rollout rol_ "MaxRollout + Animated GIF"
	(
		local splashscreenGIF = @"D:\1.gif"
		
		dotNetControl dn_flp "flowlayoutpanel" height:241 width:432
		dotNetControl btn_LengthDistance "System.Windows.Forms.button" width:432 height:241
		
		on rol_ open do
		(
			btn_LengthDistance.margin =  dotnetobject "padding" 0
			btn_LengthDistance.FlatAppearance.BorderSize = 1
			btn_LengthDistance.flatstyle = (dotNetclass "FlatStyle").flat
			btn_LengthDistance.image = (dotNetclass "System.Drawing.Image").fromfile splashscreenGIF
			
			dn_flp.Controls.Clear()
			dn_flp.SuspendLayout()
			dn_flp.controls.addrange #(btn_LengthDistance)
			dn_flp.resumelayout()
		)
	)
	createdialog rol_ 	width:460 height:261
)