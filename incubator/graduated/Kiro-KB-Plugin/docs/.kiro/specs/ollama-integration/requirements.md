# Requirements Document: Ollama Local AI Integration

## Introduction

This specification defines the requirements for integrating Ollama (local AI) into the Kiro Knowledge Base plugin to enable intelligent work pattern analysis and automated report generation. The core principle is: **AI is a tool, knowledge is an asset** - knowledge must be stored externally in portable formats (Markdown + Git), while AI serves as a temporary analysis tool that can be replaced at any time.

## Glossary

- **Ollama**: Open-source local AI runtime that runs large language models locally
- **Work_Pattern_Tracker**: Component that tracks user work activities (file access, searches, Git commits, editing time)
- **Report_Generator**: Component that uses Ollama to analyze work data and generate reports
- **Knowledge_Base**: Markdown-based repository stored in Git for cross-device portability
- **Work_Profile**: YAML file containing user's work habits, tech stack, and knowledge assets
- **Daily_Report**: AI-generated summary of daily work activities
- **Weekly_Report**: AI-generated summary of weekly work patterns
- **Central_KB**: Central knowledge base repository synchronized via Git

## Requirements

### Requirement 1: Ollama Client Integration

**User Story:** As a developer, I want the plugin to communicate with Ollama, so that I can use local AI for work pattern analysis.

#### Acceptance Criteria

1. WHEN the plugin initializes, THE Ollama_Client SHALL attempt to connect to Ollama at http://localhost:11434
2. WHEN Ollama is not running, THE System SHALL display a user-friendly error message with installation instructions
3. WHEN the Ollama_Client sends a prompt, THE System SHALL receive and parse the AI-generated response
4. WHEN the API call fails, THE System SHALL log the error and continue plugin operation without crashing
5. THE Ollama_Client SHALL support configurable model selection (Llama 3.2 3B, Qwen 2.5 3B, DeepSeek Coder)

### Requirement 2: Work Pattern Data Collection

**User Story:** As a developer, I want the system to track my work activities, so that AI can analyze my work patterns.

#### Acceptance Criteria

1. WHEN a user accesses a knowledge file, THE Work_Pattern_Tracker SHALL record the file path and timestamp
2. WHEN a user performs a search, THE Work_Pattern_Tracker SHALL record the search query and search mode (local/global)
3. WHEN a user makes a Git commit, THE Work_Pattern_Tracker SHALL record the commit message and affected files
4. WHEN a user edits a file, THE Work_Pattern_Tracker SHALL track the editing duration
5. THE Work_Pattern_Tracker SHALL provide a getWorkSnapshot() method that returns aggregated work data for a specified time period

### Requirement 3: Daily Report Generation

**User Story:** As a developer, I want the system to generate daily work reports automatically, so that I can review my daily activities and patterns.

#### Acceptance Criteria

1. WHEN the daily report generation is triggered, THE Report_Generator SHALL collect work data from Work_Pattern_Tracker
2. WHEN work data is collected, THE Report_Generator SHALL send it to Ollama with a structured prompt
3. WHEN Ollama returns the analysis, THE Report_Generator SHALL save it as a Markdown file in `work-patterns/daily/YYYY-MM-DD.md`
4. THE Daily_Report SHALL include: most accessed files, search keywords, Git activity summary, and editing time distribution
5. WHEN the report is saved, THE System SHALL add proper YAML front-matter with date, domain, and tags

### Requirement 4: Weekly Report Generation

**User Story:** As a developer, I want the system to generate weekly summaries, so that I can understand my work patterns over time.

#### Acceptance Criteria

1. WHEN the weekly report generation is triggered, THE Report_Generator SHALL analyze the past 7 daily reports
2. WHEN daily reports are analyzed, THE Report_Generator SHALL identify recurring patterns and trends
3. WHEN patterns are identified, THE Report_Generator SHALL save the summary as `work-patterns/weekly/YYYY-WXX.md`
4. THE Weekly_Report SHALL include: most productive time periods, frequently used technologies, common problem domains, and knowledge growth areas
5. WHEN the weekly report is generated, THE System SHALL update the Work_Profile YAML file with new insights

### Requirement 5: Work Profile Management

**User Story:** As a developer, I want the system to maintain a profile of my work habits and knowledge, so that I have a portable representation of my expertise.

#### Acceptance Criteria

1. WHEN the plugin first runs, THE System SHALL create a `work-patterns/profile.yaml` file if it doesn't exist
2. THE Work_Profile SHALL contain: tech stack with proficiency levels, work habits (productive hours, preferred tools, learning style), common problem domains, and knowledge asset statistics
3. WHEN weekly reports are generated, THE System SHALL update the Work_Profile with new patterns and statistics
4. THE Work_Profile SHALL be stored in YAML format for human readability and editability
5. WHEN the Work_Profile is updated, THE System SHALL preserve user manual edits while adding AI-generated insights

### Requirement 6: Knowledge Base Directory Structure

**User Story:** As a developer, I want a well-organized directory structure for AI-generated content, so that I can easily navigate and manage work pattern data.

#### Acceptance Criteria

1. WHEN the plugin initializes, THE System SHALL create a `work-patterns/` directory in the knowledge base if it doesn't exist
2. THE System SHALL create subdirectories: `daily/`, `weekly/`, and `monthly/`
3. THE System SHALL create a `profile.yaml` file in the `work-patterns/` directory
4. WHEN reports are generated, THE System SHALL save them in the appropriate subdirectory with standardized naming (YYYY-MM-DD.md for daily, YYYY-WXX.md for weekly)
5. THE directory structure SHALL coexist with existing knowledge base folders (solutions/, notes/, discussions/)

### Requirement 7: Automatic Trigger Mechanism

**User Story:** As a developer, I want reports to be generated automatically at appropriate times, so that I don't have to remember to run them manually.

#### Acceptance Criteria

1. WHEN the user closes VSCode/Kiro at end of day, THE System SHALL prompt to generate a daily report
2. WHEN it is Sunday evening (configurable), THE System SHALL prompt to generate a weekly report
3. WHEN the user declines automatic generation, THE System SHALL not prompt again until the next scheduled time
4. THE System SHALL provide manual commands to generate reports on demand
5. WHEN automatic generation is disabled in settings, THE System SHALL not show prompts but still allow manual generation

### Requirement 8: Git Synchronization Integration

**User Story:** As a developer, I want work pattern reports to be synchronized with my central knowledge base, so that I can access them across devices.

#### Acceptance Criteria

1. WHEN a daily report is generated, THE System SHALL include it in the next Git sync operation
2. WHEN a weekly report is generated, THE System SHALL automatically trigger a Git push (if auto-sync is enabled)
3. WHEN the user switches devices, THE System SHALL pull the latest work-patterns/ directory from Git
4. THE System SHALL handle merge conflicts in work pattern files gracefully
5. WHEN Git sync fails, THE System SHALL preserve local reports and retry on next sync

### Requirement 9: Cross-Device Migration

**User Story:** As a developer, I want to migrate my knowledge and work patterns to a new device easily, so that I don't lose my accumulated insights when changing computers.

#### Acceptance Criteria

1. WHEN setting up on a new device, THE System SHALL provide a setup wizard that guides through: Git clone of knowledge base, Ollama installation, plugin configuration, and central KB path setup
2. WHEN the knowledge base is cloned, THE System SHALL automatically detect the work-patterns/ directory and Work_Profile
3. WHEN Ollama is not installed, THE System SHALL provide installation instructions with download links
4. THE System SHALL verify that all required components are present before enabling AI features
5. WHEN migration is complete, THE System SHALL continue tracking work patterns seamlessly with zero data loss

### Requirement 10: Configuration Management

**User Story:** As a developer, I want to configure Ollama integration settings, so that I can customize the behavior to my preferences.

#### Acceptance Criteria

1. THE System SHALL provide configuration options for: Ollama base URL (default: http://localhost:11434), preferred model name, daily report generation time, weekly report generation day, and auto-sync enabled/disabled
2. WHEN configuration is changed, THE System SHALL validate the new values before applying
3. WHEN Ollama URL is changed, THE System SHALL test connectivity to the new URL
4. WHEN model name is changed, THE System SHALL verify the model is available in Ollama
5. THE configuration SHALL be stored in VSCode/Kiro settings and synchronized across devices

### Requirement 11: Error Handling and Fallback

**User Story:** As a developer, I want the plugin to handle errors gracefully, so that Ollama issues don't break my workflow.

#### Acceptance Criteria

1. WHEN Ollama is not running, THE System SHALL display a notification with instructions to start Ollama
2. WHEN an API call times out, THE System SHALL retry up to 3 times with exponential backoff
3. WHEN all retries fail, THE System SHALL save the work data locally and allow manual report generation later
4. WHEN Ollama returns an error, THE System SHALL log the error details and show a user-friendly message
5. THE knowledge base SHALL remain fully functional even when Ollama features are unavailable

### Requirement 12: Privacy and Data Control

**User Story:** As a developer, I want full control over my work data, so that I can ensure privacy and data ownership.

#### Acceptance Criteria

1. THE System SHALL process all data locally using Ollama (no cloud API calls)
2. WHEN work data is collected, THE System SHALL only store aggregated statistics (not raw file contents)
3. THE User SHALL be able to view and edit all generated reports as plain Markdown files
4. THE User SHALL be able to delete any work pattern data at any time
5. WHEN the user leaves a company, THE User SHALL be able to take the entire knowledge base (Git repository) with them

### Requirement 13: Performance Requirements

**User Story:** As a developer, I want AI analysis to be fast and non-intrusive, so that it doesn't slow down my work.

#### Acceptance Criteria

1. WHEN tracking work activities, THE System SHALL add less than 10ms overhead per tracked event
2. WHEN generating a daily report, THE System SHALL complete within 30 seconds (for small models on CPU)
3. WHEN generating a weekly report, THE System SHALL complete within 2 minutes
4. THE System SHALL run Ollama API calls asynchronously without blocking the UI
5. WHEN Ollama is processing, THE System SHALL show a progress indicator with cancel option

### Requirement 14: Prompt Engineering

**User Story:** As a developer, I want AI-generated reports to be concise and actionable, so that I can quickly understand my work patterns.

#### Acceptance Criteria

1. THE System SHALL use structured prompts that request specific output formats (Markdown with sections)
2. WHEN generating daily reports, THE Prompt SHALL request: summary (2-3 sentences), key activities (bullet list), time distribution (table), and insights (1-2 sentences)
3. WHEN generating weekly reports, THE Prompt SHALL request: weekly summary, pattern analysis, productivity trends, and recommendations
4. THE Prompts SHALL be configurable via template files in the plugin
5. WHEN Ollama returns overly verbose output, THE System SHALL truncate to a maximum length (configurable, default 2000 characters)

### Requirement 15: Model Selection and Management

**User Story:** As a developer, I want to choose which AI model to use, so that I can balance between quality and performance based on my hardware.

#### Acceptance Criteria

1. THE System SHALL support multiple models: Llama 3.2 3B (general analysis), Qwen 2.5 3B (Chinese optimized), and DeepSeek Coder (code analysis)
2. WHEN a model is selected, THE System SHALL verify it is installed in Ollama
3. WHEN a model is not installed, THE System SHALL provide the Ollama command to download it (e.g., `ollama pull llama3.2:3b`)
4. THE System SHALL allow switching models without losing existing reports
5. WHEN hardware is insufficient for the selected model, THE System SHALL recommend a smaller model

