//
//  CatalogMainViewController.swift
//  Drevmass
//
//  Created by Aset Bakirov on 04.03.2024.
//

import UIKit
import SnapKit
import Alamofire
import SVProgressHUD
import SwiftyJSON
import Network
import SkeletonView

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
    
    var famousCatalog: [Product] = []
    var pricedownCatalog: [Product] = []
    var priceupCatalog: [Product] = []
    
    var currentSortMain: SortType = .famous
    
    var request: Request?
    private let monitor = NWPathMonitor(requiredInterfaceType: .wifi)
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
        button.addTarget(self, action: #selector(sortAction), for: .touchUpInside)
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
    
    private var noSignalView = NoSignalUIView()
    private var notificationView = NotificationView()
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: ColorResource.Colors.EFEBE_9)
        
        primaryDownloadFamousCatalog()
        addViews()
        setConstraints()
        showCatalogView(currentView)
        horizontalTableView.isHidden = true
        verticalTableView.isHidden = true
        noSignalView.isHidden = true
        notificationView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.isSkeletonable = true
        verticalTableView.isSkeletonable = true
        horizontalTableView.isSkeletonable = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.addFont(type: .SFProDisplayBold, size: 28), .foregroundColor: UIColor(resource: ColorResource.Colors._302_C_28)]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(resource: ColorResource.Colors._302_C_28)]
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.title = "Каталог"
        sortDidSelect(currentSortMain)//тут переключение происходит
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
        backView.addSubview(noSignalView)
        backView.addSubview(sortButton)
        backView.addSubview(changeCatalogViewButton)
        backView.addSubview(collectionView)
        backView.addSubview(verticalTableView)
        backView.addSubview(horizontalTableView)
    }
    private func setNoSignalViewOn() {
        noSignalView.isHidden = false
        noSignalView.button.addTarget(self, action: #selector(reloadScreen), for: .touchUpInside)
        collectionView.isHidden = true
        verticalTableView.isHidden = true
        horizontalTableView.isHidden = true
    }
    private func setNoSignalViewOff() {
        downloadFamousCatalog()
        noSignalView.isHidden = true
        collectionView.isHidden = false
        verticalTableView.isHidden = false
        horizontalTableView.isHidden = false
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
        noSignalView.snp.makeConstraints { make in
            make.top.equalToSuperview()
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
        sortDidSelect(currentSortMain)
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
    
    @objc private func sortAction() {
        let sortVC = SortCatalogViewController()
        sortVC.delegate = self
        sortVC.currentSort = currentSortMain
        presentPanModal(sortVC)
    }
    @objc private func reloadScreen() {
        setNoSignalViewOff()
    }
    //- MARK: - Data loading
    private func primaryDownloadFamousCatalog() {
        request?.cancel()
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(AuthenticationService.shared.token)"]
        
        DispatchQueue.main.async {
            self.collectionView.showAnimatedSkeleton(usingColor: UIColor(resource: ColorResource.Colors.EFEBE_9))
            self.horizontalTableView.showAnimatedSkeleton(usingColor: UIColor(resource: ColorResource.Colors.EFEBE_9))
            self.verticalTableView.showAnimatedSkeleton(usingColor: UIColor(resource: ColorResource.Colors.EFEBE_9))
        }
        
        request = AF.request(URLs.GET_PRODUCT_FAMOUS, method: .get, headers: headers).responseData { response in
    
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8) ?? ""
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let array = json.array {
                    self.famousCatalog.removeAll()
                    for item in array {
                        let famousProduct = Product(json: item)
                        self.famousCatalog.append(famousProduct)
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.verticalTableView.reloadData()
                        self.horizontalTableView.reloadData()
                        self.collectionView.hideSkeleton()
                        self.horizontalTableView.hideSkeleton()
                        self.verticalTableView.hideSkeleton()
                    }
                }
            } else {
                self.monitor.pathUpdateHandler = { path in
                    if path.status == .unsatisfied {
                        DispatchQueue.main.async {
                            self.setNoSignalViewOn()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.setNoSignalViewOff()
                        }
                    }
                }
                self.monitor.start(queue: DispatchQueue(label: "network_monitor"))
            }
        }
    }
    
    private func downloadFamousCatalog() {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(AuthenticationService.shared.token)"]
        
        AF.request(URLs.GET_PRODUCT_FAMOUS, method: .get, headers: headers).responseData { response in
    
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8) ?? ""
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let array = json.array {
                    self.famousCatalog.removeAll()
                    for item in array {
                        let famousProduct = Product(json: item)
                        self.famousCatalog.append(famousProduct)
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.verticalTableView.reloadData()
                        self.horizontalTableView.reloadData()
                        self.collectionView.hideSkeleton()
                        self.horizontalTableView.hideSkeleton()
                        self.verticalTableView.hideSkeleton()
                    }
                }
            } else {
                var ErrorString = "CONNECTION_ERROR"
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + " \(sCode)"
                }
                ErrorString = ErrorString + " \(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
        }
    }
    
    private func downloadPriceupCatalog() {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(AuthenticationService.shared.token)"]
        
        AF.request(URLs.GET_PRODUCT_PRICEUP, method: .get, headers: headers).responseData { response in
            
            
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8) ?? ""
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let array = json.array {
                    self.priceupCatalog.removeAll()
                    for item in array {
                        let priceupProduct = Product(json: item)
                        self.priceupCatalog.append(priceupProduct)
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.verticalTableView.reloadData()
                        self.horizontalTableView.reloadData()
                        self.collectionView.hideSkeleton()
                        self.horizontalTableView.hideSkeleton()
                        self.verticalTableView.hideSkeleton()
                    }
                } else {
                    SVProgressHUD.showError(withStatus: "Error with updating data")
                }
            } else {
                var ErrorString = "CONNECTION_ERROR"
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + " \(sCode)"
                }
                ErrorString = ErrorString + " \(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
        }
    }
    
    private func downloadPricedownCatalog() {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(AuthenticationService.shared.token)"]
        
        AF.request(URLs.GET_PRODUCT_PRICEDOWN, method: .get, headers: headers).responseData { response in
            
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8) ?? ""
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let array = json.array {
                    self.pricedownCatalog.removeAll()
                    for item in array {
                        let pricedownProduct = Product(json: item)
                        self.pricedownCatalog.append(pricedownProduct)
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.verticalTableView.reloadData()
                        self.horizontalTableView.reloadData()
                        self.collectionView.hideSkeleton()
                        self.horizontalTableView.hideSkeleton()
                        self.verticalTableView.hideSkeleton()
                    }
                } else {
                    SVProgressHUD.showError(withStatus: "Error with updating data")
                }
            } else {
                var ErrorString = "CONNECTION_ERROR"
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + " \(sCode)"
                }
                ErrorString = ErrorString + " \(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
        }
    }
    
}
//- MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension CatalogMainViewController: UICollectionViewDelegate, SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        if currentSortMain == .pricedown {
            let cell = "catalogCell"
            return cell
        }
        if currentSortMain == .priceup {
            let cell = "catalogCell"
            return cell
        }
        
        let cell = "catalogCell"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if currentSortMain == .pricedown {
            return pricedownCatalog.count
        }
        if currentSortMain == .priceup {
            return priceupCatalog.count
        }
        return famousCatalog.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if currentSortMain == .pricedown {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catalogCell", for: indexPath) as! CatalogCollectionViewCell
            cell.setCell(catalog: pricedownCatalog[indexPath.item])
            cell.currentProduct = pricedownCatalog[indexPath.item]
            cell.delegate = self
            return cell
        }
        if currentSortMain == .priceup {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catalogCell", for: indexPath) as! CatalogCollectionViewCell
            cell.setCell(catalog: priceupCatalog[indexPath.item])
            cell.currentProduct = priceupCatalog[indexPath.item]
            cell.delegate = self
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catalogCell", for: indexPath) as! CatalogCollectionViewCell
        cell.setCell(catalog: famousCatalog[indexPath.item])
        cell.currentProduct = famousCatalog[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        if currentSortMain == .pricedown {
            let productVC = ProductViewController()
            productVC.productID = pricedownCatalog[indexPath.item].id
            navigationController?.show(productVC, sender: self)
            return
        }
        if currentSortMain == .priceup {
            let productVC = ProductViewController()
            productVC.productID = priceupCatalog[indexPath.item].id
            navigationController?.show(productVC, sender: self)
            return
        }
        let productVC = ProductViewController()
        productVC.productID = famousCatalog[indexPath.item].id
        navigationController?.show(productVC, sender: self)
    }
    
}
//- MARK: - UITableViewDelegate, UITableViewDataSource
extension CatalogMainViewController: UITableViewDelegate, SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        if currentView == .horizontalTableView {
            if currentSortMain == .pricedown {
                let cell = "horizontalCell"
                return cell
            }
            if currentSortMain == .priceup {
                let cell = "horizontalCell"
                return cell
            }
            let cell = "horizontalCell"
            return cell
        }
        if currentSortMain == .pricedown {
            let cell = "verticalCell"
            return cell
        }
        if currentSortMain == .priceup {
            let cell = "verticalCell"
            return cell
        }
        let cell = "verticalCell"
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if currentSortMain == .pricedown {
//            return pricedownCatalog.count
//        }
//        if currentSortMain == .priceup {
//            return priceupCatalog.count
//        }
//        return famousCatalog.count
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentSortMain == .pricedown {
            return pricedownCatalog.count
        }
        if currentSortMain == .priceup {
            return priceupCatalog.count
        }
        return famousCatalog.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if currentView == .horizontalTableView {
            return 120
        }
        return 292
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currentView == .horizontalTableView {
            if currentSortMain == .pricedown {
                let cell = horizontalTableView.dequeueReusableCell(withIdentifier: "horizontalCell") as! CatalogHorizontalTableViewCell
                cell.setCell(catalog: pricedownCatalog[indexPath.item])
                cell.currentProduct = pricedownCatalog[indexPath.item]
                cell.delegate = self
                return cell
            }
            if currentSortMain == .priceup {
                let cell = horizontalTableView.dequeueReusableCell(withIdentifier: "horizontalCell") as! CatalogHorizontalTableViewCell
                cell.setCell(catalog: priceupCatalog[indexPath.item])
                cell.currentProduct = priceupCatalog[indexPath.item]
                cell.delegate = self
                return cell
            }
            let cell = horizontalTableView.dequeueReusableCell(withIdentifier: "horizontalCell") as! CatalogHorizontalTableViewCell
            cell.setCell(catalog: famousCatalog[indexPath.item])
            cell.currentProduct = famousCatalog[indexPath.item]
            cell.delegate = self
            return cell
        }
        if currentSortMain == .pricedown {
            let cell = verticalTableView.dequeueReusableCell(withIdentifier: "verticalCell") as! CatalogVerticalTableViewCell
            cell.setCell(catalog: pricedownCatalog[indexPath.item])
            cell.currentProduct = pricedownCatalog[indexPath.item]
            cell.delegate = self
            return cell
        }
        if currentSortMain == .priceup {
            let cell = verticalTableView.dequeueReusableCell(withIdentifier: "verticalCell") as! CatalogVerticalTableViewCell
            cell.setCell(catalog: priceupCatalog[indexPath.item])
            cell.currentProduct = priceupCatalog[indexPath.item]
            cell.delegate = self
            return cell
        }
        let cell = verticalTableView.dequeueReusableCell(withIdentifier: "verticalCell") as! CatalogVerticalTableViewCell
        cell.setCell(catalog: famousCatalog[indexPath.item])
        cell.currentProduct = famousCatalog[indexPath.item]
        cell.delegate = self
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if currentSortMain == .pricedown {
            let productVC = ProductViewController()
            productVC.productID = pricedownCatalog[indexPath.item].id
            navigationController?.show(productVC, sender: self)
            return
        }
        if currentSortMain == .priceup {
            let productVC = ProductViewController()
            productVC.productID = priceupCatalog[indexPath.item].id
            navigationController?.show(productVC, sender: self)
            return
        }
        let productVC = ProductViewController()
        productVC.productID = famousCatalog[indexPath.item].id
        navigationController?.show(productVC, sender: self)
    }
}
//- MARK: - Protocol SortSelecting
extension CatalogMainViewController: SortSelecting {
    func sortDidSelect(_ sortSelected: SortType) {
        switch sortSelected {
        case .famous:
            print("famous in main")
            currentSortMain = .famous
            downloadFamousCatalog()
            sortButton.setAttributedTitle(NSAttributedString(AttributedString("По популярности", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont.addFont(type: .SFProDisplayBold, size: 15) ]))), for: .normal)
            sortButton.configuration?.image = UIImage(resource: ImageResource.Catalog.sortUp24)
            sortButton.configuration?.baseForegroundColor = UIColor(resource: ColorResource.Colors._302_C_28)
        case .priceup:
            print("priceup in main")
            currentSortMain = .priceup
            downloadPriceupCatalog()
            sortButton.setAttributedTitle(NSAttributedString(AttributedString("По возрастанию цены", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont.addFont(type: .SFProDisplayBold, size: 15) ]))), for: .normal)
            sortButton.configuration?.image = UIImage(resource: ImageResource.Catalog.sortUp24)
            sortButton.configuration?.baseForegroundColor = UIColor(resource: ColorResource.Colors._302_C_28)
        case .pricedown:
            print("pricedown in main")
            currentSortMain = .pricedown
            downloadPricedownCatalog()
            sortButton.setAttributedTitle(NSAttributedString(AttributedString("По убыванию цены", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont.addFont(type: .SFProDisplayBold, size: 15) ]))), for: .normal)
            sortButton.configuration?.image = UIImage(resource: ImageResource.Catalog.sortDown24)
            sortButton.configuration?.baseForegroundColor = UIColor(resource: ColorResource.Colors._302_C_28)
        }
    }
}

extension CatalogMainViewController: ProductAdding {
    func productDidAdd(product: Product) {
        if product.basketCount > 0 {
            let headers: HTTPHeaders = ["Authorization": "Bearer \(AuthenticationService.shared.token)"]
            AF.request(URLs.DELETE_ITEM_BASKET + String(product.id), method: .delete, headers: headers).responseData { response in
                guard let responseCode = response.response?.statusCode else {
                    self.showAlertMessage(title: "Ошибка соединения", message: "Проверьте подключение")
                    return
                }
                if responseCode == 200 {
                    let json = JSON(response.data!)
                    print("JSON: \(json)")
                    
                    getTotalCount { totalCount in
                        DispatchQueue.main.async {
                            if totalCount == 0 {
                                self.tabBarController?.tabBar.removeBadge(index: 2)
                            } else {
                                self.tabBarController?.tabBar.addBadge(index: 2, value: totalCount)
                            }
                            self.sortDidSelect(self.currentSortMain)
                        }
                    }
                } else {
                    var resultString = ""
                    if let data = response.data {
                        resultString = String(data: data, encoding: .utf8) ?? ""
                    }
                    var ErrorString = "Ошибка"
                    if let statusCode = response.response?.statusCode {
                        ErrorString = ErrorString + " \(statusCode)"
                    }
                    ErrorString = ErrorString + " \(resultString)"
                    self.showAlertMessage(title: "Ошибка соединения", message: "\(ErrorString)")
                }
            }
            return
        }
        let headers: HTTPHeaders = ["Authorization": "Bearer \(AuthenticationService.shared.token)"]
        let parameters = ["count": product.basketCount+1, "product_id": product.id, "user_id": 0]
        
        AF.request(URLs.BASKET, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
            guard let responseCode = response.response?.statusCode else {
                self.showAlertMessage(title: "Ошибка соединения", message: "Проверьте подключение")
                return
            }
            
            if responseCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                getTotalCount { totalCount in
                    DispatchQueue.main.async {
                        self.tabBarController?.tabBar.addBadge(index: 2, value: totalCount)
                        self.sortDidSelect(self.currentSortMain)
                    }
                }
            } else {
                var resultString = ""
                if let data = response.data {
                    resultString = String(data: data, encoding: .utf8) ?? ""
                }
                var ErrorString = "Ошибка"
                if let statusCode = response.response?.statusCode {
                    ErrorString = ErrorString + " \(statusCode)"
                }
                ErrorString = ErrorString + " \(resultString)"
                self.showAlertMessage(title: "Ошибка соединения", message: "\(ErrorString)")
            }
        }
    }
    
    
}
