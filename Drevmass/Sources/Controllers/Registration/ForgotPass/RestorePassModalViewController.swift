//
//  RestorePassModalViewController.swift
//  Drevmass
//
//  Created by Aset Bakirov on 05.03.2024.
//

import UIKit
import SnapKit

class RestorePassModalViewController: UIViewController, UIGestureRecognizerDelegate {
    //- MARK: - Variables
    var emailText: String = ""
    //- MARK: - Local outlets
    private lazy var topLabel: UILabel = {
        let label = UILabel()
        label.text = "Сбросить пароль"
        label.font = .addFont(type: .SFProDisplayBold, size: 22)
        label.textColor = UIColor(resource: ColorResource.Colors._302_C_28)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = """
На почту \(emailText) мы отправили 
инструкцию для сброса пароля.
"""
        label.font = .addFont(type: .SFProTextRegular, size: 16)
        label.textColor = UIColor(resource: ColorResource.Colors._787878)
        label.numberOfLines = 2
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: ColorResource.Colors.E_0_DEDD)
        view.layer.cornerRadius = 3
        return view
    }()
    
    private lazy var modalView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("Понятно", for: .normal)
        button.setTitleColor(UIColor(resource: ColorResource.Colors.FFFFFF), for: .normal)
        button.titleLabel?.font = .addFont(type: .SFProTextSemiBold, size: 17)
        button.layer.cornerRadius = 28
        button.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.19, green: 0.17, blue: 0.16, alpha: 0.65)
        setViews()
        setConstraints()
    }
    //- MARK: - Set Views
    private func setViews() {
        view.addSubview(modalView)
        view.addSubview(lineView)
        modalView.addSubview(topLabel)
        modalView.addSubview(descriptionLabel)
        modalView.addSubview(confirmButton)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    //- MARK: - Constraints
    private func setConstraints() {
        modalView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.height.equalTo(253)
        }
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(32)
            make.height.equalTo(4)
            make.bottom.equalTo(modalView.snp.top).offset(-8)
        }
        topLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(28)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(topLabel.snp.horizontalEdges)
        }
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(topLabel.snp.horizontalEdges)
            make.height.equalTo(56)
        }
    }
    //- MARK: - Gesture
    @objc func dismissView() {
      self.dismiss(animated: true, completion: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
      if (touch.view?.isDescendant(of: modalView))! {
        return false
      }
      return true
    }
}
