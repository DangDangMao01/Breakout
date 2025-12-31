import * as vscode from 'vscode';
import * as path from 'path';
import * as fs from 'fs';

// ============ 全局变量 ============
let centralPath: string = '';
let idleTimer: NodeJS.Timeout | undefined;
let lastActivityTime: number = Date.now();
let idleTimeoutMs: number = 10 * 60 * 1000;
let errorReportEnabled: boolean = true;
let autoSyncEnabled: boolean = false;
let backlogMode: string = 'auto';
let autoAnalyze: string = 'manual';
let currentLanguage: string = 'zh';
let reminderDays: number[] = [7, 30];
let sessionEditCount: number = 0;
let sessionStartTime: number = Date.now();
let statusBarItem: vscode.StatusBarItem;

const PLUGIN_VERSION = '2.2.0';
const ERROR_REPORT_REPO = 'https://github.com/DangDangMao01/Kiro_work';
const MIN_EDITS_FOR_REMINDER = 20;
const MIN_SESSION_MINUTES = 5;
const DELETED_RETENTION_DAYS = 60;

// ============ 多语言支持 ============
const i18n: Record<string, Record<string, string>> = {
    zh: {
        // 通用
        setup: '立即设置',
        cancel: '取消',
        confirm: '确定',
        later: '稍后',
        ignore: '忽略',
        delete: '删除',
        view: '查看',
        save: '保存',
        submit: '提交',
        resolve: '解决',
        keep: '保留',
        
        // 知识库相关
        kbNotConfigured: 'Kiro 知识库：未检测到中央知识库路径，请先设置',
        kbPathNotExist: 'Kiro 知识库：中央知识库路径不存在，可能路径已变更',
        kbValidationFailed: 'Kiro 知识库：路径验证失败',
        kbSetupComplete: 'Kiro 知识库设置完成',
        kbResetPath: '重新设置',
        kbViewDetails: '查看详情',
        
        // 同步相关
        syncDetected: '📚 检测到 {0} 个新的知识库文件，是否同步到中央知识库？',
        syncNow: '立即同步',
        syncAuto: '📚 自动同步：正在同步 {0} 个新文件到中央知识库...',
        syncComplete: '✅ 已同步 {0} 个文件',
        syncSkipped: '所有 {0} 个文件已存在，无需同步',
        syncNoFiles: '没有找到需要同步的文件',
        
        // 待办相关
        backlogDetected: '📋 检测到 {0} 个待处理问题',
        backlogLocal: '本地',
        backlogCentral: '中央',
        backlogResolveNow: '现在解决',
        backlogSubmitCentral: '提交到中央',
        backlogKiroAnalyze: '让 Kiro 分析',
        backlogBatchAnalyze: 'Kiro 批量分析',
        backlogViewList: '查看列表',
        backlogSaved: '✅ 问题已暂存',
        backlogSubmitted: '✅ 已提交 {0} 个问题到中央知识库',
        backlogOverdue: '⚠️ 有 {0} 个问题超过 {1} 天未处理',
        backlogPriorityHigh: '高',
        backlogPriorityNormal: '普通',
        backlogPriorityLow: '低',
        
        // 问题输入
        questionPrompt: '请输入问题描述',
        questionPlaceholder: '例如：如何实现 XXX 功能？',
        questionPriority: '选择优先级',
        questionCategory: '选择问题类型',
        categoryBug: 'Bug',
        categoryFeature: '功能想法',
        categoryIdea: '灵感',
        categoryQuestion: '疑问',
        
        // 智能整理
        organizeDetected: '📋 中央知识库检查: {0}',
        organizeSmartOrganize: '智能整理',
        organizeViewRelated: '查看关联',
        organizeViewDetails: '查看详情',
        organizeAllGood: '✅ 中央知识库状态良好，所有文件已分类',
        organizeNoYaml: '{0} 个文件缺少 YAML 元数据',
        organizeUncategorized: '{0} 个文件未分类',
        organizeRelated: '{0} 组相关文件可合并',
        
        // 空闲提醒
        idleReminder: '💡 本次会话已工作 {0} 分钟，编辑 {1} 次 - 有价值的内容记得保存！',
        idleEvaluate: '评估并保存',
        idleLater: '稍后提醒',
        idleDisable: '本次不再提醒',
        
        // 错误报告
        errorOccurred: 'Kiro KB 错误 ({0}): {1}',
        errorSubmit: '提交错误报告',
        errorSkip: '不提交',
        errorClose: '关闭',
        errorSaved: '错误报告已保存: {0}',
        errorToggled: '错误报告功能已{0}',
        errorEnabled: '启用',
        errorDisabled: '禁用',
        
        // 状态栏
        statusBacklog: '📋 待办: {0} (本地) | {1} (中央)',
        
        // 语言切换
        languageSwitched: '界面语言已切换为: {0}',
        languageChinese: '中文',
        languageEnglish: 'English',
        
        // v2.2.0 智能化
        smartCategoryDetected: '🤖 智能检测：这看起来像是 {0}',
        smartPriorityDetected: '🤖 智能检测：优先级建议为 {0}',
        smartRelatedFound: '📚 知识库中找到相关内容：{0}',
        smartRelatedView: '查看相关',
        smartRelatedIgnore: '继续暂存',
        smartUseDetected: '使用检测结果',
        smartManualSelect: '手动选择',
    },
    en: {
        // General
        setup: 'Setup Now',
        cancel: 'Cancel',
        confirm: 'OK',
        later: 'Later',
        ignore: 'Ignore',
        delete: 'Delete',
        view: 'View',
        save: 'Save',
        submit: 'Submit',
        resolve: 'Resolve',
        keep: 'Keep',
        
        // Knowledge Base
        kbNotConfigured: 'Kiro KB: Central path not configured, please setup first',
        kbPathNotExist: 'Kiro KB: Central path does not exist, may have been changed',
        kbValidationFailed: 'Kiro KB: Path validation failed',
        kbSetupComplete: 'Kiro KB setup complete',
        kbResetPath: 'Reset Path',
        kbViewDetails: 'View Details',
        
        // Sync
        syncDetected: '📚 Detected {0} new files, sync to central?',
        syncNow: 'Sync Now',
        syncAuto: '📚 Auto-sync: Syncing {0} new files...',
        syncComplete: '✅ Synced {0} files',
        syncSkipped: 'All {0} files already exist, no sync needed',
        syncNoFiles: 'No files to sync',
        
        // Backlog
        backlogDetected: '📋 {0} pending questions detected',
        backlogLocal: 'Local',
        backlogCentral: 'Central',
        backlogResolveNow: 'Resolve Now',
        backlogSubmitCentral: 'Submit to Central',
        backlogKiroAnalyze: 'Let Kiro Analyze',
        backlogBatchAnalyze: 'Kiro Batch Analyze',
        backlogViewList: 'View List',
        backlogSaved: '✅ Question saved',
        backlogSubmitted: '✅ Submitted {0} questions to central',
        backlogOverdue: '⚠️ {0} questions overdue for {1} days',
        backlogPriorityHigh: 'High',
        backlogPriorityNormal: 'Normal',
        backlogPriorityLow: 'Low',
        
        // Question Input
        questionPrompt: 'Enter question description',
        questionPlaceholder: 'e.g., How to implement XXX?',
        questionPriority: 'Select priority',
        questionCategory: 'Select category',
        categoryBug: 'Bug',
        categoryFeature: 'Feature',
        categoryIdea: 'Idea',
        categoryQuestion: 'Question',
        
        // Smart Organize
        organizeDetected: '📋 Central KB check: {0}',
        organizeSmartOrganize: 'Smart Organize',
        organizeViewRelated: 'View Related',
        organizeViewDetails: 'View Details',
        organizeAllGood: '✅ Central KB is well organized',
        organizeNoYaml: '{0} files missing YAML metadata',
        organizeUncategorized: '{0} files uncategorized',
        organizeRelated: '{0} related file pairs found',
        
        // Idle Reminder
        idleReminder: '💡 Session: {0} min, {1} edits - Remember to save valuable content!',
        idleEvaluate: 'Evaluate & Save',
        idleLater: 'Remind Later',
        idleDisable: 'Disable for Session',
        
        // Error Report
        errorOccurred: 'Kiro KB Error ({0}): {1}',
        errorSubmit: 'Submit Report',
        errorSkip: 'Skip',
        errorClose: 'Close',
        errorSaved: 'Error report saved: {0}',
        errorToggled: 'Error reporting {0}',
        errorEnabled: 'enabled',
        errorDisabled: 'disabled',
        
        // Status Bar
        statusBacklog: '📋 Backlog: {0} (local) | {1} (central)',
        
        // Language Switch
        languageSwitched: 'Language switched to: {0}',
        languageChinese: 'Chinese',
        languageEnglish: 'English',
        
        // v2.2.0 Smart Features
        smartCategoryDetected: '🤖 Smart detect: This looks like {0}',
        smartPriorityDetected: '🤖 Smart detect: Suggested priority is {0}',
        smartRelatedFound: '📚 Related content found in KB: {0}',
        smartRelatedView: 'View Related',
        smartRelatedIgnore: 'Continue Save',
        smartUseDetected: 'Use Detected',
        smartManualSelect: 'Manual Select',
    }
};

function t(key: string, ...args: any[]): string {
    let text = i18n[currentLanguage]?.[key] || i18n['zh'][key] || key;
    args.forEach((arg, i) => {
        text = text.replace(`{${i}}`, String(arg));
    });
    return text;
}

// ============ 激活入口 ============
export function activate(context: vscode.ExtensionContext) {
    console.log('Kiro Knowledge Base extension is now active!');

    // Load configuration
    loadConfiguration();

    // Create status bar item for backlog
    statusBarItem = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left, 100);
    statusBarItem.command = 'kiro-kb.viewBacklog';
    context.subscriptions.push(statusBarItem);

    // Create status bar item for quick save (💡)
    const quickSaveItem = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left, 99);
    quickSaveItem.text = '💡';
    quickSaveItem.tooltip = currentLanguage === 'zh' 
        ? '记录想法 (Ctrl+Alt+Q)' 
        : 'Save Idea (Ctrl+Alt+Q)';
    quickSaveItem.command = 'kiro-kb.saveQuestion';
    quickSaveItem.show();
    context.subscriptions.push(quickSaveItem);

    // Register commands
    context.subscriptions.push(
        vscode.commands.registerCommand('kiro-kb.setup', wrapWithErrorHandler(setupKnowledgeBase, 'setup')),
        vscode.commands.registerCommand('kiro-kb.sync', wrapWithErrorHandler(syncToCentral, 'sync')),
        vscode.commands.registerCommand('kiro-kb.generateIndex', wrapWithErrorHandler(generateIndex, 'generateIndex')),
        vscode.commands.registerCommand('kiro-kb.openKnowledgeBase', wrapWithErrorHandler(openKnowledgeBase, 'openKnowledgeBase')),
        vscode.commands.registerCommand('kiro-kb.saveReminder', showSaveReminder),
        vscode.commands.registerCommand('kiro-kb.toggleErrorReport', toggleErrorReport),
        // v2.1.0 新增命令
        vscode.commands.registerCommand('kiro-kb.saveQuestion', wrapWithErrorHandler(saveQuestion, 'saveQuestion')),
        vscode.commands.registerCommand('kiro-kb.viewBacklog', wrapWithErrorHandler(viewBacklog, 'viewBacklog')),
        vscode.commands.registerCommand('kiro-kb.submitBacklog', wrapWithErrorHandler(submitBacklog, 'submitBacklog')),
        vscode.commands.registerCommand('kiro-kb.analyzeBacklog', wrapWithErrorHandler(analyzeBacklog, 'analyzeBacklog')),
        vscode.commands.registerCommand('kiro-kb.switchLanguage', switchLanguage)
    );

    // Start idle detection
    startIdleDetection(context);

    // Auto-detect and sync on startup
    autoDetectAndSync();

    // Check daily reminders
    checkDailyReminders();

    // Update status bar
    updateStatusBar();
}

function loadConfiguration() {
    const config = vscode.workspace.getConfiguration('kiro-kb');
    centralPath = config.get('centralPath') || '';
    errorReportEnabled = config.get<boolean>('errorReportEnabled') ?? true;
    autoSyncEnabled = config.get<boolean>('autoSync') ?? false;
    backlogMode = config.get<string>('backlogMode') || 'auto';
    autoAnalyze = config.get<string>('autoAnalyze') || 'manual';
    currentLanguage = config.get<string>('language') || 'zh';
    reminderDays = config.get<number[]>('reminderDays') || [7, 30];
    
    const idleMinutes = config.get<number>('idleReminderMinutes') || 10;
    idleTimeoutMs = idleMinutes * 60 * 1000;
}


// ============ 状态栏更新 ============
async function updateStatusBar() {
    const localCount = await countLocalBacklog();
    const centralCount = await countCentralBacklog();
    
    if (localCount > 0 || centralCount > 0) {
        statusBarItem.text = t('statusBacklog', localCount, centralCount);
        statusBarItem.tooltip = currentLanguage === 'zh' 
            ? '点击查看待办问题' 
            : 'Click to view backlog';
        statusBarItem.show();
    } else {
        statusBarItem.hide();
    }
}

async function countLocalBacklog(): Promise<number> {
    const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
    if (!workspaceFolder) return 0;
    
    const backlogBasePath = path.join(workspaceFolder.uri.fsPath, 'knowledge-base', 'backlog');
    if (!fs.existsSync(backlogBasePath)) return 0;
    
    let count = 0;
    for (const folder of ['pending', 'draft']) {
        const folderPath = path.join(backlogBasePath, folder);
        if (fs.existsSync(folderPath)) {
            count += fs.readdirSync(folderPath).filter(f => f.endsWith('.md')).length;
        }
    }
    return count;
}

async function countCentralBacklog(): Promise<number> {
    if (!centralPath || !fs.existsSync(centralPath)) return 0;
    
    const pendingPath = path.join(centralPath, 'backlog', 'pending');
    const draftPath = path.join(centralPath, 'backlog', 'draft');
    
    let count = 0;
    if (fs.existsSync(pendingPath)) {
        count += fs.readdirSync(pendingPath).filter(f => f.endsWith('.md')).length;
    }
    if (fs.existsSync(draftPath)) {
        count += fs.readdirSync(draftPath).filter(f => f.endsWith('.md')).length;
    }
    return count;
}

// ============ 每日提醒检测 ============
async function checkDailyReminders() {
    const dailyItems: { title: string; filePath: string }[] = [];
    
    // 扫描本地待办
    const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
    if (workspaceFolder) {
        const localBasePath = path.join(workspaceFolder.uri.fsPath, 'knowledge-base', 'backlog');
        for (const folder of ['pending', 'draft']) {
            const folderPath = path.join(localBasePath, folder);
            if (fs.existsSync(folderPath)) {
                const files = fs.readdirSync(folderPath).filter(f => f.endsWith('.md'));
                for (const file of files) {
                    const filePath = path.join(folderPath, file);
                    const content = fs.readFileSync(filePath, 'utf8');
                    if (content.includes('reminder_mode: daily')) {
                        const titleMatch = content.match(/^#\s+.+[:：]\s*(.+)$/m);
                        const title = titleMatch ? titleMatch[1].trim() : file;
                        dailyItems.push({ title, filePath });
                    }
                }
            }
        }
    }
    
    // 扫描中央待办
    if (centralPath && fs.existsSync(centralPath)) {
        for (const folder of ['pending', 'draft']) {
            const folderPath = path.join(centralPath, 'backlog', folder);
            if (fs.existsSync(folderPath)) {
                const files = fs.readdirSync(folderPath).filter(f => f.endsWith('.md'));
                for (const file of files) {
                    const filePath = path.join(folderPath, file);
                    const content = fs.readFileSync(filePath, 'utf8');
                    if (content.includes('reminder_mode: daily')) {
                        const titleMatch = content.match(/^#\s+.+[:：]\s*(.+)$/m);
                        const title = titleMatch ? titleMatch[1].trim() : file;
                        dailyItems.push({ title, filePath });
                    }
                }
            }
        }
    }
    
    // 显示每日提醒
    if (dailyItems.length > 0) {
        const titles = dailyItems.map(item => `• ${item.title}`).join('\n');
        const message = currentLanguage === 'zh'
            ? `🔔 每日提醒：你有 ${dailyItems.length} 个待思考的想法`
            : `🔔 Daily Reminder: You have ${dailyItems.length} idea(s) to think about`;
        
        const selection = await vscode.window.showInformationMessage(
            message,
            currentLanguage === 'zh' ? '查看' : 'View',
            currentLanguage === 'zh' ? '稍后' : 'Later'
        );
        
        if (selection === (currentLanguage === 'zh' ? '查看' : 'View')) {
            // 打开第一个每日提醒项
            const doc = await vscode.workspace.openTextDocument(dailyItems[0].filePath);
            await vscode.window.showTextDocument(doc);
        }
    }
}

// ============ 问题暂存系统 ============
async function saveQuestion() {
    // 获取问题描述
    const question = await vscode.window.showInputBox({
        prompt: t('questionPrompt'),
        placeHolder: t('questionPlaceholder'),
        ignoreFocusOut: true
    });
    
    if (!question) return;
    
    // ============ v2.2.0 智能检测 ============
    const smartResult = analyzeQuestionSmart(question);
    
    // 智能分类检测
    let category = 'question';
    if (smartResult.category) {
        const categoryLabel = t(`category${smartResult.category.charAt(0).toUpperCase() + smartResult.category.slice(1)}`);
        const useDetected = await vscode.window.showInformationMessage(
            t('smartCategoryDetected', categoryLabel),
            t('smartUseDetected'),
            t('smartManualSelect')
        );
        if (useDetected === t('smartUseDetected')) {
            category = smartResult.category;
        } else {
            // 手动选择
            const categoryItems = [
                { label: `🐛 ${t('categoryBug')}`, value: 'bug' },
                { label: `✨ ${t('categoryFeature')}`, value: 'feature' },
                { label: `💡 ${t('categoryIdea')}`, value: 'idea' },
                { label: `❓ ${t('categoryQuestion')}`, value: 'question' }
            ];
            const categorySelection = await vscode.window.showQuickPick(categoryItems, {
                placeHolder: t('questionCategory')
            });
            category = categorySelection?.value || 'question';
        }
    } else {
        // 无法智能检测，手动选择
        const categoryItems = [
            { label: `🐛 ${t('categoryBug')}`, value: 'bug' },
            { label: `✨ ${t('categoryFeature')}`, value: 'feature' },
            { label: `💡 ${t('categoryIdea')}`, value: 'idea' },
            { label: `❓ ${t('categoryQuestion')}`, value: 'question' }
        ];
        const categorySelection = await vscode.window.showQuickPick(categoryItems, {
            placeHolder: t('questionCategory')
        });
        category = categorySelection?.value || 'question';
    }
    
    // 智能优先级检测
    let priority = 'normal';
    let priorityAuto = false;
    if (smartResult.priority) {
        const priorityLabel = t(`backlogPriority${smartResult.priority.charAt(0).toUpperCase() + smartResult.priority.slice(1)}`);
        const useDetected = await vscode.window.showInformationMessage(
            t('smartPriorityDetected', priorityLabel),
            t('smartUseDetected'),
            t('smartManualSelect')
        );
        if (useDetected === t('smartUseDetected')) {
            priority = smartResult.priority;
            priorityAuto = true;
        } else {
            // 手动选择
            const priorityItems = [
                { label: `🔴 ${t('backlogPriorityHigh')}`, value: 'high' },
                { label: `🟡 ${t('backlogPriorityNormal')}`, value: 'normal' },
                { label: `🟢 ${t('backlogPriorityLow')}`, value: 'low' }
            ];
            const prioritySelection = await vscode.window.showQuickPick(priorityItems, {
                placeHolder: t('questionPriority')
            });
            priority = prioritySelection?.value || 'normal';
        }
    } else {
        // 无法智能检测，手动选择
        const priorityItems = [
            { label: `🔴 ${t('backlogPriorityHigh')}`, value: 'high' },
            { label: `🟡 ${t('backlogPriorityNormal')}`, value: 'normal' },
            { label: `🟢 ${t('backlogPriorityLow')}`, value: 'low' }
        ];
        const prioritySelection = await vscode.window.showQuickPick(priorityItems, {
            placeHolder: t('questionPriority')
        });
        priority = prioritySelection?.value || 'normal';
    }
    
    // 知识库关联检测
    const relatedFiles = await searchRelatedInKB(question);
    if (relatedFiles.length > 0) {
        const relatedNames = relatedFiles.slice(0, 3).map(f => f.name).join(', ');
        const action = await vscode.window.showInformationMessage(
            t('smartRelatedFound', relatedNames),
            t('smartRelatedView'),
            t('smartRelatedIgnore')
        );
        if (action === t('smartRelatedView')) {
            // 打开第一个相关文件
            const doc = await vscode.workspace.openTextDocument(relatedFiles[0].path);
            await vscode.window.showTextDocument(doc);
            // 询问是否继续暂存
            const continueAction = await vscode.window.showInformationMessage(
                currentLanguage === 'zh' ? '查看后是否继续暂存问题？' : 'Continue to save question after viewing?',
                t('confirm'),
                t('cancel')
            );
            if (continueAction !== t('confirm')) {
                return;
            }
        }
    }
    
    // 生成问题文件
    const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
    const projectName = workspaceFolder ? path.basename(workspaceFolder.uri.fsPath) : 'unknown';
    const timestamp = Date.now();
    const dateStr = new Date().toISOString().split('T')[0];
    const id = `q-${dateStr.replace(/-/g, '')}-${timestamp.toString().slice(-4)}`;
    
    const content = `---
id: ${id}
date: ${dateStr}
status: pending
priority: ${priority}
priority_auto: ${priorityAuto}
category: ${category}
source_project: "${projectName}"
similar_count: ${relatedFiles.length}
last_reminded: ${dateStr}
deleted_date: null
---

# ${currentLanguage === 'zh' ? '问题' : 'Question'}: ${question}

## ${currentLanguage === 'zh' ? '问题描述' : 'Description'}

${question}

## ${currentLanguage === 'zh' ? '上下文' : 'Context'}

- ${currentLanguage === 'zh' ? '项目' : 'Project'}: ${projectName}
- ${currentLanguage === 'zh' ? '时间' : 'Time'}: ${new Date().toLocaleString()}
- ${currentLanguage === 'zh' ? '智能分类' : 'Smart Category'}: ${category}
- ${currentLanguage === 'zh' ? '智能优先级' : 'Smart Priority'}: ${priority} ${priorityAuto ? '(auto)' : '(manual)'}
${relatedFiles.length > 0 ? `- ${currentLanguage === 'zh' ? '相关文件' : 'Related Files'}: ${relatedFiles.map(f => f.name).join(', ')}` : ''}

---
## Kiro ${currentLanguage === 'zh' ? '分析 (草稿)' : 'Analysis (Draft)'}

(${currentLanguage === 'zh' ? '待分析' : 'Pending analysis'})

---
## ${currentLanguage === 'zh' ? '解决方案' : 'Solution'}

(${currentLanguage === 'zh' ? '待解决' : 'Pending'})
`;

    // 根据模式决定保存位置
    let savePath: string;
    
    if (backlogMode === 'central' && centralPath) {
        // 直接保存到中央
        const centralBacklog = path.join(centralPath, 'backlog', 'pending');
        if (!fs.existsSync(centralBacklog)) {
            fs.mkdirSync(centralBacklog, { recursive: true });
        }
        savePath = path.join(centralBacklog, `${id}.md`);
    } else {
        // 保存到本地
        if (!workspaceFolder) {
            throw new Error(currentLanguage === 'zh' ? '没有打开工作区' : 'No workspace open');
        }
        const localBacklog = path.join(workspaceFolder.uri.fsPath, 'knowledge-base', 'backlog', 'pending');
        if (!fs.existsSync(localBacklog)) {
            fs.mkdirSync(localBacklog, { recursive: true });
        }
        savePath = path.join(localBacklog, `${id}.md`);
    }
    
    fs.writeFileSync(savePath, content, 'utf8');
    vscode.window.showInformationMessage(t('backlogSaved'));
    
    // 更新状态栏
    updateStatusBar();
    
    // 打开文件
    const doc = await vscode.workspace.openTextDocument(savePath);
    await vscode.window.showTextDocument(doc);
}

async function viewBacklog() {
    const localCount = await countLocalBacklog();
    const centralCount = await countCentralBacklog();
    
    if (localCount === 0 && centralCount === 0) {
        vscode.window.showInformationMessage(
            currentLanguage === 'zh' ? '没有待处理的问题' : 'No pending questions'
        );
        return;
    }
    
    // 收集所有待办
    interface BacklogItem {
        id: string;
        title: string;
        priority: string;
        category: string;
        date: string;
        source: 'local' | 'central';
        status: string;
        filePath: string;
        daysOld: number;
    }
    
    const items: BacklogItem[] = [];
    
    // 本地待办
    const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
    if (workspaceFolder) {
        const localBasePath = path.join(workspaceFolder.uri.fsPath, 'knowledge-base', 'backlog');
        for (const folder of ['pending', 'draft']) {
            const localPath = path.join(localBasePath, folder);
            if (fs.existsSync(localPath)) {
                const files = fs.readdirSync(localPath).filter(f => f.endsWith('.md'));
                for (const file of files) {
                    const filePath = path.join(localPath, file);
                    const content = fs.readFileSync(filePath, 'utf8');
                    const item = parseBacklogFile(content, filePath, 'local');
                    if (item) items.push(item);
                }
            }
        }
    }
    
    // 中央待办
    if (centralPath && fs.existsSync(centralPath)) {
        for (const folder of ['pending', 'draft']) {
            const folderPath = path.join(centralPath, 'backlog', folder);
            if (fs.existsSync(folderPath)) {
                const files = fs.readdirSync(folderPath).filter(f => f.endsWith('.md'));
                for (const file of files) {
                    const filePath = path.join(folderPath, file);
                    const content = fs.readFileSync(filePath, 'utf8');
                    const item = parseBacklogFile(content, filePath, 'central');
                    if (item) items.push(item);
                }
            }
        }
    }
    
    // 排序：优先级 > 时间
    const priorityOrder: Record<string, number> = { high: 0, normal: 1, low: 2 };
    items.sort((a, b) => {
        if (priorityOrder[a.priority] !== priorityOrder[b.priority]) {
            return priorityOrder[a.priority] - priorityOrder[b.priority];
        }
        return new Date(a.date).getTime() - new Date(b.date).getTime();
    });
    
    // 显示列表
    const quickPickItems = items.map(item => {
        const priorityIcon = item.priority === 'high' ? '🔴' : item.priority === 'normal' ? '🟡' : '🟢';
        const sourceIcon = item.source === 'local' ? '📁' : '☁️';
        const statusIcon = item.status === 'draft' ? '📝' : '⏳';
        const overdueWarning = item.daysOld >= 7 ? ` ⚠️${item.daysOld}d` : '';
        
        return {
            label: `${priorityIcon} ${statusIcon} ${item.title}`,
            description: `${sourceIcon} ${item.date}${overdueWarning}`,
            detail: `${item.category} | ${item.source === 'local' ? t('backlogLocal') : t('backlogCentral')}`,
            item
        };
    });
    
    const selection = await vscode.window.showQuickPick(quickPickItems, {
        placeHolder: currentLanguage === 'zh' ? '选择要处理的问题' : 'Select question to handle'
    });
    
    if (selection) {
        // 打开选中的文件
        const doc = await vscode.workspace.openTextDocument(selection.item.filePath);
        await vscode.window.showTextDocument(doc);
        
        // 提供操作选项
        const actions = [
            { label: `✅ ${t('resolve')}`, action: 'resolve' },
            { label: `🤖 ${t('backlogKiroAnalyze')}`, action: 'analyze' },
            { label: `☁️ ${t('backlogSubmitCentral')}`, action: 'submit' },
            { label: `🗑️ ${t('delete')}`, action: 'delete' }
        ];
        
        const actionSelection = await vscode.window.showQuickPick(actions, {
            placeHolder: currentLanguage === 'zh' ? '选择操作' : 'Select action'
        });
        
        if (actionSelection) {
            await handleBacklogAction(selection.item, actionSelection.action);
        }
    }
}

function parseBacklogFile(content: string, filePath: string, source: 'local' | 'central'): any {
    const idMatch = content.match(/id:\s*(.+)/);
    const dateMatch = content.match(/date:\s*(.+)/);
    const priorityMatch = content.match(/priority:\s*(\w+)/);
    const categoryMatch = content.match(/category:\s*(\w+)/);
    const statusMatch = content.match(/status:\s*(\w+)/);
    const titleMatch = content.match(/^#\s+(?:问题|Question):\s*(.+)$/m);
    
    if (!idMatch) return null;
    
    const date = dateMatch ? dateMatch[1].trim() : '';
    const daysOld = Math.floor((Date.now() - new Date(date).getTime()) / (1000 * 60 * 60 * 24));
    
    return {
        id: idMatch[1].trim(),
        title: titleMatch ? titleMatch[1].trim() : path.basename(filePath, '.md'),
        priority: priorityMatch ? priorityMatch[1].trim() : 'normal',
        category: categoryMatch ? categoryMatch[1].trim() : 'question',
        status: statusMatch ? statusMatch[1].trim() : 'pending',
        date,
        source,
        filePath,
        daysOld
    };
}

async function handleBacklogAction(item: any, action: string) {
    switch (action) {
        case 'resolve':
            await resolveBacklogItem(item);
            break;
        case 'analyze':
            vscode.window.showInformationMessage(
                currentLanguage === 'zh' 
                    ? '请告诉 Kiro："分析这个问题并提供解决方案"'
                    : 'Tell Kiro: "Analyze this question and provide a solution"'
            );
            break;
        case 'submit':
            if (item.source === 'local') {
                await submitSingleBacklog(item);
            }
            break;
        case 'delete':
            await deleteBacklogItem(item);
            break;
    }
}

async function resolveBacklogItem(item: any) {
    // 更新状态为 resolved
    let content = fs.readFileSync(item.filePath, 'utf8');
    content = content.replace(/status:\s*\w+/, 'status: resolved');
    fs.writeFileSync(item.filePath, content, 'utf8');
    
    // 移动到 solutions
    const fileName = path.basename(item.filePath);
    let destDir: string;
    
    if (item.source === 'central') {
        destDir = path.join(centralPath, 'solutions');
    } else {
        const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
        if (workspaceFolder) {
            destDir = path.join(workspaceFolder.uri.fsPath, 'knowledge-base', 'solutions');
        } else {
            return;
        }
    }
    
    if (!fs.existsSync(destDir)) {
        fs.mkdirSync(destDir, { recursive: true });
    }
    
    const destPath = path.join(destDir, fileName);
    fs.renameSync(item.filePath, destPath);
    
    vscode.window.showInformationMessage(
        currentLanguage === 'zh' ? '✅ 问题已解决并归档' : '✅ Question resolved and archived'
    );
    
    updateStatusBar();
}

async function deleteBacklogItem(item: any) {
    const confirm = await vscode.window.showWarningMessage(
        currentLanguage === 'zh' 
            ? `确定删除问题 "${item.title}"？将保留 60 天后彻底删除`
            : `Delete "${item.title}"? Will be permanently deleted after 60 days`,
        t('confirm'),
        t('cancel')
    );
    
    if (confirm !== t('confirm')) return;
    
    // 更新状态和删除日期
    let content = fs.readFileSync(item.filePath, 'utf8');
    content = content.replace(/status:\s*\w+/, 'status: deleted');
    content = content.replace(/deleted_date:\s*null/, `deleted_date: ${new Date().toISOString().split('T')[0]}`);
    
    // 移动到 deleted 文件夹
    let deletedDir: string;
    if (item.source === 'central') {
        deletedDir = path.join(centralPath, 'backlog', 'deleted');
    } else {
        const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
        if (!workspaceFolder) return;
        deletedDir = path.join(workspaceFolder.uri.fsPath, 'knowledge-base', 'backlog', 'deleted');
    }
    
    if (!fs.existsSync(deletedDir)) {
        fs.mkdirSync(deletedDir, { recursive: true });
    }
    
    const destPath = path.join(deletedDir, path.basename(item.filePath));
    fs.writeFileSync(destPath, content, 'utf8');
    fs.unlinkSync(item.filePath);
    
    vscode.window.showInformationMessage(
        currentLanguage === 'zh' ? '已删除，将保留 60 天' : 'Deleted, will be kept for 60 days'
    );
    
    updateStatusBar();
}

async function submitSingleBacklog(item: any) {
    if (!centralPath || !fs.existsSync(centralPath)) {
        vscode.window.showErrorMessage(t('kbNotConfigured'));
        return;
    }
    
    const centralPending = path.join(centralPath, 'backlog', 'pending');
    if (!fs.existsSync(centralPending)) {
        fs.mkdirSync(centralPending, { recursive: true });
    }
    
    const destPath = path.join(centralPending, path.basename(item.filePath));
    fs.copyFileSync(item.filePath, destPath);
    fs.unlinkSync(item.filePath);
    
    vscode.window.showInformationMessage(t('backlogSubmitted', 1));
    updateStatusBar();
}


async function submitBacklog() {
    const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
    if (!workspaceFolder) {
        throw new Error(currentLanguage === 'zh' ? '没有打开工作区' : 'No workspace open');
    }
    
    if (!centralPath || !fs.existsSync(centralPath)) {
        vscode.window.showErrorMessage(t('kbNotConfigured'));
        return;
    }
    
    const localBacklog = path.join(workspaceFolder.uri.fsPath, 'knowledge-base', 'backlog');
    if (!fs.existsSync(localBacklog)) {
        vscode.window.showInformationMessage(
            currentLanguage === 'zh' ? '没有本地待办问题' : 'No local backlog'
        );
        return;
    }
    
    const files = fs.readdirSync(localBacklog).filter(f => f.endsWith('.md'));
    if (files.length === 0) {
        vscode.window.showInformationMessage(
            currentLanguage === 'zh' ? '没有本地待办问题' : 'No local backlog'
        );
        return;
    }
    
    const centralPending = path.join(centralPath, 'backlog', 'pending');
    if (!fs.existsSync(centralPending)) {
        fs.mkdirSync(centralPending, { recursive: true });
    }
    
    let submitCount = 0;
    for (const file of files) {
        const srcPath = path.join(localBacklog, file);
        const destPath = path.join(centralPending, file);
        
        if (!fs.existsSync(destPath)) {
            fs.copyFileSync(srcPath, destPath);
            fs.unlinkSync(srcPath);
            submitCount++;
        }
    }
    
    vscode.window.showInformationMessage(t('backlogSubmitted', submitCount));
    updateStatusBar();
}

async function analyzeBacklog() {
    if (!centralPath || !fs.existsSync(centralPath)) {
        vscode.window.showErrorMessage(t('kbNotConfigured'));
        return;
    }
    
    const pendingPath = path.join(centralPath, 'backlog', 'pending');
    if (!fs.existsSync(pendingPath)) {
        vscode.window.showInformationMessage(
            currentLanguage === 'zh' ? '没有待分析的问题' : 'No questions to analyze'
        );
        return;
    }
    
    const files = fs.readdirSync(pendingPath).filter(f => f.endsWith('.md'));
    if (files.length === 0) {
        vscode.window.showInformationMessage(
            currentLanguage === 'zh' ? '没有待分析的问题' : 'No questions to analyze'
        );
        return;
    }
    
    // 生成分析任务
    let taskContent = currentLanguage === 'zh' 
        ? `# 待办问题批量分析任务\n\n> 生成时间: ${new Date().toLocaleString()}\n\n`
        : `# Backlog Batch Analysis Task\n\n> Generated: ${new Date().toLocaleString()}\n\n`;
    
    taskContent += currentLanguage === 'zh'
        ? `共 ${files.length} 个问题待分析：\n\n`
        : `${files.length} questions to analyze:\n\n`;
    
    for (const file of files) {
        const filePath = path.join(pendingPath, file);
        const content = fs.readFileSync(filePath, 'utf8');
        const titleMatch = content.match(/^#\s+(?:问题|Question):\s*(.+)$/m);
        const title = titleMatch ? titleMatch[1] : file;
        
        taskContent += `## ${title}\n\n`;
        taskContent += `- ${currentLanguage === 'zh' ? '文件' : 'File'}: \`backlog/pending/${file}\`\n`;
        taskContent += `- [ ] ${currentLanguage === 'zh' ? '分析并提供解决方案' : 'Analyze and provide solution'}\n\n`;
    }
    
    taskContent += currentLanguage === 'zh'
        ? `\n## 操作指南\n\n告诉 Kiro："逐个分析这些问题，为每个问题提供解决方案草稿"\n`
        : `\n## Instructions\n\nTell Kiro: "Analyze these questions one by one and provide draft solutions"\n`;
    
    const doc = await vscode.workspace.openTextDocument({
        content: taskContent,
        language: 'markdown'
    });
    await vscode.window.showTextDocument(doc);
}

// ============ 语言切换 ============
async function switchLanguage() {
    const items = [
        { label: '🇨🇳 中文', value: 'zh' },
        { label: '🇺🇸 English', value: 'en' }
    ];
    
    const selection = await vscode.window.showQuickPick(items, {
        placeHolder: currentLanguage === 'zh' ? '选择界面语言' : 'Select language'
    });
    
    if (selection && selection.value !== currentLanguage) {
        currentLanguage = selection.value;
        const config = vscode.workspace.getConfiguration('kiro-kb');
        await config.update('language', currentLanguage, vscode.ConfigurationTarget.Global);
        
        vscode.window.showInformationMessage(
            t('languageSwitched', currentLanguage === 'zh' ? t('languageChinese') : t('languageEnglish'))
        );
        
        updateStatusBar();
    }
}

// ============ 自动检测和同步 ============
async function autoDetectAndSync() {
    // Check if central path is configured
    if (!centralPath) {
        vscode.window.showInformationMessage(t('kbNotConfigured'), t('setup')).then(selection => {
            if (selection === t('setup')) {
                vscode.commands.executeCommand('kiro-kb.setup');
            }
        });
        return;
    }

    // Check if central path exists
    if (!fs.existsSync(centralPath)) {
        vscode.window.showWarningMessage(
            `${t('kbPathNotExist')} (${centralPath})`,
            t('kbResetPath'),
            t('ignore')
        ).then(selection => {
            if (selection === t('kbResetPath')) {
                vscode.commands.executeCommand('kiro-kb.setup');
            }
        });
        return;
    }

    // Validate central knowledge base structure
    const validationResult = validateCentralKB(centralPath);
    if (!validationResult.isValid) {
        vscode.window.showWarningMessage(
            `${t('kbValidationFailed')} - ${validationResult.message}`,
            t('kbResetPath'),
            t('kbViewDetails')
        ).then(selection => {
            if (selection === t('kbResetPath')) {
                vscode.commands.executeCommand('kiro-kb.setup');
            } else if (selection === t('kbViewDetails')) {
                vscode.window.showInformationMessage(validationResult.details.join('\n'));
            }
        });
        return;
    }

    const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
    if (!workspaceFolder) return;

    const workspacePath = workspaceFolder.uri.fsPath;
    
    // Check if current workspace IS the central knowledge base
    if (workspacePath === centralPath || workspacePath.startsWith(centralPath)) {
        await checkCentralKnowledgeBase();
        return;
    }

    // Check local backlog first
    await checkLocalBacklog();

    // Normal project - check for local knowledge-base to sync
    const localKB = path.join(workspacePath, 'knowledge-base');
    if (!fs.existsSync(localKB)) return;

    // Count files to sync
    const folders = ['discussions', 'solutions', 'notes'];
    let newFilesCount = 0;
    const projectName = path.basename(workspacePath);
    const centralKBPath = path.join(centralPath, 'knowledge-base');

    for (const folder of folders) {
        const srcDir = path.join(localKB, folder);
        const destDir = path.join(centralKBPath, folder);

        if (fs.existsSync(srcDir)) {
            const files = fs.readdirSync(srcDir).filter(f => 
                f.endsWith('.md') && f !== 'README.md' && !f.startsWith('.')
            );
            
            for (const file of files) {
                const newName = `${projectName}-${file}`;
                const destFile = path.join(destDir, newName);
                if (!fs.existsSync(destFile)) {
                    newFilesCount++;
                }
            }
        }
    }

    // If there are new files, prompt to sync or auto sync
    if (newFilesCount > 0) {
        if (autoSyncEnabled) {
            vscode.window.showInformationMessage(t('syncAuto', newFilesCount));
            vscode.commands.executeCommand('kiro-kb.sync');
        } else {
            const selection = await vscode.window.showInformationMessage(
                t('syncDetected', newFilesCount),
                t('syncNow'),
                t('later')
            );

            if (selection === t('syncNow')) {
                vscode.commands.executeCommand('kiro-kb.sync');
            }
        }
    }
}

async function checkLocalBacklog() {
    const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
    if (!workspaceFolder) return;
    
    const localBacklog = path.join(workspaceFolder.uri.fsPath, 'knowledge-base', 'backlog');
    if (!fs.existsSync(localBacklog)) return;
    
    const files = fs.readdirSync(localBacklog).filter(f => f.endsWith('.md'));
    if (files.length === 0) return;
    
    // 检查是否有超期问题
    let overdueCount = 0;
    for (const file of files) {
        const content = fs.readFileSync(path.join(localBacklog, file), 'utf8');
        const dateMatch = content.match(/date:\s*(.+)/);
        if (dateMatch) {
            const daysOld = Math.floor((Date.now() - new Date(dateMatch[1]).getTime()) / (1000 * 60 * 60 * 24));
            if (daysOld >= reminderDays[0]) overdueCount++;
        }
    }
    
    // 显示提醒
    const message = overdueCount > 0
        ? `${t('backlogDetected', files.length)} (${t('backlogOverdue', overdueCount, reminderDays[0])})`
        : t('backlogDetected', files.length);
    
    const selection = await vscode.window.showInformationMessage(
        message,
        t('backlogResolveNow'),
        t('backlogSubmitCentral'),
        t('later')
    );
    
    if (selection === t('backlogResolveNow')) {
        vscode.commands.executeCommand('kiro-kb.viewBacklog');
    } else if (selection === t('backlogSubmitCentral')) {
        vscode.commands.executeCommand('kiro-kb.submitBacklog');
    }
}


// ============ 中央知识库检查 ============
async function checkCentralKnowledgeBase() {
    const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
    if (!workspaceFolder) return;

    const kbPath = workspaceFolder.uri.fsPath;
    
    // 先检查待办问题
    await checkCentralBacklog();
    
    // 清理过期删除的问题
    await cleanupDeletedBacklog();
    
    const folders = ['discussions', 'solutions', 'notes'];
    
    interface FileInfo {
        name: string;
        folder: string;
        path: string;
        hasYaml: boolean;
        domain: string;
        tags: string[];
        title: string;
        content: string;
    }
    
    const allFiles: FileInfo[] = [];
    let noYamlCount = 0;
    let otherDomainCount = 0;

    for (const folder of folders) {
        const folderPath = path.join(kbPath, folder);
        if (fs.existsSync(folderPath)) {
            const files = fs.readdirSync(folderPath).filter(f => 
                f.endsWith('.md') && !f.startsWith('.') && f !== 'README.md'
            );
            
            for (const file of files) {
                const filePath = path.join(folderPath, file);
                const content = fs.readFileSync(filePath, 'utf8');
                
                const hasYaml = content.startsWith('---');
                const domainMatch = content.match(/domain:\s*(\w+)/);
                const domain = domainMatch ? domainMatch[1] : 'other';
                
                const tagsMatch = content.match(/tags:\s*\[([^\]]+)\]/);
                const tags = tagsMatch ? tagsMatch[1].split(',').map(t => t.trim().replace(/['"]/g, '')) : [];
                
                const titleMatch = content.match(/^#\s+(.+)$/m);
                const title = titleMatch ? titleMatch[1] : file.replace('.md', '');
                
                if (!hasYaml) noYamlCount++;
                if (domain === 'other') otherDomainCount++;
                
                allFiles.push({ name: file, folder, path: filePath, hasYaml, domain, tags, title, content });
            }
        }
    }

    // Find related files
    const relatedPairs: { file1: FileInfo; file2: FileInfo; reason: string }[] = [];
    for (let i = 0; i < allFiles.length; i++) {
        for (let j = i + 1; j < allFiles.length; j++) {
            const f1 = allFiles[i];
            const f2 = allFiles[j];
            
            const commonTags = f1.tags.filter(t => f2.tags.includes(t));
            if (commonTags.length >= 2) {
                relatedPairs.push({ file1: f1, file2: f2, reason: `${currentLanguage === 'zh' ? '共同标签' : 'Common tags'}: ${commonTags.join(', ')}` });
            } else if (f1.domain === f2.domain && f1.domain !== 'other') {
                const words1 = f1.title.toLowerCase().split(/[\s\-_]+/);
                const words2 = f2.title.toLowerCase().split(/[\s\-_]+/);
                const commonWords = words1.filter(w => w.length > 3 && words2.includes(w));
                if (commonWords.length >= 2) {
                    relatedPairs.push({ file1: f1, file2: f2, reason: currentLanguage === 'zh' ? '相同领域且标题相似' : 'Same domain with similar title' });
                }
            }
        }
    }

    // Build status message
    const issues: string[] = [];
    if (noYamlCount > 0) {
        issues.push(t('organizeNoYaml', noYamlCount));
    }
    if (otherDomainCount > 0) {
        issues.push(t('organizeUncategorized', otherDomainCount));
    }
    if (relatedPairs.length > 0) {
        issues.push(t('organizeRelated', relatedPairs.length));
    }

    if (issues.length > 0) {
        const selection = await vscode.window.showInformationMessage(
            t('organizeDetected', issues.join('，')),
            t('organizeSmartOrganize'),
            t('organizeViewRelated'),
            t('organizeViewDetails'),
            t('later')
        );

        if (selection === t('organizeSmartOrganize')) {
            const needsAttention = allFiles.filter(f => !f.hasYaml || f.domain === 'other');
            const taskContent = generateOrganizeTask(needsAttention, relatedPairs);
            
            const doc = await vscode.workspace.openTextDocument({
                content: taskContent,
                language: 'markdown'
            });
            await vscode.window.showTextDocument(doc);
            
            vscode.window.showInformationMessage(
                currentLanguage === 'zh' 
                    ? '已生成整理任务清单，请告诉 Kiro："按照任务清单整理知识库"'
                    : 'Task list generated. Tell Kiro: "Organize KB according to task list"'
            );
        } else if (selection === t('organizeViewRelated')) {
            if (relatedPairs.length === 0) {
                vscode.window.showInformationMessage(
                    currentLanguage === 'zh' ? '没有检测到高度相关的文件' : 'No highly related files detected'
                );
                return;
            }
            
            const relatedContent = generateRelatedFilesReport(relatedPairs);
            const doc = await vscode.workspace.openTextDocument({
                content: relatedContent,
                language: 'markdown'
            });
            await vscode.window.showTextDocument(doc);
        } else if (selection === t('organizeViewDetails')) {
            const needsAttention = allFiles.filter(f => !f.hasYaml || f.domain === 'other');
            
            const header = currentLanguage === 'zh' ? '# 需要整理的文件\n\n' : '# Files to Organize\n\n';
            const tempContent = header + needsAttention.map(f => 
                `- [ ] \`${f.folder}/${f.name}\` - ${!f.hasYaml ? (currentLanguage === 'zh' ? '缺少YAML' : 'Missing YAML') : ''} ${f.domain === 'other' ? (currentLanguage === 'zh' ? '未分类' : 'Uncategorized') : ''}`
            ).join('\n');
            
            const doc = await vscode.workspace.openTextDocument({
                content: tempContent,
                language: 'markdown'
            });
            await vscode.window.showTextDocument(doc);
        }
    } else {
        vscode.window.showInformationMessage(t('organizeAllGood'));
    }
}

async function checkCentralBacklog() {
    const pendingPath = path.join(centralPath, 'backlog', 'pending');
    const draftPath = path.join(centralPath, 'backlog', 'draft');
    
    let pendingCount = 0;
    let draftCount = 0;
    let overdueCount = 0;
    
    if (fs.existsSync(pendingPath)) {
        const files = fs.readdirSync(pendingPath).filter(f => f.endsWith('.md'));
        pendingCount = files.length;
        
        for (const file of files) {
            const content = fs.readFileSync(path.join(pendingPath, file), 'utf8');
            const dateMatch = content.match(/date:\s*(.+)/);
            if (dateMatch) {
                const daysOld = Math.floor((Date.now() - new Date(dateMatch[1]).getTime()) / (1000 * 60 * 60 * 24));
                if (daysOld >= reminderDays[1]) overdueCount++;
            }
        }
    }
    
    if (fs.existsSync(draftPath)) {
        draftCount = fs.readdirSync(draftPath).filter(f => f.endsWith('.md')).length;
    }
    
    if (pendingCount === 0 && draftCount === 0) return;
    
    let message = currentLanguage === 'zh'
        ? `📋 中央知识库: ${pendingCount} 个待处理问题，${draftCount} 个草稿待确认`
        : `📋 Central KB: ${pendingCount} pending, ${draftCount} drafts`;
    
    if (overdueCount > 0) {
        message += currentLanguage === 'zh'
            ? ` (⚠️ ${overdueCount} 个超过 ${reminderDays[1]} 天)`
            : ` (⚠️ ${overdueCount} overdue ${reminderDays[1]}+ days)`;
    }
    
    const selection = await vscode.window.showInformationMessage(
        message,
        t('backlogViewList'),
        autoAnalyze === 'onOpen' ? t('backlogBatchAnalyze') : t('later'),
        t('later')
    );
    
    if (selection === t('backlogViewList')) {
        vscode.commands.executeCommand('kiro-kb.viewBacklog');
    } else if (selection === t('backlogBatchAnalyze')) {
        vscode.commands.executeCommand('kiro-kb.analyzeBacklog');
    }
}

async function cleanupDeletedBacklog() {
    const deletedPath = path.join(centralPath, 'backlog', 'deleted');
    if (!fs.existsSync(deletedPath)) return;
    
    const files = fs.readdirSync(deletedPath).filter(f => f.endsWith('.md'));
    const now = Date.now();
    
    for (const file of files) {
        const filePath = path.join(deletedPath, file);
        const content = fs.readFileSync(filePath, 'utf8');
        const deletedDateMatch = content.match(/deleted_date:\s*(.+)/);
        
        if (deletedDateMatch && deletedDateMatch[1] !== 'null') {
            const deletedDate = new Date(deletedDateMatch[1]).getTime();
            const daysDeleted = Math.floor((now - deletedDate) / (1000 * 60 * 60 * 24));
            
            if (daysDeleted >= DELETED_RETENTION_DAYS) {
                // 检查是否有类似问题未解决
                const hasSimilar = await checkSimilarPendingQuestions(content);
                if (!hasSimilar) {
                    fs.unlinkSync(filePath);
                    console.log(`[Kiro KB] Permanently deleted: ${file}`);
                }
            }
        }
    }
}

async function checkSimilarPendingQuestions(deletedContent: string): Promise<boolean> {
    const titleMatch = deletedContent.match(/^#\s+(?:问题|Question):\s*(.+)$/m);
    if (!titleMatch) return false;
    
    const deletedTitle = titleMatch[1].toLowerCase();
    const keywords = deletedTitle.split(/[\s\-_]+/).filter(w => w.length > 3);
    
    const pendingPath = path.join(centralPath, 'backlog', 'pending');
    if (!fs.existsSync(pendingPath)) return false;
    
    const files = fs.readdirSync(pendingPath).filter(f => f.endsWith('.md'));
    
    for (const file of files) {
        const content = fs.readFileSync(path.join(pendingPath, file), 'utf8');
        const pendingTitleMatch = content.match(/^#\s+(?:问题|Question):\s*(.+)$/m);
        if (pendingTitleMatch) {
            const pendingTitle = pendingTitleMatch[1].toLowerCase();
            const matchCount = keywords.filter(k => pendingTitle.includes(k)).length;
            if (matchCount >= 2) return true;
        }
    }
    
    return false;
}

function generateOrganizeTask(needsAttention: any[], relatedPairs: any[]): string {
    const isZh = currentLanguage === 'zh';
    let content = isZh 
        ? `# 知识库整理任务\n\n> 生成时间: ${new Date().toLocaleString()}\n\n`
        : `# KB Organization Task\n\n> Generated: ${new Date().toLocaleString()}\n\n`;
    
    if (needsAttention.length > 0) {
        content += isZh 
            ? `## 1. 需要添加 YAML 元数据的文件\n\n请为以下文件添加 YAML front-matter：\n\n`
            : `## 1. Files Missing YAML Metadata\n\nAdd YAML front-matter to these files:\n\n`;
        
        for (const f of needsAttention) {
            content += `- [ ] \`${f.folder}/${f.name}\`\n`;
            content += isZh ? `  - 标题: ${f.title}\n\n` : `  - Title: ${f.title}\n\n`;
        }
    }
    
    if (relatedPairs.length > 0) {
        content += isZh 
            ? `## 2. 相关文件分析\n\n以下文件高度相关：\n\n`
            : `## 2. Related Files Analysis\n\nHighly related files:\n\n`;
        
        for (const pair of relatedPairs) {
            content += `### ${pair.file1.title} ↔ ${pair.file2.title}\n`;
            content += `- ${isZh ? '文件1' : 'File 1'}: \`${pair.file1.folder}/${pair.file1.name}\`\n`;
            content += `- ${isZh ? '文件2' : 'File 2'}: \`${pair.file2.folder}/${pair.file2.name}\`\n`;
            content += `- ${isZh ? '关联原因' : 'Reason'}: ${pair.reason}\n\n`;
        }
    }
    
    return content;
}

function generateRelatedFilesReport(relatedPairs: any[]): string {
    const isZh = currentLanguage === 'zh';
    let content = isZh
        ? `# 关联文件分析报告\n\n> 生成时间: ${new Date().toLocaleString()}\n\n`
        : `# Related Files Report\n\n> Generated: ${new Date().toLocaleString()}\n\n`;
    
    content += isZh
        ? `检测到 ${relatedPairs.length} 组高度相关的文件：\n\n`
        : `${relatedPairs.length} related file pairs detected:\n\n`;
    
    for (let i = 0; i < relatedPairs.length; i++) {
        const pair = relatedPairs[i];
        content += `## ${i + 1}. ${pair.file1.title} ↔ ${pair.file2.title}\n\n`;
        content += `| ${isZh ? '属性' : 'Property'} | ${isZh ? '文件1' : 'File 1'} | ${isZh ? '文件2' : 'File 2'} |\n`;
        content += `|------|-------|-------|\n`;
        content += `| ${isZh ? '路径' : 'Path'} | \`${pair.file1.folder}/${pair.file1.name}\` | \`${pair.file2.folder}/${pair.file2.name}\` |\n`;
        content += `| ${isZh ? '领域' : 'Domain'} | ${pair.file1.domain} | ${pair.file2.domain} |\n`;
        content += `| ${isZh ? '标签' : 'Tags'} | ${pair.file1.tags.join(', ') || (isZh ? '无' : 'None')} | ${pair.file2.tags.join(', ') || (isZh ? '无' : 'None')} |\n\n`;
    }
    
    return content;
}


// ============ 错误处理 ============
function wrapWithErrorHandler<T extends (...args: any[]) => Promise<any>>(
    fn: T,
    commandName: string
): (...args: Parameters<T>) => Promise<void> {
    return async (...args: Parameters<T>) => {
        try {
            await fn(...args);
        } catch (error) {
            await handleError(error, commandName);
        }
    };
}

async function handleError(error: unknown, context: string) {
    const errorMessage = error instanceof Error ? error.message : String(error);
    const errorStack = error instanceof Error ? (error.stack || '') : '';
    
    console.error(`[Kiro KB Error] ${context}: ${errorMessage}`);
    
    const selection = await vscode.window.showErrorMessage(
        t('errorOccurred', context, errorMessage),
        t('errorSubmit'),
        t('errorSkip'),
        t('errorClose')
    );

    if (selection === t('errorSubmit')) {
        await saveErrorReport(errorMessage, errorStack, context);
    } else if (selection === t('errorSkip')) {
        vscode.window.showInformationMessage(
            currentLanguage === 'zh' ? '已跳过错误报告' : 'Error report skipped'
        );
    }
}

async function saveErrorReport(errorMessage: string, errorStack: string, context: string) {
    const timestamp = Date.now();
    const dateStr = new Date().toISOString().replace('T', ' ').substring(0, 19);
    
    const reportContent = `---
type: error
status: open
context: ${context}
platform: ${process.platform}
vscode_version: ${vscode.version}
plugin_version: ${PLUGIN_VERSION}
date: ${dateStr}
---

# ${currentLanguage === 'zh' ? '错误报告' : 'Error Report'}

## ${currentLanguage === 'zh' ? '环境信息' : 'Environment'}
- ${currentLanguage === 'zh' ? '平台' : 'Platform'}: ${process.platform}
- VS Code: ${vscode.version}
- Plugin: ${PLUGIN_VERSION}
- Context: ${context}
- KB Path: ${centralPath || 'N/A'}

## ${currentLanguage === 'zh' ? '错误信息' : 'Error Message'}
\`\`\`
${errorMessage}
\`\`\`

## ${currentLanguage === 'zh' ? '错误堆栈' : 'Stack Trace'}
\`\`\`
${errorStack || 'N/A'}
\`\`\`

---
> ${currentLanguage === 'zh' ? '请提交到' : 'Submit to'}: ${ERROR_REPORT_REPO}
`;

    const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
    let savedPath = '';
    
    if (workspaceFolder) {
        const errorDir = path.join(workspaceFolder.uri.fsPath, 'kiro-kb-plugin', 'error-reports');
        if (fs.existsSync(path.join(workspaceFolder.uri.fsPath, 'kiro-kb-plugin'))) {
            if (!fs.existsSync(errorDir)) {
                fs.mkdirSync(errorDir, { recursive: true });
            }
            const fileName = `error-${timestamp}-${process.platform}.md`;
            savedPath = path.join(errorDir, fileName);
            fs.writeFileSync(savedPath, reportContent, 'utf8');
        }
    }
    
    if (centralPath && fs.existsSync(centralPath)) {
        const errorDir = path.join(centralPath, 'error-reports');
        if (!fs.existsSync(errorDir)) {
            fs.mkdirSync(errorDir, { recursive: true });
        }
        const fileName = `error-${timestamp}-${process.platform}.md`;
        const filePath = path.join(errorDir, fileName);
        fs.writeFileSync(filePath, reportContent, 'utf8');
        if (!savedPath) savedPath = filePath;
    }

    if (savedPath) {
        const selection = await vscode.window.showInformationMessage(
            t('errorSaved', path.basename(savedPath)),
            currentLanguage === 'zh' ? '打开文件' : 'Open File',
            'GitHub',
            t('confirm')
        );
        
        if (selection === (currentLanguage === 'zh' ? '打开文件' : 'Open File')) {
            const doc = await vscode.workspace.openTextDocument(savedPath);
            await vscode.window.showTextDocument(doc);
        } else if (selection === 'GitHub') {
            vscode.env.openExternal(vscode.Uri.parse(ERROR_REPORT_REPO));
        }
    } else {
        await vscode.env.clipboard.writeText(reportContent);
        vscode.window.showInformationMessage(
            currentLanguage === 'zh' ? '错误报告已复制到剪贴板' : 'Error report copied to clipboard'
        );
    }
}

async function toggleErrorReport() {
    errorReportEnabled = !errorReportEnabled;
    const config = vscode.workspace.getConfiguration('kiro-kb');
    await config.update('errorReportEnabled', errorReportEnabled, vscode.ConfigurationTarget.Global);
    vscode.window.showInformationMessage(
        t('errorToggled', errorReportEnabled ? t('errorEnabled') : t('errorDisabled'))
    );
}

// ============ 空闲检测 ============
function startIdleDetection(context: vscode.ExtensionContext) {
    if (idleTimeoutMs <= 0) return;

    const resetTimer = () => {
        lastActivityTime = Date.now();
        if (idleTimer) clearTimeout(idleTimer);
        idleTimer = setTimeout(checkIdle, idleTimeoutMs);
    };

    context.subscriptions.push(
        vscode.workspace.onDidChangeTextDocument(() => {
            sessionEditCount++;
            resetTimer();
        }),
        vscode.window.onDidChangeActiveTextEditor(() => resetTimer()),
        vscode.window.onDidChangeTextEditorSelection(() => resetTimer())
    );

    resetTimer();
}

function checkIdle() {
    if (Date.now() - lastActivityTime >= idleTimeoutMs) {
        const sessionMinutes = (Date.now() - sessionStartTime) / 60000;
        if (sessionEditCount >= MIN_EDITS_FOR_REMINDER && sessionMinutes >= MIN_SESSION_MINUTES) {
            showSaveReminder();
        } else {
            lastActivityTime = Date.now();
            idleTimer = setTimeout(checkIdle, idleTimeoutMs);
        }
    }
}

async function showSaveReminder() {
    const sessionMinutes = Math.round((Date.now() - sessionStartTime) / 60000);
    
    const selection = await vscode.window.showInformationMessage(
        t('idleReminder', sessionMinutes, sessionEditCount),
        t('idleEvaluate'),
        t('idleLater'),
        t('idleDisable')
    );

    if (selection === t('idleEvaluate')) {
        vscode.window.showInformationMessage(
            currentLanguage === 'zh' 
                ? '请告诉 Kiro："评估这次对话的价值，如果有用就保存到知识库"'
                : 'Tell Kiro: "Evaluate this conversation and save to KB if valuable"'
        );
        sessionEditCount = 0;
        sessionStartTime = Date.now();
    } else if (selection === t('idleLater')) {
        lastActivityTime = Date.now();
        idleTimer = setTimeout(checkIdle, idleTimeoutMs);
    } else if (selection === t('idleDisable')) {
        if (idleTimer) clearTimeout(idleTimer);
    }
}

// ============ 核心功能 ============
function validateCentralKB(kbPath: string): { isValid: boolean; message: string; details: string[] } {
    const details: string[] = [];
    const requiredDirs = ['discussions', 'solutions', 'notes'];
    const missingDirs: string[] = [];
    
    for (const dir of requiredDirs) {
        const dirPath = path.join(kbPath, dir);
        if (fs.existsSync(dirPath)) {
            details.push(`✅ ${dir}/`);
        } else {
            missingDirs.push(dir);
            details.push(`❌ ${dir}/`);
        }
    }
    
    const readmePath = path.join(kbPath, 'README.md');
    details.push(fs.existsSync(readmePath) ? '✅ README.md' : '⚠️ README.md');
    
    const indexPath = path.join(kbPath, 'INDEX.md');
    details.push(fs.existsSync(indexPath) ? '✅ INDEX.md' : '⚠️ INDEX.md');
    
    if (missingDirs.length === requiredDirs.length) {
        return {
            isValid: false,
            message: currentLanguage === 'zh' ? '该路径不是有效的知识库' : 'Invalid KB path',
            details
        };
    }
    
    return { isValid: true, message: 'OK', details };
}

async function setupKnowledgeBase() {
    const inputPath = await vscode.window.showInputBox({
        prompt: currentLanguage === 'zh' ? '请输入中央知识库的路径' : 'Enter central KB path',
        placeHolder: 'C:\\Users\\YourName\\KiroKnowledgeBase',
        value: centralPath || ''
    });

    if (!inputPath) return;

    centralPath = inputPath;

    const config = vscode.workspace.getConfiguration('kiro-kb');
    await config.update('centralPath', centralPath, vscode.ConfigurationTarget.Global);

    // 创建目录结构
    const dirs = ['discussions', 'solutions', 'notes', 'backlog/pending', 'backlog/draft', 'backlog/deleted'];
    for (const dir of dirs) {
        const fullPath = path.join(centralPath, dir);
        if (!fs.existsSync(fullPath)) {
            fs.mkdirSync(fullPath, { recursive: true });
        }
    }

    // 创建 README
    const readmePath = path.join(centralPath, 'README.md');
    if (!fs.existsSync(readmePath)) {
        const readmeContent = currentLanguage === 'zh' 
            ? `# Kiro 知识库\n\n存储所有 Kiro 对话和解决方案的中央仓库。\n\n## 目录结构\n- **discussions/** - 问题探讨\n- **solutions/** - 解决方案\n- **notes/** - 学习笔记\n- **backlog/** - 待办问题\n`
            : `# Kiro Knowledge Base\n\nCentral repository for Kiro conversations and solutions.\n\n## Structure\n- **discussions/** - Discussions\n- **solutions/** - Solutions\n- **notes/** - Notes\n- **backlog/** - Pending questions\n`;
        fs.writeFileSync(readmePath, readmeContent, 'utf8');
    }

    // 创建 PROGRESS.md
    const progressPath = path.join(centralPath, 'PROGRESS.md');
    if (!fs.existsSync(progressPath)) {
        const date = new Date().toISOString().split('T')[0];
        fs.writeFileSync(progressPath, `---\nlast_updated: ${date}\nstatus: active\n---\n\n# ${currentLanguage === 'zh' ? '进度追踪' : 'Progress'}\n\n## ${currentLanguage === 'zh' ? '已完成' : 'Done'}\n- [x] KB Init\n\n## ${currentLanguage === 'zh' ? '进行中' : 'In Progress'}\n- [ ] ...\n`, 'utf8');
    }

    // 创建 BACKLOG-INDEX.md
    const backlogIndexPath = path.join(centralPath, 'backlog', 'BACKLOG-INDEX.md');
    if (!fs.existsSync(backlogIndexPath)) {
        const backlogContent = currentLanguage === 'zh'
            ? `# 待办问题索引\n\n## 目录\n- **pending/** - 待处理\n- **draft/** - 已分析草稿\n- **deleted/** - 已删除（保留60天）\n`
            : `# Backlog Index\n\n## Folders\n- **pending/** - Pending\n- **draft/** - Analyzed drafts\n- **deleted/** - Deleted (kept 60 days)\n`;
        fs.writeFileSync(backlogIndexPath, backlogContent, 'utf8');
    }

    await setupSteeringRules();
    vscode.window.showInformationMessage(`${t('kbSetupComplete')}: ${centralPath}`);
    updateStatusBar();
}

async function setupSteeringRules() {
    const homeDir = process.env.USERPROFILE || process.env.HOME || '';
    const steeringDir = path.join(homeDir, '.kiro', 'steering');
    
    if (!fs.existsSync(steeringDir)) {
        fs.mkdirSync(steeringDir, { recursive: true });
    }

    const steeringContent = `---
inclusion: always
---

# Knowledge Base System

## Central KB Path
\`${centralPath}\`

## On User Question
1. Read \`${centralPath}/INDEX.md\`
2. If found, read specific files
3. Answer based on KB content

## On Agent Complete
Evaluate conversation quality:
- Technical solutions → Save to solutions/
- Code snippets → Save to notes/
- Discussions → Save to discussions/

## Quick Commands
- "暂存问题" / "Save question" → Save to backlog
- "检索知识库" / "Search KB" → Search INDEX.md
- "保存到知识库" / "Save to KB" → Save conversation
`;

    fs.writeFileSync(path.join(steeringDir, 'check-knowledge-base.md'), steeringContent, 'utf8');

    const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
    if (workspaceFolder) {
        const wsSteeringDir = path.join(workspaceFolder.uri.fsPath, '.kiro', 'steering');
        if (!fs.existsSync(wsSteeringDir)) {
            fs.mkdirSync(wsSteeringDir, { recursive: true });
        }

        const kbLinkContent = `---
inclusion: always
---

# KB Link

Central KB: \`${centralPath}\`

Search KB before answering technical questions.
`;

        fs.writeFileSync(path.join(wsSteeringDir, 'kb-link.md'), kbLinkContent, 'utf8');
    }
}

async function syncToCentral() {
    if (!centralPath) {
        const sel = await vscode.window.showErrorMessage(
            currentLanguage === 'zh' ? '请先设置知识库路径' : 'Please setup KB path first',
            t('setup')
        );
        if (sel === t('setup')) vscode.commands.executeCommand('kiro-kb.setup');
        return;
    }

    if (!fs.existsSync(centralPath)) {
        throw new Error(`${currentLanguage === 'zh' ? '路径不存在' : 'Path not found'}: ${centralPath}`);
    }

    const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
    if (!workspaceFolder) {
        throw new Error(currentLanguage === 'zh' ? '没有打开工作区' : 'No workspace open');
    }

    const localKB = path.join(workspaceFolder.uri.fsPath, 'knowledge-base');
    if (!fs.existsSync(localKB)) {
        const sel = await vscode.window.showInformationMessage(
            currentLanguage === 'zh' ? '当前项目没有 knowledge-base 文件夹，是否创建？' : 'No knowledge-base folder. Create?',
            currentLanguage === 'zh' ? '创建' : 'Create',
            t('cancel')
        );
        if (sel === (currentLanguage === 'zh' ? '创建' : 'Create')) {
            for (const dir of ['discussions', 'solutions', 'notes', 'backlog']) {
                fs.mkdirSync(path.join(localKB, dir), { recursive: true });
            }
            vscode.window.showInformationMessage(
                currentLanguage === 'zh' ? '已创建 knowledge-base 文件夹' : 'Created knowledge-base folder'
            );
        }
        return;
    }

    const projectName = path.basename(workspaceFolder.uri.fsPath);
    const folders = ['discussions', 'solutions', 'notes'];
    
    let syncCount = 0, skipCount = 0;

    for (const folder of folders) {
        const srcDir = path.join(localKB, folder);
        const destDir = path.join(centralPath, folder);

        if (!fs.existsSync(destDir)) fs.mkdirSync(destDir, { recursive: true });

        if (fs.existsSync(srcDir)) {
            const files = fs.readdirSync(srcDir).filter(f => 
                f.endsWith('.md') && f !== 'README.md' && !f.startsWith('.')
            );
            
            for (const file of files) {
                const newName = `${projectName}-${file}`;
                const destFile = path.join(destDir, newName);
                
                if (!fs.existsSync(destFile)) {
                    fs.copyFileSync(path.join(srcDir, file), destFile);
                    syncCount++;
                } else {
                    skipCount++;
                }
            }
        }
    }

    if (syncCount > 0) {
        vscode.window.showInformationMessage(
            `${t('syncComplete', syncCount)}${skipCount > 0 ? ` (${currentLanguage === 'zh' ? '跳过' : 'skipped'} ${skipCount})` : ''}`
        );
    } else if (skipCount > 0) {
        vscode.window.showInformationMessage(t('syncSkipped', skipCount));
    } else {
        vscode.window.showInformationMessage(t('syncNoFiles'));
    }
}

async function generateIndex() {
    if (!centralPath) {
        throw new Error(currentLanguage === 'zh' ? '请先设置知识库路径' : 'Please setup KB path first');
    }

    if (!fs.existsSync(centralPath)) {
        throw new Error(`${currentLanguage === 'zh' ? '路径不存在' : 'Path not found'}: ${centralPath}`);
    }

    const folders = ['discussions', 'solutions', 'notes'];
    const allFiles: { name: string; path: string; folder: string; domain: string; tags: string[] }[] = [];

    for (const folder of folders) {
        const folderPath = path.join(centralPath, folder);
        if (fs.existsSync(folderPath)) {
            const files = fs.readdirSync(folderPath).filter(f => f.endsWith('.md') && !f.startsWith('.'));
            
            for (const file of files) {
                const content = fs.readFileSync(path.join(folderPath, file), 'utf8');
                let domain = 'other';
                let tags: string[] = [];
                
                const domainMatch = content.match(/domain:\s*(\w+)/);
                if (domainMatch) domain = domainMatch[1];
                
                const tagsMatch = content.match(/tags:\s*\[([^\]]+)\]/);
                if (tagsMatch) tags = tagsMatch[1].split(',').map(t => t.trim());
                
                allFiles.push({ name: file, path: `${folder}/${file}`, folder, domain, tags });
            }
        }
    }

    const date = new Date().toISOString().replace('T', ' ').substring(0, 16);
    let indexContent = currentLanguage === 'zh'
        ? `# 知识库索引\n\n> 生成时间: ${date}\n\n## 按领域分类\n`
        : `# KB Index\n\n> Generated: ${date}\n\n## By Domain\n`;

    const domains = [...new Set(allFiles.map(f => f.domain))];
    for (const domain of domains) {
        indexContent += `\n### ${domain}\n\n`;
        for (const file of allFiles.filter(f => f.domain === domain)) {
            const tagStr = file.tags.length > 0 ? ' `' + file.tags.join('` `') + '`' : '';
            indexContent += `- [${file.name}](${file.path})${tagStr}\n`;
        }
    }

    fs.writeFileSync(path.join(centralPath, 'INDEX.md'), indexContent, 'utf8');
    vscode.window.showInformationMessage(
        currentLanguage === 'zh' ? `索引已生成，共 ${allFiles.length} 个文件` : `Index generated: ${allFiles.length} files`
    );
}

async function openKnowledgeBase() {
    if (!centralPath) {
        const sel = await vscode.window.showErrorMessage(
            currentLanguage === 'zh' ? '请先设置知识库路径' : 'Please setup KB path first',
            t('setup')
        );
        if (sel === t('setup')) vscode.commands.executeCommand('kiro-kb.setup');
        return;
    }

    if (!fs.existsSync(centralPath)) {
        throw new Error(`${currentLanguage === 'zh' ? '路径不存在' : 'Path not found'}: ${centralPath}`);
    }

    const items = currentLanguage === 'zh' ? [
        { label: '📂 在新窗口打开', action: 'newWindow' },
        { label: '📄 打开 INDEX.md', action: 'index' },
        { label: '📊 打开 PROGRESS.md', action: 'progress' },
        { label: '📋 查看待办问题', action: 'backlog' },
        { label: '📁 在文件管理器中打开', action: 'explorer' }
    ] : [
        { label: '📂 Open in New Window', action: 'newWindow' },
        { label: '📄 Open INDEX.md', action: 'index' },
        { label: '📊 Open PROGRESS.md', action: 'progress' },
        { label: '📋 View Backlog', action: 'backlog' },
        { label: '📁 Open in Explorer', action: 'explorer' }
    ];

    const selection = await vscode.window.showQuickPick(items, {
        placeHolder: currentLanguage === 'zh' ? '选择打开方式' : 'Select action'
    });

    if (!selection) return;

    switch (selection.action) {
        case 'newWindow':
            vscode.commands.executeCommand('vscode.openFolder', vscode.Uri.file(centralPath), true);
            break;
        case 'index':
            const indexPath = path.join(centralPath, 'INDEX.md');
            if (fs.existsSync(indexPath)) {
                const doc = await vscode.workspace.openTextDocument(indexPath);
                await vscode.window.showTextDocument(doc);
            } else {
                const gen = await vscode.window.showInformationMessage(
                    currentLanguage === 'zh' ? 'INDEX.md 不存在，是否生成？' : 'INDEX.md not found. Generate?',
                    currentLanguage === 'zh' ? '生成' : 'Generate',
                    t('cancel')
                );
                if (gen === (currentLanguage === 'zh' ? '生成' : 'Generate')) {
                    vscode.commands.executeCommand('kiro-kb.generateIndex');
                }
            }
            break;
        case 'progress':
            const progressPath = path.join(centralPath, 'PROGRESS.md');
            if (fs.existsSync(progressPath)) {
                const doc = await vscode.workspace.openTextDocument(progressPath);
                await vscode.window.showTextDocument(doc);
            }
            break;
        case 'backlog':
            vscode.commands.executeCommand('kiro-kb.viewBacklog');
            break;
        case 'explorer':
            vscode.env.openExternal(vscode.Uri.file(centralPath));
            break;
    }
}

// ============ v2.2.0 智能分析功能 ============

interface SmartAnalysisResult {
    category: string | null;
    priority: string | null;
    keywords: string[];
}

function analyzeQuestionSmart(question: string): SmartAnalysisResult {
    const lowerQuestion = question.toLowerCase();
    const result: SmartAnalysisResult = {
        category: null,
        priority: null,
        keywords: []
    };
    
    // 提取关键词（长度>2的词）
    const words = question.split(/[\s\-_，。？！、：；""''（）\[\]{}]+/);
    result.keywords = words.filter(w => w.length > 2);
    
    // ============ 智能分类检测 ============
    // Bug 关键词
    const bugKeywords = [
        // 中文
        '报错', '错误', '崩溃', '失败', '不工作', '不能用', '无法', '异常', 
        '问题', 'bug', '故障', '卡死', '闪退', '白屏', '黑屏', '死循环',
        '内存泄漏', '空指针', '未定义', '找不到', '丢失', '损坏',
        // 英文
        'error', 'crash', 'fail', 'broken', 'not working', 'exception',
        'undefined', 'null', 'missing', 'lost', 'corrupt'
    ];
    
    // Feature 关键词
    const featureKeywords = [
        // 中文
        '希望', '能不能', '想要', '需要', '添加', '新增', '实现', '支持',
        '功能', '优化', '改进', '升级', '扩展', '增强', '怎么做', '如何实现',
        // 英文
        'want', 'need', 'add', 'implement', 'support', 'feature',
        'improve', 'enhance', 'upgrade', 'extend', 'how to'
    ];
    
    // Idea 关键词
    const ideaKeywords = [
        // 中文
        '灵感', '想法', '创意', '点子', '思路', '方案', '设计', '架构',
        '如果', '假如', '或许', '可能', '尝试', '探索', '研究',
        // 英文
        'idea', 'thought', 'concept', 'design', 'architecture',
        'maybe', 'perhaps', 'try', 'explore', 'research'
    ];
    
    // 检测分类
    for (const keyword of bugKeywords) {
        if (lowerQuestion.includes(keyword)) {
            result.category = 'bug';
            break;
        }
    }
    
    if (!result.category) {
        for (const keyword of featureKeywords) {
            if (lowerQuestion.includes(keyword)) {
                result.category = 'feature';
                break;
            }
        }
    }
    
    if (!result.category) {
        for (const keyword of ideaKeywords) {
            if (lowerQuestion.includes(keyword)) {
                result.category = 'idea';
                break;
            }
        }
    }
    
    // ============ 智能优先级检测 ============
    // 高优先级关键词
    const highPriorityKeywords = [
        // 中文
        '紧急', '马上', '立即', '阻塞', '严重', '重要', '必须', '急',
        '生产环境', '线上', '客户', '老板', '今天', '现在', '尽快',
        // 英文
        'urgent', 'asap', 'immediately', 'blocking', 'critical', 
        'important', 'must', 'production', 'customer', 'today', 'now'
    ];
    
    // 低优先级关键词
    const lowPriorityKeywords = [
        // 中文
        '有空', '以后', '将来', '可选', '建议', '考虑', '也许', '随便',
        '不急', '慢慢', '有时间', '方便时',
        // 英文
        'later', 'future', 'optional', 'suggestion', 'consider',
        'maybe', 'whenever', 'no rush', 'low priority'
    ];
    
    // 检测优先级
    for (const keyword of highPriorityKeywords) {
        if (lowerQuestion.includes(keyword)) {
            result.priority = 'high';
            break;
        }
    }
    
    if (!result.priority) {
        for (const keyword of lowPriorityKeywords) {
            if (lowerQuestion.includes(keyword)) {
                result.priority = 'low';
                break;
            }
        }
    }
    
    return result;
}

interface RelatedFile {
    name: string;
    path: string;
    score: number;
}

async function searchRelatedInKB(question: string): Promise<RelatedFile[]> {
    if (!centralPath || !fs.existsSync(centralPath)) {
        return [];
    }
    
    const relatedFiles: RelatedFile[] = [];
    const lowerQuestion = question.toLowerCase();
    
    // 提取搜索关键词（长度>2的词）
    const searchWords = question.split(/[\s\-_，。？！、：；""''（）\[\]{}]+/)
        .filter(w => w.length > 2)
        .map(w => w.toLowerCase());
    
    if (searchWords.length === 0) return [];
    
    // 搜索目录
    const searchDirs = ['solutions', 'notes', 'discussions'];
    
    for (const dir of searchDirs) {
        const dirPath = path.join(centralPath, dir);
        if (!fs.existsSync(dirPath)) continue;
        
        const files = fs.readdirSync(dirPath).filter(f => f.endsWith('.md'));
        
        for (const file of files) {
            const filePath = path.join(dirPath, file);
            const content = fs.readFileSync(filePath, 'utf8').toLowerCase();
            
            // 计算匹配分数
            let score = 0;
            for (const word of searchWords) {
                if (content.includes(word)) {
                    score++;
                }
                // 文件名匹配加分
                if (file.toLowerCase().includes(word)) {
                    score += 2;
                }
            }
            
            // 标题匹配加分
            const titleMatch = content.match(/^#\s+(.+)$/m);
            if (titleMatch) {
                const title = titleMatch[1].toLowerCase();
                for (const word of searchWords) {
                    if (title.includes(word)) {
                        score += 3;
                    }
                }
            }
            
            // 标签匹配加分
            const tagsMatch = content.match(/tags:\s*\[([^\]]+)\]/);
            if (tagsMatch) {
                const tags = tagsMatch[1].toLowerCase();
                for (const word of searchWords) {
                    if (tags.includes(word)) {
                        score += 2;
                    }
                }
            }
            
            if (score >= 2) {  // 至少匹配2个关键词
                relatedFiles.push({
                    name: file,
                    path: filePath,
                    score
                });
            }
        }
    }
    
    // 按分数排序，返回前5个
    relatedFiles.sort((a, b) => b.score - a.score);
    return relatedFiles.slice(0, 5);
}

export function deactivate() {
    if (statusBarItem) {
        statusBarItem.dispose();
    }
}
