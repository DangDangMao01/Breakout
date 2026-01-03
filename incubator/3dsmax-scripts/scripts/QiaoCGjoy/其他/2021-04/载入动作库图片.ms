global  fPath = GetFilenamePath (GetSourceFileName())
	  global db="driver={Microsoft Access Driver (*.mdb, *.accdb)}; DBQ="+fPath+"anim.mdb"
rollout testddl_rollout "动作库"
(global bipObja
	local filename
local  none = #()
	
	
	
	
	
	
	
	
	
		fn sqlout lei =( 

		DogConn2 = createOLEObject "ADODB.Connection"
DogConn2.Open db
recordSet1 = createOLEObject "ADODB.Recordset"
	
	  recordSet1.Open ("SELECT * from "+lei+"") DogConn2
      b = recordSet1.GetRows()
	c=b.dataArray
	  MyArray = #()--creates an empty array
for i=1 to c.count do(
	d=c[i]


if d[2]!=null do(

 append MyArray (d[2]))
	
	
)return MyArray
	  
recordSet1.close())
	
	
fn sqlout1 lei lei1 =( 

	DogConn2 = createOLEObject "ADODB.Connection"
DogConn2.Open db
recordSet1 = createOLEObject "ADODB.Recordset"
	
	  recordSet1.Open ("SELECT "+lei1+" from "+lei+"" ) DogConn2
      b = recordSet1.GetRows()
	c=b.dataArray
	  MyArray = #()--creates an empty array
for i=1 to c.count do(
	d=c[i]



if d[1]!=null do(
 append MyArray (d[1]))
	
	
)return MyArray
	  
recordSet1.close())	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	fn jhm axx =(
		rollout rendrollout1 "The skin tool panel" width:500 height:500
(	               edittext jhm "注册码:"  labelOnTop:true
					edittext jhtxt "激活码:"  labelOnTop:true
	  button gb "关闭"  pos:[250,350]
 HyperLink lbl9 "试用期结束，请激活！获取激活码请点击" pos:[250,90] width:300  color:(color 255 127.5 0) address:"https://pylblog.com/post/maxdzk.html"
	button jhbtn "激活" pos:[108,90] width:50 height:30
	on rendrollout1 open do (
              a= random 111111 999999
  format "----------------------------%\n"  a
				jhm.text=a	as string
)


on gb pressed do (
	DestroyDialog testddl_rollout
	DestroyDialog rendrollout1
)

  on jhbtn pressed do (
numtxt1=jhtxt.text 
	  numtxt2=jhm.text 
	  intjh=numtxt2 as integer
	    intjh2=numtxt1 as integer
yz=intjh*2+1000*3-666*2-689+565

if   intjh2==yz then(
 
	    createFile "C:\\ProgramData\Autodesk\autodesklog.fix"


	
	format "激活成功！----------------------------"  yz
	
	DestroyDialog rendrollout1
	
	
	
	
)else( MessageBox "激活码错误" title:"提示")


)



)

	createdialog rendrollout1  bgcolor:(color 50 50 50)  fgcolor:(color 50 255 255)  style:#( #style_minimizebox)
					
 )
	
	
	
	
	
	
	fn format_txt filepath filetext =
(
    if doesFileExist filepath == true 
        then
    (
        fin = openfile filepath mode:"wb"
       ---- seek fin #eof
        txt = filetext
        format txt to:fin
        close fin
    )
    else
    (
        newfile = createFile filepath
        close newfile
      format_txt filepath filetext
        )
    )
	





  --button btn_select1 "Select 1" align:#left--these buttons will set the list
 -- button btn_select2 "Select 2"align:#left --by calling the custom function that
 -- button btn_select3 "Select 3" align:#left--replaces the on selected() handler
dropdownlist leiList1 "分类1:" items:none width:130 pos:[260, 10]
dropdownlist leiList2 "分类2:" items:none width:130 pos:[260, 50] --this is the dropdownlist
dropdownlist leiList3 "分类3:" items:none width:130 pos:[260, 90]  --this is the dropdownlist
dropdownlist leiList4 "動作:" items:none width:130 pos:[260, 130]    --this is the dropdownlist

	checkbox filestruc "匹配bip文件骨骼" across:1 offset:[260,2]
	checkbutton newbip "预览" checked:false tooltip:"Opens setup panels" pos:[260,200]
	 button jiazai "加载"  pos:[320,200]     
	
	 HyperLink lbl9 "官网" pos:[350,5] width:80  color:(color 255 127.5 0) address:"https://pylblog.com/post/maxdzk.html"
  --this is the custom function that performs the operations normally done --inside the on selected() event handler:
  

 button jih "激活"  pos:[290,230] 
  on jih pressed do ( jhm "1"
  )
  
dotNetControl wb "System.Windows.forms.WebBrowser" height:250 width:250 align:#left pos:[0, 0]

-------------------
	on testddl_rollout open do( 
		
		leiList1.items =sqlout "fenlei"

if doesFileExist ("C:\\ProgramData\Autodesk\autodesklog.fix")==false then
(
    
	local nowtim=getUniversalTime()
	
	local nowday = nowtim[4] as integer
		local q= nowday+1000 
		local qian =q as string
		
		if doesFileExist ("C:\\ProgramData\Autodesk\AutodeskPlugins") == true then
(
MyPath = openfile  "C:\\ProgramData\Autodesk\AutodeskPlugins" mode:"r+"
	txt2=readChars MyPath 4
	-------------1000
	local textall1  = txt2 as integer -1000
	skipToString MyPath "~"
	txt1=readLine MyPath
	-----------01
local textall  = txt1  as integer -2000
	close MyPath 
	
	
	if nowday != textall1 and textall > 1 then(
		local xierutim=textall-1 +2000
			
			ss=qian + "~" +xierutim as string
	format_txt "C:\\ProgramData\Autodesk\AutodeskPlugins" ss
			)
			
else (if textall <= 1 then(
 jhm "1"
		)
			
			
			
	
))else (
			ss=qian + "~2005"
	format_txt "C:\\ProgramData\Autodesk\AutodeskPlugins" ss
			
		))
	  

		
		
		
------------------------------------------------------------------------------------		
		
		
		
		
		path=GetFilenamePath (GetSourceFileName())+"img/250.jpg"
wb.url = dotNetObject "System.Uri" path
	
	)
  
  on leiList1 selected i do (
	  
	
	  
		local selectlist1=leiList1.selected

	   leiList2.items = sqlout1 "fenlei1" selectlist1	
		  format "----------------------------%\n" selectlist1
	  
	  
	)---------------------------------------------------------------------
	  
	
	
		on leiList2 selected i do (
	
 local selectlist2=leiList2.selected
 leiList3.items = sqlout1 "fenlei2" selectlist2
		
 
	)
	
  
  
  
  
  
  
  
  
  
  
  on leiList3 selected i do (
	 --case leiList.selection of
	-- (
	--	 1: aniList.items= manani
		--  2: aniList.items= huani
	--	3: aniList.items= dogani
		--  4: aniList.items= maani
		-- default:  messagebox "错误" 
		-- )
	 
	 -- )
	  DogConn3 = createOLEObject "ADODB.Connection"
DogConn3.Open db
recordSet3 = createOLEObject "ADODB.Recordset"
	global selectlist1=leiList1.selected
	  global selectlist2=leiList2.selected
	  global selectlist3=leiList3.selected
	  recordSet3.Open ("SELECT mingzi,dizhi from wenjian where fenlei1='"+selectlist1+"' and fenlei2='"+selectlist2+"' and fenlei3='"+selectlist3+"'") DogConn3
b = recordSet3.GetRows()
	  
	  c=b.dataArray
	  MyArray = #()--creates an empty array
for i=1 to c.count do(
	d=c[i]



 append MyArray (d[1])
	
)
	  leiList4.items =MyArray
	  --format "You selected %\n" b.dataArray[1]--and do something inside

	 aniurl = c[1][2]
	  format "----------------------------%\n" aniurl

  )

---创建bip

on newbip changed state do(
	if state == on then (
 global bipObja = biped.createNew 20 20 [0,0,20]
select bipObja
 bip2 = bipObja.controller
 
-- Display properties
--biped.displayPrefsDlg bip2)


	)
-----删除bip

else (delete  bipObja))

---创建bip结束

--预览动画
on leiList4 selected i do (
	
	---加载地址
	selectlistnam=leiList4.selected
	
	
mov=fPath+"img/"+selectlist2+"_"+selectlistnam+".gif"
	 format "----------------------------%\n"mov

wb.url = dotNetObject "System.Uri" mov
	
	


	
	
	
	
	
	
	
	
	
	
	
	DogConn1 = createOLEObject "ADODB.Connection"
DogConn1.Open db
recordSet2 = createOLEObject "ADODB.Recordset"
	
	  recordSet2.Open ("SELECT dizhi from wenjian where fenlei1='"+selectlist1+"' and fenlei2='"+selectlist2+"' and fenlei3='"+selectlist3+"' and mingzi='"+selectlistnam+"'") DogConn1
k= recordSet2.GetRows()
	  l=k.dataArray
	recordSet2.close()
	global m=l[1][1]
global bipurl=fPath+m
	format "You selected %\n"bipurl
	---加载地址结束
	
	if newbip.checked==true  then(
	select bipObja
	bip3 = bipObja.controller
	biped.LoadBipFile bip3 (bipurl) #matchFileStruct  
	)

	
	)
	--结束预览


fn ddl_someList_Selected itm =--we pass the argument passed to the handler
  (
    format "You selected %\n" itm--and do something inside
  )

--messagebox
  
 
  --on btn_select2 pressed do leiList_Selected (aniList.selection = 2)

	  
	  on jiazai pressed do ( 
		 
if classof $==Biped_Object do
(		  
bip1 = $.controller   
max motion mode   
--File I/O 
	if filestruc.triState==1 then(
	
biped.LoadBipFile bip1 (bipurl) #matchFileStruct  )

else if filestruc.triState==0 then (
biped.LoadBipFile bip1 (bipurl))
	
	)
)
	  
	  
	  )
	  

	  
createDialog testddl_rollout 400 250