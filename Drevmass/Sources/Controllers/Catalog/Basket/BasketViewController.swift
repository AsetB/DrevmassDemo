//
//  BasketViewController.swift
//  Drevmass
//
//  Created by Aset Bakirov on 04.03.2024.
//

import UIKit
import SnapKit

class BasketViewController: UIViewController {
    //- MARK: - Variables
    
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
        label2.text = "Наполните её товарами из каталога"
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
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: ColorResource.Colors.EFEBE_9)
        
        setNavBar()
        addViews()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //navigationController?.navigationBar.prefersLargeTitles = false
        //navigationItem.title = " "
    }
    //- MARK: - SetupNavBar
    private func setNavBar() {
        navigationItem.title = "Корзина"
        navigationController?.navigationBar.tintColor = UIColor(resource: ColorResource.Colors._989898)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.addFont(type: .SFProDisplayBold, size: 28), .foregroundColor: UIColor(resource: ColorResource.Colors._302_C_28)]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(resource: ColorResource.Colors._302_C_28)]
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true

        // Initial setup for image for Large NavBar state since the the screen always has Large NavBar once it gets opened
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
            //make.height.equalTo(1500)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        emptyBasketView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(120)
            make.horizontalEdges.equalToSuperview().inset(56)
            make.height.equalTo(280)
        }
        
    }
    //- MARK: - Button actions
    @objc func clearAllBasket() {
        print("Clear basket")
    }
    
    @objc func goToCatalog() {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 1
        }
    }
}

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
