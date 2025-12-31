/**
 * @author Jason
 * @email jiangran@126.com
 * @name PsDeepCleaner
 * @description Photoshop metadata deep clean script
 * @version 2.0 - 兼容 PS2020+ (v21.0+)
 */

#target photoshop

// 保存原始单位设置
var originalRulerUnits = app.preferences.rulerUnits;
app.preferences.rulerUnits = Units.PIXELS;

var layerSetStr = "";
var mainDocument = null;
var processedCount = 0;

function deleteDocumentAncestorsMetadata() {
    // 兼容性检查
    if (String(app.name).indexOf("Photoshop") < 0) {
        alert("此脚本仅适用于 Adobe Photoshop！");
        return;
    }

    if (!documents.length) {
        alert("没有打开的文档，请先打开一个 PSD 文件。");
        return;
    }

    // 加载 XMP 库（兼容新旧版本）
    try {
        if (ExternalObject.AdobeXMPScript == undefined) {
            ExternalObject.AdobeXMPScript = new ExternalObject("lib:AdobeXMPScript");
        }
    } catch (e) {
        alert("无法加载 AdobeXMPScript 库：" + e);
        return;
    }

    // 清理当前文档的元数据
    try {
        var xmp = new XMPMeta(activeDocument.xmpMetadata.rawData);
        xmp.deleteProperty(XMPConst.NS_PHOTOSHOP, "DocumentAncestors");
        app.activeDocument.xmpMetadata.rawData = xmp.serialize();
    } catch (e) {
        // 某些文档可能没有 XMP 数据，忽略错误
    }

    // 递归处理所有图层
    clearDocumentAncestorsForAllLayers(app.activeDocument);

    // 保存文档
    try {
        if (app.activeDocument !== mainDocument) {
            app.activeDocument.close(SaveOptions.SAVECHANGES);
        } else {
            app.activeDocument.save();
        }
    } catch (e) {
        // 忽略保存错误
    }
}

function clearDocumentAncestorsForAllLayers(doc) {
    if (doc == undefined) {
        return;
    }

    try {
        processLayers(doc.layers);
    } catch (e) {
        alert("图层处理失败：" + e);
    }
}

function processLayers(layers) {
    for (var i = 0; i < layers.length; i++) {
        var curLayer = layers[i];
        
        try {
            // 跳过锁定的图层
            if (curLayer.allLocked) {
                continue;
            }

            // 图层组 - 递归处理
            if (curLayer.typename === "LayerSet") {
                processLayers(curLayer.layers);
                continue;
            }

            // 智能对象处理（兼容 PS2020+）
            if (curLayer.typename === "ArtLayer" && isSmartObject(curLayer)) {
                app.activeDocument.activeLayer = curLayer;
                
                // 使用 Action 打开智能对象（兼容所有版本）
                var idplacedLayerEditContents = stringIDToTypeID("placedLayerEditContents");
                var actionDescriptor = new ActionDescriptor();
                executeAction(idplacedLayerEditContents, actionDescriptor, DialogModes.NO);

                // 检查是否成功打开了新文档
                if (app.activeDocument !== mainDocument && app.activeDocument.activeLayer !== curLayer) {
                    deleteDocumentAncestorsMetadata();
                    layerSetStr += "\n  - " + curLayer.name;
                    processedCount++;
                }
            }
        } catch (e) {
            // 单个图层处理失败，继续处理其他图层
            continue;
        }
    }
}

// 判断是否为智能对象（兼容 PS2020+）
function isSmartObject(layer) {
    try {
        // 方法1：直接检查 kind 属性
        if (layer.kind === LayerKind.SMARTOBJECT) {
            return true;
        }
    } catch (e) {}

    try {
        // 方法2：通过 Action 检查（更可靠）
        var ref = new ActionReference();
        ref.putEnumerated(charIDToTypeID("Lyr "), charIDToTypeID("Ordn"), charIDToTypeID("Trgt"));
        var desc = executeActionGet(ref);
        
        if (desc.hasKey(stringIDToTypeID("smartObject"))) {
            return true;
        }
    } catch (e) {}

    return false;
}

// 获取 PS 版本号
function getPSVersion() {
    var version = app.version;
    var majorVersion = parseInt(version.split(".")[0]);
    return majorVersion;
}

function start() {
    var startTime = new Date().getTime();
    
    mainDocument = app.activeDocument;
    var docName = mainDocument.name;
    
    deleteDocumentAncestorsMetadata();
    
    var endTime = new Date().getTime();
    var duration = ((endTime - startTime) / 1000).toFixed(2);
    
    var message = "清理完成！\n\n";
    message += "文档：" + docName + "\n";
    message += "处理智能对象：" + processedCount + " 个\n";
    message += "耗时：" + duration + " 秒";
    
    if (layerSetStr !== "") {
        message += "\n\n处理的智能对象：" + layerSetStr;
    }
    
    alert(message);
}

// 主入口
try {
    var psVersion = getPSVersion();
    var confirmMsg = "即将清理文档元数据（DocumentAncestors）\n\n";
    confirmMsg += "当前 Photoshop 版本：" + app.version + "\n";
    confirmMsg += "此操作会自动保存文档，建议先备份。\n\n";
    confirmMsg += "是否继续？";
    
    if (confirm(confirmMsg)) {
        start();
    }
} catch (e) {
    alert("脚本执行失败：" + e);
} finally {
    // 恢复原始单位设置
    app.preferences.rulerUnits = originalRulerUnits;
}
