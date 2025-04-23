import UIKit
import Photos

class ImageManagerViewController: BaseViewController {
    
    // MARK: - Properties
    private var images: [String] = [] // 存储所有图片路径
    private var filteredImages: [String] = [] // 存储筛选后的图片路径
    private var currentFilter: ImageFilter = .all // 当前筛选状态
    
    private enum ImageFilter {
        case all
        case inUse
        case unused
        
        var title: String {
            switch self {
            case .all: return "全部图片"
            case .inUse: return "使用中的图片"
            case .unused: return "未关联的图片"
            }
        }
    }
    
    // MARK: - UI Components
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let width = (UIScreen.main.bounds.width - 40 - 20) / 3 // 每行3张图片
        layout.itemSize = CGSize(width: width, height: width)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        return cv
    }()
    
    private lazy var filterButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal.decrease.circle"),
            menu: createFilterMenu()
        )
        return button
    }()
    
    // 添加菜单按钮和相关属性
    private let menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let menuView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 4
        view.isHidden = true
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideTitleLayout()
        setupUI()
        loadSavedImages()
        setupMenuButton()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "图片管理"
        view.backgroundColor = .systemBackground
        
        // 添加筛选按钮到导航栏
        navigationItem.rightBarButtonItem = filterButton
        
        // 添加长按手势
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView.addGestureRecognizer(longPressGesture)
        
        view.addSubview(collectionView)
        view.addSubview(addButton)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.width.height.equalTo(60)
        }
    }
    
    private func createFilterMenu() -> UIMenu {
        let allAction = UIAction(
            title: ImageFilter.all.title,
            state: currentFilter == .all ? .on : .off
        ) { [weak self] _ in
            self?.applyFilter(.all)
        }
        
        let inUseAction = UIAction(
            title: ImageFilter.inUse.title,
            state: currentFilter == .inUse ? .on : .off
        ) { [weak self] _ in
            self?.applyFilter(.inUse)
        }
        
        let unusedAction = UIAction(
            title: ImageFilter.unused.title,
            state: currentFilter == .unused ? .on : .off
        ) { [weak self] _ in
            self?.applyFilter(.unused)
        }
        
        return UIMenu(title: "", children: [allAction, inUseAction, unusedAction])
    }
    
    private func applyFilter(_ filter: ImageFilter) {
        currentFilter = filter
        
        switch filter {
        case .all:
            filteredImages = images
        case .inUse:
            // 这里需要实现检查图片是否在使用中的逻辑
            filteredImages = images.filter { imagePath in
                return isImageInUse(imagePath)
            }
        case .unused:
            // 这里需要实现检查图片是否未使用的逻辑
            filteredImages = images.filter { imagePath in
                return !isImageInUse(imagePath)
            }
        }
        
        // 更新筛选按钮的菜单
        filterButton.menu = createFilterMenu()
        
        // 刷新集合视图
        collectionView.reloadData()
    }
    
    private func isImageInUse(_ imagePath: String) -> Bool {
        // TODO: 实现检查图片是否在使用中的逻辑
        // 这里需要根据你的应用实际情况来实现
        // 例如：检查数据库中是否有引用这个图片路径
        return false
    }
    
    // MARK: - Actions
    @objc private func addButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    @objc private func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state != .began { return }
        
        let point = gesture.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: point) {
            showDeleteAlert(for: indexPath)
        }
    }
    
    private func showDeleteAlert(for indexPath: IndexPath) {
        let alert = UIAlertController(
            title: "删除图片",
            message: "确定要删除这张图片吗？",
            preferredStyle: .actionSheet
        )
        
        let deleteAction = UIAlertAction(title: "删除", style: .destructive) { [weak self] _ in
            self?.deleteImage(at: indexPath)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        // iPad 支持
        if let popoverController = alert.popoverPresentationController {
            if let cell = collectionView.cellForItem(at: indexPath) {
                popoverController.sourceView = cell
                popoverController.sourceRect = cell.bounds
            }
        }
        
        present(alert, animated: true)
    }
    
    private func deleteImage(at indexPath: IndexPath) {
        let imagePath = filteredImages[indexPath.item]
        let fileManager = FileManager.default
        
        // 检查文件是否存在
        guard fileManager.fileExists(atPath: imagePath) else {
            // 文件不存在，直接从数据源中移除
            filteredImages.remove(at: indexPath.item)
            collectionView.performBatchUpdates {
                collectionView.deleteItems(at: [indexPath])
            }
            return
        }
        
        do {
            // 删除文件
            try fileManager.removeItem(atPath: imagePath)
            
            // 更新数据源
            filteredImages.remove(at: indexPath.item)
            
            // 更新 UI
            collectionView.performBatchUpdates {
                collectionView.deleteItems(at: [indexPath])
            }
        } catch {
            print("Error deleting image: \(error)")
            
            // 显示错误提示
            let alert = UIAlertController(
                title: "删除失败",
                message: "无法删除图片，请稍后重试",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "确定", style: .default))
            present(alert, animated: true)
        }
    }
    
    // MARK: - Helper Methods
    private func loadSavedImages() {
        // 从 Documents 目录加载已保存的图片路径
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imagesPath = documentsPath.appendingPathComponent("SavedImages")
        
        do {
            try fileManager.createDirectory(at: imagesPath, withIntermediateDirectories: true)
            let imageURLs = try fileManager.contentsOfDirectory(at: imagesPath, includingPropertiesForKeys: nil)
            images = imageURLs.map { $0.path }
            collectionView.reloadData()
        } catch {
            print("Error loading images: \(error)")
        }
        
        // 初始化筛选后的图片数组
        filteredImages = images
    }
    
    private func saveImage(_ image: UIImage) {
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imagesPath = documentsPath.appendingPathComponent("SavedImages")
        
        // 生成唯一文件名，先不带扩展名
        let uniqueID = UUID().uuidString
        
        // 尝试获取图片数据和合适的扩展名
        var imageData: Data?
        var fileExtension = "jpg"
        
        // 首先尝试 PNG 格式
        if let pngData = image.pngData() {
            imageData = pngData
            fileExtension = "png"
        }
        // 如果不是 PNG，则尝试 JPEG
        else if let jpegData = image.jpegData(compressionQuality: 0.8) {
            imageData = jpegData
            fileExtension = "jpg"
        }
        // 如果都不是，尝试 HEIC（iOS 11 及以上支持）
        else if #available(iOS 11.0, *), let heicData = image.heicData {
            imageData = heicData
            fileExtension = "heic"
        }
        
        guard let finalImageData = imageData else {
            print("Error: Could not get image data")
            return
        }
        
        // 使用正确的扩展名创建文件 URL
        let fileName = "\(uniqueID).\(fileExtension)"
        let fileURL = imagesPath.appendingPathComponent(fileName)
        
        do {
            try finalImageData.write(to: fileURL)
            images.append(fileURL.path)
            collectionView.reloadData()
        } catch {
            print("Error saving image: \(error)")
        }
    }
    
    private func setupMenuButton() {
        view.addSubview(menuButton)
        view.addSubview(menuView)
        
        // 使用 SnapKit 设置 menuButton 约束
        menuButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        // 使用 SnapKit 设置 menuView 约束
        menuView.snp.makeConstraints { make in
            make.top.equalTo(menuButton.snp.bottom).offset(8)
            make.trailing.equalTo(menuButton)
            make.width.equalTo(120)
        }
        
        // 添加菜单项
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        menuView.addSubview(stackView)
        
        // 使用 SnapKit 设置 stackView 约束
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        }
        
        // 添加菜单项按钮
        let menuItems = ["选项 1", "选项 2", "选项 3"]
        for item in menuItems {
            let itemButton = UIButton(type: .system)
            itemButton.setTitle(item, for: .normal)
            itemButton.contentHorizontalAlignment = .left
            itemButton.setTitleColor(.black, for: .normal)
            stackView.addArrangedSubview(itemButton)
        }
        
        // 添加点击事件
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
    }
    
    @objc private func menuButtonTapped() {
        menuView.isHidden.toggle()
    }
}

// MARK: - UICollectionViewDataSource
extension ImageManagerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredImages.count // 使用筛选后的数组
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        let imagePath = filteredImages[indexPath.item] // 使用筛选后的数组
        cell.configure(with: imagePath)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ImageManagerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 可以添加点击图片的处理逻辑
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ImageManagerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 尝试获取图片的 URL
        if let imageUrl = info[.imageURL] as? URL {
            saveImageFromURL(imageUrl)
        }
        // 如果获取不到 URL，则回退到之前的方式
        else if let image = info[.originalImage] as? UIImage {
            saveImage(image)
        }
        picker.dismiss(animated: true)
    }
    
    private func saveImageFromURL(_ sourceURL: URL) {
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imagesPath = documentsPath.appendingPathComponent("SavedImages")
        
        // 获取原始文件名和扩展名
        let originalFileName = sourceURL.lastPathComponent
        let fileExtension = sourceURL.pathExtension
        
        // 生成新的文件名，保持原始扩展名
        let uniqueID = UUID().uuidString
        let fileName = "\(uniqueID).\(fileExtension)"
        let destinationURL = imagesPath.appendingPathComponent(fileName)
        
        do {
            // 确保目标目录存在
            try fileManager.createDirectory(at: imagesPath, withIntermediateDirectories: true)
            
            // 复制文件
            try fileManager.copyItem(at: sourceURL, to: destinationURL)
            
            // 更新数据源
            images.append(destinationURL.path)
            collectionView.reloadData()
        } catch {
            print("Error saving image: \(error)")
            
            // 如果复制失败，回退到之前的方式
//            if let image = UIImage(contentsOf: sourceURL) {
//                saveImage(image)
//            }
        }
    }
}

// MARK: - ImageCell
class ImageCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with imagePath: String) {
        imageView.image = UIImage(contentsOfFile: imagePath)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}

// 添加 HEIC 支持的扩展
extension UIImage {
    @available(iOS 11.0, *)
    var heicData: Data? {
        return autoreleasepool { () -> Data? in
            let data = NSMutableData()
            guard let destination = CGImageDestinationCreateWithData(data as CFMutableData, "public.heic" as CFString, 1, nil) else { return nil }
            guard let cgImage = self.cgImage else { return nil }
            
            let options = [
                kCGImageDestinationLossyCompressionQuality: 0.8
            ] as CFDictionary
            
            CGImageDestinationAddImage(destination, cgImage, options)
            guard CGImageDestinationFinalize(destination) else { return nil }
            return data as Data
        }
    }
} 
