//
//  NotificationView.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 26.03.2024.
//

import Foundation
import UIKit
import SnapKit

class NotificationView: UIView {
    
    
    var imageView: UIImageView = {
       var imageview = UIImageView()
        imageview.clipsToBounds = true
        imageview.contentMode = .scaleAspectFill
        imageview.frame.size = CGSize(width: 24, height: 24)
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    var titleLabel: UILabel = {
       var label = UILabel()
        label.font = .addFont(type: .SFProTextSemiBold, size: 15)
        label.textColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 24
        
        addSubview(imageView)
        addSubview(titleLabel)
        
        imageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(16)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(imageView)
            make.left.equalTo(imageView.snp.right).inset(-12)
            make.right.equalToSuperview().inset(16)
        }
        
 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func show(viewController: UIViewController, notificationType: NotificationType) {
           guard let targetView = viewController.view else { return }
           
           frame = CGRect(x: 0, y: 0, width: targetView.frame.width , height: 98)
        
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.addSubview(self)
        
        switch notificationType {
        case .success:
            backgroundColor = UIColor(resource: ColorResource.Colors._3_ABD_5_B)
            imageView.image = UIImage(resource: ImageResource.Notification.icSuccess)
        case .signal:
            backgroundColor = UIColor(resource: ColorResource.Colors._787878)
            imageView.image = UIImage(resource: ImageResource.Notification.icSignal)
        case .attantion:
            backgroundColor = UIColor(resource: ColorResource.Colors.F_96666)
            imageView.image = UIImage(resource: ImageResource.Notification.icAttantion)
        case .warning:
            backgroundColor = UIColor(resource: ColorResource.Colors.FFAC_38)
            imageView.image = UIImage(resource: ImageResource.Notification.icWarning)
        }
      
           // show view
           DispatchQueue.main.asyncAfter(deadline: .now()) {
               UIView.transition(with: self, duration: 0.6,
                                 options: .transitionCrossDissolve,
                                 animations: {
                   self.alpha = 1
                   print("ddddddddddd animation")
               })
           }
           
           // hide view after 3 sec delay
           DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
               UIView.transition(with: self, duration: 1,
                                 options: .transitionCrossDissolve,
                                 animations: {
                   self.alpha = 0
                   print("pppppp izchez 33333")
               })
               
           }
       }
    
    enum NotificationType {
        case success
        case attantion
        case warning
        case signal
    }
    
}
