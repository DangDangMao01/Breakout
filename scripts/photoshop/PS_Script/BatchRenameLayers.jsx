/*
 * 批量重命名图层脚本
 * 功能：前缀 + 序号 + 后缀
 */

#target photoshop

if (app.documents.length === 0) {
    alert("请先打开一个文档！");
} else {
    var doc = app.activeDocument;
    
    // 创建对话框
    var dialog = new Window("dialog", "批量重命名图层");
    
    // 前缀输入
    dialog.add("statictext", undefined, "前缀：");
    var prefixInput = dialog.add("edittext", undefined, "layer_");
    prefixInput.characters = 20;
    
    // 起始序号
    dialog.add("statictext", undefined, "起始序号：");
    var startNumInput = dialog.add("edittext", undefined, "1");
    startNumInput.characters = 20;
    
    // 序号位数
    dialog.add("statictext", undefined, "序号位数（如3表示001）：");
    var digitsInput = dialog.add("edittext", undefined, "3");
    digitsInput.characters = 20;
    
    // 后缀输入
    dialog.add("statictext", undefined, "后缀：");
    var suffixInput = dialog.add("edittext", undefined, "");
    suffixInput.characters = 20;
    
    // 选项
    var includeGroups = dialog.add("checkbox", undefined, "包含图层组");
    includeGroups.value = false;
    
    var selectedOnly = dialog.add("checkbox", undefined, "仅重命名选中的图层");
    selectedOnly.value = false;
    
    // 按钮
    var btnGroup = dialog.add("group");
    btnGroup.add("button", undefined, "确定", {name: "ok"});
    btnGroup.add("button", undefined, "取消", {name: "cancel"});
    
    if (dialog.show() === 1) {
        var prefix = prefixInput.text;
        var suffix = suffixInput.text;
        var startNum = parseInt(startNumInput.text) || 1;
        var digits = parseInt(digitsInput.text) || 3;
        var withGroups = includeGroups.value;
        var onlySelected = selectedOnly.value;
        
        var count = 0;
        
        if (onlySelected && doc.activeLayer) {
            // 重命名选中的图层
            var selectedLayers = getSelectedLayers();
            for (var i = 0; i < selectedLayers.length; i++) {
                var layer = selectedLayers[i];
                if (withGroups || layer.typename !== "LayerSet") {
                    layer.name = prefix + padNumber(startNum + count, digits) + suffix;
                    count++;
                }
            }
        } else {
            // 重命名所有图层
            count = renameLayers(doc.layers, prefix, suffix, startNum, digits, withGroups, count);
        }
        
        alert("完成！共重命名 " + count + " 个图层。");
    }
}

// 递归重命名图层
function renameLayers(layers, prefix, suffix, startNum, digits, withGroups, count) {
    for (var i = layers.length - 1; i >= 0; i--) {
        var layer = layers[i];
        
        if (layer.typename === "LayerSet") {
            // 图层组
            if (withGroups) {
                layer.name = prefix + padNumber(startNum + count, digits) + suffix;
                count++;
            }
            // 递归处理子图层
            count = renameLayers(layer.layers, prefix, suffix, startNum, digits, withGroups, count);
        } else {
            layer.name = prefix + padNumber(startNum + count, digits) + suffix;
            count++;
        }
    }
    return count;
}

// 数字补零
function padNumber(num, digits) {
    var str = num.toString();
    while (str.length < digits) {
        str = "0" + str;
    }
    return str;
}

// 获取选中的图层
function getSelectedLayers() {
    var selectedLayers = [];
    var ref = new ActionReference();
    ref.putEnumerated(charIDToTypeID("Dcmn"), charIDToTypeID("Ordn"), charIDToTypeID("Trgt"));
    var desc = executeActionGet(ref);
    
    if (desc.hasKey(stringIDToTypeID("targetLayers"))) {
        var targetLayers = desc.getList(stringIDToTypeID("targetLayers"));
        for (var i = 0; i < targetLayers.count; i++) {
            var index = targetLayers.getReference(i).getIndex() + 1;
            var layerRef = new ActionReference();
            layerRef.putIndex(charIDToTypeID("Lyr "), index);
            var layerDesc = executeActionGet(layerRef);
            var layerName = layerDesc.getString(charIDToTypeID("Nm  "));
            
            // 通过名称找到图层
            try {
                selectedLayers.push(findLayerByName(app.activeDocument.layers, layerName));
            } catch (e) {}
        }
    } else {
        selectedLayers.push(app.activeDocument.activeLayer);
    }
    
    return selectedLayers;
}

// 通过名称查找图层
function findLayerByName(layers, name) {
    for (var i = 0; i < layers.length; i++) {
        if (layers[i].name === name) {
            return layers[i];
        }
        if (layers[i].typename === "LayerSet") {
            var found = findLayerByName(layers[i].layers, name);
            if (found) return found;
        }
    }
    return null;
}
