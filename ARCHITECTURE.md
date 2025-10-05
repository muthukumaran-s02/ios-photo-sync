# iOS Photo Sync - Technical Architecture

## Application Structure

```
PhotoSync.app
├── AppDelegate.swift          - App lifecycle management
├── SceneDelegate.swift        - Scene lifecycle management
├── ViewController.swift       - Main UI and user interactions
├── PhotoSyncManager.swift     - Core sync logic and photo management
├── Info.plist                - Permissions and configuration
├── Main.storyboard           - Main interface layout
└── LaunchScreen.storyboard   - Launch screen

```

## Component Breakdown

### 1. ViewController.swift (Main UI Controller)

**Responsibilities:**
- User interface presentation and management
- User interaction handling (button taps, switch toggles)
- Storage location selection via UIDocumentPicker
- Display sync progress and status updates
- Photo library permission requests

**UI Components:**
- Title and status labels
- Storage path display
- Select storage button (UIButton)
- Start/Stop sync buttons (UIButton)
- Progress bar (UIProgressView)
- Progress counter label
- Auto-sync toggle (UISwitch)

**Key Methods:**
- `selectStorageLocation()` - Opens document picker for folder selection
- `startSync()` - Initiates photo sync process
- `stopSync()` - Halts ongoing sync
- `autoSyncToggled()` - Enables/disables automatic new photo detection
- `updateProgress()` - Updates UI with sync progress

### 2. PhotoSyncManager.swift (Core Sync Engine)

**Responsibilities:**
- Photo library access and enumeration
- File copying to external storage
- Background task management
- Progress tracking and callbacks
- New photo detection and monitoring
- Persistence of sync state

**Key Features:**

**Photo Fetching:**
```swift
fetchAndSyncAllPhotos(to: URL)
- Fetches all photos from photo library using PHAsset
- No user selection required - automatic full library sync
- Sorts by creation date
```

**Background Processing:**
```swift
beginBackgroundTask() / endBackgroundTask()
- Registers background task with iOS
- Allows sync to continue when app is backgrounded
- Properly terminates when complete
```

**Progress Tracking:**
```swift
onProgressUpdate: (Int, Int) -> Void
- Callback with (current, total) photo count
- Real-time updates during sync
- Thread-safe UI updates via DispatchQueue.main
```

**New Photo Monitoring:**
```swift
PHPhotoLibraryChangeObserver protocol
- Listens for photo library changes
- Automatically syncs newly added photos
- Enabled via auto-sync toggle
```

**State Persistence:**
```swift
syncedPhotoIdentifiers: Set<String>
- Tracks already-synced photos by identifier
- Prevents duplicate copies
- Persisted in UserDefaults
```

### 3. Info.plist Configuration

**Required Permissions:**
```xml
NSPhotoLibraryUsageDescription
- Required for reading photo library
- User-facing explanation text

UIBackgroundModes
- fetch: Background fetch capability
- processing: Background processing tasks

LSSupportsOpeningDocumentsInPlace
- Allows access to external storage
```

## Data Flow

```
User Action Flow:
1. User taps "Select Storage Location"
   └─> UIDocumentPicker presented
       └─> User selects folder
           └─> Security-scoped bookmark created
               └─> Storage path displayed

2. User taps "Start Sync"
   └─> PhotoSyncManager.startSync(to: URL)
       └─> Background task begins
           └─> All photos fetched via PHAsset
               └─> Each photo processed:
                   ├─> Check if already synced
                   ├─> Request image data
                   ├─> Generate unique filename
                   ├─> Write to storage
                   ├─> Update progress
                   └─> Mark as synced
               └─> Sync completion callback
                   └─> UI updated

3. User enables "Auto-sync new photos"
   └─> PhotoSyncManager registers as PHPhotoLibraryChangeObserver
       └─> photoLibraryDidChange called when new photos added
           └─> New photos automatically synced
```

## Key Design Decisions

### 1. Background Task Support
- Uses `UIBackgroundTaskIdentifier` for iOS background execution
- Ensures sync completes even if app is backgrounded
- Properly manages task lifecycle

### 2. Progress Tracking
- Real-time callbacks from sync manager to view controller
- Thread-safe UI updates via `DispatchQueue.main.async`
- Visual progress bar + numeric counter

### 3. Storage Selection
- Uses `UIDocumentPickerViewController` for standard iOS folder picker
- Security-scoped bookmarks for persistent access
- User can change storage location anytime

### 4. Duplicate Prevention
- Maintains Set of synced photo identifiers
- Persists to UserDefaults for app restarts
- Skips already-synced photos for efficiency

### 5. New Photo Detection
- Implements `PHPhotoLibraryChangeObserver` protocol
- Only active when auto-sync is enabled
- Automatically processes new additions

### 6. File Naming
- Unique filenames with date and identifier
- Format: `photo_YYYY-MM-DD_HH-mm-ss_<identifier>.jpg`
- Prevents overwrites and conflicts

## Threading Model

- **Main Thread**: All UI operations and user interactions
- **Background Thread**: Photo enumeration and file I/O operations
- **Callbacks**: Posted to main thread for UI updates

## Error Handling

- Photo access permission checks
- File write error handling
- Background task expiration handling
- User-friendly error alerts

## Scalability Considerations

- Processes photos one at a time to manage memory
- Skips already-synced photos for efficiency
- Background task ensures large libraries can sync completely
- Progress tracking for user feedback on long operations
