//
//  BasketTableViewCell.swift
//  Drevmass
//
//  Created by Aset Bakirov on 21.03.2024.
//

import UIKit
import SnapKit
import SDWebImage

class BasketTableViewCell: UITableViewCell {
    //- MARK: - Variables
    var counterLabel: UILabel?
    weak var delegate: ProductCounting?
    var currentBasketItem = BasketItem()
    //- MARK: - Local Outlets
    lazy var goodsImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 17
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
    
    lazy var counterView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor(resource: ColorResource.Colors.F_3_F_1_F_0)
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        
        let minusButton = UIButton()
        minusButton.setImage(UIImage(resource: ImageResource.Basket.minus16), for: .normal)
        minusButton.addTarget(self, action: #selector(decreaseCounter), for: .touchUpInside)
        
        let plusButton = UIButton()
        plusButton.setImage(UIImage(resource: ImageResource.Basket.plus16), for: .normal)
        plusButton.addTarget(self, action: #selector(increaseCounter), for: .touchUpInside)
        
        let counterLabel = UILabel()
        counterLabel.text = "1"
        counterLabel.font = .addFont(type: .SFProTextSemiBold, size: 15)
        counterLabel.textColor = UIColor(resource: ColorResource.Colors._302_C_28)
        self.counterLabel = counterLabel
        
        view.addSubview(counterLabel)
        view.addSubview(minusButton)
        view.addSubview(plusButton)
        
        minusButton.snp.makeConstraints { make in
            make.width.equalTo(32)
            make.height.equalTo(28)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        plusButton.snp.makeConstraints { make in
            make.width.equalTo(32)
            make.height.equalTo(28)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        counterLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        return view
    }()
    //- MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "basketCell")
        self.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
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
        contentView.addSubview(counterView)
    }
    
    //- MARK: - Constarints
    func setupConstraints() {
        goodsImage.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(16)
            make.leading.equalToSuperview()
            make.width.equalTo(112)
            make.height.equalTo(76)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalTo(goodsImage.snp.trailing).offset(12)
            make.trailing.equalToSuperview()
            make.height.equalTo(36)
        }
        priceLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.leading.equalTo(nameLabel.snp.leading)
            make.height.equalTo(16)
        }
        counterView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.trailing.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(28)
        }
    }
    //- MARK: - Lifecycle
    @objc func increaseCounter() {
        print("increment +1")
        delegate?.productDidCount(basketItem: currentBasketItem, countIs: .increment)
    }
    @objc func decreaseCounter() {
        print("decrement -1")
        delegate?.productDidCount(basketItem: currentBasketItem, countIs: .decrement)
    }
    //- MARK: - Set Data
    func setCell(product: BasketItem) {
        goodsImage.sd_setImage(with: URL(string: imageSource.BASE_URL + product.productImg), placeholderImage: nil, context: nil)
        priceLabel.text = formatPrice(product.price)
        nameLabel.text = product.productTitle
        counterLabel?.text = String(product.count)
    }
}
