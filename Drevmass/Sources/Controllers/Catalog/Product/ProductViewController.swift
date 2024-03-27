//
//  ProductViewController.swift
//  Drevmass
//
//  Created by Aset Bakirov on 15.03.2024.
//

import UIKit
import SnapKit
import SDWebImage
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ProductViewController: UIViewController, UIScrollViewDelegate {
    //- MARK: - Variables
    private var heightCentimeterLabel: UILabel?
    private var sizeCentimeterLabel: UILabel?
    var productDetail = Product()
    var productSimilarArray: [Product] = []
    var productID: Int = 0
    //- MARK: - Local outlets
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        //scrollView.delegate = self
        scrollView.isScrollEnabled = true
        scrollView.bounces = true
        scrollView.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: ImageResource.Catalog.share24), for: .normal)
        button.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var goodsImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(resource: ImageResource.Hardcode.goods)
        image.layer.cornerRadius = 24
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "5-роликовый массажер"
        label.font = .addFont(type: .SFProTextRegular, size: 17)
        label.textColor = UIColor(resource: ColorResource.Colors._302_C_28)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "12 900 ₽"
        label.font = .addFont(type: .SFProDisplayBold, size: 28)
        label.textColor = UIColor(resource: ColorResource.Colors._302_C_28)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var addToBasketButton: UIButton = {
        let button = UIButton()
        button.setTitle("В корзину", for: .normal)
        button.setTitleColor(UIColor(resource: ColorResource.Colors.FFFFFF), for: .normal)
        button.titleLabel?.font = .addFont(type: .SFProTextSemiBold, size: 17)
        button.layer.cornerRadius = 28
        button.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        //button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        return button
    }()
    
    private lazy var addToBasketPriceButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 28
        button.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        //button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonMainLabel: UILabel = {
        let label = UILabel()
        label.text = "В корзину"
        label.font = .addFont(type: .SFProTextSemiBold, size: 17)
        label.textColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        return label
    }()
    
    private lazy var buttonPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "12 900 ₽"
        label.font = .addFont(type: .SFProTextSemiBold, size: 17)
        label.textColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        return label
    }()
    
    private lazy var openTutorialButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        //title
        let title = "Как использовать?"
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([NSAttributedString.Key.font : UIFont.addFont(type: .SFProTextSemiBold, size: 15) ]))
        //logo
        config.image = UIImage(resource: ImageResource.Catalog.tutorial28)
        config.imagePadding = 8
        //button
        config.baseForegroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        button.contentHorizontalAlignment = .center
        button.configuration = config
        return button
    }()
    
    private lazy var specificationView: UIView = { [weak self] in
        guard let self = self else { return UIView() }
        
        let view = UIView()
        view.layer.cornerRadius = 24
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(resource: ColorResource.Colors.F_3_F_1_F_0).cgColor
        //UpperPart
        let heightImage = UIImageView()
        heightImage.image = UIImage(resource: ImageResource.Catalog.weight28)
        
        let heightLabel = UILabel()
        heightLabel.text = "Рост"
        heightLabel.font = .addFont(type: .SFProTextRegular, size: 15)
        heightLabel.textColor = UIColor(resource: ColorResource.Colors._787878)
        
        let heightCentLabel = UILabel()
        heightCentLabel.text = "от 50-180 см"
        heightCentLabel.font = .addFont(type: .SFProTextSemiBold, size: 15)
        heightCentLabel.textColor = UIColor(resource: ColorResource.Colors._181715)
        self.heightCentimeterLabel = heightCentLabel
        
        //Lower Part
        let sizeImage = UIImageView()
        sizeImage.image = UIImage(resource: ImageResource.Catalog.size24)
        
        let sizeLabel = UILabel()
        sizeLabel.text = "Размер"
        sizeLabel.font = .addFont(type: .SFProTextRegular, size: 15)
        sizeLabel.textColor = UIColor(resource: ColorResource.Colors._787878)
        
        let sizeCentLabel = UILabel()
        sizeCentLabel.text = "16 см х 8 см"
        sizeCentLabel.font = .addFont(type: .SFProTextSemiBold, size: 15)
        sizeCentLabel.textColor = UIColor(resource: ColorResource.Colors._181715)
        self.sizeCentimeterLabel = sizeCentLabel
        
        //Dashed Line
        var dashedLineView: DashedLineView = {
            var view = DashedLineView()
            view.dashColor = UIColor(resource: ColorResource.Colors.D_6_D_1_CE)
            view.backgroundColor = .clear
            view.spaceBetweenDash = 6
            view.perDashLength = 5
            return view
        }()
        
        view.addSubview(heightImage)
        view.addSubview(heightLabel)
        view.addSubview(heightCentLabel)
        view.addSubview(dashedLineView)
        view.addSubview(sizeImage)
        view.addSubview(sizeLabel)
        view.addSubview(sizeCentLabel)
        
        heightImage.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(18)
            make.size.equalTo(24)
        }
        heightLabel.snp.makeConstraints { make in
            make.leading.equalTo(heightImage.snp.trailing).offset(16)
            make.height.equalTo(20)
            make.centerY.equalTo(heightImage.snp.centerY)
        }
        heightCentLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(18)
            make.height.equalTo(20)
            make.centerY.equalTo(heightImage.snp.centerY)
        }
        dashedLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(14)
            make.centerY.equalToSuperview()
        }
        sizeImage.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview().inset(18)
            make.size.equalTo(24)
        }
        sizeLabel.snp.makeConstraints { make in
            make.leading.equalTo(sizeImage.snp.trailing).offset(16)
            make.height.equalTo(20)
            make.centerY.equalTo(sizeImage.snp.centerY)
        }
        sizeCentLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(18)
            make.height.equalTo(20)
            make.centerY.equalTo(sizeImage.snp.centerY)
        }
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание"
        label.font = .addFont(type: .SFProDisplaySemibold, size: 20)
        label.textColor = UIColor(resource: ColorResource.Colors._302_C_28)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Массажер Древмасс - это эффективный тренажер, изготовленный из дерева бука, который представляет собой конструкцию из 5-ти роликов, закрепленных на деревянной раме и оснащенный удобной опорной рукояткой. Он является идеальным решением для тренировки различных групп мышц, включая спину, ноги. пресс, ягодицы и многое другое. Массажер Древмасс не только помогает укрепить мышцы спины и снять нагрузку с позвоночника, но и является универсальным тренажером для всего тела."
        label.font = .addFont(type: .SFProTextRegular, size: 16)
        label.textColor = UIColor(resource: ColorResource.Colors._787878)
        label.numberOfLines = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6.5
        paragraphStyle.alignment = .left
        let attributedString = NSMutableAttributedString(string: label.text ?? "default value")
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
        return label
    }()
    
    private lazy var similarGoodsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "С этим товаром покупают"
        label.font = .addFont(type: .SFProDisplaySemibold, size: 20)
        label.textColor = UIColor(resource: ColorResource.Colors._181715)
        return label
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
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        collectionView.isScrollEnabled = true
        collectionView.bounces = false
        return collectionView
    }()
    
    private var gradientView = CustomGradientView(startColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0), midColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1), endColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1), startLocation: 0.1, midLocation: 0.5, endLocation: 1.0, horizontalMode: false, diagonalMode: false)
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        navigationController?.navigationBar.tintColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(resource: ImageResource.Catalog.share24), style: .done, target: self, action: #selector(shareAction))
        downloadProductDetail()
        setViews()
        setConstraints()
        scrollView.delegate = self
        scrollView.contentSize = contentView.bounds.size
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        //navigationController?.isNavigationBarHidden = true
        addToBasketPriceButton.isHidden = true
        gradientView.isHidden = true
        gradientView.updateColors()
        gradientView.updateLocations()
        
        guard let navBar = navigationController?.navigationBar else { return }
        
        let navBarHeight = navBar.frame.height
        let offsetY = scrollView.contentOffset.y + navBarHeight
        let buttonY = addToBasketButton.frame.maxY - navBarHeight
        if offsetY > buttonY {
            addToBasketButton.isHidden = true
            addToBasketPriceButton.isHidden = false
            gradientView.isHidden = false
        } else {
            addToBasketButton.isHidden = false
            addToBasketPriceButton.isHidden = true
            gradientView.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //navigationController?.isNavigationBarHidden = false
    }
    //- MARK: - Set Views
    private func setViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(goodsImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(openTutorialButton)
        contentView.addSubview(specificationView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(similarGoodsTitleLabel)
        contentView.addSubview(collectionView)
        contentView.addSubview(addToBasketButton)
        view.addSubview(gradientView)
        view.addSubview(addToBasketPriceButton)
        addToBasketPriceButton.addSubview(buttonMainLabel)
        addToBasketPriceButton.addSubview(buttonPriceLabel)
    }
    //- MARK: - Set Constraints
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
        goodsImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(220)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(goodsImage.snp.bottom).offset(17)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(22)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(nameLabel.snp.horizontalEdges)
            make.height.equalTo(34)
        }
        addToBasketButton.snp.makeConstraints { make in
            make.bottom.equalTo(priceLabel.snp.bottom).offset(72)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }
        openTutorialButton.snp.makeConstraints { make in
            make.top.equalTo(addToBasketButton.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        specificationView.snp.makeConstraints { make in
            make.top.equalTo(openTutorialButton.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(116)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(specificationView.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(24)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        similarGoodsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(24)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(similarGoodsTitleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(180)
            make.bottom.equalToSuperview().inset(105)
        }
        addToBasketPriceButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }
        gradientView.snp.makeConstraints { make in
            make.bottom.equalTo(addToBasketPriceButton.snp.bottom).offset(16)
            make.height.equalTo(137)
            make.horizontalEdges.equalToSuperview()
        }
        buttonPriceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(24)
            make.height.equalTo(22)
        }
        buttonMainLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(22)
        }
        
    }
    //- MARK: - Data loading
    private func downloadProductDetail() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(AuthenticationService.shared.token)"]
        
        AF.request(URLs.GET_PRODUCT_BY_ID + String(productID), method: .get, headers: headers).responseData { [self] response in
            
            SVProgressHUD.dismiss()
            
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let productID = json["Product"]["id"].int {
                    self.productDetail.id = productID
                }
                if let productTitle = json["Product"]["title"].string {
                    self.productDetail.title = productTitle
                }
                if let productDesc = json["Product"]["description"].string {
                    self.productDetail.description = productDesc
                }
                if let productPrice = json["Product"]["price"].int {
                    self.productDetail.price = productPrice
                }
                if let productHeight = json["Product"]["height"].string {
                    self.productDetail.height = productHeight
                }
                if let productSize = json["Product"]["size"].string {
                    self.productDetail.size = productSize
                }
                if let productBasketCount = json["Product"]["basket_count"].int {
                    self.productDetail.basketCount = productBasketCount
                }
                if let productImage = json["Product"]["image_src"].string {
                    self.productDetail.imageSource = productImage
                }
                if let productVideo = json["Product"]["video_src"].string {
                    self.productDetail.videoSource = productVideo
                }
                if let productViewed = json["Product"]["viewed"].int {
                    self.productDetail.viewed = productViewed
                }
                self.setData()
                self.title = productDetail.title
                if let array = json["Recommend"].array {
                    self.productSimilarArray.removeAll()
                    for item in array {
                        let similarProduct = Product(json: item)
                        self.productSimilarArray.append(similarProduct)
                    }
                    self.collectionView.reloadData()
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
    //- MARK: - Set data
    func setData() {
        let transformer = SDImageResizingTransformer(size: CGSize(width: 357, height: 220), scaleMode: .aspectFill)
        goodsImage.sd_setImage(with: URL(string: imageSource.BASE_URL + productDetail.imageSource), placeholderImage: nil, context: [.imageTransformer : transformer])
        nameLabel.text = productDetail.title
        let priceRouble = formatPrice(productDetail.price)
        priceLabel.text = priceRouble
        buttonPriceLabel.text = priceRouble
        descriptionLabel.text = productDetail.description
        heightCentimeterLabel?.text = productDetail.height
        sizeCentimeterLabel?.text = productDetail.size
    }
    
    //- MARK: - Button Actions
    @objc func shareAction() {
        let text = "Привет! В приложении Древмасс нашёл «\(nameLabel.text!)», который стоит внимания. Для дополнительной выгоды используй мой промокод CXVO6WRP и получи 2500 бонусных рублей на счёт. Открой для себя мир комфорта и уюта с лучшими массажёрами. Загрузи приложение по ссылке: https://apps.apple.com/ru/app/drevmass/id6450933706."
        let image = goodsImage.image
        let shareAll = [text, image!] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            return
        }
    
        guard let navBar = navigationController?.navigationBar else { return }
        
        let navBarHeight = navBar.frame.height
        let offsetY = scrollView.contentOffset.y + navBarHeight
        let buttonY = addToBasketButton.frame.maxY - navBarHeight
        if offsetY > buttonY {
            addToBasketButton.isHidden = true
            addToBasketPriceButton.isHidden = false
            gradientView.isHidden = false
        } else {
            addToBasketButton.isHidden = false
            addToBasketPriceButton.isHidden = true
            gradientView.isHidden = true
        }
    }
}

//- MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension ProductViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productSimilarArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catalogCell", for: indexPath) as! CatalogCollectionViewCell
        cell.setCell(catalog: productSimilarArray[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let productVC = ProductViewController()
        productVC.productID = productSimilarArray[indexPath.item].id
        navigationController?.show(productVC, sender: self)
    }
    
    
}

