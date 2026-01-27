/*
Copy Seletion Set
get all the item in current selection set, and build a new script string use to create same selection set
for other max file to keep all the file have same selection set
获得当前选择集的所有物体，并在剪贴板里生成用于创建同样选择集的脚本命令
将命令用于其他max文件可保证所有max文件都含有同样的选择集

how to use
1.open max file with correct selection set
2.select the selection set you need
3.run this script
4.paste(ctrl+v) in blank notepad and save as *.ms file
5.run new *.ms file in other max file, recommand work with batch scripts

使用方法
1.打开包含正确选择集的max文件
2.选择所需的选择集
3.运行本脚本
4.在空白记事本中按粘帖（ctrl+v）并将结果另存为*.ms文件
5.在其他需要复制选择集的max文件中运行创建出的*.ms脚本

Yanbin Bai
baiyanbin@outlook.com
2016.01.15

*/

-- compare two array and return different
fn diffArray a b =(
    retArray = #()
    for element in a do(
        idx = finditem b element --比较如果值不存在返回0
        if idx == 0 then append retArray element 
    )
    return retArray
)


selectSetName = undefined
-- restore current selection
currentSelection = GetCurrentSelection()
-- go through all selection sets and find match up one with current selection
--依次比较选择集，找到与当前选择集相匹配的一个
for i = 1 to getNumNamedSelSets() do (
    select selectionSets[getNamedSelSetName i]
    setMember = GetCurrentSelection()
    if (diffArray setMember currentSelection).count == 0 then (
        if setMember.count == currentSelection.count then(
            selectSetName = getNamedSelSetName i
        )
    )
    Clearselection()
)

-- build string
if selectSetName != undefined then (
    select selectionSets[selectSetName]
    objs = GetCurrentSelection()
    if objs.count>0 then(
        newName = ""
        for item in objs do(
            if ( findString item.name " ") == undefined then (
                newName = newName + "$"+item.name+","
            )
            else(
                newName = newName + "$'"+item.name+"',"
            )
        )
        newName = replace newName newName.count 1 ""--替换数组里最后一位“，”就是去除最后一个逗号
        setclipboardText("selectionSets[\""+selectSetName+"\"] = #("+newName+")")
    )
)
else(
    messageBox "Pick Selection Set First!"
)
selectSetName = undefined
