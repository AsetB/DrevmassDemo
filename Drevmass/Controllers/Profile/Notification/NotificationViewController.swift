//
//  NotificationViewController.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 11.03.2024.
//

import UIKit

class NotificationViewController: UIViewController {
    
    // - MARK: - UI elements
    
    var titleLabel: UILabel = {
       var label = UILabel()
        label.text = "Напоминание о занятиях"
        label.textColor = UIColor(resource: ColorResource.Colors._181715) 
        label.font = .addFont(type: .SFProTextSemiBold, size: 17)
        return label
    }()
    
    var switchNotification: UISwitch = {
       var switchNotification = UISwitch()
        switchNotification.onTintColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        return switchNotification
    }()
    
    var subtitleLabel: UILabel = {
       var label = UILabel()
        label.text = "Какой-то дескрипшн"
        label.textColor = UIColor(resource: ColorResource.Colors._787878)
        label.font = .addFont(type: .SFProTextMedium, size: 15)
        label.numberOfLines = 0
        return label
    }()

    // - MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()
        setupNavigationBar()
    }
    

}

extension NotificationViewController {
    
    // - MARK: - other funcs
    
    @objc func dismissView() {
        navigationController?.popViewController(animated: true)
    }
    
    // - MARK: - setups
    func setupNavigationBar(){
        navigationItem.title = "Уведомления"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .Profile.iconBack, style: .done, target: self, action: #selector(dismissView))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
    }
    
    func setupView() {
        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        view.addSubview(titleLabel)
        view.addSubview(switchNotification)
        view.addSubview(subtitleLabel)
        
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        switchNotification.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview().inset(16)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-4)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
