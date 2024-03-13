//
//  CatalogMainViewController.swift
//  Drevmass
//
//  Created by Aset Bakirov on 04.03.2024.
//

import UIKit
import SnapKit

class CatalogMainViewController: UIViewController {
    //- MARK: - Local outlets
    private lazy var catalogTitle: UILabel = {
        let label = UILabel()
        label.text = "Каталог"
        label.font = .addFont(type: .SFProDisplayBold, size: 28)
        label.textColor = UIColor(resource: ColorResource.Colors._302_C_28)
        label.textAlignment = .left
        return label
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
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
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
        
        return collectionView
    }()
    
//    private lazy var verticalTableView: UITableView = {
//        let tableView = UITableView()
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.separatorStyle = .none
//        tableView.register(CatalogVerticalTableViewCell.self, forCellReuseIdentifier: "verticalCell")
//        return tableView
//    }()
//    
//    private lazy var horizontalTableView: UITableView = {
//        let tableView = UITableView()
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.separatorStyle = .none
//        tableView.register(CatalogHorizontalTableViewCell.self, forCellReuseIdentifier: "horizontalCell")
//        return tableView
//    }()
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: ColorResource.Colors.EFEBE_9)
        addViews()
        setConstraints()
    }
    //- MARK: - Add & Set Views
    private func addViews() {
        view.addSubview(catalogTitle)
        view.addSubview(backView)
        backView.addSubview(sortButton)
        backView.addSubview(changeCatalogViewButton)
        backView.addSubview(collectionView)
    }
    //- MARK: - Constraints
    private func setConstraints() {
        catalogTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(92)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        backView.snp.makeConstraints { make in
            make.top.equalTo(catalogTitle.snp.bottom).offset(23)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
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
            make.bottom.horizontalEdges.equalToSuperview()
        }
    }
}
//- MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension CatalogMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 22
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catalogCell", for: indexPath) as! CatalogCollectionViewCell
        cell.setCell(image: UIImage(resource: ImageResource.Hardcode.goods), price: "12 900 ₽", name: "Массажёр эконом")
        return cell
    }
    
    
}
//- MARK: - UITableViewDelegate, UITableViewDataSource
//extension CatalogMainViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = CatalogVerticalTableViewCell()
//        return cell
//    }
//    
//    
//}
