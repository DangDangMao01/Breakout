# Design Document: Ollama Local AI Integration

## Overview

This design specifies the architecture for integrating Ollama (local AI) into the Kiro Knowledge Base plugin. The integration enables intelligent work pattern analysis and automated report generation while maintaining the core principle: **AI is a tool, knowledge is an asset**. All knowledge remains portable in Markdown + Git format, while AI serves as a replaceable analysis tool.

### Key Design Principles

1. **Knowledge Externalization**: All important information stored in Markdown files
2. **AI as Tool**: Ollama can be replaced at any time without data loss
3. **Cross-Device Portability**: Git-based synchronization ensures seamless migration
4. **Privacy First**: All processing happens locally, no cloud API calls
5. **Graceful Degradation**: Plugin remains functional even when Ollama is unavailable

## Architecture

### System Components

```
┌─────────────────────────────────────────────────────────────┐
│                    Kiro KB Plugin                           │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Extension.ts (Main Entry Point)                     │  │
│  └────────────┬─────────────────────────────────────────┘  │
│               │                                             │
│       ┌───────┴────────┬──────────────┬──────────────┐    │
│       │                │              │              │    │
│  ┌────▼─────┐   ┌─────▼──────┐  ┌───▼────┐   ┌────▼────┐│
│  │ Ollama   │   │   Work     │  │ Report │   │  Config │││
│  │ Client   │   │  Pattern   │  │ Gen    │   │ Manager │││
│  │          │   │  Tracker   │  │        │   │         │││
│  └────┬─────┘   └─────┬──────┘  └───┬────┘   └────┬────┘│
│       │               │              │              │    │
│       │               └──────┬───────┘              │    │
│       │                      │                      │    │
└───────┼──────────────────────┼──────────────────────┼────┘
        │                      │                      │
        │                      ▼                      │
        │         ┌────────────────────────┐         │
        │         │  Work Data Snapshot    │         │
        │         │  - File Access Logs    │         │
        │         │  - Search History      │         │
        │         │  - Git Commits         │         │
        │         │  - Editing Time        │         │
        │         └────────────────────────┘         │
        │                      │                      │
        ▼                      ▼                      ▼
┌─────────────────────────────────────────────────────────┐
│              Ollama (Local AI Runtime)                  │
│  - Model: Llama 3.2 3B / Qwen 2.5 3B / DeepSeek       │
│  - API: http://localhost:11434                         │
└─────────────────────────────────────────────────────────┘
        │
        ▼
┌─────────────────────────────────────────────────────────┐
│         Knowledge Base (Markdown + Git)                 │
│  ┌──────────────────────────────────────────────────┐  │
│  │  work-patterns/                                  │  │
│  │    ├── daily/                                    │  │
│  │    │   └── 2026-01-08.md                        │  │
│  │    ├── weekly/                                   │  │
│  │    │   └── 2026-W02.md                          │  │
│  │    ├── monthly/                                  │  │
│  │    └── profile.yaml                             │  │
│  │                                                  │  │
│  │  solutions/  (existing)                         │  │
│  │  notes/      (existing)                         │  │
│  │  discussions/ (existing)                        │  │
│  └──────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```


## Components and Interfaces

### 1. OllamaClient

**Purpose**: Manages communication with the Ollama API

**Interface**:
```typescript
interface OllamaClient {
  // Connection management
  connect(): Promise<boolean>;
  isConnected(): boolean;
  getAvailableModels(): Promise<string[]>;
  
  // AI generation
  generate(prompt: string, model?: string): Promise<string>;
  analyzeWorkPattern(data: WorkData): Promise<string>;
  
  // Configuration
  setBaseUrl(url: string): void;
  setModel(modelName: string): void;
  getModel(): string;
}
```

**Key Methods**:
- `connect()`: Attempts to connect to Ollama at configured URL, returns success status
- `generate()`: Sends a prompt to Ollama and returns the generated text
- `analyzeWorkPattern()`: Specialized method for work pattern analysis with structured prompts
- `getAvailableModels()`: Queries Ollama for installed models

**Error Handling**:
- Connection failures: Return false, log error, show user notification
- API timeouts: Retry up to 3 times with exponential backoff (1s, 2s, 4s)
- Invalid responses: Log error, return empty string, notify user

### 2. WorkPatternTracker

**Purpose**: Tracks user work activities for analysis

**Interface**:
```typescript
interface WorkData {
  timeRange: { start: Date; end: Date };
  fileAccess: Array<{ path: string; timestamp: Date; count: number }>;
  searches: Array<{ query: string; mode: 'local' | 'global'; timestamp: Date }>;
  gitCommits: Array<{ message: string; files: string[]; timestamp: Date }>;
  editingTime: Map<string, number>; // filePath -> milliseconds
}

interface WorkPatternTracker {
  // Tracking methods
  trackFileAccess(filePath: string): void;
  trackSearch(query: string, mode: 'local' | 'global'): void;
  trackGitCommit(message: string, files: string[]): void;
  trackEditingTime(filePath: string, duration: number): void;
  
  // Data retrieval
  getWorkSnapshot(timeRange?: { start: Date; end: Date }): WorkData;
  getDailySnapshot(): WorkData;
  getWeeklySnapshot(): WorkData;
  
  // Persistence
  save(): Promise<void>;
  load(): Promise<void>;
}
```

**Implementation Details**:
- Uses in-memory storage with periodic saves to `.kiro/work-tracking.json`
- File access tracking: Increments counter for each access, stores last access time
- Search tracking: Stores query, mode, and timestamp
- Git commit tracking: Integrates with existing Git operations in the plugin
- Editing time tracking: Measures time between first and last edit in a session

**Performance Considerations**:
- Tracking overhead must be < 10ms per event
- Use debouncing for editing time (update every 30 seconds)
- Batch saves to disk (every 5 minutes or on plugin deactivation)

### 3. ReportGenerator

**Purpose**: Generates AI-powered reports from work data

**Interface**:
```typescript
interface ReportGenerator {
  // Report generation
  generateDailyReport(date?: Date): Promise<string>;
  generateWeeklyReport(weekNumber?: number): Promise<string>;
  generateMonthlyReport(month?: number): Promise<string>;
  
  // Profile management
  updateProfile(insights: WorkInsights): Promise<void>;
  getProfile(): Promise<WorkProfile>;
  
  // Utilities
  saveReport(content: string, type: 'daily' | 'weekly' | 'monthly', date: Date): Promise<string>;
}

interface WorkProfile {
  techStack: Array<{ name: string; proficiency: 'learning' | 'familiar' | 'proficient' | 'expert' }>;
  workHabits: {
    productiveHours: string[];
    preferredTools: string[];
    learningStyle: string;
  };
  commonProblems: string[];
  knowledgeAssets: {
    technicalDocs: number;
    codeSnippets: number;
    projectExperiences: number;
    solutions: number;
  };
}
```

**Report Generation Flow**:
1. Collect work data from WorkPatternTracker
2. Format data into structured prompt
3. Send prompt to OllamaClient
4. Parse and validate AI response
5. Add YAML front-matter
6. Save to appropriate directory
7. Update profile if weekly/monthly report

**Prompt Templates**:
- Daily: Focus on activities, time distribution, key files
- Weekly: Focus on patterns, trends, productivity insights
- Monthly: Focus on growth, skill development, knowledge accumulation


### 4. ConfigManager

**Purpose**: Manages Ollama integration configuration

**Interface**:
```typescript
interface OllamaConfig {
  baseUrl: string;
  model: string;
  dailyReportTime: string; // HH:MM format
  weeklyReportDay: number; // 0-6, Sunday = 0
  autoSyncEnabled: boolean;
  enabled: boolean;
}

interface ConfigManager {
  getConfig(): OllamaConfig;
  updateConfig(partial: Partial<OllamaConfig>): Promise<void>;
  validateConfig(config: Partial<OllamaConfig>): Promise<ValidationResult>;
  resetToDefaults(): void;
}
```

**Default Configuration**:
```typescript
const DEFAULT_CONFIG: OllamaConfig = {
  baseUrl: 'http://localhost:11434',
  model: 'llama3.2:3b',
  dailyReportTime: '18:00',
  weeklyReportDay: 0, // Sunday
  autoSyncEnabled: false,
  enabled: true
};
```

**Validation Rules**:
- `baseUrl`: Must be valid HTTP/HTTPS URL
- `model`: Must be available in Ollama (checked via API)
- `dailyReportTime`: Must be valid HH:MM format
- `weeklyReportDay`: Must be 0-6
- `autoSyncEnabled`: Boolean
- `enabled`: Boolean

## Data Models

### WorkData Structure

```typescript
interface WorkData {
  timeRange: {
    start: Date;
    end: Date;
  };
  fileAccess: FileAccessLog[];
  searches: SearchLog[];
  gitCommits: GitCommitLog[];
  editingTime: Map<string, number>;
}

interface FileAccessLog {
  path: string;
  timestamp: Date;
  count: number;
  lastAccessed: Date;
}

interface SearchLog {
  query: string;
  mode: 'local' | 'global';
  timestamp: Date;
  resultsCount?: number;
}

interface GitCommitLog {
  message: string;
  files: string[];
  timestamp: Date;
  hash?: string;
}
```

### Report Structure

All reports follow this Markdown structure:

```markdown
---
domain: work-patterns
tags: [daily-report, work-analysis, ai-generated]
date: 2026-01-08
generated_by: ollama
model: llama3.2:3b
source_project: "Kiro-KB-Plugin"
---

# Daily Work Report - 2026-01-08

## Summary
[2-3 sentence overview of the day]

## Key Activities
- [Activity 1]
- [Activity 2]
- [Activity 3]

## Time Distribution
| Activity | Duration | Percentage |
|----------|----------|------------|
| Coding   | 4h 30m   | 60%        |
| Research | 1h 45m   | 23%        |
| Meetings | 1h 15m   | 17%        |

## Most Accessed Files
1. `src/extension.ts` (15 times)
2. `src/ollama.ts` (12 times)
3. `README.md` (8 times)

## Search Patterns
- TypeScript async/await (3 searches)
- Ollama API documentation (2 searches)
- VSCode extension lifecycle (1 search)

## Git Activity
- 5 commits
- 12 files changed
- Main focus: Ollama integration

## Insights
[1-2 sentences of AI-generated insights about work patterns]
```

### Profile YAML Structure

```yaml
tech_stack:
  - name: TypeScript
    proficiency: proficient
    last_used: 2026-01-08
  - name: Unity
    proficiency: expert
    last_used: 2026-01-07
  - name: Shader
    proficiency: learning
    last_used: 2026-01-06

work_habits:
  productive_hours:
    - "09:00-11:00"
    - "14:00-16:00"
  preferred_tools:
    - VSCode
    - Git
    - Kiro
  learning_style: "hands-on, practice-first"

common_problems:
  - TypeScript type inference
  - Git branch management
  - Unity performance optimization
  - VSCode extension development

knowledge_assets:
  technical_docs: 200
  code_snippets: 50
  project_experiences: 30
  solutions: 100

last_updated: 2026-01-08
generated_by: ollama
model: llama3.2:3b
```


## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system—essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Property 1: Ollama Communication Round Trip
*For any* valid prompt sent to Ollama, the system should receive a parseable response that can be processed without errors.
**Validates: Requirements 1.3**

### Property 2: Error Resilience
*For any* API failure or error condition, the plugin should continue operating without crashing and should log the error appropriately.
**Validates: Requirements 1.4, 11.4**

### Property 3: Model Configuration
*For any* valid model name, when configured, the system should use that model for subsequent AI generation requests.
**Validates: Requirements 1.5**

### Property 4: File Access Tracking
*For any* knowledge file access, the Work_Pattern_Tracker should record the file path and timestamp in the work data snapshot.
**Validates: Requirements 2.1**

### Property 5: Search Tracking
*For any* search operation (local or global), the Work_Pattern_Tracker should record the query, mode, and timestamp.
**Validates: Requirements 2.2**

### Property 6: Git Commit Tracking
*For any* Git commit operation, the Work_Pattern_Tracker should record the commit message and affected files.
**Validates: Requirements 2.3**

### Property 7: Editing Time Tracking
*For any* file editing session, the Work_Pattern_Tracker should track and accumulate the editing duration.
**Validates: Requirements 2.4**

### Property 8: Work Snapshot Completeness
*For any* call to getWorkSnapshot(), the returned WorkData should contain all tracked activities within the specified time range.
**Validates: Requirements 2.5**

### Property 9: Report Data Collection
*For any* report generation trigger, the Report_Generator should successfully collect work data from the Work_Pattern_Tracker.
**Validates: Requirements 3.1**

### Property 10: Structured Prompt Generation
*For any* work data collected, the Report_Generator should send a properly structured prompt to Ollama that includes all required sections.
**Validates: Requirements 3.2, 14.1, 14.2**

### Property 11: Report File Naming
*For any* Ollama response saved as a daily report, the filename should follow the pattern `work-patterns/daily/YYYY-MM-DD.md`.
**Validates: Requirements 3.3, 6.4**

### Property 12: Report Content Structure
*For any* generated daily report, the content should include sections for: most accessed files, search keywords, Git activity summary, and editing time distribution.
**Validates: Requirements 3.4**

### Property 13: YAML Front-matter Presence
*For any* saved report file, the file should contain valid YAML front-matter with at least: domain, tags, date, and generated_by fields.
**Validates: Requirements 3.5**

### Property 14: Weekly Report Aggregation
*For any* weekly report generation, the system should analyze all daily reports from the past 7 days.
**Validates: Requirements 4.1**

### Property 15: Weekly Report Naming
*For any* weekly report saved, the filename should follow the pattern `work-patterns/weekly/YYYY-WXX.md` where XX is the ISO week number.
**Validates: Requirements 4.3**

### Property 16: Weekly Report Structure
*For any* generated weekly report, the content should include sections for: productive time periods, frequently used technologies, common problem domains, and knowledge growth areas.
**Validates: Requirements 4.4**

### Property 17: Profile Update on Weekly Report
*For any* weekly report generation, the Work_Profile YAML file should be updated with new insights and statistics.
**Validates: Requirements 4.5, 5.3**

### Property 18: Profile Required Fields
*For any* Work_Profile file, it should contain the required fields: tech_stack, work_habits, common_problems, and knowledge_assets.
**Validates: Requirements 5.2**

### Property 19: Profile YAML Validity
*For any* Work_Profile file, the content should be valid YAML that can be parsed without errors.
**Validates: Requirements 5.4**

### Property 20: Profile Manual Edit Preservation
*For any* profile update operation, user-added manual edits should be preserved while AI-generated insights are added.
**Validates: Requirements 5.5**

### Property 21: Git Sync Inclusion
*For any* daily report generated, the file should be included in the next Git sync operation (staged for commit).
**Validates: Requirements 8.1**

### Property 22: Merge Conflict Handling
*For any* Git merge conflict in work pattern files, the system should handle it gracefully without crashing and provide resolution options.
**Validates: Requirements 8.4**

### Property 23: Sync Failure Data Preservation
*For any* Git sync failure, local reports should be preserved and queued for retry on the next sync attempt.
**Validates: Requirements 8.5**

### Property 24: Work Patterns Directory Detection
*For any* cloned knowledge base containing a `work-patterns/` directory, the system should automatically detect and recognize it.
**Validates: Requirements 9.2**

### Property 25: Migration Data Integrity
*For any* cross-device migration, all work pattern data should be transferred without loss (zero data loss).
**Validates: Requirements 9.5**

### Property 26: Configuration Validation
*For any* configuration change, the system should validate the new values before applying them.
**Validates: Requirements 10.2**

### Property 27: URL Connectivity Test
*For any* Ollama URL configuration change, the system should test connectivity to the new URL before accepting it.
**Validates: Requirements 10.3**

### Property 28: Model Availability Check
*For any* model name configuration change, the system should verify the model is available in Ollama before accepting it.
**Validates: Requirements 10.4**

### Property 29: Retry with Exponential Backoff
*For any* API timeout, the system should retry up to 3 times with exponential backoff (1s, 2s, 4s).
**Validates: Requirements 11.2**

### Property 30: Failure Data Preservation
*For any* complete API failure (after all retries), work data should be saved locally for later processing.
**Validates: Requirements 11.3**

### Property 31: Privacy - No Raw Content Storage
*For any* work data collection, the system should only store aggregated statistics and metadata, not raw file contents.
**Validates: Requirements 12.2**

### Property 32: Tracking Performance Overhead
*For any* tracked event (file access, search, commit, edit), the tracking overhead should be less than 10ms.
**Validates: Requirements 13.1**

### Property 33: Prompt Template Structure
*For any* prompt sent to Ollama, it should follow the configured template structure with all required placeholders filled.
**Validates: Requirements 14.1**

### Property 34: Output Truncation
*For any* Ollama response exceeding the configured maximum length, the system should truncate it to the maximum length.
**Validates: Requirements 14.5**

### Property 35: Model Verification
*For any* model selection, the system should verify the model is installed in Ollama before attempting to use it.
**Validates: Requirements 15.2**

### Property 36: Model Switch Data Preservation
*For any* model switch operation, all existing reports should remain intact and accessible.
**Validates: Requirements 15.4**


## Error Handling

### Connection Errors

**Scenario**: Ollama is not running or unreachable

**Handling**:
1. Detect connection failure during `connect()` call
2. Log error with details (URL, error message)
3. Show user notification: "Ollama is not running. Please start Ollama or install it from https://ollama.ai"
4. Disable AI features but keep plugin functional
5. Retry connection on next report generation attempt

**User Actions**:
- Install Ollama button (opens browser to ollama.ai)
- Retry connection button
- Disable Ollama integration (in settings)

### API Timeout Errors

**Scenario**: Ollama API call takes too long

**Handling**:
1. Set timeout for API calls (30 seconds default)
2. On timeout, retry with exponential backoff:
   - Attempt 1: Wait 1 second, retry
   - Attempt 2: Wait 2 seconds, retry
   - Attempt 3: Wait 4 seconds, retry
3. After 3 failures, save work data locally
4. Log error with full details
5. Notify user: "Report generation timed out. Data saved for later."

**Recovery**:
- Manual retry command available
- Automatic retry on next scheduled generation
- Saved work data preserved until successful generation

### Model Not Found Errors

**Scenario**: Configured model is not installed in Ollama

**Handling**:
1. Detect model unavailability during verification
2. Log error with model name
3. Show user notification with download command:
   ```
   Model 'llama3.2:3b' not found.
   Run: ollama pull llama3.2:3b
   ```
4. Provide button to copy command to clipboard
5. Fall back to default model if available
6. Disable AI features if no models available

**User Actions**:
- Copy download command
- Open terminal to run command
- Select different model from available list
- Disable Ollama integration

### Invalid Response Errors

**Scenario**: Ollama returns malformed or empty response

**Handling**:
1. Validate response structure
2. If invalid, log full response for debugging
3. Retry with simplified prompt (remove complex formatting)
4. If still invalid, save raw response to error log
5. Notify user: "AI generation failed. Please check Ollama logs."

**Fallback**:
- Generate basic report from work data without AI analysis
- Include raw statistics and file lists
- Mark report as "non-AI generated"

### Git Sync Errors

**Scenario**: Git operations fail during report sync

**Handling**:
1. Catch Git errors (network, conflicts, permissions)
2. Log error with Git output
3. Preserve local reports in staging area
4. Show user notification with error details
5. Provide manual sync option

**Conflict Resolution**:
- For work pattern files, prefer local version (newer data)
- Create backup of conflicted files
- Log conflict details for user review
- Provide merge tool integration

### Disk Space Errors

**Scenario**: Insufficient disk space for reports

**Handling**:
1. Check available disk space before writing
2. If insufficient (<100MB), warn user
3. Offer to archive old reports
4. Compress reports older than 90 days
5. Provide cleanup utility

**Cleanup Strategy**:
- Archive reports older than 1 year
- Compress daily reports older than 90 days
- Keep all weekly and monthly reports
- User-configurable retention policy


## Testing Strategy

### Dual Testing Approach

This project will use both unit tests and property-based tests to ensure comprehensive coverage:

- **Unit tests**: Verify specific examples, edge cases, and error conditions
- **Property tests**: Verify universal properties across all inputs

Both types of tests are complementary and necessary. Unit tests catch concrete bugs in specific scenarios, while property tests verify general correctness across a wide range of inputs.

### Property-Based Testing Framework

**Framework**: fast-check (for TypeScript/JavaScript)

**Configuration**:
- Minimum 100 iterations per property test (due to randomization)
- Each property test must reference its design document property
- Tag format: `Feature: ollama-integration, Property {number}: {property_text}`

**Example Property Test**:
```typescript
import fc from 'fast-check';

// Feature: ollama-integration, Property 4: File Access Tracking
test('Property 4: For any file access, tracker records path and timestamp', () => {
  fc.assert(
    fc.property(
      fc.string(), // random file path
      fc.date(),   // random timestamp
      (filePath, timestamp) => {
        const tracker = new WorkPatternTracker();
        tracker.trackFileAccess(filePath);
        
        const snapshot = tracker.getWorkSnapshot();
        const accessLog = snapshot.fileAccess.find(log => log.path === filePath);
        
        expect(accessLog).toBeDefined();
        expect(accessLog.path).toBe(filePath);
        expect(accessLog.timestamp).toBeInstanceOf(Date);
      }
    ),
    { numRuns: 100 }
  );
});
```

### Unit Testing Strategy

**Framework**: Jest (for TypeScript/JavaScript)

**Test Categories**:

1. **Component Tests**:
   - OllamaClient: Connection, API calls, error handling
   - WorkPatternTracker: Tracking methods, data aggregation
   - ReportGenerator: Report generation, profile updates
   - ConfigManager: Configuration validation, persistence

2. **Integration Tests**:
   - End-to-end report generation flow
   - Git synchronization with reports
   - Cross-device migration scenarios
   - Error recovery workflows

3. **Edge Case Tests**:
   - Empty work data
   - Ollama not installed
   - Network failures
   - Disk space issues
   - Concurrent tracking operations

**Example Unit Test**:
```typescript
describe('OllamaClient', () => {
  test('should retry on timeout with exponential backoff', async () => {
    const client = new OllamaClient();
    const mockGenerate = jest.fn()
      .mockRejectedValueOnce(new Error('Timeout'))
      .mockRejectedValueOnce(new Error('Timeout'))
      .mockResolvedValueOnce('Success');
    
    client.generate = mockGenerate;
    
    const result = await client.generateWithRetry('test prompt');
    
    expect(mockGenerate).toHaveBeenCalledTimes(3);
    expect(result).toBe('Success');
  });
});
```

### Test Coverage Goals

- **Line Coverage**: > 80%
- **Branch Coverage**: > 75%
- **Function Coverage**: > 85%
- **Property Coverage**: 100% (all 36 properties tested)

### Testing Workflow

1. **Development**: Write tests alongside implementation
2. **Pre-commit**: Run unit tests (fast feedback)
3. **CI Pipeline**: Run full test suite including property tests
4. **Release**: Verify all tests pass, check coverage metrics

### Mock Strategy

**What to Mock**:
- Ollama API calls (use mock responses)
- File system operations (use in-memory FS)
- Git operations (use mock Git client)
- VSCode API (use test doubles)

**What NOT to Mock**:
- Core business logic (WorkPatternTracker, ReportGenerator)
- Data structures and models
- Utility functions
- Configuration validation

### Performance Testing

**Benchmarks**:
- Tracking overhead: < 10ms per event
- Daily report generation: < 30 seconds
- Weekly report generation: < 2 minutes
- Profile update: < 5 seconds

**Tools**:
- Use `console.time()` / `console.timeEnd()` for timing
- Run performance tests on representative hardware
- Test with realistic data volumes (1000+ tracked events)

### Manual Testing Checklist

**Installation & Setup**:
- [ ] Fresh install on Windows
- [ ] Fresh install on macOS
- [ ] Fresh install on Linux
- [ ] Ollama not installed scenario
- [ ] Ollama installed but not running
- [ ] Multiple models available

**Daily Workflow**:
- [ ] Track file access during normal work
- [ ] Track searches (local and global)
- [ ] Track Git commits
- [ ] Track editing time
- [ ] Generate daily report at end of day
- [ ] Verify report content accuracy

**Weekly Workflow**:
- [ ] Generate weekly report on Sunday
- [ ] Verify 7 days of data aggregation
- [ ] Check profile updates
- [ ] Verify Git sync

**Error Scenarios**:
- [ ] Ollama crashes during generation
- [ ] Network timeout during API call
- [ ] Disk full during report save
- [ ] Git conflict during sync
- [ ] Invalid model configuration

**Cross-Device Migration**:
- [ ] Export knowledge base from Device A
- [ ] Import on Device B
- [ ] Verify all reports present
- [ ] Verify profile intact
- [ ] Continue tracking on Device B

