# iOS Photo Sync Application

A Swift-based iOS application for syncing photos from the device's photo library to external storage.

## Features

1. **Swift Implementation**: Written entirely in Swift using standard iOS controls (UIKit)
2. **External Storage Selection**: Users can select and change the external storage location at any time using the system document picker
3. **Automatic Photo Sync**: Copies all photos from the photo library to the selected external storage without requiring manual selection
4. **Progress Tracking**: Real-time progress display showing the number of photos synced
5. **Background Task Support**: Sync process runs as a background task to ensure completion even when the app is backgrounded
6. **New Photo Detection**: Automatically detects and syncs new photos added to the library when auto-sync is enabled

## Components

### Main Files

- **ViewController.swift**: Main UI controller with all user interface elements and controls
- **PhotoSyncManager.swift**: Core sync logic including photo fetching, copying, and library observation
- **AppDelegate.swift**: Application lifecycle management
- **SceneDelegate.swift**: Scene-based lifecycle management
- **Info.plist**: Configuration file with photo library permissions
- **Main.storyboard**: Main interface storyboard
- **LaunchScreen.storyboard**: Launch screen storyboard

## Permissions

The app requires the following permissions (configured in Info.plist):

- **Photo Library Access**: To read and access all photos
- **Background Modes**: To continue syncing when the app is in the background
- **Document Browser**: To select external storage locations

## How It Works

1. **Storage Selection**: Tap "Select Storage Location" to choose a folder for syncing photos
2. **Manual Sync**: Tap "Start Sync" to begin syncing all photos to the selected location
3. **Auto-Sync**: Enable the "Auto-sync new photos" switch to automatically sync new photos as they're added
4. **Progress Monitoring**: View real-time progress with the progress bar and counter
5. **Stop Sync**: Tap "Stop Sync" to halt the current sync operation

## Technical Details

- **Minimum iOS Version**: iOS 15.0
- **Framework**: UIKit
- **Photo Access**: Uses Photos framework (PHPhotoLibrary, PHAsset)
- **File Management**: Uses FileManager and security-scoped URLs for external storage access
- **Background Processing**: Implements UIBackgroundTask for continuous operation
- **Photo Observation**: Implements PHPhotoLibraryChangeObserver for detecting new photos

## Build Requirements

- Xcode 15.0 or later
- iOS 15.0 SDK or later
- Swift 5.0 or later
