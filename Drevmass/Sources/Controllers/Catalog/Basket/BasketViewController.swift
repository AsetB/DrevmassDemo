//
//  BasketViewController.swift
//  Drevmass
//
//  Created by Aset Bakirov on 04.03.2024.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class BasketViewController: UIViewController {
    //- MARK: - Variables
    var productsInBasket: [BasketItem] = []
    var similarProductsBasket: [Product] = []
    var basketInfo = Basket()
    //- MARK: - Local outlets
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.bounces = true
        scrollView.backgroundColor = UIColor(resource: ColorResource.Colors.EFEBE_9)
        scrollView.showsVerticalScrollIndicator = true
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
    
    private lazy var clearBasketButton: UIButton = {
        let buttonWidth: CGFloat = 24.0
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: buttonWidth, height: buttonWidth)))
        button.setImage(UIImage(resource: ImageResource.Basket.delete24), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.addTarget(self, action: #selector(clearAllBasket), for: .touchUpInside)
        return button
    }()
    
    private lazy var emptyBasketView: UIView = {
        let view = UIView()
        
        let image = UIImageView()
        image.image = UIImage(resource: ImageResource.Basket.emptyBasket)
        
        let label1 = UILabel()
        label1.text = "В корзине пока ничего нет"
        label1.font = .addFont(type: .SFProTextSemiBold, size: 17)
        label1.textColor = UIColor(resource: ColorResource.Colors._181715)
        label1.textAlignment = .center
        
        let label2 = UILabel()
        label2.text = """
        Наполните её товарами из 
        каталога
        """
        label2.font = .addFont(type: .SFProTextRegular, size: 16)
        label2.textColor = UIColor(resource: ColorResource.Colors._989898)
        label2.textAlignment = .center
        label2.numberOfLines = 2
        
        lazy var goToCatalogButton: UIButton = {
            let button = UIButton()
            button.setTitle("Перейти в каталог", for: .normal)
            button.setTitleColor(UIColor(resource: ColorResource.Colors.FFFFFF), for: .normal)
            button.titleLabel?.font = .addFont(type: .SFProTextSemiBold, size: 16)
            button.layer.cornerRadius = 24
            button.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
            button.addTarget(self, action: #selector(goToCatalog), for: .touchUpInside)
            return button
        }()
        
        view.addSubview(image)
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(goToCatalogButton)
        
        image.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(112)
        }
        label1.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(22)
        }
        label2.snp.makeConstraints { make in
            make.top.equalTo(label1.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(46)
        }
        goToCatalogButton.snp.makeConstraints { make in
            make.top.equalTo(label2.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(48)
        }
        
        return view
    }()
    
    private lazy var basketTableView: SelfSizingTableView = {
        let tableView = SelfSizingTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(BasketTableViewCell.self, forCellReuseIdentifier: "basketCell")
        tableView.isScrollEnabled = false
        tableView.bounces = false
        return tableView
    }()
    
    private lazy var topLabel: UILabel = {
        let topLabel = UILabel()
        topLabel.font = .addFont(type: .SFProTextSemiBold, size: 17)
        topLabel.textColor = UIColor(resource: ColorResource.Colors._181715)
        topLabel.text = "Списать бонусы"
        return topLabel
    }()
    
    private lazy var bonusLabel: UILabel = {
        let bonusLabel = UILabel()
        bonusLabel.font = .addFont(type: .SFProTextSemiBold, size: 17)
        bonusLabel.textColor = UIColor(resource: ColorResource.Colors._181715)
        bonusLabel.text = ""
        return bonusLabel
    }()
    
    private lazy var bonusIcon: UIImageView = {
        let bonusIcon = UIImageView()
        bonusIcon.image = UIImage(resource: ImageResource.Basket.bonus)
        return bonusIcon
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = """
Баллами можно оплатить до 30% от 
стоимости заказа.
"""
        descriptionLabel.font = .addFont(type: .SFProTextRegular, size: 15)
        descriptionLabel.textColor = UIColor(resource: ColorResource.Colors._787878)
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textAlignment  = .left
        return descriptionLabel
    }()
    
    private lazy var bonusSwitch: UISwitch = {
        let bonusSwitch = UISwitch()
        //off state
        bonusSwitch.subviews.first?.subviews.first?.backgroundColor = UIColor(resource: ColorResource.Colors.E_0_DEDD)
        bonusSwitch.tintColor = UIColor(resource: ColorResource.Colors.E_0_DEDD)
        
        //on state
        bonusSwitch.onTintColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        bonusSwitch.addTarget(self, action: #selector(applyBonus), for: .valueChanged)
        return bonusSwitch
    }()
    
    private lazy var enterPromocodeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(resource: ColorResource.Colors.F_3_F_1_F_0).cgColor
        
        let icon = UIImageView()
        icon.image = UIImage(resource: ImageResource.Basket.promocode)
        
        let arrow = UIImageView()
        arrow.image = UIImage(resource: ImageResource.Basket.rightArrow)
        
        let label = UILabel()
        label.text = "Ввести промокод"
        label.textColor = UIColor(resource: ColorResource.Colors._181715)
        label.font = .addFont(type: .SFProTextSemiBold, size: 17)
        
        button.addSubview(icon)
        button.addSubview(arrow)
        button.addSubview(label)
        
        icon.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.leading.equalToSuperview().inset(14)
            make.centerY.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.leading.equalTo(icon.snp.trailing).offset(12)
            make.height.equalTo(22)
            make.centerY.equalToSuperview()
        }
        arrow.snp.makeConstraints { make in
            make.size.equalTo(16)
            make.trailing.equalToSuperview().inset(14)
            make.centerY.equalToSuperview()
        }
        
        button.addTarget(self, action: #selector(openPromocodeModal), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var backGroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor(resource: ColorResource.Colors.F_3_F_1_F_0)
        
        var dashedLineView: DashedLineView = {
            var view = DashedLineView()
            view.dashColor = UIColor(resource: ColorResource.Colors.D_6_D_1_CE)
            view.backgroundColor = .clear
            view.spaceBetweenDash = 6
            view.perDashLength = 5
            return view
        }()
        
        view.addSubview(dashedLineView)
        
        dashedLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(53.5)
        }
        return view
    }()
    
    private lazy var similarProductsLabel: UILabel = {
        let label = UILabel()
        label.font = .addFont(type: .SFProDisplaySemibold, size: 20)
        label.textColor = UIColor(resource: ColorResource.Colors._181715)
        label.text = "С этим товаром покупают"
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
    
    private lazy var orderButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 28
        button.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        button.addTarget(self, action: #selector(makeOrder), for: .touchUpInside)
        return button
    }()
    
    private lazy var orderButtonLabel: UILabel = {
        let label = UILabel()
        label.text = "Оформить"
        label.font = .addFont(type: .SFProTextSemiBold, size: 17)
        label.textColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        return label
    }()
    
    private lazy var orderButtonPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "15 390 ₽"
        label.font = .addFont(type: .SFProTextSemiBold, size: 17)
        label.textColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        return label
    }()
    
    private var gradientView = CustomGradientView(startColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0), midColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1), endColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1), startLocation: 0.1, midLocation: 0.5, endLocation: 1.0, horizontalMode: false, diagonalMode: false)
    
    // MARK: Background view labels
    private lazy var amountOfProductsLabel: UILabel = {
        let label = UILabel()
        label.font = .addFont(type: .SFProTextRegular, size: 13)
        label.textColor = UIColor(resource: ColorResource.Colors._787878)
        label.text = "1 товар"
        return label
    }()
    
    private lazy var payWithBonusLabel: UILabel = {
        let label = UILabel()
        label.font = .addFont(type: .SFProTextRegular, size: 13)
        label.textColor = UIColor(resource: ColorResource.Colors._787878)
        label.text = "Оплата бонусами"
        return label
    }()
    
    private lazy var priceForProductsLabel: UILabel = {
        let label = UILabel()
        label.font = .addFont(type: .SFProTextRegular, size: 13)
        label.textColor = UIColor(resource: ColorResource.Colors._181715)
        label.text = "12 900 ₽"
        label.textAlignment = .right
        return label
    }()
    
    private lazy var bonusToPayLabel: UILabel = {
        let label = UILabel()
        label.font = .addFont(type: .SFProTextRegular, size: 13)
        label.textColor = UIColor(resource: ColorResource.Colors.FA_5_C_5_C)
        label.text = "0 ₽"
        label.textAlignment = .right
        return label
    }()
    
    private lazy var totalForProductsLabel: UILabel = {
        let label = UILabel()
        label.font = .addFont(type: .SFProTextSemiBold, size: 15)
        label.textColor = UIColor(resource: ColorResource.Colors._181715)
        label.text = "Итого"
        return label
    }()
    
    private lazy var totalPriceForProductsLabel: UILabel = {
        let label = UILabel()
        label.font = .addFont(type: .SFProTextBold, size: 15)
        label.textColor = UIColor(resource: ColorResource.Colors._181715)
        label.text = "12 900 ₽"
        return label
    }()
    
    private var activityIndicator = MyActivityIndicator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    
    private var notificationView = NotificationView()
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: ColorResource.Colors.EFEBE_9)
        notificationView.alpha = 0
        setNavBar()
        addViews()
        setConstraints()
        setIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emptyBasketView.isHidden = true
        loadBasketData()
        gradientView.updateColors()
        gradientView.updateLocations()
        setNavBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        clearBasketButton.isHidden = true
        navigationItem.title = ""
    }
    //- MARK: - SetupNavBar
    private func setNavBar() {
        navigationItem.title = "Корзина"
        navigationController?.navigationBar.tintColor = UIColor(resource: ColorResource.Colors._989898)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.addFont(type: .SFProDisplayBold, size: 28), .foregroundColor: UIColor(resource: ColorResource.Colors._302_C_28)]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(resource: ColorResource.Colors._302_C_28)]
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true

        // Initial setup for Large NavBar state
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(clearBasketButton)
        clearBasketButton.clipsToBounds = true
        clearBasketButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            clearBasketButton.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.buttonRightMargin),
            clearBasketButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.buttonBottomMarginForLargeState),
            clearBasketButton.heightAnchor.constraint(equalToConstant: Const.buttonSizeForLargeState),
            clearBasketButton.widthAnchor.constraint(equalTo: clearBasketButton.heightAnchor)
            ])
    }
    //- MARK: - Add & Set Views
    private func addViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(backView)
        backView.addSubview(emptyBasketView)
        backView.addSubview(basketTableView)
        backView.addSubview(topLabel)
        backView.addSubview(bonusLabel)
        backView.addSubview(bonusIcon)
        backView.addSubview(bonusSwitch)
        backView.addSubview(descriptionLabel)
        backView.addSubview(enterPromocodeButton)
        backView.addSubview(backGroundView)
        backGroundView.addSubview(amountOfProductsLabel)
        backGroundView.addSubview(payWithBonusLabel)
        backGroundView.addSubview(priceForProductsLabel)
        backGroundView.addSubview(bonusToPayLabel)
        backGroundView.addSubview(totalForProductsLabel)
        backGroundView.addSubview(totalPriceForProductsLabel)
        backView.addSubview(similarProductsLabel)
        backView.addSubview(collectionView)
        view.addSubview(gradientView)
        view.addSubview(orderButton)
        orderButton.addSubview(orderButtonLabel)
        orderButton.addSubview(orderButtonPriceLabel)
    }
    private func setEmptyBasket() {
        if basketInfo.countProducts == 0 {
            scrollView.isScrollEnabled = false
            emptyBasketView.isHidden = false
            basketTableView.isHidden = true
            topLabel.isHidden = true
            bonusLabel.isHidden = true
            bonusIcon.isHidden = true
            descriptionLabel.isHidden = true
            enterPromocodeButton.isHidden = true
            backGroundView.isHidden = true
            similarProductsLabel.isHidden = true
            collectionView.isHidden = true
            gradientView.isHidden = true
            orderButton.isHidden = true
            bonusSwitch.isHidden = true
            clearBasketButton.isHidden = true
        } else {
            scrollView.isScrollEnabled = true
            emptyBasketView.isHidden = true
            basketTableView.isHidden = false
            topLabel.isHidden = false
            bonusLabel.isHidden = false
            bonusIcon.isHidden = false
            descriptionLabel.isHidden = false
            enterPromocodeButton.isHidden = false
            backGroundView.isHidden = false
            similarProductsLabel.isHidden = false
            collectionView.isHidden = false
            gradientView.isHidden = false
            orderButton.isHidden = false
            bonusSwitch.isHidden = false
            clearBasketButton.isHidden = false
        }
    }
    private func setIndicator() {
        activityIndicator.image = UIImage(resource: ImageResource.Registration.loading24)
        orderButton.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(24)
            make.size.equalTo(24)
        }
        activityIndicator.isHidden = true
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
        emptyBasketView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(120)
            make.horizontalEdges.equalToSuperview().inset(56)
            make.height.equalTo(280)
        }
        basketTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(topLabel.snp.top).offset(36.5).priority(.medium)
        }
        topLabel.snp.makeConstraints { make in
            make.top.equalTo(basketTableView.snp.bottom).offset(36.5)
            make.height.equalTo(22)
            make.leading.equalToSuperview().inset(16)
        }
        bonusLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.leading.equalTo(topLabel.snp.trailing).offset(4)
            make.centerY.equalTo(topLabel.snp.centerY)
        }
        bonusIcon.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.leading.equalTo(bonusLabel.snp.trailing).offset(4)
            make.centerY.equalTo(bonusLabel.snp.centerY)
        }
        bonusSwitch.snp.makeConstraints { make in
            make.width.equalTo(51)
            make.height.equalTo(31)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(bonusIcon.snp.centerY)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(8.5)
            make.leading.equalTo(topLabel.snp.leading)
            make.height.equalTo(40)
        }
        enterPromocodeButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(64)
        }
        backGroundView.snp.makeConstraints { make in
            make.top.equalTo(enterPromocodeButton.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(134)
        }
        similarProductsLabel.snp.makeConstraints { make in
            make.top.equalTo(backGroundView.snp.bottom).offset(32)
            make.height.equalTo(24)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(similarProductsLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(180)
            make.bottom.equalToSuperview().inset(105)
        }
        orderButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }
        gradientView.snp.makeConstraints { make in
            make.bottom.equalTo(orderButton.snp.bottom).offset(16)
            make.height.equalTo(137)
            make.horizontalEdges.equalToSuperview()
        }
        orderButtonPriceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(24)
            make.height.equalTo(22)
        }
        orderButtonLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(22)
        }
        amountOfProductsLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(18)
        }
        payWithBonusLabel.snp.makeConstraints { make in
            make.top.equalTo(amountOfProductsLabel.snp.bottom).offset(12)
            make.leading.equalTo(amountOfProductsLabel.snp.leading)
            make.height.equalTo(18)
        }
        priceForProductsLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(18)
        }
        bonusToPayLabel.snp.makeConstraints { make in
            make.top.equalTo(priceForProductsLabel.snp.bottom).offset(12)
            make.trailing.equalTo(priceForProductsLabel.snp.trailing)
            make.height.equalTo(18)
        }
        totalForProductsLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(19)
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(20)
        }
        totalPriceForProductsLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(19)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(20)
        }
    }
    //- MARK: - Button actions
    @objc func clearAllBasket() {
        print("delete tapped")
        let alert = UIAlertController(title: "Удаление товаров", message: "Вы уверены, что хотите удалить все товары?", preferredStyle: .actionSheet)
        alert.view.subviews.first?.subviews.first?.backgroundColor = .white
        alert.view.subviews.first?.subviews.first?.alpha = 1
        alert.view.subviews.first?.subviews.first?.layer.cornerRadius = 15
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(UIAlertAction(title: "Очистить корзину", style: .destructive, handler: { _ in
            
            let headers: HTTPHeaders = ["Authorization": "Bearer \(AuthenticationService.shared.token)"]
            
            AF.request(URLs.BASKET, method: .delete, headers: headers).responseData {  response in
                
                guard let responseCode = response.response?.statusCode else {
                    self.showAlertMessage(title: "Ошибка соединения", message: "Проверьте подключение")
                    return
                }
                
                if responseCode == 200 {
                    let json = JSON(response.data!)
                    print("JSON: \(json)")
                    DispatchQueue.main.async{
                        self.emptyBasketView.isHidden = true
                        self.loadBasketData()
                        self.gradientView.updateColors()
                        self.gradientView.updateLocations()
                    }
                    getTotalCount { totalCount in
                        DispatchQueue.main.async {
                            if totalCount == 0 {
                                self.tabBarController?.tabBar.removeBadge(index: 2)
                            } else {
                                self.tabBarController?.tabBar.addBadge(index: 2, value: totalCount)
                            }
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
        }))
        present(alert, animated: true)
    }
    
    @objc func goToCatalog() {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 1
        }
    }
    @objc func applyBonus() {
        if bonusSwitch.isOn {
            print("apply Bonus")
            totalPriceForProductsLabel.text = formatPrice(calculatePrice())
            orderButtonPriceLabel.text = formatPrice(calculatePrice())
            bonusToPayLabel.text = "- \(calculateUsedBonus()) ₽"
        } else {
            print("Do not apply Bonus")
            totalPriceForProductsLabel.text = formatPrice(basketInfo.totalPrice)
            orderButtonPriceLabel.text = formatPrice(basketInfo.totalPrice)
            bonusToPayLabel.text = "0 ₽"
        }
    }
    @objc func openPromocodeModal() {
        let vc = PromocodeBasketViewController()
        presentPanModal(vc)
        print("enter promocode tapped")
    }
    @objc func makeOrder() {
        let orderVC = OrderViewController()
        for item in productsInBasket {
            let productOrder = ProductOrder()
            productOrder.name = item.productTitle
            productOrder.price = item.price
            productOrder.productID = item.productID
            productOrder.quantity = item.count
            orderVC.productData.append(productOrder)
        }
        orderVC.orderData.bonus = calculateUsedBonus()
        orderVC.orderData.totalPrice = calculatePrice()
        navigationController?.show(orderVC, sender: self)
        
        //navigationController?.pushViewController(vc, animated: true)
    }
    //- MARK: - Set data
    private func setData() {
        bonusLabel.text = String(basketInfo.bonus)
        amountOfProductsLabel.text = "\(basketInfo.countProducts)" + " \(applyProductWordEnding(number: basketInfo.countProducts, singular: "товар", genitive: "товара", plural: "товаров"))"
        priceForProductsLabel.text = formatPrice(basketInfo.basketPrice)
        bonusToPayLabel.text = formatPrice(basketInfo.usedBonus)
        if bonusSwitch.isOn {
            totalPriceForProductsLabel.text = formatPrice(calculatePrice())
            orderButtonPriceLabel.text = formatPrice(calculatePrice())
            bonusToPayLabel.text = "- \(calculateUsedBonus()) ₽"
        } else {
            totalPriceForProductsLabel.text = formatPrice(basketInfo.totalPrice)
            orderButtonPriceLabel.text = formatPrice(basketInfo.totalPrice)
            bonusToPayLabel.text = "0 ₽"
        }
        if basketInfo.bonus == 0 {
            noBonus()
        }
    }
    
    private func noBonus() {
        topLabel.textColor = UIColor(resource: ColorResource.Colors._989898)
        bonusLabel.textColor = UIColor(resource: ColorResource.Colors._989898)
        descriptionLabel.text = """
На данный момент у вас нет бонусов
для списания.
"""
        bonusSwitch.isEnabled = false
    }
    
    private func applyProductWordEnding(number n: Int, singular s1: String, genitive s2: String, plural s5: String) -> String {
        let n1 = abs(n) % 100 //две последние цифры числа убираем
        if n1 >= 11 && n1 <= 19 { // еслм это от 11 до 19 вернем мн.ч
            return s5
        }
        
        let n2 = n1 % 10 //убираем последнюю цифру
        if n2 == 1 { // ед.ч
            return s1
        }
        
        if n2 > 1 && n2 < 5 { //род.падеж
            return s2
        }
        
        return s5 //во всех ост случаях мн.ч
    }
    //- MARK: - Network
    private func loadBasketData() {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(AuthenticationService.shared.token)"]
        
        AF.request(URLs.BASKET, method: .get, headers: headers).responseData {  response in
            
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8) ?? ""
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                //parse basket items
                if let array = json["basket"].array {
                    self.productsInBasket.removeAll()
                    for item in array {
                        let basketItem = BasketItem(json: item)
                        self.productsInBasket.append(basketItem)
                    }
                    self.basketTableView.reloadData()
                }
                //parse similar products
                if let array = json["products"].array {
                    self.similarProductsBasket.removeAll()
                    for item in array {
                        let similarProducts = Product(json: item)
                        self.similarProductsBasket.append(similarProducts)
                    }
                    self.collectionView.reloadData()
                }
                //parse basket
                if let bonus = json["bonus"].int {
                    self.basketInfo.bonus = bonus
                }
                if let totalPrice = json["total_price"].int {
                    self.basketInfo.totalPrice = totalPrice
                }
                if let usedBonus = json["used_bonus"].int {
                    self.basketInfo.usedBonus = usedBonus
                }
                if let basketPrice = json["basket_price"].int {
                    self.basketInfo.basketPrice = basketPrice
                }
                if let discount = json["discount"].int {
                    self.basketInfo.discount = discount
                }
                if let countProducts = json["count_products"].int {
                    self.basketInfo.countProducts = countProducts
                }
                self.setEmptyBasket()
                self.setData()
            } else {
                self.notificationView.show(viewController: self, notificationType: .attantion)
                self.notificationView.titleLabel.text = "Ошибка соединения"
            }
        }
    }
    
    //- MARK: - CalculatePrice
    private func calculatePrice() -> Int {
        let basketPrice = basketInfo.basketPrice
        let availableBonus = basketInfo.bonus
        let maximumPayWithBonus = (basketPrice * 30) / 100
        var finalPrice = 0
        
        if availableBonus <= maximumPayWithBonus {
            finalPrice = basketPrice - availableBonus
        } else {
            finalPrice = basketPrice - maximumPayWithBonus
        }
        finalPrice = max(finalPrice, 0)
        return finalPrice
    }
    
    private func calculateUsedBonus() -> Int {
        let basketPrice = basketInfo.basketPrice
        let availableBonus = basketInfo.bonus
        let maximumPayWithBonus = (basketPrice * 30) / 100
        var usedBonus = 0
        
        if availableBonus <= maximumPayWithBonus {
            usedBonus = availableBonus
            return usedBonus
        } else {
            usedBonus = maximumPayWithBonus
            return usedBonus
        }
    }
}
//- MARK: - UITableViewDelegate & UITableViewDataSource
extension BasketViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsInBasket.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = basketTableView.dequeueReusableCell(withIdentifier: "basketCell") as! BasketTableViewCell
        cell.setCell(product: productsInBasket[indexPath.row])
        cell.currentBasketItem = productsInBasket[indexPath.row]
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productVC = ProductViewController()
        productVC.productID = productsInBasket[indexPath.row].productID
        navigationController?.show(productVC, sender: self)
    }
    
}
//- MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension BasketViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarProductsBasket.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catalogCell", for: indexPath) as! CatalogCollectionViewCell
        cell.setCell(catalog: similarProductsBasket[indexPath.item])
        cell.currentProduct = similarProductsBasket[indexPath.item]
        cell.delegate = self
        return cell
    }
}

//- MARK: - Similar products adding to basket
extension BasketViewController: ProductAdding {
    func productDidAdd(product: Product) {
        if product.basketCount > 0 {
            let headers: HTTPHeaders = ["Authorization": "Bearer \(AuthenticationService.shared.token)"]
            
            orderButtonPriceLabel.isHidden = true
            activityIndicator.startAnimating()
            
            AF.request(URLs.DELETE_ITEM_BASKET + String(product.id), method: .delete, headers: headers).responseData {  response in
                
                self.activityIndicator.stopAnimating()
                self.orderButtonPriceLabel.isHidden = false
                
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
                            self.loadBasketData()
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
        
        orderButtonPriceLabel.isHidden = true
        activityIndicator.startAnimating()
        
        AF.request(URLs.BASKET, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData {  response in
            
            self.activityIndicator.stopAnimating()
            self.orderButtonPriceLabel.isHidden = false
            
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
                        self.loadBasketData()
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

//- MARK: - TableView product increment and decrement
extension BasketViewController: ProductCounting {
    func productDidCount(basketItem: BasketItem, countIs: CountType) {
        switch countIs {
        case .increment:
            let headers: HTTPHeaders = ["Authorization": "Bearer \(AuthenticationService.shared.token)"]
            let parameters = ["count": basketItem.count, "product_id": basketItem.productID, "user_id": 0]
            
            orderButtonPriceLabel.isHidden = true
            activityIndicator.startAnimating()
            
            AF.request(URLs.INCREASE_ITEM_BASKET, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
                
                self.activityIndicator.stopAnimating()
                self.orderButtonPriceLabel.isHidden = false
                
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
                            self.loadBasketData()
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
        case .decrement:
            if basketItem.count == 1 {
                let alert = UIAlertController(title: "Вы уверены, что хотите удалить товар из корзины?", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { _ in
                    
                    let headers: HTTPHeaders = ["Authorization": "Bearer \(AuthenticationService.shared.token)"]
                    let parameters = ["count": basketItem.count, "product_id": basketItem.productID, "user_id": 0]
                    
                    self.orderButtonPriceLabel.isHidden = true
                    self.activityIndicator.startAnimating()
                    
                    AF.request(URLs.DECREASE_ITEM_BASKET, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
                        
                        self.activityIndicator.stopAnimating()
                        self.orderButtonPriceLabel.isHidden = false
                        
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
                                    self.loadBasketData()
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
                }))
                present(alert, animated: true)
                return
            }
            let headers: HTTPHeaders = ["Authorization": "Bearer \(AuthenticationService.shared.token)"]
            let parameters = ["count": basketItem.count, "product_id": basketItem.productID, "user_id": 0]
            
            orderButtonPriceLabel.isHidden = true
            activityIndicator.startAnimating()
            
            AF.request(URLs.DECREASE_ITEM_BASKET, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
                
                self.activityIndicator.stopAnimating()
                self.orderButtonPriceLabel.isHidden = false
                
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
                            self.loadBasketData()
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
}

//- MARK: - Navigation bar button constants
private struct Const {
    /// Image height/width for Large NavBar state
    static let buttonSizeForLargeState: CGFloat = 24
    /// Margin from right anchor of safe area to right anchor of Image
    static let buttonRightMargin: CGFloat = 16
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
    static let buttonBottomMarginForLargeState: CGFloat = 12
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
    static let buttonBottomMarginForSmallState: CGFloat = 9
    /// Image height/width for Small NavBar state
    static let buttonSizeForSmallState: CGFloat = 24
    /// Height of NavBar for Small state. Usually it's just 44
    static let NavBarHeightSmallState: CGFloat = 44
    /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
    static let NavBarHeightLargeState: CGFloat = 96.5
}

