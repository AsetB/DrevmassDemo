//
//  NoSignalUIView.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 28.03.2024.
//

import Foundation
import UIKit
import Network

final class NoSignalUIView: UIView {
    var imageview: UIImageView = {
       var imageview = UIImageView()
        imageview.image = UIImage(resource: ImageResource.Notification.illNoSignal)
        imageview.clipsToBounds = true
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    
    var titleLabel: UILabel = {
       var label = UILabel()
        label.text = "Не удалось загрузить"
        label.font = .addFont(type: .SFProTextSemiBold, size: 17)
        label.textColor = UIColor(resource: ColorResource.Colors._181715)
        return label
    }()
    
    var button: UIButton = {
       var button = UIButton()
        button.setTitle("Повторить попытку", for: .normal)
        button.titleLabel?.font = .addFont(type: .SFProTextSemiBold, size: 15)
        button.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        button.layer.cornerRadius = 24
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
//        button.addTarget(self, action: #selector(sentAgain), for: .touchUpInside)
        return button
    }()
    
    
     let monitor = NWPathMonitor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        layer.cornerRadius = 24
        addSubview(imageview)
        addSubview(titleLabel)
        addSubview(button)
        
        imageview.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(112)
            make.top.equalToSuperview().inset(164)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageview.snp.bottom).inset(-24)
            make.centerX.equalToSuperview()
        }
        button.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-24)
            make.centerX.equalToSuperview()
            make.width.equalTo(207)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    @objc func sentAgain() {
//        print("sentAgain")
//        monitor.pathUpdateHandler = { path in
//            if path.status == .satisfied {
//                self.isHidden = true
//                print("ishidden")
//                
//            }
//        }
//        let queue = DispatchQueue(label: "Monitor")
//        monitor.start(queue: queue)
//        
//    }

}
