//
//  ShareImageGeneratorViewController.swift
//  quote
//
//  Created by Michelle on 2025/8/7.
//  Copyright © 2025 景彬. All rights reserved.
//

import UIKit
import Photos
import SnapKit

class ShareImageGeneratorViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    private let containerView = UIView()
    
    // 优化：提高缩放因子以获得更清晰的图片
    private let scaleFactor: CGFloat = 1.0
    
    private let shareImageModels: [ShareImageModel] = [
        ShareImageModel(title: "夏日促销", subtitle: "全场商品8折起", bgColor: .systemRed),
        ShareImageModel(title: "新品上市", subtitle: "限时尝鲜价", bgColor: .systemBlue),
        ShareImageModel(title: "会员专享", subtitle: "积分翻倍兑好礼", bgColor: .systemGreen),
        ShareImageModel(title: "节日祝福", subtitle: "中秋团圆，好礼相送", bgColor: .systemOrange),
        ShareImageModel(title: "年终大促", subtitle: "跨年满减叠加用", bgColor: .systemPurple),
        ShareImageModel(title: "限时秒杀", subtitle: "每日10点准时开抢", bgColor: .systemPink),
        ShareImageModel(title: "满减活动", subtitle: "满200减50，上不封顶", bgColor: .systemTeal)
    ]
    
    private let actionSheet = UIAlertController(
        title: nil,
        message: nil,
        preferredStyle: .actionSheet
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupShareImages()
        setupActionSheet()
    }
    
    private func setupNavigationBar() {
        title = "生成分享图"
        view.backgroundColor = .systemBackground
        
        let menuButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: self,
            action: #selector(menuButtonTapped)
        )
        navigationItem.rightBarButtonItem = menuButton
    }
    
    private func setupActionSheet() {
        let saveAction = UIAlertAction(title: "保存图片", style: .default) { [weak self] _ in
            self?.handleSaveImage()
        }
        saveAction.setValue(UIImage(systemName: "photo"), forKey: "image")
        
        let shareAction = UIAlertAction(title: "分享图片", style: .default) { [weak self] _ in
            self?.handleShareImage()
        }
        shareAction.setValue(UIImage(systemName: "square.and.arrow.up"), forKey: "image")
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        
        actionSheet.addAction(saveAction)
        actionSheet.addAction(shareAction)
        actionSheet.addAction(cancelAction)
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.barButtonItem = navigationItem.rightBarButtonItem
        }
    }
    
    private func setupUI() {
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        
        containerView.backgroundColor = .systemBackground
        scrollView.addSubview(containerView)
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 24
        contentStackView.alignment = .center
        contentStackView.distribution = .equalSpacing
        containerView.addSubview(contentStackView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(containerView).inset(20)
            make.leading.trailing.equalTo(containerView).inset(30)
        }
    }
    
    private func setupShareImages() {
        for model in shareImageModels {
            let cardView = ShareImageCardView(model: model, scaleFactor: scaleFactor)
            contentStackView.addArrangedSubview(cardView)
            cardView.snp.makeConstraints { make in
                make.width.equalTo(contentStackView)
                make.height.equalTo(320)
            }
        }
    }
    
    @objc private func menuButtonTapped() {
        present(actionSheet, animated: true)
    }
    
    private func handleSaveImage() {
        generateHighResolutionImage { [weak self] image in
            guard let self = self, let image = image else {
                self?.showErrorAlert(message: "图片生成失败")
                return
            }
            self.saveImageToAlbum(image: image)
        }
    }
    
    private func handleShareImage() {
        generateHighResolutionImage { [weak self] image in
            guard let self = self, let image = image else {
                self?.showErrorAlert(message: "图片生成失败")
                return
            }
            self.shareImageWithSaveOption(image: image)
        }
    }
    
    // 优化：生成超高分辨率图片
    private func generateHighResolutionImage(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // 强制刷新所有布局
            self.view.layoutIfNeeded()
            self.scrollView.layoutIfNeeded()
            self.containerView.layoutIfNeeded()
            self.contentStackView.layoutIfNeeded()
            
            // 获取基础内容尺寸
            let contentSize = self.scrollView.contentSize
            let screenScale = UIScreen.main.scale
            
            // 计算超高分辨率尺寸
            let scaledSize = CGSize(
                width: contentSize.width * self.scaleFactor,
                height: contentSize.height * self.scaleFactor
            )
            
            // 创建超高分辨率图像上下文
            UIGraphicsBeginImageContextWithOptions(scaledSize, false, screenScale)
            defer { UIGraphicsEndImageContext() }
            
            // 保存原始偏移量并滚动到顶部
            let originalOffset = self.scrollView.contentOffset
            self.scrollView.contentOffset = .zero
            
            // 缩放上下文以绘制超高分辨率内容
            if let context = UIGraphicsGetCurrentContext() {
                context.scaleBy(x: self.scaleFactor, y: self.scaleFactor)
                self.containerView.layer.render(in: context)
            }
            
            // 恢复偏移量
            self.scrollView.contentOffset = originalOffset
            
            // 获取生成的超高分辨率图片
            let image = UIGraphicsGetImageFromCurrentImageContext()
            completion(image)
        }
    }
    
    // 优化：保存超高分辨率图片
    private func saveImageToAlbum(image: UIImage) {
        checkPhotoPermission { [weak self] authorized in
            guard let self = self else { return }
            
            if authorized {
                // 保存为最高质量JPEG（1.0表示无压缩）
                if let jpegData = image.jpegData(compressionQuality: 1.0) {
                    PHPhotoLibrary.shared().performChanges({
                        let request = PHAssetCreationRequest.forAsset()
                        request.addResource(with: .photo, data: jpegData, options: nil)
                    }) { success, error in
                        DispatchQueue.main.async {
                            if success {
                                self.showSuccessHUD(message: "超高清晰度图片已保存到相册")
                            } else {
                                self.showErrorAlert(message: error?.localizedDescription ?? "保存失败")
                            }
                        }
                    }
                } else {
                    self.showErrorAlert(message: "无法处理图片数据")
                }
            } else {
                self.showPermissionGuideAlert()
            }
        }
    }
    
    // 新增：分享图片时添加保存选项
    private func shareImageWithSaveOption(image: UIImage) {
        // 确保分享的是超高分辨率数据
        guard let highResData = image.jpegData(compressionQuality: 1.0),
              let highResImage = UIImage(data: highResData) else {
            showErrorAlert(message: "无法准备高清分享图片")
            return
        }
        
        // 创建自定义活动项，包含保存选项
        let activityItems: [Any] = [highResImage]
        
        let activityViewController = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: [SaveToPhotosActivity()]
//            applicationActivities: nil
        )
        
        // 排除某些活动类型，保留有用的选项
        activityViewController.excludedActivityTypes = [
            .assignToContact,
            .addToReadingList,
            .openInIBooks,
            .markupAsPDF
        ]
        
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.barButtonItem = navigationItem.rightBarButtonItem
        }
        
        activityViewController.completionWithItemsHandler = { [weak self] _, completed, _, error in
            DispatchQueue.main.async {
                if completed {
                    self?.showSuccessHUD(message: "超高清晰度图片分享成功")
                } else if let error = error {
                    self?.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
        
        present(activityViewController, animated: true)
    }
    
    // 其他方法保持不变
    private func checkPhotoPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        
        switch status {
        case .notDetermined:
            let alert = UIAlertController(
                title: "需要相册权限",
                message: "我们需要访问相册以保存您生成的分享图，不会读取您的其他照片",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "允许", style: .default) { _ in
                PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                    completion(status == .authorized)
                }
            })
            alert.addAction(UIAlertAction(title: "不允许", style: .cancel) { _ in
                completion(false)
            })
            present(alert, animated: true)
            
        case .authorized:
            completion(true)
            
        default:
            completion(false)
        }
    }
    
    private func showSuccessHUD(message: String) {
        let hud = UIAlertController(title: "成功", message: message, preferredStyle: .alert)
        present(hud, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            hud.dismiss(animated: true)
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "失败", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    private func showPermissionGuideAlert() {
        let alert = UIAlertController(
            title: "无法保存图片",
            message: "请在设置中允许访问相册，以便保存您的分享图",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "去设置", style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        })
        present(alert, animated: true)
    }
}

// 新增：自定义保存到相册的活动
class SaveToPhotosActivity: UIActivity {
    private var items: [Any] = []
    
    override var activityTitle: String? {
        return "保存到相册"
    }
    
    override var activityImage: UIImage? {
        return UIImage(systemName: "photo")
    }
    
    override var activityType: UIActivity.ActivityType? {
        return UIActivity.ActivityType("SaveToPhotosActivity")
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return activityItems.contains { $0 is UIImage }
    }
    
    override func prepare(withActivityItems activityItems: [Any]) {
        self.items = activityItems
    }
    
    override func perform() {
        // 获取图片并保存
        if let image = items.first as? UIImage {
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetCreationRequest.forAsset()
                if let jpegData = image.jpegData(compressionQuality: 1.0) {
                    request.addResource(with: .photo, data: jpegData, options: nil)
                }
            }) { success, error in
                DispatchQueue.main.async {
                    if success {
                        // 显示成功提示
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let topViewController = windowScene.windows.first?.rootViewController?.topMostViewController() {
                            let alert = UIAlertController(title: "成功", message: "图片已保存到相册", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "确定", style: .default))
                            topViewController.present(alert, animated: true)
                        }
                    }
                }
            }
        }
        activityDidFinish(true)
    }
}

// 扩展：获取最顶层视图控制器
extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presented = presentedViewController {
            return presented.topMostViewController()
        }
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        return self
    }
}

// 优化：卡片视图应用超高缩放因子以提高清晰度
class ShareImageCardView: UIView {
    private let model: ShareImageModel
    private let scaleFactor: CGFloat
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let logoImageView = UIImageView()
    
    init(model: ShareImageModel, scaleFactor: CGFloat) {
        self.model = model
        self.scaleFactor = scaleFactor
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = model.bgColor
        layer.cornerRadius = 16
        clipsToBounds = true
        
        // 阴影设置
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
        shadowLayer.fillColor = model.bgColor.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOpacity = 0.15
        shadowLayer.shadowOffset = .zero
        shadowLayer.shadowRadius = 12
        shadowLayer.shadowPath = shadowLayer.path
        layer.insertSublayer(shadowLayer, at: 0)
        
        // 标题设置（超高分辨率优化）
        titleLabel.text = model.title
        titleLabel.font = UIFont.systemFont(ofSize: 24 * scaleFactor, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.layer.contentsScale = UIScreen.main.scale * scaleFactor
        
        // 副标题设置（超高分辨率优化）
        subtitleLabel.text = model.subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 16 * scaleFactor)
        subtitleLabel.textColor = .white.withAlphaComponent(0.9)
        subtitleLabel.layer.contentsScale = UIScreen.main.scale * scaleFactor
        
        // Logo设置（超高分辨率优化）
        logoImageView.image = UIImage(systemName: "gift.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.layer.contentsScale = UIScreen.main.scale * scaleFactor
        
        // 垂直排列内容
        let stackView = UIStackView(arrangedSubviews: [logoImageView, titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 16 * scaleFactor
        stackView.alignment = .center
        addSubview(stackView)
        
        // 卡片内容约束
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(60 * scaleFactor)
        }
        
        // 监听边界变化更新阴影
        addObserver(self, forKeyPath: "bounds", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "bounds", let layer = layer.sublayers?.first as? CAShapeLayer {
            layer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
            layer.shadowPath = layer.path
        }
    }
    
    deinit {
        removeObserver(self, forKeyPath: "bounds")
    }
}

struct ShareImageModel {
    let title: String
    let subtitle: String
    let bgColor: UIColor
}

