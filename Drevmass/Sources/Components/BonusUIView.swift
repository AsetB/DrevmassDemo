//
//  BonusUIView.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 18.03.2024.
//

import Foundation
import UIKit

class BonusUIView: UIView {
    
    let bonusImageview: UIImageView = {
       var imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        return imageview
    }()
    
    let bonusTitleLabel: UILabel = {
       var label = UILabel()
        label.font = .addFont(type: .SFProTextBold, size: 13)
        label.textColor = UIColor(resource: ColorResource.Colors._181715)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bonusImageview)
        addSubview(bonusTitleLabel)
        bonusImageview.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.right.equalToSuperview().inset(2)
            make.centerY.equalToSuperview()
        }
        bonusTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(8)
            make.right.equalTo(bonusImageview.snp.left).inset(-4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
