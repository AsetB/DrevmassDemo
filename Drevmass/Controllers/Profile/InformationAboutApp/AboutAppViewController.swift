//
//  AboutAppViewController.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 12.03.2024.
//

import UIKit

class AboutAppViewController: UIViewController {
    // - MARK: - UI elements
    
    var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "О компании"
        label.font = UIFont(name: "SFProText-Semibold", size: 17)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
     var rightButton: UIButton = {
        var button = UIButton()
        button.setTitle("Закрыть", for: .normal)
        button.setTitleColor(UIColor(resource: ColorResource.Colors._007_AFF) , for: .normal)
         button.titleLabel?.font = .addFont(type: .SFProTextSemiBold, size: 15)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()
    
    var imageView: UIImageView = {
       var imageview = UIImageView()
        imageview.image = .Profile.iconApp
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.layer.cornerRadius = 24
        return imageview
    }()
    
    var DrevmassLabel: UILabel = {
       var label = UILabel()
        label.text = "Древмасс"
        label.textColor = UIColor(resource: ColorResource.Colors._302_C_28) 
        label.font = .addFont(type: .SFProDisplayBold, size: 22)
        return label
    }()  
    
    var versionLabel: UILabel = {
       var label = UILabel()
        label.text = "Версия 1.0.4"
        label.textColor = UIColor(resource: ColorResource.Colors._787878)
        label.font = .addFont(type: .SFProTextRegular, size: 15)
        return label
    }() 
    
    var bottomLabel: UILabel = {
       var label = UILabel()
        label.text = "© 2023 Name Inc\nВсе права защищены"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = UIColor(resource: ColorResource.Colors._787878)
        label.font = .addFont(type: .SFProTextRegular, size: 15)
        return label
    }()
    
    // - MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()
    }
    

}
extension AboutAppViewController {
    
    // - MARK: - other funcs
    
    @objc func dismissView() {
        dismiss(animated: true)
    }

  
    // - MARK: - setups
    
    func setupView() {
        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        view.addSubview(titleLabel)
        view.addSubview(rightButton)
        view.addSubview(imageView)
        view.addSubview(DrevmassLabel)
        view.addSubview(versionLabel)
        view.addSubview(bottomLabel)
    }
    
    func setupConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(13)
        }
        rightButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(12)
        }
        imageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-91)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(112)
        }
        DrevmassLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).inset(-16)
            make.centerX.equalToSuperview()
        }
        versionLabel.snp.makeConstraints { make in
            make.top.equalTo(DrevmassLabel.snp.bottom).inset(-4)
            make.centerX.equalToSuperview()
        }
        bottomLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(36)
        }
    }
}
