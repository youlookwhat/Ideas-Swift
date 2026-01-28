//
//  LivePhotoViewController.swift
//  quote
//
//  Created by GitHub Copilot on 2026/01/28.
//  Copyright © 2026 景彬. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class LivePhotoViewController: BaseViewController {
    
    // MARK: - Properties
    private var selectedLivePhoto: PHLivePhoto?
    
    // MARK: - UI Components
    private lazy var selectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("选择Live Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(selectLivePhoto), for: .touchUpInside)
        return button
    }()
    
    private lazy var livePhotoView: PHLivePhotoView = {
        let view = PHLivePhotoView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.isHidden = true
        return view
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "暂未选择Live Photo\n点击下方按钮选择"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "长按Live Photo可播放动画效果"
        label.textAlignment = .center
        label.textColor = .systemGray2
        label.font = UIFont.systemFont(ofSize: 14)
        label.isHidden = true
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideTitleLayout()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Live Photo"
        view.backgroundColor = .systemBackground
        
        view.addSubview(livePhotoView)
        view.addSubview(placeholderLabel)
        view.addSubview(selectButton)
        view.addSubview(instructionLabel)
        
        livePhotoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-60)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(livePhotoView.snp.width)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.center.equalTo(livePhotoView)
            make.width.equalToSuperview().offset(-80)
        }
        
        selectButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(livePhotoView.snp.bottom).offset(30)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        instructionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(selectButton.snp.bottom).offset(20)
            make.width.equalToSuperview().offset(-40)
        }
    }
    
    // MARK: - Actions
    @objc private func selectLivePhoto() {
        checkPhotoLibraryPermission { [weak self] granted in
            if granted {
                self?.presentPHPicker()
            } else {
                self?.showPermissionAlert()
            }
        }
    }
    
    private func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized, .limited:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized || newStatus == .limited)
                }
            }
        @unknown default:
            completion(false)
        }
    }
    
    private func presentPHPicker() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = 1
        configuration.filter = .livePhotos
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func showPermissionAlert() {
        let alert = UIAlertController(
            title: "需要照片权限",
            message: "请在设置中允许访问照片库以选择Live Photo",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "去设置", style: .default) { _ in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        })
        
        present(alert, animated: true)
    }
    
    private func displayLivePhoto(_ livePhoto: PHLivePhoto) {
        selectedLivePhoto = livePhoto
        livePhotoView.livePhoto = livePhoto
        livePhotoView.isHidden = false
        placeholderLabel.isHidden = true
        instructionLabel.isHidden = false
        selectButton.setTitle("重新选择", for: .normal)
        
        // Enable playback hint
        livePhotoView.startPlayback(with: .hint)
    }
}

// MARK: - PHPickerViewControllerDelegate
extension LivePhotoViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let result = results.first else { return }
        
        // Check if the selected item can provide a Live Photo
        if result.itemProvider.canLoadObject(ofClass: PHLivePhoto.self) {
            result.itemProvider.loadObject(ofClass: PHLivePhoto.self) { [weak self] livePhoto, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error loading Live Photo: \(error)")
                        self?.showErrorAlert()
                        return
                    }
                    
                    if let livePhoto = livePhoto as? PHLivePhoto {
                        self?.displayLivePhoto(livePhoto)
                    } else {
                        self?.showErrorAlert()
                    }
                }
            }
        } else {
            showErrorAlert()
        }
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "加载失败",
            message: "无法加载选中的Live Photo，请重试",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}
