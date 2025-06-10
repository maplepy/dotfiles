# ProtonDB Search Plugin - Comprehensive Documentation

## Table of Contents
1. [Overview](#overview)
2. [System Architecture](#system-architecture)
3. [Data Flow](#data-flow)
4. [Search Algorithm](#search-algorithm)
5. [API Integration](#api-integration)
6. [Installation Process](#installation-process)
7. [Error Handling](#error-handling)

## Overview

The ProtonDB Search Plugin is an Albert launcher extension that enables users to search for Steam game compatibility ratings directly from the Albert interface. The plugin integrates with ProtonDB's community-driven database to provide real-time compatibility information for Windows games running on Linux via Steam's Proton.

## System Architecture

```mermaid
graph TB
    subgraph "Albert Launcher"
        UI[User Interface]
        Core[Albert Core]
        PluginMgr[Plugin Manager]
    end
    
    subgraph "ProtonDB Plugin"
        Plugin[Plugin Class]
        SearchEngine[Search Engine]
        Cache[Result Cache]
        APIClient[API Client]
    end
    
    subgraph "Data Sources"
        SteamDB[(Steam Database<br/>~250k games)]
        ProtonAPI[ProtonDB API]
        SteamAPI[Steam Web API]
    end
    
    subgraph "External Services"
        ProtonWeb[ProtonDB Website]
        SteamStore[Steam Store]
    end
    
    UI --> Core
    Core --> PluginMgr
    PluginMgr --> Plugin
    Plugin --> SearchEngine
    Plugin --> Cache
    Plugin --> APIClient
    
    SearchEngine --> SteamDB
    APIClient --> ProtonAPI
    APIClient --> SteamAPI
    
    Plugin --> ProtonWeb
    Plugin --> SteamStore
    
    style Plugin fill:#1e3a8a,color:#ffffff
    style SearchEngine fill:#581c87,color:#ffffff
    style Cache fill:#c2410c,color:#ffffff
    style APIClient fill:#166534,color:#ffffff
```



## Data Flow

### Search Process Flow

```mermaid
flowchart TD
    Start([User Input: proton game_name]) --> Parse[Parse Query]
    Parse --> LoadDB{Steam DB Loaded?}
    
    LoadDB -->|No| DownloadDB[Download Steam Database]
    LoadDB -->|Yes| Search[Search Local Database]
    DownloadDB --> Search
    
    Search --> Filter[Filter Results]
    Filter --> Sort[Sort by Relevance]
    Sort --> Cache{Check Cache}
    
    Cache -->|Hit| Display[Display Results]
    Cache -->|Miss| API[Query ProtonDB API]
    
    API --> RateLimit[Apply Rate Limiting]
    RateLimit --> StoreCache[Store in Cache]
    StoreCache --> Display
    
    Display --> UserAction{User Action}
    UserAction -->|Open ProtonDB| ProtonSite[Open ProtonDB Page]
    UserAction -->|Open Steam| SteamSite[Open Steam Page]
    UserAction -->|Copy Info| Clipboard[Copy to Clipboard]
    
    ProtonSite --> End([End])
    SteamSite --> End
    Clipboard --> End
    
    style Start fill:#166534,color:#ffffff
    style End fill:#dc2626,color:#ffffff
    style API fill:#1e40af,color:#ffffff
    style Cache fill:#c2410c,color:#ffffff
```



## Search Algorithm

### Match Prioritization Logic

```mermaid
flowchart LR
    Input[Search Query] --> Normalize[Normalize Query]
    Normalize --> Compare[Compare with Game Names]
    
    Compare --> Exact{Exact Match?}
    Compare --> StartsWith{Starts With?}
    Compare --> Contains{Contains?}
    
    Exact -->|Yes| ExactList[Exact Matches<br/>Priority: 1]
    StartsWith -->|Yes| StartsWithList[StartsWith Matches<br/>Priority: 2]
    Contains -->|Yes| ContainsList[Contains Matches<br/>Priority: 3]
    
    ExactList --> Filter[Filter Demos/Trailers]
    StartsWithList --> Filter
    ContainsList --> Filter
    
    Filter --> SortLength[Sort by Name Length<br/>Shorter = Better]
    SortLength --> Combine[Combine Results<br/>Maintain Priority Order]
    Combine --> Limit[Limit to Top Results]
    
    style ExactList fill:#166534,color:#ffffff
    style StartsWithList fill:#1e40af,color:#ffffff
    style ContainsList fill:#7c3aed,color:#ffffff
```



## API Integration

### ProtonDB API Flow

```mermaid
sequenceDiagram
    participant Plugin
    participant RateLimiter
    participant ProtonDB
    participant Cache
    
    Plugin->>RateLimiter: Request API call
    RateLimiter->>RateLimiter: Check last request time
    
    alt Rate limit OK
        RateLimiter->>ProtonDB: GET /api/v1/reports/summaries/{appid}.json
        ProtonDB-->>RateLimiter: Response (200/404)
        RateLimiter-->>Plugin: Return data
        Plugin->>Cache: Store result
    else Rate limited
        RateLimiter->>RateLimiter: Wait 0.2 seconds
        RateLimiter->>ProtonDB: GET /api/v1/reports/summaries/{appid}.json
        ProtonDB-->>RateLimiter: Response
        RateLimiter-->>Plugin: Return data
    end
    
    Note over Plugin,Cache: All API responses cached for 5 minutes
```



## Installation Process

### Installation Workflow

```mermaid
flowchart TD
    Start([Run install.sh]) --> CheckAlbert{Albert Installed?}
    
    CheckAlbert -->|No| WarnAlbert[Warning: Albert not found]
    CheckAlbert -->|Yes| SuccessAlbert[✓ Albert found]
    
    WarnAlbert --> CheckDeps[Check Python Dependencies]
    SuccessAlbert --> CheckDeps
    
    CheckDeps --> CheckRequests{requests library?}
    CheckRequests -->|No| InstallRequests[pip install requests]
    CheckRequests -->|Yes| SuccessDeps[✓ Dependencies OK]
    
    InstallRequests --> InstallError{Install Success?}
    InstallError -->|No| ErrorExit[❌ Exit with Error]
    InstallError -->|Yes| SuccessDeps
    
    SuccessDeps --> FindPluginDir[Find Albert Plugin Directory]
    FindPluginDir --> CheckDir{Directory Exists?}
    
    CheckDir -->|No| CreateDir[Create Plugin Directory]
    CheckDir -->|Yes| CheckExisting{Plugin Exists?}
    CreateDir --> CheckExisting
    
    CheckExisting -->|Yes| PromptOverwrite{Overwrite?}
    CheckExisting -->|No| CopyFiles[Copy Plugin Files]
    
    PromptOverwrite -->|No| CancelInstall[Cancel Installation]
    PromptOverwrite -->|Yes| RemoveOld[Remove Old Plugin]
    RemoveOld --> CopyFiles
    
    CopyFiles --> CopySuccess{Copy Success?}
    CopySuccess -->|No| CopyError[❌ Copy Failed]
    CopySuccess -->|Yes| InstallComplete[✅ Installation Complete]
    
    InstallComplete --> Instructions[Show Usage Instructions]
    Instructions --> End([End])
    
    ErrorExit --> End
    CancelInstall --> End
    CopyError --> End
    
    style Start fill:#166534,color:#ffffff
    style InstallComplete fill:#059669,color:#ffffff
    style ErrorExit fill:#dc2626,color:#ffffff
    style CopyError fill:#dc2626,color:#ffffff
```

### File Structure After Installation

```mermaid
graph TD
    subgraph "Albert Plugin Directory"
        A[~/.local/share/albert/python/plugins/]
        A --> B[protondb/]
        B --> C[__init__.py]
        B --> D[README.md]
        B --> E[requirements.txt]
        B --> F[test_search.py]
        B --> G[install.sh]
        B --> H[data/]
        H --> I[steamapi.json]
        B --> J[test_data/]
        J --> K[steamapi.json]
    end
    
    style A fill:#1e3a8a,color:#ffffff
    style B fill:#581c87,color:#ffffff
    style C fill:#166534,color:#ffffff
    style I fill:#1e40af,color:#ffffff
```

## Error Handling

### Error Handling Strategy

```mermaid
flowchart TD
    Error[Error Occurs] --> Type{Error Type}
    
    Type -->|Network Error| NetworkHandler[Network Error Handler]
    Type -->|API Error| APIHandler[API Error Handler]
    Type -->|File Error| FileHandler[File Error Handler]
    Type -->|Albert Error| AlbertHandler[Albert Error Handler]
    
    NetworkHandler --> Retry{Retry Available?}
    APIHandler --> RateLimit{Rate Limited?}
    FileHandler --> Fallback{Fallback Available?}
    AlbertHandler --> SafeLog[Use Safe Logging]
    
    Retry -->|Yes| RetryRequest[Retry with Backoff]
    Retry -->|No| LogError[Log Error]
    
    RateLimit -->|Yes| Wait[Wait and Retry]
    RateLimit -->|No| LogAPI[Log API Error]
    
    Fallback -->|Yes| UseFallback[Use Cached/Default Data]
    Fallback -->|No| LogFile[Log File Error]
    
    SafeLog --> Continue[Continue Execution]
    
    RetryRequest --> Success{Success?}
    Success -->|Yes| Continue
    Success -->|No| LogError
    
    Wait --> APIHandler
    LogError --> Continue
    LogAPI --> Continue
    UseFallback --> Continue
    LogFile --> Continue
    
    style Error fill:#dc2626,color:#ffffff
    style Continue fill:#166534,color:#ffffff
    style SafeLog fill:#1e40af,color:#ffffff
```

### Fallback Mechanisms

```mermaid
graph LR
    subgraph "Logging Fallbacks"
        A[albert.warning] --> B{Function Exists?}
        B -->|No| C[print to stderr]
        B -->|Yes| D[Use Albert logging]
    end
    
    subgraph "Data Fallbacks"
        E[API Request] --> F{Success?}
        F -->|No| G[Check Cache]
        G --> H{Cache Available?}
        H -->|No| I[Return Unknown rating]
        H -->|Yes| J[Use Cached Data]
        F -->|Yes| K[Use Fresh Data]
    end
    
    subgraph "Search Fallbacks"
        L[Local Search] --> M{Database Available?}
        M -->|No| N[Download Database]
        N --> O{Download Success?}
        O -->|No| P[Return Empty Results]
        O -->|Yes| Q[Perform Search]
        M -->|Yes| Q
    end
    
    style C fill:#dc2626,color:#ffffff
    style I fill:#dc2626,color:#ffffff
    style P fill:#dc2626,color:#ffffff
    style J fill:#1e40af,color:#ffffff
    style K fill:#166534,color:#ffffff
    style Q fill:#166534,color:#ffffff
```



---

## Conclusion

This comprehensive documentation provides a complete technical overview of the ProtonDB Search Plugin for Albert. The plugin demonstrates best practices in Python development, API integration, error handling, and user experience design. The modular architecture ensures maintainability and extensibility for future enhancements.

For additional information, please refer to the README.md, CHANGELOG.md, and the extensive test suite included with the plugin.