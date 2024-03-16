//
//  CatalogMainViewController.swift
//  Drevmass
//
//  Created by Aset Bakirov on 04.03.2024.
//

import UIKit
import SnapKit

class CatalogMainViewController: UIViewController {
    //- MARK: - Variables
    enum CatalogView {
        case collectionView
        case verticalTableView
        case horizontalTableView
    }
    var currentView: CatalogView = .collectionView
    var collectionViewBottom: Constraint? = nil
    var horizontalTableViewBottom: Constraint? = nil
    var verticalTableViewBottom: Constraint? = nil
    //- MARK: - Local outlets
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.bounces = true
        scrollView.backgroundColor = UIColor(resource: ColorResource.Colors.EFEBE_9)
        scrollView.showsVerticalScrollIndicator = true
        //scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        //title
        let title = "По популярности"
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([NSAttributedString.Key.font : UIFont.addFont(type: .SFProDisplayBold, size: 15) ]))
        //logo
        config.image = UIImage(resource: ImageResource.Catalog.sortUp24)
        config.imagePadding = 8
        //button
        config.baseForegroundColor = UIColor(resource: ColorResource.Colors._302_C_28)
        button.contentHorizontalAlignment = .center
        button.configuration = config
        return button
    }()
    
    private lazy var changeCatalogViewButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: ImageResource.Catalog.tile24), for: .normal)
        button.addTarget(self, action: #selector(changeCatalogView), for: .touchUpInside)
        return button
    }()
    
    private lazy var collectionView: SelfSizingCollectionView = {
        let collectionView = SelfSizingCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CatalogCollectionViewCell.self, forCellWithReuseIdentifier: "catalogCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 24
        layout.estimatedItemSize.width = 165
        layout.estimatedItemSize.height = 180
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        collectionView.isScrollEnabled = false
        collectionView.bounces = false
        return collectionView
    }()
    
    private lazy var verticalTableView: SelfSizingTableView = {
        let tableView = SelfSizingTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(CatalogVerticalTableViewCell.self, forCellReuseIdentifier: "verticalCell")
        tableView.isScrollEnabled = false
        tableView.bounces = false
        return tableView
    }()
    
    private lazy var horizontalTableView: SelfSizingTableView = {
        let tableView = SelfSizingTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(CatalogHorizontalTableViewCell.self, forCellReuseIdentifier: "horizontalCell")
        tableView.isScrollEnabled = false
        tableView.bounces = false
        return tableView
    }()
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: ColorResource.Colors.EFEBE_9)
        addViews()
        setConstraints()
        showCatalogView(currentView)
        horizontalTableView.isHidden = true
        verticalTableView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.addFont(type: .SFProDisplayBold, size: 28), .foregroundColor: UIColor(resource: ColorResource.Colors._302_C_28)]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(resource: ColorResource.Colors._302_C_28)]
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.title = "Каталог"
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = " "
    }

    //- MARK: - Add & Set Views
    private func addViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(backView)
        backView.addSubview(sortButton)
        backView.addSubview(changeCatalogViewButton)
        backView.addSubview(collectionView)
        backView.addSubview(verticalTableView)
        backView.addSubview(horizontalTableView)
    }
    //- MARK: - Constraints
    private func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.edges.horizontalEdges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalTo(scrollView.frameLayoutGuide).priority(.medium)
        }
        backView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        sortButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.height.equalTo(36)
        }
        changeCatalogViewButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(16)
            make.height.equalTo(36)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sortButton.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            self.collectionViewBottom =  make.bottom.equalToSuperview().inset(36).priority(.medium).constraint
        }
        verticalTableView.snp.makeConstraints { make in
            make.top.equalTo(sortButton.snp.bottom).offset(16)
            self.verticalTableViewBottom =  make.bottom.equalToSuperview().inset(36).priority(.low).constraint
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        horizontalTableView.snp.makeConstraints { make in
            make.top.equalTo(sortButton.snp.bottom).offset(16)
            self.horizontalTableViewBottom =  make.bottom.equalToSuperview().inset(36).priority(.low).constraint
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    //- MARK: - Button actions
    @objc private func changeCatalogView() {
        hideCatalogView(currentView)
        switch currentView {
        case .collectionView:
            currentView = .verticalTableView
            changeCatalogViewButton.setImage(UIImage(resource: ImageResource.Catalog.verticalList24), for: .normal)
            collectionViewBottom?.update(priority: .low)
            verticalTableViewBottom?.update(priority: .high)
        case .verticalTableView:
            currentView = .horizontalTableView
            changeCatalogViewButton.setImage(UIImage(resource: ImageResource.Catalog.gorizontalList24), for: .normal)
            verticalTableViewBottom?.update(priority: .low)
            horizontalTableViewBottom?.update(priority: .medium)
        case .horizontalTableView:
            currentView = .collectionView
            changeCatalogViewButton.setImage(UIImage(resource: ImageResource.Catalog.tile24), for: .normal)
            horizontalTableViewBottom?.update(priority: .low)
            collectionViewBottom?.update(priority: .medium)
        }
        showCatalogView(currentView)
        if currentView == .horizontalTableView {
            horizontalTableView.reloadData()
        } else {
            verticalTableView.reloadData()
        }
    }
    private func showCatalogView(_ catalogView: CatalogView) {
        switch catalogView {
        case .collectionView:
            collectionView.isHidden = false
        case .horizontalTableView:
            horizontalTableView.isHidden = false
        case .verticalTableView:
            verticalTableView.isHidden = false
        }
    }
    private func hideCatalogView(_ catalogView: CatalogView) {
        switch catalogView {
        case .collectionView:
            collectionView.isHidden = true
        case .horizontalTableView:
            horizontalTableView.isHidden = true
        case .verticalTableView:
            verticalTableView.isHidden = true
        }
    }
}
//- MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension CatalogMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catalogCell", for: indexPath) as! CatalogCollectionViewCell
        cell.setCell(image: UIImage(resource: ImageResource.Hardcode.goods), price: "12 900 ₽", name: "Массажёр эконом")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = ProductViewController()
        navigationController?.show(vc, sender: self)
    }
    
}
//- MARK: - UITableViewDelegate, UITableViewDataSource
extension CatalogMainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if currentView == .horizontalTableView {
            return 120
        }
        return 292
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currentView == .horizontalTableView {
            let cell = horizontalTableView.dequeueReusableCell(withIdentifier: "horizontalCell") as! CatalogHorizontalTableViewCell
            cell.setCell(image: UIImage(resource: ImageResource.Hardcode.goods), price: "12 900 ₽", name: "Массажёр эконом")
            return cell
        }
        let cell = verticalTableView.dequeueReusableCell(withIdentifier: "verticalCell") as! CatalogVerticalTableViewCell
        cell.setCell(image: UIImage(resource: ImageResource.Hardcode.goods), price: "12 900 ₽", name: "Массажёр эконом")
        return cell
    }
    
    
}

class SelfSizingTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }

    override var intrinsicContentSize: CGSize {
        let height = min(.infinity, contentSize.height)
        return CGSize(width: contentSize.width, height: height)
    }
}

class SelfSizingCollectionView: UICollectionView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }

    override var intrinsicContentSize: CGSize {
        let height = min(.infinity, contentSize.height)
        return CGSize(width: contentSize.width, height: height)
    }
}
