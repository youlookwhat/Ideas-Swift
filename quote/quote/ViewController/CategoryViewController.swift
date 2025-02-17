import UIKit
import SnapKit

// 定义数据模型并实现 Hashable
struct Category: Hashable {
    let id = UUID()
    var name: String
    var isExpanded: Bool
    var subCategories: [SubCategory]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        lhs.id == rhs.id
    }
}

struct SubCategory: Hashable {
    let id = UUID()
    var name: String
    var isExpanded: Bool
    var items: [Item]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Item: Hashable {
    let id = UUID()
    var name: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// 定义 Section 类型
enum Section: Hashable {
    case main
}

class CategoryViewController: BaseViewController {
    
    // MARK: - Properties
    private var categories: [Category] = [
        Category(name: "文学", isExpanded: false, subCategories: [
            SubCategory(name: "小说", isExpanded: false, items: [
                Item(name: "言情小说"),
                Item(name: "武侠小说"),
                Item(name: "科幻小说")
            ]),
            SubCategory(name: "散文", isExpanded: false, items: [
                Item(name: "抒情散文"),
                Item(name: "记叙散文")
            ])
        ]),
        Category(name: "艺术", isExpanded: false, subCategories: [
            SubCategory(name: "音乐", isExpanded: false, items: [
                Item(name: "古典音乐"),
                Item(name: "流行音乐")
            ]),
            SubCategory(name: "绘画", isExpanded: false, items: [
                Item(name: "水彩"),
                Item(name: "油画")
            ])
        ])
    ]
    private var categories3: [Category] = [
        Category(name: "文学", isExpanded: false, subCategories: [
            SubCategory(name: "小说", isExpanded: false, items: []),
            SubCategory(name: "散文", isExpanded: false, items: [])
        ]),
        Category(name: "艺术", isExpanded: false, subCategories: [
            SubCategory(name: "音乐", isExpanded: false, items: []),
            SubCategory(name: "绘画", isExpanded: false, items: [])
        ])
    ]
    private var categories4: [Category] = [
        Category(name: "文学", isExpanded: false, subCategories: []),
        Category(name: "艺术", isExpanded: false, subCategories: [])
    ]
    
    private var dataSource: UITableViewDiffableDataSource<Section, AnyHashable>!
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: self.view.frame, style: .plain)
        table.delegate = self
        table.register(CategoryCell.self, forCellReuseIdentifier: "CategoryCell")
        table.register(SubCategoryCell.self, forCellReuseIdentifier: "SubCategoryCell")
        table.register(ItemCell.self, forCellReuseIdentifier: "ItemCell")
        table.separatorStyle = .none
        return table
    }()
    
    private var isAllExpanded = false
    private lazy var expandButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "全部展开",
            style: .plain,
            target: self,
            action: #selector(toggleAllCategories)
        )
        return button
    }()
    
    private var selectedItemId: UUID?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureDataSource()
        applyInitialSnapshot()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "分类"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = expandButton
        
        view.addSubview(tableView)
        tableView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, AnyHashable>(tableView: tableView) { [weak self]
            (tableView, indexPath, item) -> UITableViewCell? in
            
            if let category = item as? Category {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
                cell.selectionStyle = .none
                
                let hasSubCategories = !category.subCategories.isEmpty
                cell.configure(with: category.name, 
                             isExpanded: category.isExpanded, 
                             isSelected: category.id == self?.selectedItemId,
                             hasSubCategories: hasSubCategories)
                cell.arrowButton.tag = indexPath.row
                cell.arrowButton.addTarget(self, action: #selector(self?.handleExpandTapped(_:)), for: .touchUpInside)
                cell.moreButton.tag = indexPath.row
                cell.moreButton.addTarget(self, action: #selector(self?.handleMoreButtonTapped(_:)), for: .touchUpInside)
                return cell
            } else if let subCategory = item as? SubCategory {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoryCell", for: indexPath) as! SubCategoryCell
                cell.selectionStyle = .none
                let hasItems = !subCategory.items.isEmpty
                cell.configure(with: subCategory.name, 
                             isExpanded: subCategory.isExpanded, 
                             isSelected: subCategory.id == self?.selectedItemId,
                             hasItems: hasItems)
                cell.arrowButton.tag = indexPath.row
                cell.arrowButton.addTarget(self, action: #selector(self?.handleExpandTapped(_:)), for: .touchUpInside)
                cell.moreButton.tag = indexPath.row
                cell.moreButton.addTarget(self, action: #selector(self?.handleMoreButtonTapped(_:)), for: .touchUpInside)
                return cell
            } else if let item = item as? Item {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
                cell.selectionStyle = .none
                cell.configure(with: item.name, isSelected: item.id == self?.selectedItemId)
                cell.moreButton.tag = indexPath.row
                cell.moreButton.addTarget(self, action: #selector(self?.handleMoreButtonTapped(_:)), for: .touchUpInside)
                return cell
            }
            
            return UITableViewCell()
        }
    }
    
    private func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.main])
        
        var items: [AnyHashable] = []
        for category in categories {
            items.append(category)
            if category.isExpanded {
                for subCategory in category.subCategories {
                    items.append(subCategory)
                    if subCategory.isExpanded {
                        items.append(contentsOf: subCategory.items)
                    }
                }
            }
        }
        
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func updateSnapshot(animated: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.main])
        
        // 准备新的数据
        var items: [AnyHashable] = []
        for category in categories {
            items.append(category)
            if category.isExpanded {
                for subCategory in category.subCategories {
                    items.append(subCategory)
                    if subCategory.isExpanded {
                        items.append(contentsOf: subCategory.items)
                    }
                }
            }
        }
        
        // 更新数据
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
        
        // 更新所有可见 cell 的状态
        self.tableView.visibleCells.forEach { cell in
            if let categoryCell = cell as? CategoryCell,
               let indexPath = self.tableView.indexPath(for: cell),
               let item = self.dataSource.itemIdentifier(for: indexPath) as? Category {
                let hasSubCategories = !item.subCategories.isEmpty
                categoryCell.configure(with: item.name, 
                                    isExpanded: item.isExpanded, 
                                    isSelected: item.id == selectedItemId,
                                    hasSubCategories: hasSubCategories)
            } else if let subCategoryCell = cell as? SubCategoryCell,
                      let indexPath = self.tableView.indexPath(for: cell),
                      let item = self.dataSource.itemIdentifier(for: indexPath) as? SubCategory {
                let hasItems = !item.items.isEmpty
                subCategoryCell.configure(with: item.name, 
                                       isExpanded: item.isExpanded, 
                                       isSelected: item.id == selectedItemId,
                                       hasItems: hasItems)
            } else if let itemCell = cell as? ItemCell,
                      let indexPath = self.tableView.indexPath(for: cell),
                      let item = self.dataSource.itemIdentifier(for: indexPath) as? Item {
                itemCell.configure(with: item.name, isSelected: item.id == selectedItemId)
            }
        }
    }
    
    @objc private func toggleAllCategories() {
        isAllExpanded.toggle()
        
        expandButton.title = isAllExpanded ? "全部收起" : "全部展开"
        
        for i in 0..<categories.count {
            categories[i].isExpanded = isAllExpanded
            if isAllExpanded {
                for j in 0..<categories[i].subCategories.count {
                    categories[i].subCategories[j].isExpanded = true
                }
            } else {
                for j in 0..<categories[i].subCategories.count {
                    categories[i].subCategories[j].isExpanded = false
                }
            }
        }
        
        updateSnapshot()
    }
    
    // 点击展开
    @objc private func handleExpandTapped(_ sender: UIButton) {
        guard let indexPath = getIndexPath(for: sender),
              let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        if let category = item as? Category {
            if let index = categories.firstIndex(where: { $0.id == category.id }) {
                categories[index].isExpanded.toggle()
                updateExpandButtonState()
                updateSnapshot()
            }
        } else if let subCategory = item as? SubCategory {
            for (categoryIndex, category) in categories.enumerated() {
                if let subCategoryIndex = category.subCategories.firstIndex(where: { $0.id == subCategory.id }) {
                    categories[categoryIndex].subCategories[subCategoryIndex].isExpanded.toggle()
                    updateExpandButtonState()
                    updateSnapshot()
                    break
                }
            }
        }
    }
    // 点击菜单
    @objc private func handleMoreButtonTapped(_ sender: UIButton) {
        guard let indexPath = getIndexPath(for: sender),
              let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let alertController = UIAlertController(title: "修改名称", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            if let category = item as? Category {
                textField.text = category.name
            } else if let subCategory = item as? SubCategory {
                textField.text = subCategory.name
            } else if let item = item as? Item {
                textField.text = item.name
            }
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        let confirmAction = UIAlertAction(title: "确定", style: .default) { [weak self] _ in
            guard let self = self,
                  let newName = alertController.textFields?.first?.text,
                  !newName.isEmpty else { return }
            
            if let category = item as? Category {
                if let index = self.categories.firstIndex(where: { $0.id == category.id }) {
                    var updatedCategory = self.categories[index]
                    updatedCategory.name = newName
                    self.categories[index] = updatedCategory
                    self.updateSnapshot()
                }
            } else if let subCategory = item as? SubCategory {
                for (categoryIndex, category) in self.categories.enumerated() {
                    if let subCategoryIndex = category.subCategories.firstIndex(where: { $0.id == subCategory.id }) {
                        var updatedSubCategories = self.categories[categoryIndex].subCategories
                        var updatedSubCategory = updatedSubCategories[subCategoryIndex]
                        updatedSubCategory.name = newName
                        updatedSubCategories[subCategoryIndex] = updatedSubCategory
                        self.categories[categoryIndex].subCategories = updatedSubCategories
                        self.updateSnapshot()
                        break
                    }
                }
            } else if let item = item as? Item {
                for (categoryIndex, category) in self.categories.enumerated() {
                    for (subCategoryIndex, subCategory) in category.subCategories.enumerated() {
                        if let itemIndex = subCategory.items.firstIndex(where: { $0.id == item.id }) {
                            var updatedItems = self.categories[categoryIndex].subCategories[subCategoryIndex].items
                            var updatedItem = updatedItems[itemIndex]
                            updatedItem.name = newName
                            updatedItems[itemIndex] = updatedItem
                            self.categories[categoryIndex].subCategories[subCategoryIndex].items = updatedItems
                            self.updateSnapshot()
                            break
                        }
                    }
                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true)
    }
    
    private func getIndexPath(for button: UIButton) -> IndexPath? {
        let point = button.convert(CGPoint.zero, to: tableView)
        return tableView.indexPathForRow(at: point)
    }
}

// MARK: - UITableViewDelegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        if let category = item as? Category {
            selectedItemId = selectedItemId == category.id ? nil : category.id
            updateSnapshot()
        } else if let subCategory = item as? SubCategory {
            selectedItemId = selectedItemId == subCategory.id ? nil : subCategory.id
            updateSnapshot()
        } else if let item = item as? Item {
            selectedItemId = selectedItemId == item.id ? nil : item.id
            updateSnapshot()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 移除这段代码
        // cell.alpha = 0
        // UIView.animate(withDuration: 0.3) {
        //     cell.alpha = 1
        // }
    }
    
    private func updateExpandButtonState() {
        let allExpanded = categories.allSatisfy { category in
            category.isExpanded && category.subCategories.allSatisfy { $0.isExpanded }
        }
        
        let allCollapsed = categories.allSatisfy { category in
            !category.isExpanded && category.subCategories.allSatisfy { !$0.isExpanded }
        }
        
        if allExpanded {
            isAllExpanded = true
            expandButton.title = "全部收起"
        } else if allCollapsed {
            isAllExpanded = false
            expandButton.title = "全部展开"
        }
    }
}
