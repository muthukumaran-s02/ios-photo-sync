import UIKit
import Photos

class ViewController: UIViewController {
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Photo Sync"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Ready to sync"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let storagePathLabel: UILabel = {
        let label = UILabel()
        label.text = "No storage location selected"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let selectStorageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Storage Location", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let startSyncButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Sync", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.isEnabled = false
        button.alpha = 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stopSyncButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Stop Sync", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.isEnabled = false
        button.alpha = 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.progress = 0.0
        return progress
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.text = "0 / 0 photos synced"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let autoSyncSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.isOn = false
        return switchControl
    }()
    
    private let autoSyncLabel: UILabel = {
        let label = UILabel()
        label.text = "Auto-sync new photos"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties
    private let photoSyncManager = PhotoSyncManager()
    private var selectedStorageURL: URL?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPhotoSyncManager()
        requestPhotoLibraryAccess()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        view.addSubview(statusLabel)
        view.addSubview(storagePathLabel)
        view.addSubview(selectStorageButton)
        view.addSubview(startSyncButton)
        view.addSubview(stopSyncButton)
        view.addSubview(progressView)
        view.addSubview(progressLabel)
        view.addSubview(autoSyncLabel)
        view.addSubview(autoSyncSwitch)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            statusLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            storagePathLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 30),
            storagePathLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            storagePathLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            selectStorageButton.topAnchor.constraint(equalTo: storagePathLabel.bottomAnchor, constant: 20),
            selectStorageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            selectStorageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            selectStorageButton.heightAnchor.constraint(equalToConstant: 50),
            
            progressView.topAnchor.constraint(equalTo: selectStorageButton.bottomAnchor, constant: 40),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            progressLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 10),
            progressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            startSyncButton.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 30),
            startSyncButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startSyncButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            startSyncButton.heightAnchor.constraint(equalToConstant: 50),
            
            stopSyncButton.topAnchor.constraint(equalTo: startSyncButton.bottomAnchor, constant: 15),
            stopSyncButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stopSyncButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stopSyncButton.heightAnchor.constraint(equalToConstant: 50),
            
            autoSyncLabel.topAnchor.constraint(equalTo: stopSyncButton.bottomAnchor, constant: 40),
            autoSyncLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            autoSyncSwitch.centerYAnchor.constraint(equalTo: autoSyncLabel.centerYAnchor),
            autoSyncSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        selectStorageButton.addTarget(self, action: #selector(selectStorageLocation), for: .touchUpInside)
        startSyncButton.addTarget(self, action: #selector(startSync), for: .touchUpInside)
        stopSyncButton.addTarget(self, action: #selector(stopSync), for: .touchUpInside)
        autoSyncSwitch.addTarget(self, action: #selector(autoSyncToggled), for: .valueChanged)
    }
    
    private func setupPhotoSyncManager() {
        photoSyncManager.onProgressUpdate = { [weak self] current, total in
            DispatchQueue.main.async {
                self?.updateProgress(current: current, total: total)
            }
        }
        
        photoSyncManager.onStatusUpdate = { [weak self] status in
            DispatchQueue.main.async {
                self?.updateStatus(status)
            }
        }
        
        photoSyncManager.onSyncCompleted = { [weak self] in
            DispatchQueue.main.async {
                self?.syncCompleted()
            }
        }
    }
    
    // MARK: - Photo Library Access
    private func requestPhotoLibraryAccess() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .authorized, .limited:
                    self?.statusLabel.text = "Photo access granted"
                case .denied, .restricted:
                    self?.statusLabel.text = "Photo access denied"
                    self?.showAlert(title: "Access Denied", message: "Please enable photo access in Settings to use this app.")
                case .notDetermined:
                    self?.statusLabel.text = "Photo access not determined"
                @unknown default:
                    break
                }
            }
        }
    }
    
    // MARK: - Actions
    @objc private func selectStorageLocation() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        documentPicker.shouldShowFileExtensions = true
        present(documentPicker, animated: true)
    }
    
    @objc private func startSync() {
        guard let storageURL = selectedStorageURL else {
            showAlert(title: "No Storage", message: "Please select a storage location first.")
            return
        }
        
        startSyncButton.isEnabled = false
        startSyncButton.alpha = 0.5
        stopSyncButton.isEnabled = true
        stopSyncButton.alpha = 1.0
        
        photoSyncManager.startSync(to: storageURL)
    }
    
    @objc private func stopSync() {
        photoSyncManager.stopSync()
        
        startSyncButton.isEnabled = true
        startSyncButton.alpha = 1.0
        stopSyncButton.isEnabled = false
        stopSyncButton.alpha = 0.5
    }
    
    @objc private func autoSyncToggled() {
        if autoSyncSwitch.isOn {
            guard let storageURL = selectedStorageURL else {
                autoSyncSwitch.setOn(false, animated: true)
                showAlert(title: "No Storage", message: "Please select a storage location first.")
                return
            }
            photoSyncManager.startObservingNewPhotos(storageURL: storageURL)
            statusLabel.text = "Monitoring for new photos"
        } else {
            photoSyncManager.stopObservingNewPhotos()
            statusLabel.text = "Auto-sync disabled"
        }
    }
    
    // MARK: - Update Methods
    private func updateProgress(current: Int, total: Int) {
        let progress = total > 0 ? Float(current) / Float(total) : 0
        progressView.progress = progress
        progressLabel.text = "\(current) / \(total) photos synced"
    }
    
    private func updateStatus(_ status: String) {
        statusLabel.text = status
    }
    
    private func syncCompleted() {
        startSyncButton.isEnabled = true
        startSyncButton.alpha = 1.0
        stopSyncButton.isEnabled = false
        stopSyncButton.alpha = 0.5
        statusLabel.text = "Sync completed"
    }
    
    // MARK: - Helper Methods
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UIDocumentPickerDelegate
extension ViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        
        selectedStorageURL = url
        
        // Start accessing security-scoped resource
        if url.startAccessingSecurityScopedResource() {
            storagePathLabel.text = "Storage: \(url.lastPathComponent)"
            startSyncButton.isEnabled = true
            startSyncButton.alpha = 1.0
            
            // Save the bookmark for later access
            do {
                let bookmarkData = try url.bookmarkData(options: .minimalBookmark, includingResourceValuesForKeys: nil, relativeTo: nil)
                UserDefaults.standard.set(bookmarkData, forKey: "storageBookmark")
            } catch {
                print("Failed to create bookmark: \(error)")
            }
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        statusLabel.text = "Storage selection cancelled"
    }
}
