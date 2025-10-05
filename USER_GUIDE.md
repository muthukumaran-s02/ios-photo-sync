# iOS Photo Sync - User Guide

## Getting Started

### Prerequisites
- iOS device running iOS 15.0 or later
- Photos in your photo library
- External storage location (iCloud Drive, Files app folder, etc.)

### First Time Setup

1. **Launch the App**
   - Open Photo Sync on your iOS device
   - The app will request photo library access
   - Tap "Allow" to grant access

2. **Select Storage Location**
   - Tap the "Select Storage Location" button
   - Navigate to your preferred storage folder
   - This could be:
     - iCloud Drive folder
     - On My iPhone folder
     - Any folder accessible via Files app
   - Tap the folder to select it
   - The selected path will be displayed on screen

## Features

### Manual Sync

**To sync all photos manually:**

1. Ensure you've selected a storage location
2. Tap "Start Sync"
3. Watch the progress bar and counter
4. Wait for completion message
5. Tap "Stop Sync" to cancel at any time

**What happens during sync:**
- All photos from your library are copied
- Progress is shown in real-time
- Already-synced photos are skipped (won't be copied again)
- The process continues even if you switch apps or lock your phone

### Auto-Sync New Photos

**To automatically sync new photos as you take them:**

1. Select a storage location first
2. Enable the "Auto-sync new photos" toggle switch
3. New photos will be automatically copied to storage

**How it works:**
- The app monitors your photo library
- When new photos are added, they're automatically synced
- You'll see status updates for each new photo
- No manual intervention needed

### Changing Storage Location

You can change your storage location at any time:

1. Tap "Select Storage Location" again
2. Choose a different folder
3. Previously synced photos tracking is maintained
4. Next sync will use the new location

## Understanding the Interface

### Status Display
- **Title**: "Photo Sync" - App name
- **Status Label**: Shows current app status
  - "Ready to sync" - Idle
  - "Found X photos to sync" - Sync starting
  - "Syncing photo X of Y" - Active sync
  - "Sync completed" - Finished
  - "New photo detected" - Auto-sync active
  - "Photo access denied" - Need to grant permission

### Storage Path
- Shows the currently selected storage location
- "No storage location selected" if none chosen

### Progress Display
- **Progress Bar**: Visual progress indicator
- **Counter**: Shows "X / Y photos synced"

### Buttons
- **Select Storage Location** (Blue)
  - Opens folder picker
  - Always available
  
- **Start Sync** (Green)
  - Begins syncing all photos
  - Enabled only after selecting storage
  - Disabled during active sync
  
- **Stop Sync** (Red)
  - Halts current sync operation
  - Enabled only during active sync

### Auto-Sync Toggle
- **OFF**: Manual sync only
- **ON**: Automatically syncs new photos

## Tips and Best Practices

### Efficient Syncing
- **First Sync**: May take time depending on library size
- **Subsequent Syncs**: Faster - only new photos are copied
- **Background Operation**: Safe to switch apps or lock phone during sync

### Storage Management
- **Check Space**: Ensure external storage has enough space
- **Organized Folders**: Create a dedicated "Photo Sync" folder
- **Regular Backups**: Periodically verify your synced photos

### Troubleshooting

**"Photo access denied" message:**
1. Open iOS Settings
2. Find Photo Sync app
3. Tap "Photos"
4. Select "All Photos"

**Sync not progressing:**
1. Check internet connection (for iCloud storage)
2. Verify storage location still accessible
3. Try stopping and restarting sync
4. Ensure storage has available space

**Auto-sync not working:**
1. Verify toggle is ON
2. Check storage location is selected
3. Ensure app has photo library access
4. Keep app installed (don't delete)

**Can't select storage location:**
1. Ensure Files app is working
2. Try selecting a different location
3. Check if folder permissions are correct

## Privacy and Security

- **Local Processing**: Photos are copied directly, no cloud processing
- **No Internet Required**: Works offline (except for iCloud storage)
- **Permissions**: Only accesses photo library and selected storage
- **Security**: Uses iOS security-scoped bookmarks for storage access
- **Data**: No tracking, no analytics, no data collection

## Technical Notes

- **File Format**: Photos saved as JPEG files
- **File Naming**: `photo_YYYY-MM-DD_HH-mm-ss_<id>.jpg`
- **Duplicate Prevention**: Already-synced photos are tracked
- **Background Mode**: Sync continues when app is backgrounded
- **Memory Efficient**: Processes one photo at a time

## Support

For issues or questions:
1. Check this guide for common solutions
2. Verify all permissions are granted
3. Try restarting the app
4. Ensure iOS is up to date (15.0+)
