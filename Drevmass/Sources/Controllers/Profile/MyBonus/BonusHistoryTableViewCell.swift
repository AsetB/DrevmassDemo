//
//  BonusHistoryTableViewCell.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 06.03.2024.
//

import UIKit

class BonusHistoryTableViewCell: UITableViewCell {
    
    var titleLabel: UILabel = {
       var label = UILabel()

        label.textColor = UIColor(resource: ColorResource.Colors._302_C_28)
        label.font = UIFont(name: "SFProText-Regular", size: 15)
        label.numberOfLines = 2
        return label
    }()
    
    var subtitleLabel: UILabel = {
       var label = UILabel()
        label.textColor = UIColor(resource: ColorResource.Colors._989898)
        label.font = UIFont(name: "SFProText-Regular", size: 13)
        return label
    }()
    
    var bonusLabel: UILabel = {
       var label = UILabel()
        label.textColor = UIColor(resource: ColorResource.Colors._302_C_28)
        label.font = UIFont(name: "SFProText-Bold", size: 15)
        return label
    }()
    
    var bonusImageView: UIImageView = {
        var imageview = UIImageView()
        imageview.image = UIImage(resource: ImageResource.Profile.iconBonusBeige)
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    
    var dashedLineView: DashedLineView = {
       var view = DashedLineView()

        view.dashColor = UIColor(resource: ColorResource.Colors.D_6_D_1_CE)
        view.backgroundColor = .clear
        view.spaceBetweenDash = 5
        view.perDashLength = 5
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

extension BonusHistoryTableViewCell {
    func setupView() {
        contentView.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(bonusLabel)
        contentView.addSubview(bonusImageView)
        contentView.addSubview(dashedLineView)
    }
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.equalToSuperview()
            make.right.equalToSuperview().inset(88)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview().inset(88)
            make.bottom.equalToSuperview().inset(16)
        }
        bonusImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.height.width.equalTo(20)
        }
        bonusLabel.snp.makeConstraints { make in
            make.centerY.equalTo(bonusImageView)
            make.right.equalTo(bonusImageView.snp.left)
        }
        dashedLineView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).inset(-14)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
