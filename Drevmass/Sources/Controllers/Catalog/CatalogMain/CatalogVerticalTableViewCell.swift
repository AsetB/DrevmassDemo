//
//  CatalogVerticalTableViewCell.swift
//  Drevmass
//
//  Created by Aset Bakirov on 08.03.2024.
//

import UIKit
import SnapKit
import SDWebImage
import SkeletonView

class CatalogVerticalTableViewCell: UITableViewCell {
    //- MARK: - Variables
    weak var delegate: ProductAdding?
    var currentProduct = Product()
    //- MARK: - Local Outlets
    private lazy var goodsImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 16
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .addFont(type: .SFProTextBold, size: 20)
        label.textColor = UIColor(resource: ColorResource.Colors._302_C_28)
        label.textAlignment = .left
        label.skeletonTextNumberOfLines = 1
        label.skeletonLineSpacing = 8
        label.skeletonTextLineHeight = .fixed(12)
        label.linesCornerRadius = 4
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .addFont(type: .SFProTextRegular, size: 14)
        label.textColor = UIColor(resource: ColorResource.Colors._302_C_28)
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.skeletonLineSpacing = 8
        label.skeletonTextLineHeight = .fixed(12)
        label.linesCornerRadius = 4
        return label
    }()
    
    private lazy var basketButton: UIButton = {
        let button = UIButton()
        button.skeletonCornerRadius = 18
        button.setImage(UIImage(resource: ImageResource.Catalog.basketButton48), for: .normal)
        button.setImage(UIImage(resource: ImageResource.Catalog.basketButtonCheck48), for: .selected)
        button.addTarget(self, action: #selector(addToBasket), for: .touchUpInside)
        return button
    }()
    //- MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "verticalCell")
        self.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        self.isSkeletonable = true
        setupViews()
        setupConstraints()
        self.selectedBackgroundView = {
            let view = UIView()
            view.backgroundColor = UIColor.clear
            return view
        }()
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
        contentView.isSkeletonable = true
        goodsImage.isSkeletonable = true
        priceLabel.isSkeletonable = true
        nameLabel.isSkeletonable = true
        basketButton.isSkeletonable = true
    }
    
    //- MARK: - Constarints
    func setupConstraints() {
        goodsImage.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(202)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(goodsImage.snp.bottom).offset(12)
            make.leading.equalToSuperview()
            make.height.equalTo(24)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview()
            make.width.equalTo(279)
            make.height.equalTo(22)
        }
        basketButton.snp.makeConstraints { make in
            make.top.equalTo(goodsImage.snp.bottom).offset(12)
            make.trailing.equalToSuperview()
            make.size.equalTo(48)
        }
    }
    //- MARK: - Set Data
    func setCell(catalog: Product) {
        if catalog.basketCount > 0 {
            basketButton.isSelected = true
        } else {
            basketButton.isSelected = false
        }
        let transformer = SDImageResizingTransformer(size: CGSize(width: 343, height: 202), scaleMode: .aspectFill)
        goodsImage.sd_setImage(with: URL(string: imageSource.BASE_URL + catalog.imageSource), placeholderImage: nil, context: [.imageTransformer : transformer])
        priceLabel.text = formatPrice(catalog.price)
        nameLabel.text = catalog.title
    }
    //- MARK: - Button actions
    @objc func addToBasket() {
        basketButton.isSelected.toggle()
        delegate?.productDidAdd(product: currentProduct)
    }
}
