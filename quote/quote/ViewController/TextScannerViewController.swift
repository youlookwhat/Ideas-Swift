//
//  TextScannerViewController.swift
//  quote
//
//  Created by Michelle on 2025/4/22.
//  Copyright © 2025 景彬. All rights reserved.
//

import UIKit
import VisionKit

class TextScannerViewController: BaseViewController {
    
    // MARK: - Properties
    private var isSupported: Bool {
        if #available(iOS 16.0, *) {
            return DataScannerViewController.isSupported &&
            DataScannerViewController.isAvailable
        } else {
            // Fallback on earlier versions
            return false
        }
    }
    
    // MARK: - UI Components
    private lazy var textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .white
        tv.layer.cornerRadius = 8
        tv.layer.borderWidth = 1
        
        tv.layer.borderColor = UIColor.systemGray5.cgColor
        tv.font = .systemFont(ofSize: 16)
        tv.isEditable = true
        return tv
    }()
    
    private lazy var scanButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("扫描文本", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
//        button.addTarget(self, action: #selector(scanButtonTapped), for: .touchUpInside)
        button.addAction(UIAction.captureTextFromCamera(
            responder: makeCoordinator(),
                identifier: nil
        ), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        title = "文本扫描"
        view.backgroundColor = .systemBackground
        
        view.addSubview(textView)
        view.addSubview(scanButton)
        
        textView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(200)
        }
        
        scanButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(textView.snp.bottom).offset(16)
            make.height.equalTo(44)
        }
        
        textView.becomeFirstResponder()
        textView.delegate = makeCoordinator()
        
        // 是否可用
        if !self.textView.canPerformAction(#selector(UIResponder.captureTextFromCamera(_:)), withSender: self) {
            scanButton.setTitle("扫描文本不支持", for: .normal)
            scanButton.backgroundColor = .gray
            scanButton.isEnabled = false
        }
    }
    
    public class Coordinator: UIResponder, UIKeyInput, UITextViewDelegate {
        public let parent: UITextView
        
        public var hasText: Bool {
            !parent.text.isEmpty
        }
        
        public init(_ parent: UITextView) {
            self.parent = parent
        }
        
        public func insertText(_ text: String) {
            parent.text = text
        }
        
        public func deleteBackward() { }
        
        public func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text ?? ""
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(textView)
    }
        
    
    // MARK: - Actions
    @objc private func scanButtonTapped() {
        print("-------scanButtonTapped")
        if !self.textView.canPerformAction(#selector(UIResponder.captureTextFromCamera(_:)), withSender: self) {
            print("不支持文本扫描")
            return
        }
        
        let action = UIAction.captureTextFromCamera(responder: makeCoordinator(),identifier: nil)
    }
    
    @objc private func scanButtonTapped1() {
        if #available(iOS 16.0, *) {
            guard isSupported else {
                let alert = UIAlertController(
                    title: "不支持",
                    message: "您的设备不支持实时文本识别功能",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "确定", style: .default))
                present(alert, animated: true)
                return
            }
            
            let scanner = DataScannerViewController(
                recognizedDataTypes: [.text()],
                qualityLevel: .balanced,
                isHighlightingEnabled: true
            )
            
            scanner.delegate = self
            
            // 设置半屏展示
            if let sheet = scanner.sheetPresentationController {
                sheet.detents = [.custom { _ in return 291 }] // 键盘高度
                sheet.prefersGrabberVisible = true
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.preferredCornerRadius = 10
            }
            
            // 添加关闭按钮
            let closeButton = UIButton(type: .system)
            closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            closeButton.tintColor = .white
            closeButton.addTarget(self, action: #selector(dismissScanner), for: .touchUpInside)
            
            // 添加插入按钮
            let insertButton = UIButton(type: .system)
            insertButton.setTitle("插入", for: .normal)
            insertButton.setTitleColor(.white, for: .normal)
            insertButton.backgroundColor = .systemBlue
            insertButton.layer.cornerRadius = 15
            insertButton.addTarget(self, action: #selector(insertScannedText), for: .touchUpInside)
            
            scanner.view.addSubview(closeButton)
            scanner.view.addSubview(insertButton)
            
            closeButton.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(16)
                make.trailing.equalToSuperview().offset(-16)
                make.width.height.equalTo(32)
            }
            
            insertButton.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-16)
                make.centerX.equalToSuperview()
                make.width.equalTo(100)
                make.height.equalTo(30)
            }
            
            // 设置扫描区域提示文本
//            scanner.guidanceContentView?.title = "扫描文本"
//            scanner.guidanceContentView?.description = "将相机对准文本"
            
            present(scanner, animated: true) {
                try? scanner.startScanning()
            }
        }
    }
    
    @objc private func dismissScanner() {
        dismiss(animated: true)
    }
    
    @objc private func insertScannedText() {
        if let text = currentScannedText {
            // 在光标位置插入文本
            let selectedRange = textView.selectedRange
            let currentText = textView.text ?? ""
            let prefix = (currentText as NSString).substring(to: selectedRange.location)
            let suffix = (currentText as NSString).substring(from: selectedRange.location)
            textView.text = prefix + text + suffix
            
            // 更新光标位置
            let newPosition = selectedRange.location + text.count
            textView.selectedRange = NSRange(location: newPosition, length: 0)
        }
        dismiss(animated: true)
    }
    
    // 存储当前扫描的文本
    private var currentScannedText: String?
}

// MARK: - DataScannerViewControllerDelegate
extension TextScannerViewController: DataScannerViewControllerDelegate {
    @available(iOS 16.0, *)
    func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        for item in addedItems {
            if case .text(let text) = item {
                currentScannedText = text.transcript
            }
        }
    }
    
    @available(iOS 16.0, *)
    func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
        if case .text(let text) = item {
            currentScannedText = text.transcript
        }
    }
    
    @available(iOS 16.0, *)
    func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        // 处理移除的文本项
    }
    
    @available(iOS 16.0, *)
    func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
        print("扫描不可用: \(error.localizedDescription)")
    }
}
