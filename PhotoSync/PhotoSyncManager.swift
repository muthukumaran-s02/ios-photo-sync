import Foundation
import Photos
import UIKit

class PhotoSyncManager: NSObject {
    
    // MARK: - Properties
    private var isSyncing = false
    private var shouldStopSync = false
    private var photoChangeObserver: PHPhotoLibraryChangeObserver?
    private var currentStorageURL: URL?
    private var syncedPhotoIdentifiers = Set<String>()
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    // MARK: - Callbacks
    var onProgressUpdate: ((Int, Int) -> Void)?
    var onStatusUpdate: ((String) -> Void)?
    var onSyncCompleted: (() -> Void)?
    
    // MARK: - Initialization
    override init() {
        super.init()
        loadSyncedPhotoIdentifiers()
    }
    
    // MARK: - Sync Methods
    func startSync(to storageURL: URL) {
        guard !isSyncing else {
            print("Sync already in progress")
            return
        }
        
        isSyncing = true
        shouldStopSync = false
        currentStorageURL = storageURL
        
        // Start background task
        beginBackgroundTask()
        
        // Fetch all photos
        fetchAndSyncAllPhotos(to: storageURL)
    }
    
    func stopSync() {
        shouldStopSync = true
        isSyncing = false
        endBackgroundTask()
        onStatusUpdate?("Sync stopped")
    }
    
    // MARK: - Photo Fetching and Syncing
    private func fetchAndSyncAllPhotos(to storageURL: URL) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        let totalCount = allPhotos.count
        
        onStatusUpdate?("Found \(totalCount) photos to sync")
        onProgressUpdate?(0, totalCount)
        
        // Process photos in background
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            var syncedCount = 0
            let imageManager = PHImageManager.default()
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            requestOptions.deliveryMode = .highQualityFormat
            requestOptions.isNetworkAccessAllowed = true
            
            allPhotos.enumerateObjects { asset, index, stop in
                if self.shouldStopSync {
                    stop.pointee = true
                    return
                }
                
                // Skip if already synced
                if self.syncedPhotoIdentifiers.contains(asset.localIdentifier) {
                    syncedCount += 1
                    self.onProgressUpdate?(syncedCount, totalCount)
                    return
                }
                
                self.onStatusUpdate?("Syncing photo \(index + 1) of \(totalCount)")
                
                // Request image data
                imageManager.requestImageDataAndOrientation(for: asset, options: requestOptions) { data, dataUTI, orientation, info in
                    guard let imageData = data else { return }
                    
                    // Generate filename
                    let filename = self.generateFilename(for: asset)
                    let fileURL = storageURL.appendingPathComponent(filename)
                    
                    do {
                        // Write image to storage
                        try imageData.write(to: fileURL)
                        
                        // Mark as synced
                        self.syncedPhotoIdentifiers.insert(asset.localIdentifier)
                        syncedCount += 1
                        
                        // Update progress
                        self.onProgressUpdate?(syncedCount, totalCount)
                        
                    } catch {
                        print("Failed to write photo: \(error)")
                    }
                }
            }
            
            // Save synced identifiers
            self.saveSyncedPhotoIdentifiers()
            
            // Complete sync
            if !self.shouldStopSync {
                self.isSyncing = false
                self.endBackgroundTask()
                self.onStatusUpdate?("Sync completed: \(syncedCount) photos")
                self.onSyncCompleted?()
            }
        }
    }
    
    // MARK: - Photo Library Observer
    func startObservingNewPhotos(storageURL: URL) {
        currentStorageURL = storageURL
        PHPhotoLibrary.shared().register(self)
    }
    
    func stopObservingNewPhotos() {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
        currentStorageURL = nil
    }
    
    // MARK: - Helper Methods
    private func generateFilename(for asset: PHAsset) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        
        let dateString = asset.creationDate.map { dateFormatter.string(from: $0) } ?? "unknown"
        let identifier = String(asset.localIdentifier.prefix(8))
        
        return "photo_\(dateString)_\(identifier).jpg"
    }
    
    private func syncSinglePhoto(_ asset: PHAsset, to storageURL: URL) {
        guard !syncedPhotoIdentifiers.contains(asset.localIdentifier) else {
            return
        }
        
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.isNetworkAccessAllowed = true
        
        imageManager.requestImageDataAndOrientation(for: asset, options: requestOptions) { [weak self] data, dataUTI, orientation, info in
            guard let self = self,
                  let imageData = data else { return }
            
            let filename = self.generateFilename(for: asset)
            let fileURL = storageURL.appendingPathComponent(filename)
            
            do {
                try imageData.write(to: fileURL)
                self.syncedPhotoIdentifiers.insert(asset.localIdentifier)
                self.saveSyncedPhotoIdentifiers()
                self.onStatusUpdate?("New photo synced: \(filename)")
            } catch {
                print("Failed to sync new photo: \(error)")
            }
        }
    }
    
    // MARK: - Background Task
    private func beginBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
    }
    
    private func endBackgroundTask() {
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
    
    // MARK: - Persistence
    private func saveSyncedPhotoIdentifiers() {
        let identifiersArray = Array(syncedPhotoIdentifiers)
        UserDefaults.standard.set(identifiersArray, forKey: "syncedPhotoIdentifiers")
    }
    
    private func loadSyncedPhotoIdentifiers() {
        if let identifiersArray = UserDefaults.standard.array(forKey: "syncedPhotoIdentifiers") as? [String] {
            syncedPhotoIdentifiers = Set(identifiersArray)
        }
    }
}

// MARK: - PHPhotoLibraryChangeObserver
extension PhotoSyncManager: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let storageURL = currentStorageURL else { return }
        
        // Fetch all photos to check for new additions
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        if let changes = changeInstance.changeDetails(for: allPhotos) {
            // Check for inserted photos
            changes.insertedObjects.forEach { asset in
                onStatusUpdate?("New photo detected, syncing...")
                syncSinglePhoto(asset, to: storageURL)
            }
        }
    }
}
