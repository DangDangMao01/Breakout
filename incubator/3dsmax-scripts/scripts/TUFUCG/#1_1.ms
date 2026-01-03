rollout diyigegongju "工具"
(	

)
--//CreateDialog diyigegongju 200 300 style:#(#style_border,#style_titlebar,#style_sysmenu,#style_resizing)
--//style固定写法，表示要进行样式设置。#:井号表示可以多种、多个、多组。只要记住，凡是出现了井号的地方，就可以有好几个东西或事件或数字放在一起，
--//():括号，凡是有事件发生就可以用括号包起来，此处放，说明待会可能有事件发生，
--//#style_border:边框效果
--//#style_titlebar:头部带有标题栏
--//#style_sysmenu:系统菜单关闭。
--//#style_resizing:自由缩放
--//#style_minimizbox:在系统菜单栏加上窗口最小化按钮，窗口就可以最小化。
--//#style_maximizebox:在系统菜单栏加上窗口最大化按钮，窗口就可以最大化。
--//#style_sunkenedge:立体凹陷边框，要单独使用才看的出效果，如果组合了默认样式，这个是看不到效果的。
--//style_toolwindow:windows工具窗体样式，一般指浮动的工具面板， 没有特殊情况，一般可以不用这个样式.

/*CreateDialog diyigegongju 200 300 stlye:#()


CreateDialog diyigegongju 200 300 style:#(#style_toolwindow,#style_sysmenu)

cui.registerDialogBar diyigegongju

--//将名为diyigegongju的窗口，在cui中心进行注册。

cui.dockDialogBar diyigegongju #cui_dock_left

--//将名为diyige gongju,的窗口备案状态是dock停靠。#cui_dock_left:停靠位置为left左边。
--//left左边，right右边，top上边，bottom底部
--//toolwindow,浮动工具面板，配合sysmenu,浮动时候有关闭按钮。
*/

/*CreateDialog diyigegongju 200 300 style:#(#style_toolwindow,#style_sysmenu)

cui.registerDialogBar diyigegongju

cui.dockDialogBar diyigegongju #(#cui_dock_all, #cui_floatable,#cui_handles)

--//组合写法和常用方法：

--//#（#cui_dock_all,#cui_floatable,#cui_handles）:凡是出现#号的地方，就是表示可以放多个，多组，多事件，


--//#cui_dock_all:支持所有上下左右的停靠，不用一个一个的写了，

--//#cui_dock_horz:只支持top和bottom底部停靠。

--//#cui_dock_vert:  只支持左右两边的停靠。

--//#cui_dock_left: 左停靠。

--//cui_dock_top:顶部停靠。

--//#cui_dock_right:右边停靠。

--//#cui_dock_bottom.底部停靠。

--//cui_floatble:可浮动的。

--//cui_handles:停靠时显示抓手手柄。

--//#cui_max_sized:最大尺寸铺满。

--//

--//

--//

--//
*//

CreateDialog diyigegongju 200 300 100 100

--//面板位置。
--//CreateDialog diyiggongju: 创建一个名叫“diyigegongju"的对话面板。 200 300 面板的大小尺寸， 100 100面板所在的位置。（在未写入面板位置坐标时，默认是max界面中间
--// ）