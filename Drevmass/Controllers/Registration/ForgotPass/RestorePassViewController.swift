//
//  RestorePassViewController.swift
//  Drevmass
//
//  Created by Aset Bakirov on 05.03.2024.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class RestorePassViewController: UIViewController {
    //- MARK: - Variables
    var resetButtonBottomToSafeAreaBottom: Constraint? = nil
    //- MARK: - Local outlets
    private lazy var navigationLabel: UILabel = {
        let label = UILabel()
        label.text = "Сбросить пароль"
        label.font = .addFont(type: .SFProTextSemiBold, size: 17)
        label.textColor = .black
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.setImage(.Registration.backArrowBrand, for: .normal)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите email для сброса пароля."
        label.font = .addFont(type: .SFProTextRegular, size: 15)
        label.textColor = UIColor(resource: ColorResource.Colors._787878)
        return label
    }()
    
    private lazy var textfieldLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = .addFont(type: .SFProTextMedium, size: 13)
        label.textColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        return label
    }()
    
    private lazy var emailTextfield: UITextField = {
        let textfield = UITextField()
        textfield.defaultTextAttributes = [NSAttributedString.Key.font : UIFont.addFont(type: .SFProTextSemiBold, size: 17), NSAttributedString.Key.foregroundColor : UIColor(resource: ColorResource.Colors._181715)]
        textfield.borderStyle = .none
        textfield.textContentType = .emailAddress
        textfield.autocapitalizationType = .none
        textfield.keyboardType = .emailAddress
        textfield.addTarget(self, action: #selector(textfieldEditBegin), for: .editingDidBegin)
        textfield.addTarget(self, action: #selector(textfieldEditEnd), for: .editingDidEnd)
        textfield.addTarget(self, action: #selector(textfieldEditingChanged), for: .editingChanged)
        textfield.addTarget(self, action: #selector(textfieldAllEditing), for: .allEditingEvents)
        return textfield
    }()
    
    private lazy var clearEmailButton: UIButton = {
        let button = UIButton()
        button.setImage(.Registration.clear20, for: .normal)
        button.addTarget(self, action: #selector(clearField), for: .touchUpInside)
        return button
    }()
    
    private lazy var dividerEmailView: UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor(red: 223/255, green: 222/255, blue: 221/255, alpha: 1) //tint UIColor(resource: ColorResource.Colors.B_5_A_380)
        return divider
    }()
    
    private lazy var resetPassButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сбросить пароль", for: .normal)
        button.setTitleColor(UIColor(resource: ColorResource.Colors.FFFFFF), for: .normal)
        button.titleLabel?.font = .addFont(type: .SFProTextSemiBold, size: 15)
        button.layer.cornerRadius = 24
        button.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        button.addTarget(self, action: #selector(resetPass), for: .touchUpInside)
        return button
    }()
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Сбросить пароль"//cделай как лейбл на верху
        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        setViews()
        setConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //- MARK: - Set Views
    private func setViews() {
        view.addSubview(navigationLabel)
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(emailTextfield)
        emailTextfield.addSubview(textfieldLabel)
        view.addSubview(clearEmailButton)
        view.addSubview(dividerEmailView)
        view.addSubview(resetPassButton)
        clearEmailButton.isHidden = true
    }
    //- MARK: - Constraints
    private func setConstraints() {
        navigationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.horizontalEdges.equalToSuperview().inset(116)
            make.height.equalTo(22)
        }
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.size.equalTo(24)
            make.centerY.equalTo(navigationLabel.snp.centerY)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(113)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(20)
        }
        emailTextfield.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        textfieldLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        clearEmailButton.snp.makeConstraints { make in
            make.trailing.equalTo(emailTextfield.snp.trailing)
            make.bottom.equalTo(emailTextfield.snp.bottom)
            make.width.equalTo(32)
            make.height.equalTo(48)
        }
        dividerEmailView.snp.makeConstraints { make in
            make.top.equalTo(emailTextfield.snp.bottom)
            make.height.equalTo(1)
            make.horizontalEdges.equalTo(emailTextfield.snp.horizontalEdges)
        }
        resetPassButton.snp.makeConstraints { make in
            self.resetButtonBottomToSafeAreaBottom = make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16).constraint
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
    //- MARK: - Button Actions
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func resetPass() {
        guard let email = emailTextfield.text else {
            return
        }
        
        if !email.isEmail() {
            showAlertMessage(title: "Некорректный адрес email", message: "Попробуйте снова")
            return
        }
        let parameters = ["email": email]
        
        AF.upload(multipartFormData: {(multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append(Data(value.utf8), withName: key)
            }
        }, to: URLs.FORGOT_PASS_URL).responseDecodable(of: Data.self) { response in
            guard let responseCode = response.response?.statusCode else {
                self.showAlertMessage(title: "Ошибка соединения", message: "Проверьте подключение")
                return
            }
            if responseCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                let modalVC = RestorePassModalViewController()
                modalVC.modalPresentationStyle = .overFullScreen
                modalVC.emailText = email
                self.present(modalVC, animated: true)
                self.emailTextfield.text = .none
            } else {
                var resultString = ""
                if let data = response.data {
                    resultString = String(data: data, encoding: .utf8)!
                }
                var ErrorString = "Ошибка"
                if let statusCode = response.response?.statusCode {
                    ErrorString = ErrorString + " \(statusCode)"
                }
                ErrorString = ErrorString + " \(resultString)"
                self.showAlertMessage(title: "Ошибка соединения", message: "\(ErrorString)")
            }
        }
    }
    private func enableReset() {
        guard let email = emailTextfield.text else {
            return
        }
        if !email.isEmpty {
            resetPassButton.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
            resetPassButton.isEnabled = true
        } else {
            resetPassButton.backgroundColor = UIColor(resource: ColorResource.Colors.D_3_C_8_B_3)
            resetPassButton.isEnabled = false
        }
    }
    @objc func clearField() {
        emailTextfield.text = .none
    }
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.resetButtonBottomToSafeAreaBottom?.update(inset: -16 + keyboardSize.height)
        }
    }
    @objc private func keyboardWillHide(notification: NSNotification) {
        self.resetButtonBottomToSafeAreaBottom?.update(inset: 16)
    }
    //- MARK: - Textfield actions
    @objc func textfieldEditBegin() {
        guard let name = emailTextfield.text else {
            return
        }
        if name.isEmpty {
            clearEmailButton.isHidden = true
        } else {
            clearEmailButton.isHidden = false
        }
        dividerEmailView.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
    }
    @objc func textfieldEditEnd() {
        dividerEmailView.backgroundColor = UIColor(red: 223/255, green: 222/255, blue: 221/255, alpha: 1)
        clearEmailButton.isHidden = true
        guard let text = emailTextfield.text, !text.isEmpty else {
            return
        }
        if !text.isEmail() {
            showAlertMessage(title: "Некорректный email", message: "Попробуйте снова")
            return
        }
    }
    @objc func textfieldEditingChanged () {
        guard let text = emailTextfield.text, !text.isEmpty else {
            clearEmailButton.isHidden = true
            return
        }
        clearEmailButton.isHidden = false
        enableReset()
    }
    @objc func textfieldAllEditing() {
        enableReset()
    }
}
