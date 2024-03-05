//
//  UIButton.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 05.03.2024.
//

import UIKit
import SnapKit

class Button: UIButton {
    
    var leftIcon: UIImageView = {
        var imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
    
        return imageview
    }()
    
    var rightIcon: UIImageView = {
        var imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
    
        return imageview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Button {
   func setupView() {
       
       setTitleColor(.Colors._181715 , for: .normal)
       titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 17)
       layer.borderWidth = 2
       layer.cornerRadius = 20
       titleLabel?.snp.makeConstraints({ make in
           make.left.equalToSuperview().inset(52)
       })
       
       addSubview(leftIcon)
       addSubview(rightIcon)
    }
   func setupConstraints() {
       leftIcon.snp.makeConstraints { make in
           make.centerY.equalToSuperview()
           make.height.width.equalTo(24)
           make.left.equalToSuperview().inset(16)
       }
       rightIcon.snp.makeConstraints { make in
           make.centerY.equalToSuperview()
           make.height.width.equalTo(16)
           make.right.equalTo(self.snp.right).inset(16)
       }
    }
}
