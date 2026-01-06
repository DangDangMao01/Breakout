// 在 PS 中画一个红色圆形
var doc = app.activeDocument;

// 创建新图层
var layer = doc.artLayers.add();
layer.name = "Kiro画的圆";

// 设置前景色为红色
var color = new SolidColor();
color.rgb.red = 255;
color.rgb.green = 60;
color.rgb.blue = 60;
app.foregroundColor = color;

// 计算圆心和半径
var centerX = doc.width.value / 2;
var centerY = doc.height.value / 2;
var radius = 150;

// 创建椭圆选区
var left = centerX - radius;
var top = centerY - radius;
var right = centerX + radius;
var bottom = centerY + radius;

doc.selection.select([
    [left, top],
    [right, top],
    [right, bottom],
    [left, bottom]
], SelectionType.REPLACE, 0, false);

// 转换为椭圆
var idslct = charIDToTypeID("slct");
var desc = new ActionDescriptor();
var idnull = charIDToTypeID("null");
var ref = new ActionReference();
var idElps = charIDToTypeID("Elps");
ref.putClass(idElps);
desc.putReference(idnull, ref);
var idT = charIDToTypeID("T   ");
var desc2 = new ActionDescriptor();
var idTop = charIDToTypeID("Top ");
var idPxl = charIDToTypeID("#Pxl");
desc2.putUnitDouble(idTop, idPxl, top);
var idLeft = charIDToTypeID("Left");
desc2.putUnitDouble(idLeft, idPxl, left);
var idBtom = charIDToTypeID("Btom");
desc2.putUnitDouble(idBtom, idPxl, bottom);
var idRght = charIDToTypeID("Rght");
desc2.putUnitDouble(idRght, idPxl, right);
desc.putObject(idT, idElps, desc2);
executeAction(idslct, desc, DialogModes.NO);

// 填充颜色
doc.selection.fill(app.foregroundColor);
doc.selection.deselect();

alert("圆形已绘制完成！");
