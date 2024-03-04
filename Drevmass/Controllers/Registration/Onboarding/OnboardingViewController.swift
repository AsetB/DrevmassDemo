//
//  OnboardingViewController.swift
//  Drevmass
//
//  Created by Aset Bakirov on 04.03.2024.
//

import UIKit
import SnapKit

class OnboardingViewController: UIViewController {
    //- MARK: - Local outlets
    private lazy var imageView: UIImageView = {
        var image = UIImageView()
        //image.clipsToBounds = true
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        image.image = .Onboarding.image1
        return image
    }()
    
    private lazy var topLabel: UILabel = {
        let label = UILabel()
        label.font = .addFont(type: .SFProDisplayBold, size: 28)
        label.textColor = .Colors._181715
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .addFont(type: .SFProTextRegular, size: 17)
        label.textColor = .Colors._181715
        return label
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вход", for: .normal)
        button.titleLabel?.textColor = .Colors.FFFFFF
        button.titleLabel?.font = .addFont(type: .SFProTextSemiBold, size: 17)
        button.layer.cornerRadius = 28
        button.backgroundColor = .Colors.B_5_A_380
        return button
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Регистрация", for: .normal)
        button.titleLabel?.textColor = .Colors.B_5_A_380
        button.titleLabel?.font = .addFont(type: .SFProTextSemiBold, size: 17)
        button.layer.cornerRadius = 28
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(resource: ColorResource.Colors.B_5_A_380).cgColor
        button.backgroundColor = .clear
        return button
    }()
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .Colors.FFFFFF
        setViews()
        setConstraints()
        setData()
    }
    //- MARK: - Set Views
    private func setViews() {
        view.addSubview(imageView)
        view.addSubview(topLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
    }
    //- MARK: - Constraints
    private func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(signInButton.snp.top).offset(16)
        }
        signInButton.snp.makeConstraints { make in
            make.leading.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(56)
            make.trailing.equalTo(signUpButton.snp.leading).offset(8)
        }
        signUpButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(56)
        }
    }
    //- MARK: - Set Data
    func setData() {
        
    }
}
