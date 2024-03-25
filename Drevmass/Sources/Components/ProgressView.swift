//
//  ProgressView.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 23.03.2024.
//

import Foundation
import UIKit
import SnapKit

class ProgressView: UIView {
    
    // MARK: - UI element
    
    var titleLabel: UILabel = {
       var label = UILabel()
        label.font = .addFont(type: .SFProTextSemiBold, size: 15)
        label.textColor = UIColor(resource: ColorResource.Colors._181715)
        label.text = "Пройдено уроков"
        return label
    }()
    
    var progressView: UIProgressView = {
       var progressview = UIProgressView()
        progressview.progressTintColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        progressview.trackTintColor = UIColor(resource: ColorResource.Colors.D_6_D_1_CE)
       
        return progressview
    }()
    
    var countLabel: UILabel = {
       var label = UILabel()
        label.font = .addFont(type: .SFProTextSemiBold, size: 15)
        label.textColor = UIColor(resource: ColorResource.Colors._181715)
        return label
    }()  
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setups
    
    func setupView() {
        addSubview(titleLabel)
        addSubview(progressView)
        addSubview(countLabel)
    }
    
    func setupConstraints(){
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.left.equalToSuperview().inset(16)
        }
        progressView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-12)
            make.height.equalTo(6)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        countLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
        }
    }
    
}
