//
//  SupportViewController.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 12.03.2024.
//

import UIKit

class SupportViewController: UIViewController {
    
    // - MARK: - UI elements
    
    var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Служба поддержки"
        label.font = UIFont(name: "SFProText-Semibold", size: 17)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    lazy var leftButton: UIButton = {
        var button = UIButton()
        button.setImage(.Profile.iconBack, for: .normal)
        button.tintColor = .Colors.B_5_A_380
        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()
    
    var textViewForText: UITextView = {
       var textview = UITextView()
        
        return textview
    }()
    
    // - MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()
    }
    

}

extension SupportViewController {
    
    // - MARK: - network
    
 
    
    // - MARK: - other funcs
    
    @objc func dismissView() {
        dismiss(animated: true)
    }
   @objc func did() {
        dismiss(animated: true)
    }
   
   
   
    // - MARK: - setups

    func setupView() {
        view.backgroundColor = .Colors.FFFFFF
        view.addSubview(titleLabel)
        view.addSubview(leftButton)
    }
    
    func setupConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(13)
        }
        leftButton.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(12)
            make.height.width.equalTo(24)
        }
       
    }
}
