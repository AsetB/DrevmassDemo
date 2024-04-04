//
//  CatalogHorizontalTableViewCell.swift
//  Drevmass
//
//  Created by Aset Bakirov on 08.03.2024.
//

import UIKit
import SnapKit
import SDWebImage
import SkeletonView

class CatalogHorizontalTableViewCell: UITableViewCell {
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
        label.font = .addFont(type: .SFProTextBold, size: 15)
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
        label.font = .addFont(type: .SFProTextRegular, size: 15)
        label.textColor = UIColor(resource: ColorResource.Colors._302_C_28)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.skeletonLineSpacing = 8
        label.skeletonTextLineHeight = .fixed(12)
        label.linesCornerRadius = 4
        return label
    }()
    
    private lazy var basketButton: UIButton = {
        let button = UIButton()
        button.skeletonCornerRadius = 18
        button.setImage(UIImage(resource: ImageResource.Catalog.basketButton36), for: .normal)
        button.setImage(UIImage(resource: ImageResource.Catalog.basketButtonCheck36), for: .selected)
        button.addTarget(self, action: #selector(addToBasket), for: .touchUpInside)
        return button
    }()
    //- MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "horizontalCell")
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
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
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
            make.verticalEdges.equalToSuperview().inset(16)
            make.leading.equalToSuperview()
            make.width.equalTo(146)
            make.height.equalTo(88)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalTo(goodsImage.snp.trailing).offset(12)
            make.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.leading.equalTo(nameLabel.snp.leading)
            make.height.equalTo(20)
        }
        basketButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
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
        goodsImage.sd_setImage(with: URL(string: imageSource.BASE_URL + catalog.imageSource), placeholderImage: nil, context: nil)
        priceLabel.text = formatPrice(catalog.price)
        nameLabel.text = catalog.title
    }
    //- MARK: - Button actions
    @objc func addToBasket() {
        basketButton.isSelected.toggle()
        delegate?.productDidAdd(product: currentProduct)
    }
}
