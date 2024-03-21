//
//  DayCollectionViewCell.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 20.03.2024.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .addFont(type: .SFProTextSemiBold, size: 15)
        label.textColor = UIColor(resource: ColorResource.Colors._181715)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 2
        layer.borderColor = UIColor(resource: ColorResource.Colors.EFEBE_9).cgColor
        layer.cornerRadius = 12
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
