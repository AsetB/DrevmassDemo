//
//  ChangePasswordViewController.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 10.03.2024.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import SnapKit

class ChangePasswordViewController: UIViewController {
    
    var saveButtonBottomConstraint: Constraint?
    
    // - MARK: - UI elements
    
    var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Сменить пароль"
        label.font = UIFont(name: "SFProText-Semibold", size: 17)
        label.textColor = .black
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var leftButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(resource: ImageResource.Profile.iconBack), for: .normal)
        button.tintColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()
    
    // currentPassword
    
    var currentPasswordLabel: UILabel = {
        var label = UILabel()
        label.text = "  "
        label.textColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        label.font = .addFont(type: .SFProTextMedium, size: 13)
        return label
    }()
    
    var currentPasswordTextfield: UITextField = {
        var textfield = UITextField()
        textfield.attributedPlaceholder = NSAttributedString(string: "Введите текущий пароль", attributes: [.font: UIFont.addFont(type: .SFProTextSemiBold, size: 17), .foregroundColor: UIColor(resource: ColorResource.Colors._989898) ])
        textfield.textColor = UIColor(resource: ColorResource.Colors._181715) 
        textfield.isSecureTextEntry = true
        textfield.font = .addFont(type: .SFProTextSemiBold, size: 17)
        textfield.addTarget(self, action: #selector(editingDidBeginCurrentPasswordTextfield), for: .editingDidBegin)
        textfield.addTarget(self, action: #selector(editingDidEndForPassword), for: .editingDidEnd)
//        textfield.addTarget(self, action: #selector(unlockSaveButton), for: .editingDidEnd)
        return textfield
    }()
    
    var viewUnderCurrentPassword: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(resource: ColorResource.Colors.E_0_DEDD) 
        return view
    }()
    
    var showPasswordButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(resource: ImageResource.Registration.eye24), for: .normal)
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(toggleShowButton), for: .touchUpInside)
        return button
    }()
    
    var forgotPasswordButton: UIButton = {
        var button = UIButton()
        button.setTitle("Забыли пароль?", for: .normal)
        button.setTitleColor(UIColor(resource: ColorResource.Colors.B_5_A_380) , for: .normal)
        button.titleLabel?.font = .addFont(type: .SFProTextSemiBold, size: 15)
        return button
    }()
    
    // newPassword
    
    var newPasswordLabel: UILabel = {
        var label = UILabel()
        label.text = "  "
        label.textColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        label.font = .addFont(type: .SFProTextMedium, size: 13)
        return label
    }()
    
    var newPasswordTextfield: UITextField = {
        var textfield = UITextField()
        textfield.attributedPlaceholder = NSAttributedString(string: "Введите новый пароль", attributes: [.font: UIFont.addFont(type: .SFProTextSemiBold, size: 17), .foregroundColor: UIColor(resource: ColorResource.Colors._989898) ])
        textfield.textColor = UIColor(resource: ColorResource.Colors._181715) 
        textfield.font = .addFont(type: .SFProTextSemiBold, size: 17)
        textfield.isSecureTextEntry = true
        textfield.addTarget(self, action: #selector(editingDidBeginNewPasswordTextfield), for: .editingDidBegin)
        textfield.addTarget(self, action: #selector(editingDidEndForNewPassword), for: .editingDidEnd)
//        textfield.addTarget(self, action: #selector(unlockSaveButton), for: .editingDidEnd)
        return textfield
    }()
    
    var viewUnderNewPassword: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(resource: ColorResource.Colors.E_0_DEDD) 
        return view
    }()
    
    var showNewPasswordButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(resource: ImageResource.Registration.eye24), for: .normal)
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(toggleNewShowButton), for: .touchUpInside)
        return button
    }()
    
    var saveButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        button.setTitle("Продолжить", for: .normal)
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        button.titleLabel?.font = .addFont(type: .SFProTextSemiBold, size: 15)
        return button
    }()
    
    // - MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saveButton.isEnabled = false
        saveButton.backgroundColor = UIColor(resource: ColorResource.Colors.D_3_C_8_B_3) 
    }
}

extension ChangePasswordViewController {
    
    // - MARK: - network
    
    @objc func resetPassword(){
        SVProgressHUD.show()
        
        let current_password = currentPasswordTextfield.text!
        let new_password = newPasswordTextfield.text!
        let parameteres = ["current_password": current_password, "new_password": new_password]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AuthenticationService.shared.token)"
        ]
        AF.request(URLs.RESET_PASSWORD_URL, method: .post, parameters: parameteres, encoding: JSONEncoding.default, headers: headers).responseData { response in
         SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            if response.response?.statusCode == 200{
                
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
            } else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR")
            }
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first else {
               return
             }
        }
        dismissView()
    }
    
    // - MARK: - other funcs
    
    @objc func dismissView() {
        dismiss(animated: true)
    }
    
    @objc func unlockSaveButton() {
        if currentPasswordLabel.text == "" || newPasswordTextfield.text == "" {
            saveButton.isEnabled = false
            saveButton.backgroundColor = UIColor(resource: ColorResource.Colors.D_3_C_8_B_3) 
        }else{
            saveButton.isEnabled = true
            saveButton.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        }
    }
    
    @objc func editingDidBeginCurrentPasswordTextfield() {
        
        currentPasswordLabel.text = "Введите текущий пароль"
        currentPasswordTextfield.placeholder = "  "
        viewUnderCurrentPassword.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
    }
    @objc func editingDidBeginNewPasswordTextfield() {
        
        newPasswordLabel.text = "Введите новый пароль"
        newPasswordTextfield.placeholder = "  "
        viewUnderNewPassword.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
    }
    
    @objc func editingDidEndForPassword() {
        
        if currentPasswordTextfield.text == "" {
            currentPasswordLabel.text = "  "
            currentPasswordTextfield.attributedPlaceholder = NSAttributedString(string: "Введите текущий пароль", attributes: [.font: UIFont.addFont(type: .SFProTextSemiBold, size: 17), .foregroundColor: UIColor(resource: ColorResource.Colors._989898) ])
        }
        viewUnderCurrentPassword.backgroundColor = UIColor(resource: ColorResource.Colors.E_0_DEDD) 
    }
    
    @objc func editingDidEndForNewPassword() {

        if newPasswordTextfield.text == "" {
            newPasswordLabel.text = "  "
            newPasswordTextfield.attributedPlaceholder = NSAttributedString(string: "Введите новый пароль", attributes: [.font: UIFont.addFont(type: .SFProTextSemiBold, size: 17), .foregroundColor: UIColor(resource: ColorResource.Colors._989898) ])
        }
        viewUnderNewPassword.backgroundColor = UIColor(resource: ColorResource.Colors.E_0_DEDD) 
    }
    
    @objc func toggleNewShowButton() {
        
        newPasswordTextfield.isSecureTextEntry.toggle()
        if newPasswordTextfield.isSecureTextEntry == true {
            showNewPasswordButton.setImage(UIImage(resource: ImageResource.Registration.eye24), for: .normal)
        }else{
            showNewPasswordButton.setImage(UIImage(resource: ImageResource.Registration.eyeOff24), for: .normal)
        }
    }
    
    @objc func toggleShowButton() {
        
        currentPasswordTextfield.isSecureTextEntry.toggle()
        if currentPasswordTextfield.isSecureTextEntry == true {
            showPasswordButton.setImage(UIImage(resource: ImageResource.Registration.eye24), for: .normal)
        }else{
            showPasswordButton.setImage(UIImage(resource: ImageResource.Registration.eyeOff24), for: .normal)
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
               saveButtonBottomConstraint?.update(inset: -16 + keyboardSize.height)
            }
        }
    @objc private func keyboardWillHide(notification: NSNotification) {
        saveButtonBottomConstraint?.update(inset: 16)
    }
    @objc func doneButtonAction(){
        currentPasswordTextfield.resignFirstResponder()
        newPasswordTextfield.resignFirstResponder()
        
    }
   
    // - MARK: - setups

    func setupView() {
        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        view.addSubview(titleLabel)
        view.addSubview(leftButton)
        view.addSubview(currentPasswordLabel)
        view.addSubview(currentPasswordTextfield)
        view.addSubview(viewUnderCurrentPassword)
        view.addSubview(showPasswordButton)
        view.addSubview(forgotPasswordButton)
        view.addSubview(newPasswordLabel)
        view.addSubview(newPasswordTextfield)
        view.addSubview(viewUnderNewPassword)
        view.addSubview(showNewPasswordButton)
        view.addSubview(saveButton)
        
        //кнопка готово, его ширина равно ширине экрана
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        doneToolbar.barStyle = .default
        
                // кнопка готово справа
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        // сама кнопка
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneButtonAction))
        doneButton.tintColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        
        
        doneToolbar.items = [flexSpace, doneButton]
        
        //скрывать клаву или тулбар
        currentPasswordTextfield.inputAccessoryView = doneToolbar
        newPasswordTextfield.inputAccessoryView = doneToolbar
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
        currentPasswordLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).inset(-27)
        }
        currentPasswordTextfield.snp.makeConstraints { make in
            make.height.equalTo(37)
            make.top.equalTo(currentPasswordLabel.snp.bottom).inset(-4)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        viewUnderCurrentPassword.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(currentPasswordTextfield.snp.bottom).inset(-3)
            make.height.equalTo(1)
        }
        showPasswordButton.snp.makeConstraints { make in
            make.height.width.equalTo(37)
            make.centerY.equalTo(currentPasswordTextfield)
            make.right.equalTo(currentPasswordTextfield.snp.right)
        }
        forgotPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(showPasswordButton.snp.bottom).inset(-12)
            make.left.equalToSuperview().inset(16)
        }
        newPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(forgotPasswordButton.snp.bottom).inset(-16)
            make.left.equalToSuperview().inset(16)
        }
        newPasswordTextfield.snp.makeConstraints { make in
            make.height.equalTo(37)
            make.top.equalTo(newPasswordLabel.snp.bottom).inset(-4)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        viewUnderNewPassword.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(newPasswordTextfield.snp.bottom).inset(-3)
            make.height.equalTo(1)
        }
        showNewPasswordButton.snp.makeConstraints { make in
            make.height.width.equalTo(37)
            make.centerY.equalTo(newPasswordTextfield)
            make.right.equalTo(newPasswordTextfield.snp.right)
        }
        saveButton.snp.makeConstraints { make in
            self.saveButtonBottomConstraint =  make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16).constraint
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
}
