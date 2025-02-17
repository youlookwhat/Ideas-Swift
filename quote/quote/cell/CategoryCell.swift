import UIKit

class CategoryCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    internal let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .gray
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    public let arrowButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        return button
    }()
    
    private let selectedIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 3
        view.isHidden = true
        return view
    }()
    
    internal let moreButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(weight: .light)
        let image = UIImage(systemName: "ellipsis", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = UIColor(lightColor: .white, darkColor: .systemGray3)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(selectedIndicator)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(arrowButton)
        contentView.addSubview(moreButton)
        
//        titleLabel.snp.makeConstraints { make in
//            make.left.equalTo(16)
//            make.centerY.equalToSuperview()
//        }
//        
        selectedIndicator.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(16)
            make.width.height.equalTo(6)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(selectedIndicator.snp.right).offset(8)
            make.centerY.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints { make in
            make.right.equalTo(arrowImageView.snp.left).offset(-8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        arrowButton.snp.makeConstraints { make in
            make.edges.equalTo(arrowImageView)
        }
    }
    
    func configure(with title: String, isExpanded: Bool, isSelected: Bool = false, hasSubCategories: Bool = true) {
        titleLabel.text = title
        selectedIndicator.isHidden = !isSelected
        titleLabel.textColor = isSelected ? .systemBlue : .black
        titleLabel.font = isSelected ? 
            .systemFont(ofSize: 16, weight: .semibold) : 
            .systemFont(ofSize: 16, weight: .medium)
        
        // 根据是否有子分类来显示/隐藏箭头
        arrowImageView.isHidden = !hasSubCategories
        arrowButton.isHidden = !hasSubCategories
        
        if hasSubCategories {
            UIView.animate(withDuration: 0.3) {
                self.arrowImageView.transform = isExpanded ? 
                    CGAffineTransform(rotationAngle: .pi/2) : 
                    .identity
            }
        }
    }
} 
