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
        label.textColor = .Colors._302_C_28
        label.font = UIFont(name: "SFProText-Regular", size: 15)
        label.numberOfLines = 2
        label.text = "Начисление за прохождение видеокурса"
        return label
    }()
    
    var subtitleLabel: UILabel = {
       var label = UILabel()
        label.textColor = .Colors._989898
        label.font = UIFont(name: "SFProText-Regular", size: 15)
        label.text = "15 октября 2023"
        return label
    }()
    
    var bonusLabel: UILabel = {
       var label = UILabel()
        label.textColor = .Colors._302_C_28
        label.font = UIFont(name: "SFProText-Bold", size: 15)
        label.text = "15 октября 2023"
        return label
    }()
    
    var bonusImageView: UIImageView = {
        var imageview = UIImageView()
        imageview.image = .Profile.iconBonusProfile
        imageview.contentMode = .scaleAspectFit
        return imageview
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
        contentView.backgroundColor = .clear
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(bonusLabel)
        contentView.addSubview(bonusImageView)
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
    }
}
