(
	struct tstStruct --定义结构体
	(  
		
		aa = 1, --定义结构体里的变量  
	   fn printHello =  --定义结构体里的函数
		(     
			   print "HELLO WORLD" 
		)
		
	)

	tstStruct.printHello()--调用结构体里的函数
	
	temp = tstStruct()
	temp.aa --调用结构体里的变量

)
