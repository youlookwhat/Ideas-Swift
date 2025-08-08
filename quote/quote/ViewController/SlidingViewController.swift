//
//  SlidingViewController.swift
//  quote
//
//  Created by Michelle on 2025/7/13.
//  Copyright © 2025 景彬. All rights reserved.
//

import UIKit

class SlidingViewController: BaseViewController {
    
    // MARK: - Properties
    private var totalPages: Int = 1
    private var currentPage: Int = 0
    private var loadedPages: Set<Int> = []
    private var isTransitioning = false // 添加过渡状态标记
    
    // MARK: - UI Components
    private lazy var pageViewController: UIPageViewController = {
        let pageVC = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,// 如果只有一条数据时，可以使用 vertical ，这样可以直接左滑退出
            options: nil
        )
        pageVC.dataSource = self
        pageVC.delegate = self
        return pageVC
    }()
    
    private lazy var leftButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .systemBlue
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 4
        button.addTarget(self, action: #selector(previousPage), for: .touchUpInside)
        return button
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .systemBlue
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 4
        button.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        return button
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .systemBlue
        pageControl.pageIndicatorTintColor = .systemGray4
        pageControl.addTarget(self, action: #selector(pageControlChanged), for: .valueChanged)
        return pageControl
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = .systemBlue
        progressView.trackTintColor = .systemGray5
        progressView.layer.cornerRadius = 2
        progressView.clipsToBounds = true
        return progressView
    }()
    
    private lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPageViewController()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        title = "滑动页面"
        view.backgroundColor = .systemBackground
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
//        setupGestureRecognizers()
        
        view.addSubview(leftButton)
        view.addSubview(rightButton)
        view.addSubview(progressView)
        view.addSubview(progressLabel)
        view.addSubview(pageControl)
        
        pageViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        leftButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalTo(progressView.snp.top).offset(-15)
            make.width.height.equalTo(40)
        }
        
        rightButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(progressView.snp.top).offset(-15)
            make.width.height.equalTo(40)
        }
        
        progressView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(40)
            make.bottom.equalTo(pageControl.snp.top).offset(-15)
            make.height.equalTo(4)
        }
        
        progressLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(progressView.snp.top).offset(-8)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(20)
        }
    }

    
    private func updatePageViewGestures() {
    }

    private func setupPageViewController() {
        pageControl.numberOfPages = totalPages
        pageControl.currentPage = currentPage
        updateProgress()
        updateButtonStates()
        
        if let initialViewController = createPageViewController(at: currentPage) {
            pageViewController.setViewControllers(
                [initialViewController],
                direction: .forward,
                animated: false
            ) { [weak self] finished in
                // 确保初始化完成后重置过渡状态
                self?.isTransitioning = false
            }
            loadedPages.insert(currentPage)
        }
    }
    
    // MARK: - Progress Update
    private func updateProgress() {
        let progress = totalPages > 1 ? Float(currentPage) / Float(totalPages - 1) : 1.0
        
        UIView.animate(withDuration: 0.1) {
            self.progressView.setProgress(progress, animated: true)
        }
        
        progressLabel.text = "\(currentPage + 1) / \(totalPages)"
    }
    
    // MARK: - Button States Update
    private func updateButtonStates() {
//        leftButton.isEnabled = currentPage > 0 && !isTransitioning
        leftButton.isEnabled = currentPage > 0
//        rightButton.isEnabled = currentPage < totalPages - 1 && !isTransitioning
        rightButton.isEnabled = currentPage < totalPages - 1
        
        // 更新按钮透明度
        leftButton.alpha = leftButton.isEnabled ? 1.0 : 0.3
        rightButton.alpha = rightButton.isEnabled ? 1.0 : 0.3
    }
    
    // MARK: - Actions
        @objc private func previousPage() {
            guard currentPage > 0 && !isTransitioning else { return }
            
            isTransitioning = true
            let targetPage = currentPage - 1
            
            if let targetViewController = createPageViewController(at: targetPage) {
                pageViewController.setViewControllers(
                    [targetViewController],
                    direction: .reverse,
                    animated: true
                ) { [weak self] finished in
                    if finished {
                        self?.currentPage = targetPage
                        self?.pageControl.currentPage = targetPage
                        self?.updateProgress()
                        self?.updateButtonStates()
                        self?.updatePageViewGestures() // 更新手势状态
                        self?.isTransitioning = false
                    }
                }
                loadedPages.insert(targetPage)
            } else {
                isTransitioning = false
            }
        }
        
        @objc private func nextPage() {
            guard currentPage < totalPages - 1 && !isTransitioning else { return }
            
            isTransitioning = true
            let targetPage = currentPage + 1
            
            if let targetViewController = createPageViewController(at: targetPage) {
                pageViewController.setViewControllers(
                    [targetViewController],
                    direction: .forward,
                    animated: true
                ) { [weak self] finished in
                    if finished {
                        self?.currentPage = targetPage
                        self?.pageControl.currentPage = targetPage
                        self?.updateProgress()
                        self?.updateButtonStates()
                        self?.updatePageViewGestures() // 更新手势状态
                        self?.isTransitioning = false
                    }
                }
                loadedPages.insert(targetPage)
            } else {
                isTransitioning = false
            }
        }
    
    @objc private func pageControlChanged() {
            guard !isTransitioning else { return }
            
            let targetPage = pageControl.currentPage
            let direction: UIPageViewController.NavigationDirection = targetPage > currentPage ? .forward : .reverse
            
            isTransitioning = true
            
            if let targetViewController = createPageViewController(at: targetPage) {
                pageViewController.setViewControllers(
                    [targetViewController],
                    direction: direction,
                    animated: true
                ) { [weak self] finished in
                    if finished {
                        self?.currentPage = targetPage
                        self?.updateProgress()
                        self?.updateButtonStates()
                        self?.updatePageViewGestures() // 更新手势状态
                        self?.isTransitioning = false
                    }
                }
                loadedPages.insert(targetPage)
            } else {
                isTransitioning = false
            }
        }
    
    // MARK: - Helper Methods
    private func createPageViewController(at index: Int) -> UIViewController? {
        guard index >= 0 && index < totalPages else { return nil }
        
        let pageVC = PageContentViewController()
        pageVC.pageIndex = index
        pageVC.totalPages = totalPages
        pageVC.delegate = self
        return pageVC
    }
    
    // MARK: - Memory Management
    private func cleanupUnusedPages() {
        let pagesToKeep = Set([currentPage - 1, currentPage, currentPage + 1])
        let pagesToRemove = loadedPages.subtracting(pagesToKeep)
        
        for page in pagesToRemove {
            loadedPages.remove(page)
            print("清理页面 \(page)")
        }
    }
    
    // MARK: - Public Methods
    func setTotalPages(_ count: Int) {
        totalPages = max(1, count)
        pageControl.numberOfPages = totalPages
        
        if currentPage >= totalPages {
            currentPage = totalPages - 1
        }
        
        pageControl.currentPage = currentPage
        loadedPages.removeAll()
        
        updateProgress()
        updateButtonStates()
        
        if let currentViewController = createPageViewController(at: currentPage) {
            pageViewController.setViewControllers(
                [currentViewController],
                direction: .forward,
                animated: false
            )
            loadedPages.insert(currentPage)
        }
    }
    
    // MARK: - Public Methods
    func jumpToPage(_ page: Int, animated: Bool = true) {
        guard page >= 0 && page < totalPages && !isTransitioning else { return }
        
        isTransitioning = true
        let direction: UIPageViewController.NavigationDirection = page > currentPage ? .forward : .reverse
        
        if let targetViewController = createPageViewController(at: page) {
            pageViewController.setViewControllers(
                [targetViewController],
                direction: direction,
                animated: animated
            ) { [weak self] finished in
                if finished {
                    self?.currentPage = page
                    self?.pageControl.currentPage = page
                    self?.updateProgress()
                    self?.updateButtonStates()
                    self?.updatePageViewGestures() // 更新手势状态
                    self?.isTransitioning = false
                }
            }
            loadedPages.insert(page)
        } else {
            isTransitioning = false
        }
    }
}

// MARK: - UIPageViewControllerDataSource
extension SlidingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let pageVC = viewController as? PageContentViewController else { return nil }
        let previousIndex = pageVC.pageIndex - 1
        return createPageViewController(at: previousIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let pageVC = viewController as? PageContentViewController else { return nil }
        let nextIndex = pageVC.pageIndex + 1
        return createPageViewController(at: nextIndex)
    }
}

// MARK: - UIPageViewControllerDelegate
extension SlidingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentViewController = pageViewController.viewControllers?.first as? PageContentViewController {
                currentPage = currentViewController.pageIndex
                pageControl.currentPage = currentPage
                
                updateProgress()
                updateButtonStates()
                updatePageViewGestures() // 更新手势状态
                cleanupUnusedPages()
            }
        }
        isTransitioning = false
    }
}

// MARK: - PageContentViewControllerDelegate
//extension SlidingViewController: PageContentViewControllerDelegate {
//    func pageContentViewController(_ controller: PageContentViewController, didLoadDataForPage page: Int) {
//        print("页面 \(page + 1) 数据加载完成")
//    }
//}

// MARK: - PageContentViewControllerDelegate
protocol PageContentViewControllerDelegate: AnyObject {
    func pageContentViewController(_ controller: PageContentViewController, didLoadDataForPage page: Int)
}

// MARK: - PageContentViewController
class PageContentViewController: UIViewController {
    
    var pageIndex: Int = 0
    var totalPages: Int = 0
    weak var delegate: PageContentViewControllerDelegate?
    
    private var isDataLoaded = false
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private lazy var pageInfoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDataIfNeeded()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // 可以在这里清理一些资源
        print("页面 \(pageIndex + 1) 消失")
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(contentLabel)
        view.addSubview(pageInfoLabel)
        view.addSubview(loadingIndicator)
        
        contentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
        }
        
        pageInfoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(contentLabel.snp.bottom).offset(20)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func loadDataIfNeeded() {
        guard !isDataLoaded else { return }
        
        // 显示加载指示器
        loadingIndicator.startAnimating()
        contentLabel.isHidden = true
        pageInfoLabel.isHidden = true
        
        // 模拟数据加载
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.loadData()
        }
    }
    
    private func loadData() {
        // 模拟数据加载过程
        print("加载页面 \(pageIndex + 1) 的数据")
        
        // 更新UI
        contentLabel.text = "页面 \(pageIndex + 1)"
        pageInfoLabel.text = "第 \(pageIndex + 1) 页，共 \(totalPages) 页"
        
        // 设置背景色
        let colors: [UIColor] = [.systemRed, .systemBlue, .systemGreen, .systemOrange, .systemPurple]
        view.backgroundColor = colors[pageIndex % colors.count].withAlphaComponent(0.1)
        
        // 隐藏加载指示器，显示内容
        loadingIndicator.stopAnimating()
        contentLabel.isHidden = false
        pageInfoLabel.isHidden = false
        
        isDataLoaded = true
        
        // 通知代理
        delegate?.pageContentViewController(self, didLoadDataForPage: pageIndex)
    }
    
    deinit {
        print("页面 \(pageIndex + 1) 被销毁")
    }
}

// MARK: - PageContentViewControllerDelegate
extension SlidingViewController: PageContentViewControllerDelegate {
    func pageContentViewController(_ controller: PageContentViewController, didLoadDataForPage page: Int) {
        print("页面 \(page + 1) 数据加载完成")
    }
}
