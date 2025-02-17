import UIKit

class ItemCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    private let lineView0: UIView = {
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
    
    private let selectedIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 3
        view.isHidden = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
//        contentView.backgroundColor = UIColor(lightColor: UIColor(white: 0.95, alpha: 1.0), darkColor: .systemGray5)
        
        contentView.addSubview(lineView0)
        contentView.addSubview(lineView)
        contentView.addSubview(selectedIndicator)
        contentView.addSubview(titleLabel)
        contentView.addSubview(moreButton)
        
        lineView0.snp.makeConstraints { make in
            make.left.equalTo(32)
            make.width.equalTo(1)
            make.top.bottom.equalToSuperview()
        }
        lineView.snp.makeConstraints { make in
            make.left.equalTo(lineView0.snp.right).offset(40)
            make.width.equalTo(1)
            make.top.bottom.equalToSuperview()
        }
        
        selectedIndicator.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(lineView.snp.right).offset(8)
            make.width.height.equalTo(6)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(selectedIndicator.snp.right).offset(8)
            make.centerY.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }
    
    func configure(with title: String, isSelected: Bool = false) {
        titleLabel.text = title
        selectedIndicator.isHidden = !isSelected
        titleLabel.textColor = isSelected ? .systemBlue : .gray
        titleLabel.font = isSelected ? .systemFont(ofSize: 13, weight: .medium) : .systemFont(ofSize: 13)
    }
} 
