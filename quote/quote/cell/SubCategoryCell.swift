import UIKit

class SubCategoryCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let selectedIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 3
        view.isHidden = true
        return view
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
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    internal let moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
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
//        contentView.backgroundColor = UIColor(lightColor: UIColor(white: 0.97, alpha: 1.0), darkColor: .systemGray4)
        
        contentView.addSubview(lineView)
        contentView.addSubview(selectedIndicator)
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(arrowButton)
        contentView.addSubview(moreButton)
        
        lineView.snp.makeConstraints { make in
            make.left.equalTo(32)
            make.width.equalTo(1)
            make.top.bottom.equalToSuperview()
        }
        
        selectedIndicator.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(lineView.snp.right).offset(15)
            make.width.height.equalTo(6)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(selectedIndicator.snp.right).offset(8)
            make.centerY.equalToSuperview()
        }
        
//        titleLabel.snp.makeConstraints { make in
//            make.left.equalTo(32)
//            make.centerY.equalToSuperview()
//        }
        
        arrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        arrowButton.snp.makeConstraints { make in
            make.edges.equalTo(arrowImageView)
        }
        
        moreButton.snp.makeConstraints { make in
            make.right.equalTo(arrowImageView.snp.left).offset(-8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }
    
    func configure(with title: String, isExpanded: Bool, isSelected: Bool = false, hasItems: Bool = true) {
        titleLabel.text = title
        selectedIndicator.isHidden = !isSelected
        titleLabel.textColor = isSelected ? .systemBlue : .black
        titleLabel.font = isSelected ? 
            .systemFont(ofSize: 14, weight: .medium) : 
            .systemFont(ofSize: 14)
        
        // 根据是否有子项来显示/隐藏箭头
        arrowImageView.isHidden = !hasItems
        arrowButton.isHidden = !hasItems
        
        if hasItems {
            UIView.animate(withDuration: 0.3) {
                self.arrowImageView.transform = isExpanded ? 
                    CGAffineTransform(rotationAngle: .pi/2) : 
                    .identity
            }
        }
    }
} 
