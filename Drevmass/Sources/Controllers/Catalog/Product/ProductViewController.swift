//
//  ProductViewController.swift
//  Drevmass
//
//  Created by Aset Bakirov on 15.03.2024.
//

import UIKit
import SnapKit

class ProductViewController: UIViewController {
    //- MARK: - Local outlets
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
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
    
    private lazy var goodsImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 24
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .addFont(type: .SFProTextRegular, size: 17)
        label.textColor = UIColor(resource: ColorResource.Colors._302_C_28)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
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
    
    private lazy var openTutorialButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        //title
        let title = "Как использовать?"
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([NSAttributedString.Key.font : UIFont.addFont(type: .SFProTextSemiBold, size: 15) ]))
        //logo
        config.image = UIImage(resource: ImageResource.Catalog.sortUp24)
        config.imagePadding = 8
        //button
        config.baseForegroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        button.contentHorizontalAlignment = .center
        button.configuration = config
        return button
    }()
    
    private lazy var specificationView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(resource: ColorResource.Colors.F_3_F_1_F_0).cgColor
        //UpperPart
        let heightImage = UIImageView()
        heightImage.image = UIImage(resource: ImageResource.Catalog.sortUp24)
        
        let heightLabel = UILabel()
        heightLabel.text = "Рост"
        heightLabel.font = .addFont(type: .SFProTextRegular, size: 15)
        heightLabel.textColor = UIColor(resource: ColorResource.Colors._787878)
        
        let heightCentimeterLabel = UILabel()
        heightCentimeterLabel.font = .addFont(type: .SFProTextSemiBold, size: 15)
        heightCentimeterLabel.textColor = UIColor(resource: ColorResource.Colors._181715)
        
        //Lower Part
        let sizeImage = UIImageView()
        sizeImage.image = UIImage(resource: ImageResource.Catalog.sortUp24)
        
        let sizeLabel = UILabel()
        sizeLabel.text = "Размер"
        sizeLabel.font = .addFont(type: .SFProTextRegular, size: 15)
        sizeLabel.textColor = UIColor(resource: ColorResource.Colors._787878)
        
        let sizeCentimeterLabel = UILabel()
        sizeCentimeterLabel.font = .addFont(type: .SFProTextSemiBold, size: 15)
        sizeCentimeterLabel.textColor = UIColor(resource: ColorResource.Colors._181715)
        
        //Dashed Line
        var dashedLineView: DashedLineView = {
            var view = DashedLineView()
            view.dashColor = UIColor(resource: ColorResource.Colors.D_6_D_1_CE)
            view.backgroundColor = .clear
            view.spaceBetweenDash = 5
            view.perDashLength = 5
            return view
        }()
        
        view.addSubview(heightImage)
        view.addSubview(heightLabel)
        view.addSubview(heightCentimeterLabel)
        view.addSubview(dashedLineView)
        view.addSubview(sizeImage)
        view.addSubview(sizeLabel)
        view.addSubview(sizeCentimeterLabel)
        
        heightImage.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(18)
            make.size.equalTo(24)
        }
        heightLabel.snp.makeConstraints { make in
            make.leading.equalTo(heightImage.snp.trailing).offset(16)
            make.height.equalTo(20)
            make.centerY.equalTo(heightImage.snp.centerY)
        }
        heightCentimeterLabel.snp.makeConstraints { make in
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
        sizeCentimeterLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(18)
            make.height.equalTo(20)
            make.centerY.equalTo(sizeImage.snp.centerY)
        }
        return view
    }()
    
    private lazy var titleDescription: UILabel = {
        let label = UILabel()
        label.text = "Описание"
        label.font = .addFont(type: .SFProDisplaySemibold, size: 20)
        label.textColor = UIColor(resource: ColorResource.Colors._302_C_28)
        return label
    }()
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}
