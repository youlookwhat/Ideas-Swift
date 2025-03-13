import UIKit
import SnapKit

class DataSyncViewController: BaseViewController {
    
    // MARK: - Properties
    // 梦境数据
    private var cloudCount: Int = 138
    private var localCount: Int = 126
    private var cloudImageCount: Int = 23
    private var localImageCount: Int = 18
    
    // 所思数据
    private var cloudCount2: Int = 245
    private var localCount2: Int = 232
    private var cloudImageCount2: Int = 15
    private var localImageCount2: Int = 12
    
    // 用于存储数据区域的视图引用
    private var dreamDataSection: UIView?
    private var thoughtDataSection: UIView?
    
    // MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var bottomContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
//    private lazy var titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "数据核验"
//        label.font = .systemFont(ofSize: 24, weight: .bold)
//        return label
//    }()
//    
//    private lazy var refreshButton: UIButton = {
//        let button = UIButton(type: .system)
//        let config = UIImage.SymbolConfiguration(weight: .light)
//        let image = UIImage(systemName: "arrow.clockwise", withConfiguration: config)
//        button.setImage(image, for: .normal)
//        button.tintColor = .gray
//        button.addTarget(self, action: #selector(refreshData), for: .touchUpInside)
//        return button
//    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var syncButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("开始校对", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 25
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.addTarget(self, action: #selector(startSync), for: .touchUpInside)
        return button
    }()
    
    private lazy var lastSyncTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "上次同步时间：2024-01-18 15:30:45"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideTitleLayout()
        setupUI()
        
        // 隐藏导航栏返回按钮标题
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 设置导航栏样式
//        navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.largeTitleDisplayMode = .never
        title = "iCloud数据校对"
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // 添加 scrollView 和 contentView
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // 添加底部固定视图容器
        view.addSubview(bottomContainer)
        bottomContainer.addSubview(syncButton)
        bottomContainer.addSubview(lastSyncTimeLabel)
        
        // 添加其他视图到 contentView
//        contentView.addSubview(titleLabel)
//        contentView.addSubview(refreshButton)
        contentView.addSubview(stackView)
        
        // Add data sections
        dreamDataSection = createDataSection(
            title: "梦境数据", 
            cloudCount: cloudCount, 
            localCount: localCount,
            cloudImageCount: cloudImageCount,
            localImageCount: localImageCount
        )
        thoughtDataSection = createDataSection(
            title: "所思数据", 
            cloudCount: cloudCount2, 
            localCount: localCount2,
            cloudImageCount: cloudImageCount2,
            localImageCount: localImageCount2
        )
        
        stackView.addArrangedSubview(dreamDataSection!)
        stackView.addArrangedSubview(thoughtDataSection!)
        stackView.addArrangedSubview(createSyncSection())
        
        // Setup constraints
        bottomContainer.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(120) // 根据需要调整高度
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(bottomContainer.snp.top)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(20)
//            make.left.equalToSuperview().offset(20)
//        }
//        
//        refreshButton.snp.makeConstraints { make in
//            make.centerY.equalTo(titleLabel)
//            make.right.equalToSuperview().offset(-20)
//            make.width.height.equalTo(44)
//        }
        
        stackView.snp.makeConstraints { make in
//            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            // 添加底部约束以确保内容完整显示
            make.bottom.equalToSuperview().offset(-20)
        }
        
        // 底部固定视图的约束
        syncButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(50)
        }
        
        lastSyncTimeLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(syncButton.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
    }
    
    private func createDataSection(title: String, cloudCount: Int, localCount: Int, cloudImageCount: Int, localImageCount: Int) -> UIView {
        let container = UIView()
        container.backgroundColor = .clear
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 18, weight: .medium)
        
        // 创建两个数据容器
        let textDataContainer = UIView()
        let imageDataContainer = UIView()
        
        // 文本数据
        let cloudView = createDataBox(title: "云端数据", count: cloudCount, isCloud: true)
        let localView = createDataBox(title: "本地数据", count: localCount, isCloud: false)
        
        // 图片数据
        let cloudImageView = createDataBox(title: "云端图片", count: cloudImageCount, isCloud: true)
        let localImageView = createDataBox(title: "本地图片", count: localImageCount, isCloud: false)
        
        container.addSubview(titleLabel)
        container.addSubview(textDataContainer)
        container.addSubview(imageDataContainer)
        
        textDataContainer.addSubview(cloudView)
        textDataContainer.addSubview(localView)
        imageDataContainer.addSubview(cloudImageView)
        imageDataContainer.addSubview(localImageView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        
        // 文本数据容器约束
        textDataContainer.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
        // 图片数据容器约束
        imageDataContainer.snp.makeConstraints { make in
            make.top.equalTo(textDataContainer.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(100)
        }
        
        // 文本数据视图约束
        cloudView.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(textDataContainer)
            make.width.equalTo(textDataContainer.snp.width).multipliedBy(0.48)
        }
        
        localView.snp.makeConstraints { make in
            make.right.top.bottom.equalTo(textDataContainer)
            make.width.equalTo(textDataContainer.snp.width).multipliedBy(0.48)
        }
        
        // 图片数据视图约束
        cloudImageView.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(imageDataContainer)
            make.width.equalTo(imageDataContainer.snp.width).multipliedBy(0.48)
        }
        
        localImageView.snp.makeConstraints { make in
            make.right.top.bottom.equalTo(imageDataContainer)
            make.width.equalTo(imageDataContainer.snp.width).multipliedBy(0.48)
        }
        
        return container
    }
    
    private func createDataBox(title: String, count: Int, isCloud: Bool) -> UIView {
        let container = UIView()
        container.backgroundColor = isCloud ? .systemBlue.withAlphaComponent(0.1) : .systemGreen.withAlphaComponent(0.1)
        container.layer.cornerRadius = 12
        
        let titleStack = UIStackView()
        titleStack.axis = .horizontal
        titleStack.spacing = 4
        titleStack.alignment = .center
        
        let iconImageView = UIImageView()
        let iconName = title.contains("图片") ? "photo" : "doc.text"
        iconImageView.image = UIImage(systemName: iconName)
        iconImageView.tintColor = .gray
        iconImageView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .gray
        titleLabel.font = .systemFont(ofSize: 14)
        
        titleStack.addArrangedSubview(iconImageView)
        titleStack.addArrangedSubview(titleLabel)
        
        let countLabel = UILabel()
        countLabel.text = "\(count)"
        countLabel.font = .systemFont(ofSize: 32, weight: .bold)
        countLabel.textColor = isCloud ? .systemBlue : .systemGreen
        
        container.addSubview(titleStack)
        container.addSubview(countLabel)
        
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(16)
        }
        
        titleStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
        }
        
        countLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        return container
    }
    
    private func createSyncSection() -> UIView {
        let container = UIView()
        
        // 计算梦境数据的总差异
        let dreamTextDiff = abs(cloudCount - localCount)
        let dreamImageDiff = abs(cloudImageCount - localImageCount)
        let dreamTotalDiff = dreamTextDiff + dreamImageDiff
        
        // 计算所思数据的总差异
        let thoughtTextDiff = abs(cloudCount2 - localCount2)
        let thoughtImageDiff = abs(cloudImageCount2 - localImageCount2)
        let thoughtTotalDiff = thoughtTextDiff + thoughtImageDiff
        
        let syncNeededView1 = createSyncNeededView(
            title: "梦境数据差异",
            count: dreamTotalDiff,
            textDiff: dreamTextDiff,
            imageDiff: dreamImageDiff
        )
        
        let syncNeededView2 = createSyncNeededView(
            title: "所思数据差异",
            count: thoughtTotalDiff,
            textDiff: thoughtTextDiff,
            imageDiff: thoughtImageDiff
        )
        
        container.addSubview(syncNeededView1)
        container.addSubview(syncNeededView2)
        
        syncNeededView1.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        syncNeededView2.snp.makeConstraints { make in
            make.top.equalTo(syncNeededView1.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(60)
        }
        
        return container
    }
    
    private func createSyncNeededView(title: String, count: Int, textDiff: Int, imageDiff: Int) -> UIView {
        let container = UIView()
        container.backgroundColor = .secondarySystemBackground
        container.layer.cornerRadius = 12
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16)
        
        let detailLabel = UILabel()
        if count == 0 {
            detailLabel.text = "数据已同步"
        } else {
            var detailText = "需要同步 \(count) 条记录"
            if textDiff > 0 && imageDiff > 0 {
                detailText += "（文本 \(textDiff)，图片 \(imageDiff)）"
            } else if textDiff > 0 {
                detailText += "（文本）"
            } else if imageDiff > 0 {
                detailText += "（图片）"
            }
            detailLabel.text = detailText
        }
        detailLabel.textColor = .gray
        detailLabel.font = .systemFont(ofSize: 14)
        
        container.addSubview(titleLabel)
        container.addSubview(detailLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        detailLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
        
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(syncDetailTapped))
        container.addGestureRecognizer(tapGesture)
        container.isUserInteractionEnabled = true
        
        return container
    }
    
    // MARK: - Actions
    @objc private func refreshData() {
        // Implement refresh logic
    }
    
    @objc private func startSync() {
        // 模拟同步过程
        syncButton.isEnabled = false
        syncButton.setTitle("同步中...", for: .disabled)
        
        // 模拟网络延迟
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            // 随机更新数据
            self.cloudCount = Int.random(in: 130...150)
            self.localCount = Int.random(in: 120...140)
            self.cloudImageCount = Int.random(in: 20...30)
            self.localImageCount = Int.random(in: 15...25)
            
            self.cloudCount2 = Int.random(in: 240...260)
            self.localCount2 = Int.random(in: 230...250)
            self.cloudImageCount2 = Int.random(in: 10...20)
            self.localImageCount2 = Int.random(in: 8...16)
            
            // 重新创建数据区域
            if let oldDreamSection = self.dreamDataSection {
                let newDreamSection = self.createDataSection(
                    title: "梦境数据",
                    cloudCount: self.cloudCount,
                    localCount: self.localCount,
                    cloudImageCount: self.cloudImageCount,
                    localImageCount: self.localImageCount
                )
                
                self.stackView.removeArrangedSubview(oldDreamSection)
                oldDreamSection.removeFromSuperview()
                self.stackView.insertArrangedSubview(newDreamSection, at: 0)
                self.dreamDataSection = newDreamSection
            }
            
            if let oldThoughtSection = self.thoughtDataSection {
                let newThoughtSection = self.createDataSection(
                    title: "所思数据",
                    cloudCount: self.cloudCount2,
                    localCount: self.localCount2,
                    cloudImageCount: self.cloudImageCount2,
                    localImageCount: self.localImageCount2
                )
                
                self.stackView.removeArrangedSubview(oldThoughtSection)
                oldThoughtSection.removeFromSuperview()
                self.stackView.insertArrangedSubview(newThoughtSection, at: 1)
                self.thoughtDataSection = newThoughtSection
            }
            
            // 更新差异部分
            if let oldSyncSection = self.stackView.arrangedSubviews.last {
                let newSyncSection = self.createSyncSection()
                self.stackView.removeArrangedSubview(oldSyncSection)
                oldSyncSection.removeFromSuperview()
                self.stackView.addArrangedSubview(newSyncSection)
            }
            
            // 更新同步时间
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            self.lastSyncTimeLabel.text = "上次同步时间：\(dateFormatter.string(from: Date()))"
            
            // 恢复按钮状态
            self.syncButton.isEnabled = true
            self.syncButton.setTitle("开始校对", for: .normal)
        }
    }
    
    @objc private func syncDetailTapped() {
        // Implement sync detail view navigation
    }
} 
