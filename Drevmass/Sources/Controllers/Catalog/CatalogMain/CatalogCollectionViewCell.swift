//
//  CatalogCollectionViewCell.swift
//  Drevmass
//
//  Created by Aset Bakirov on 08.03.2024.
//

import UIKit
import SnapKit
import SDWebImage

class CatalogCollectionViewCell: UICollectionViewCell {
    //- MARK: - Variables
    weak var delegate: ProductAdding?
    var currentProduct = Product()
    //- MARK: - Local outlets
    lazy var goodsImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 16
        image.clipsToBounds = true
        return image
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .addFont(type: .SFProTextBold, size: 15)
        label.textColor = UIColor(resource: ColorResource.Colors._302_C_28)
        label.textAlignment = .left
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .addFont(type: .SFProTextRegular, size: 15)
        label.textColor = UIColor(resource: ColorResource.Colors._302_C_28)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    lazy var basketButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: ImageResource.Catalog.basketButton36), for: .normal)
        button.setImage(UIImage(resource: ImageResource.Catalog.basketButtonCheck36), for: .selected)
        button.addTarget(self, action: #selector(addToBasket), for: .touchUpInside)
        return button
    }()
    
    //- MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        setupViews()
        setupConstraints()
        self.isSelected = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //- MARK: - Setup Views
    func setupViews() {
        contentView.addSubview(goodsImage)
        contentView.addSubview(priceLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(basketButton)
    }
    //- MARK: - Constraints
    func setupConstraints() {
        goodsImage.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(100)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(goodsImage.snp.bottom).offset(12)
            make.leading.equalToSuperview()
            make.height.equalTo(20)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview()
            make.width.equalTo(117)
            make.height.equalTo(40)
        }
        basketButton.snp.makeConstraints { make in
            make.top.equalTo(goodsImage.snp.bottom).offset(12)
            make.trailing.equalToSuperview()
            make.size.equalTo(36)
        }
    }
    //- MARK: - Set Data
    func setCell(catalog: Product) {
        if catalog.basketCount > 0 {
            basketButton.isSelected = true
        } else {
            basketButton.isSelected = false
        }
        let transformer = SDImageResizingTransformer(size: CGSize(width: 167, height: 100), scaleMode: .aspectFill)
        goodsImage.sd_setImage(with: URL(string: imageSource.BASE_URL + catalog.imageSource), placeholderImage: nil, context: [.imageTransformer : transformer])
        priceLabel.text = formatPrice(catalog.price)
        nameLabel.text = catalog.title
    }
    //- MARK: - Button actions
    @objc func addToBasket() {
        //tabBarController?.tabBar.addBadge(index: 2, value: 2)
        basketButton.isSelected.toggle()
        delegate?.productDidAdd(product: currentProduct)
        
    }
}
