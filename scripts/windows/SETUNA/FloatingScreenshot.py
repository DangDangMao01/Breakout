"""
悬浮截图工具 - 4K DPI 感知版本
功能：截图、悬浮显示、缩放、拖动
"""
import sys
from PyQt5.QtWidgets import (QApplication, QMainWindow, QLabel, QMenu, 
                             QAction, QRubberBand)
from PyQt5.QtCore import Qt, QRect, QPoint, QSize
from PyQt5.QtGui import QPixmap, QScreen, QCursor, QPainter, QColor
import ctypes

# 设置 DPI 感知
ctypes.windll.shcore.SetProcessDpiAwareness(2)

class FloatingImage(QMainWindow):
    """悬浮图片窗口"""
    def __init__(self, pixmap):
        super().__init__()
        self.pixmap = pixmap
        self.scale_factor = 1.0
        self.drag_position = None
        
        # 窗口设置
        self.setWindowFlags(Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint | Qt.Tool)
        self.setAttribute(Qt.WA_TranslucentBackground)
        
        # 图片标签
        self.label = QLabel(self)
        self.label.setPixmap(pixmap)
        self.label.setScaledContents(True)
        
        # 调整窗口大小
        self.resize(pixmap.size())
        self.label.resize(pixmap.size())
        
        # 移动到鼠标位置
        cursor_pos = QCursor.pos()
        self.move(cursor_pos.x() - pixmap.width() // 2, 
                 cursor_pos.y() - pixmap.height() // 2)
        
        self.show()
    
    def contextMenuEvent(self, event):
        """右键菜单"""
        menu = QMenu(self)
        
        zoom_in = QAction('放大 (Ctrl+滚轮上)', self)
        zoom_out = QAction('缩小 (Ctrl+滚轮下)', self)
        reset_size = QAction('重置大小', self)
        close_action = QAction('关闭', self)
        
        zoom_in.triggered.connect(lambda: self.zoom(1.2))
        zoom_out.triggered.connect(lambda: self.zoom(0.8))
        reset_size.triggered.connect(self.reset_zoom)
        close_action.triggered.connect(self.close)
        
        menu.addAction(zoom_in)
        menu.addAction(zoom_out)
        menu.addAction(reset_size)
        menu.addSeparator()
        menu.addAction(close_action)
        
        menu.exec_(event.globalPos())
    
    def wheelEvent(self, event):
        """鼠标滚轮缩放"""
        if event.modifiers() == Qt.ControlModifier:
            if event.angleDelta().y() > 0:
                self.zoom(1.1)
            else:
                self.zoom(0.9)
    
    def zoom(self, factor):
        """缩放"""
        self.scale_factor *= factor
        new_size = self.pixmap.size() * self.scale_factor
        self.resize(new_size)
        self.label.resize(new_size)
    
    def reset_zoom(self):
        """重置缩放"""
        self.scale_factor = 1.0
        self.resize(self.pixmap.size())
        self.label.resize(self.pixmap.size())
    
    def mousePressEvent(self, event):
        """鼠标按下 - 开始拖动"""
        if event.button() == Qt.LeftButton:
            self.drag_position = event.globalPos() - self.frameGeometry().topLeft()
    
    def mouseMoveEvent(self, event):
        """鼠标移动 - 拖动窗口"""
        if event.buttons() == Qt.LeftButton and self.drag_position:
            self.move(event.globalPos() - self.drag_position)


class ScreenshotSelector(QMainWindow):
    """截图选择器"""
    def __init__(self):
        super().__init__()
        self.setWindowFlags(Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint)
        self.setWindowState(Qt.WindowFullScreen)
        self.setAttribute(Qt.WA_TranslucentBackground)
        
        # 截取全屏
        screen = QApplication.primaryScreen()
        self.screenshot = screen.grabWindow(0)
        
        # 选择区域
        self.origin = QPoint()
        self.rubber_band = QRubberBand(QRubberBand.Rectangle, self)
        
        self.show()
    
    def paintEvent(self, event):
        """绘制半透明遮罩"""
        painter = QPainter(self)
        painter.drawPixmap(self.rect(), self.screenshot)
        
        # 半透明黑色遮罩
        painter.fillRect(self.rect(), QColor(0, 0, 0, 100))
    
    def mousePressEvent(self, event):
        """开始选择区域"""
        if event.button() == Qt.LeftButton:
            self.origin = event.pos()
            self.rubber_band.setGeometry(QRect(self.origin, QSize()))
            self.rubber_band.show()
    
    def mouseMoveEvent(self, event):
        """更新选择区域"""
        if self.rubber_band.isVisible():
            self.rubber_band.setGeometry(QRect(self.origin, event.pos()).normalized())
    
    def mouseReleaseEvent(self, event):
        """完成选择"""
        if event.button() == Qt.LeftButton:
            self.rubber_band.hide()
            
            # 获取选择区域
            rect = QRect(self.origin, event.pos()).normalized()
            
            if rect.width() > 10 and rect.height() > 10:
                # 截取选中区域
                cropped = self.screenshot.copy(rect)
                
                # 创建悬浮窗口
                FloatingImage(cropped)
            
            self.close()
    
    def keyPressEvent(self, event):
        """ESC 取消"""
        if event.key() == Qt.Key_Escape:
            self.close()


class ScreenshotApp(QApplication):
    """主应用"""
    def __init__(self, argv):
        super().__init__(argv)
        
        # 启动截图选择器
        self.selector = ScreenshotSelector()


if __name__ == '__main__':
    app = ScreenshotApp(sys.argv)
    sys.exit(app.exec_())
