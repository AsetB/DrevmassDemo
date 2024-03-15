//
//  CatalogCollectionViewCell.swift
//  Drevmass
//
//  Created by Aset Bakirov on 08.03.2024.
//

import UIKit
import SnapKit

class CatalogCollectionViewCell: UICollectionViewCell {
    //- MARK: - Local outlets
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
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .addFont(type: .SFProTextBold, size: 15)
        label.textColor = UIColor(resource: ColorResource.Colors._302_C_28)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var basketButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: ImageResource.Catalog.basketButton36), for: .normal)
        return button
    }()
    
    //- MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        setupViews()
        setupConstraints()
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
            make.height.equalTo(40)
        }
        basketButton.snp.makeConstraints { make in
            make.top.equalTo(goodsImage.snp.bottom).offset(12)
            make.trailing.equalToSuperview()
            make.size.equalTo(36)
        }
    }
    //- MARK: - Set Data
    func setCell(image: UIImage, price: String, name: String) {
        goodsImage.image = image
        priceLabel.text = price
        nameLabel.text = name
    }
}
