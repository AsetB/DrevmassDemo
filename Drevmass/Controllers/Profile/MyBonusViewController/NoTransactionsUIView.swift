//
//  UIViewWhenNoTransactions.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 06.03.2024.
//

import Foundation
import UIKit

class NoTransactionsUIView: UIView {
    
    var historyPointsLabel: UILabel = {
        var label = UILabel()
        label.textColor = .Colors._181715
        label.font = UIFont(name: "SFProDisplay-Bold", size: 20)
        label.text = "История баллов"
        return label
    }()
    
    var twoEmptyBonusesEmageView: UIImageView = {
        var imageview = UIImageView()
        imageview.image = .Profile.epmtyBonuses
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    
    var aboutBonusTitlteLabel: UILabel = {
        var label = UILabel()
        label.textColor = .Colors._181715
        label.font = UIFont(name: "SFProText-Medium", size: 17)
        label.textAlignment = .center
        label.text = "В истории баллов пока пусто"
        return label
    }()
    
    var aboutBonusSubtitlteLabel: UILabel = {
        var label = UILabel()
        label.textColor = .Colors._989898
        label.font = UIFont(name: "SFProText-Regular", size: 16)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "Совершайте покупки, проходите видеоуроки и получайте за это баллы."
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .Colors.FFFFFF

        addSubview(historyPointsLabel)
        addSubview(twoEmptyBonusesEmageView)
        addSubview(aboutBonusTitlteLabel)
        addSubview(aboutBonusSubtitlteLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension NoTransactionsUIView {
    
    func setupConstraints() {
        historyPointsLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        twoEmptyBonusesEmageView.snp.makeConstraints { make in
            make.height.width.equalTo(112)
            make.centerX.equalToSuperview()
            make.top.equalTo(historyPointsLabel.snp.bottom).inset(-120)
        }
        aboutBonusTitlteLabel.snp.makeConstraints { make in
            make.top.equalTo(twoEmptyBonusesEmageView.snp.bottom).inset(-24)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        aboutBonusSubtitlteLabel.snp.makeConstraints { make in
            make.top.equalTo(aboutBonusTitlteLabel.snp.bottom).inset(-4)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(188)
        }
    }
}
