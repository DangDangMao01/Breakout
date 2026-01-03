/*messageBox "这里是弹出内容" title:"这是头部标题" beep : true

/*messageBox:
messageBox的语法：
messageBox + "消息内容"+标题 + beep : true/false

固定写法，表示消息弹窗，“”里面是内容，是展示出来的具体文字内容，带引号表示这是字符串，如果不用引号，就会变成变量，
或者函数，方法等。
title: "这是头部标题，"title是固定写法，表示指定标题，后面冒号跟上引号内容，就是标题要显示的内容；
beep : true: 这是系统提示声音，消息弹窗弹出时，会“叮”一声，如果不想要生硬，可以将true，改为false,或者beep:true，整句不写。

print  除了了messageBox消息弹窗以外，还经常用到print打印输出进行测试。 print打印输出，是指将一些信息内容，打印输出到F11的帧听器中，
声明：print在后加上引号，引号里面的就是输出的内容。
注意事项：
引号内的内容，不管是英文还是中午，都可以被正确的打印输出，
2若直接输入cgtools或其他的时候，打印输出的结果却是undefined。  OK和undefined是max脚本语言里面数据类型中的特殊类型，undefined的意思是指未定义，

*/
print ok
print zhongguo
print (3+5)
print (5*9)