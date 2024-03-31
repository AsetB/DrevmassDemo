//
//  SignInViewController.swift
//  Drevmass
//
//  Created by Aset Bakirov on 05.03.2024.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class SignInViewController: UIViewController {
    //- MARK: - Variables
    var previousVC: UIViewController?
    var signInBottomToSignUpTop: Constraint? = nil
    //- MARK: - Local outlets
    private lazy var topLabel: UILabel = {
        let label = UILabel()
        label.text = "С возвращением!"
        label.font = .addFont(type: .SFProDisplayBold, size: 28)
        label.textColor = UIColor(resource: ColorResource.Colors._181715)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = """
Мы с вами научимся заниматься
на тренажере-массажере для спины
Древмасс.
"""
        label.font = .addFont(type: .SFProTextRegular, size: 15)
        label.textColor = UIColor(resource: ColorResource.Colors._787878)
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var emailTextfield: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        let placeholderText = "Email"
        textfield.defaultTextAttributes = [NSAttributedString.Key.font : UIFont.addFont(type: .SFProTextSemiBold, size: 17), NSAttributedString.Key.foregroundColor : UIColor(resource: ColorResource.Colors._181715)]
        textfield.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.font : UIFont.addFont(type: .SFProTextSemiBold, size: 17), NSAttributedString.Key.foregroundColor : UIColor(resource: ColorResource.Colors.A_1_A_1_A_1)])
        textfield.setIcon(UIImage(resource: ImageResource.Registration.mail24))
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
    
    private lazy var passTextfield: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        let placeholderText = "Пароль"
        textfield.defaultTextAttributes = [NSAttributedString.Key.font : UIFont.addFont(type: .SFProTextSemiBold, size: 17), NSAttributedString.Key.foregroundColor : UIColor(resource: ColorResource.Colors._181715)]
        textfield.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.font : UIFont.addFont(type: .SFProTextSemiBold, size: 17), NSAttributedString.Key.foregroundColor : UIColor(resource: ColorResource.Colors.A_1_A_1_A_1)])
        textfield.setIcon(UIImage(resource: ImageResource.Registration.lock24))
        textfield.borderStyle = .none
        textfield.isSecureTextEntry = true
        textfield.addTarget(self, action: #selector(textfieldEditBegin), for: .editingDidBegin)
        textfield.addTarget(self, action: #selector(textfieldEditEnd), for: .editingDidEnd)
        textfield.addTarget(self, action: #selector(textfieldEditingChanged), for: .editingChanged)
        textfield.addTarget(self, action: #selector(textfieldAllEditing), for: .allEditingEvents)
        return textfield
    }()
    
    private lazy var clearEmailButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: ImageResource.Registration.clear20), for: .normal)
        button.addTarget(self, action: #selector(clearField), for: .touchUpInside)
        return button
    }()
    
    private lazy var showPassButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: ImageResource.Registration.eye24), for: .normal)
        button.contentHorizontalAlignment = .trailing
        button.addTarget(self, action: #selector(showPass), for: .touchUpInside)
        return button
    }()
    
    private lazy var dividerEmailView: UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor(red: 223/255, green: 222/255, blue: 221/255, alpha: 1) //tint UIColor(resource: ColorResourceUIColor(resource: ColorResource.Colors.B_5_A_380))
        return divider
    }()
    
    private lazy var dividerPassView: UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor(red: 223/255, green: 222/255, blue: 221/255, alpha: 1) //tint UIColor(resource: ColorResourceUIColor(resource: ColorResource.Colors.B_5_A_380))
        return divider
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.setTitle("", for: .disabled)
        button.setTitleColor(UIColor(resource: ColorResource.Colors.FFFFFF), for: .normal)
        button.titleLabel?.font = .addFont(type: .SFProTextSemiBold, size: 17)
        button.layer.cornerRadius = 28
        button.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)//.Colors.D_3_C_8_B_3
        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        return button
    }()
    
    lazy var goToSignUpButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        let stringOne = "Ещё нет аккаунта? "
        let stringTwo = "Регистрация"
        var buttonStringOne = NSMutableAttributedString(string: stringOne, attributes: [NSAttributedString.Key.font : UIFont.addFont(type: .SFProTextSemiBold, size: 15)])
        var buttonStringTwo = NSMutableAttributedString(string: stringTwo, attributes: [NSAttributedString.Key.font : UIFont.addFont(type: .SFProTextSemiBold, size: 15)])
        buttonStringOne.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(resource: ColorResource.Colors._302_C_28)], range: NSRange(location: 0, length: stringOne.count))
        buttonStringTwo.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(resource: ColorResource.Colors.B_5_A_380)], range: NSRange(location: 0, length: stringTwo.count))
        buttonStringOne.append(buttonStringTwo)
        button.setAttributedTitle(buttonStringOne, for: .normal)
        button.contentHorizontalAlignment = .center
        button.configuration = config
        button.addTarget(self, action: #selector(goToSignUp), for: .touchUpInside)
        return button
    }()
    
    lazy var forgotPassButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        let stringOne = "Забыли пароль?"
        var buttonStringOne = NSMutableAttributedString(string: stringOne, attributes: [NSAttributedString.Key.font : UIFont.addFont(type: .SFProTextSemiBold, size: 15)])
        buttonStringOne.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(resource: ColorResource.Colors.B_5_A_380)], range: NSRange(location: 0, length: stringOne.count))
        button.setAttributedTitle(buttonStringOne, for: .normal)
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16)
        button.contentHorizontalAlignment = .leading
        button.configuration = config
        button.addTarget(self, action: #selector(goToRestorePass), for: .touchUpInside)
        return button
    }()
    
    private var activityIndicator = MyActivityIndicator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        navigationItem.title = " "
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(resource: ImageResource.Registration.backArrowBrand), style: .done, target: self, action: #selector(dismissView))
        navigationController?.navigationBar.tintColor = UIColor(resource: ColorResource.Colors.B_5_A_380)

        addViews()
        setViews()
        setIndicator()
        setConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //- MARK: - Add & Set Views
    private func addViews() {
        view.addSubview(topLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(emailTextfield)
        view.addSubview(clearEmailButton)
        view.addSubview(dividerEmailView)
        view.addSubview(passTextfield)
        view.addSubview(showPassButton)
        view.addSubview(dividerPassView)
        view.addSubview(forgotPassButton)
        view.addSubview(signInButton)
        view.addSubview(goToSignUpButton)
    }
    private func setViews() {
        clearEmailButton.isHidden = true
    }
    private func setIndicator() {
        activityIndicator.image = UIImage(resource: ImageResource.Registration.loading24)
        signInButton.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(signInButton.snp.center)
        }
        activityIndicator.isHidden = true
    }
    //- MARK: - Constraints
    private func setConstraints() {
        topLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(33)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(topLabel.snp.horizontalEdges)
            make.height.equalTo(60)
        }
        emailTextfield.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(48)
        }
        dividerEmailView.snp.makeConstraints { make in
            make.top.equalTo(emailTextfield.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(1)
        }
        clearEmailButton.snp.makeConstraints { make in
            make.centerY.equalTo(emailTextfield.snp.centerY)
            make.trailing.equalTo(emailTextfield.snp.trailing)
            make.height.equalTo(48)
            make.width.equalTo(40)
        }
        passTextfield.snp.makeConstraints { make in
            make.top.equalTo(emailTextfield.snp.bottom).offset(1)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(48)
        }
        dividerPassView.snp.makeConstraints { make in
            make.top.equalTo(passTextfield.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(1)
        }
        showPassButton.snp.makeConstraints { make in
            make.centerY.equalTo(passTextfield.snp.centerY)
            make.trailing.equalTo(passTextfield.snp.trailing)
            make.height.equalTo(48)
            make.width.equalTo(40)
        }
        forgotPassButton.snp.makeConstraints { make in
            make.top.equalTo(dividerPassView.snp.bottom).offset(2)
            make.horizontalEdges.equalTo(dividerPassView.snp.horizontalEdges)
            make.height.equalTo(40)
        }
        goToSignUpButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(14)
            make.height.equalTo(40)
            make.horizontalEdges.equalToSuperview().inset(32)
        }
        signInButton.snp.makeConstraints { make in
            self.signInBottomToSignUpTop = make.bottom.equalTo(view.safeAreaLayoutGuide).inset(68).constraint
            make.horizontalEdges.equalTo(goToSignUpButton.snp.horizontalEdges)
            make.height.equalTo(56)
        }
//        loginSpinner.snp.makeConstraints { make in
//            make.center.equalTo(signInButton.snp.center)
//        }
//        activityIndicator.snp.makeConstraints { make in
//            make.center.equalTo(signInButton.snp.center)
//        }
    }
    //- MARK: - Button Actions
    @objc func goToRestorePass() {
        let restoreVC = RestorePassViewController()
        navigationController?.modalPresentationStyle = .overFullScreen
        present(restoreVC, animated: true, completion: nil)
    }
    @objc func goToSignUp() {
        if let previousVC = previousVC, previousVC is SignUpViewController {
            navigationController?.popViewController(animated: true)
        } else {
            let signUpVC = SignUpViewController()
            signUpVC.previousVC = self
            navigationController?.show(signUpVC, sender: self)
        }
    }
    @objc func dismissView() {
        navigationController?.popViewController(animated: true)
    }
    @objc func showPass() {
        passTextfield.isSecureTextEntry = !passTextfield.isSecureTextEntry
        if passTextfield.isSecureTextEntry {
            showPassButton.setImage(UIImage(resource: ImageResource.Registration.eye24), for: .normal)
        } else {
            showPassButton.setImage(UIImage(resource: ImageResource.Registration.eyeOff24), for: .normal)
        }
    }
    private func enableSignIn() {
        guard let email = emailTextfield.text else {
            return
        }
        guard let pass = passTextfield.text else {
            return
        }
        if !email.isEmpty && !pass.isEmpty {
            signInButton.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
            //signInButton.isEnabled = true
        } else {
            signInButton.backgroundColor = UIColor(resource: ColorResource.Colors.D_3_C_8_B_3)
            //signInButton.isEnabled = false
        }
    }
    @objc func clearField() {
        emailTextfield.text = .none
    }
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.signInBottomToSignUpTop?.update(inset: -16 + keyboardSize.height)
            let defaults = UserDefaults.standard
            defaults.set(keyboardSize.height, forKey: "keyboardHeight")
        }
    }
    @objc private func keyboardWillHide(notification: NSNotification) {
        self.signInBottomToSignUpTop?.update(inset: 68)
    }
    
    @objc private func signIn() {
        emailTextfield.resignFirstResponder()
        passTextfield.resignFirstResponder()
        guard let pass = passTextfield.text else { return }
        guard let email = emailTextfield.text else { return }
        
        if !email.isEmail() {
            showAlertMessage(title: "Некорректный адрес email", message: "Попробуйте снова")
            return
        }
        
        let parameters = ["email": email, "password": pass]
        signInButton.isEnabled = false
        activityIndicator.startAnimating()
        
        AF.request(URLs.SIGN_IN_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
            
            self.activityIndicator.stopAnimating()
            self.signInButton.isEnabled = true
            
            guard let responseCode = response.response?.statusCode else {
                self.showAlertMessage(title: "Ошибка соединения", message: "Проверьте подключение")
                return
            }
            if responseCode == 401 {
                self.showRedError()
                self.showAlertMessage(title: "Ошибка", message: "Неверный логин или пароль")
                return
            }
            if responseCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                if let token = json["access_token"].string {
                    AuthenticationService.shared.token = token
                    self.startApp()
                }
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
    
    private func startApp() {
        let tabViewController = TabBarController()
        tabViewController.modalPresentationStyle = .fullScreen
        self.present(tabViewController, animated: true, completion: nil)
    }
    private func showRedError() {
        emailTextfield.setIcon(UIImage(resource: ImageResource.Registration.mail24Red))
        dividerEmailView.backgroundColor = UIColor(resource: ColorResource.Colors.FA_5_C_5_C)
        passTextfield.setIcon(UIImage(resource: ImageResource.Registration.lock24Red))
        dividerPassView.backgroundColor = UIColor(resource: ColorResource.Colors.FA_5_C_5_C)
    }
    private func hideRedError() {
        emailTextfield.setIcon(UIImage(resource: ImageResource.Registration.mail24))
        dividerEmailView.backgroundColor = UIColor(red: 223/255, green: 222/255, blue: 221/255, alpha: 1)
        passTextfield.setIcon(UIImage(resource: ImageResource.Registration.lock24))
        dividerPassView.backgroundColor = UIColor(red: 223/255, green: 222/255, blue: 221/255, alpha: 1)
    }
    //- MARK: - Textfield actions
    @objc func textfieldEditBegin(textField: TextFieldWithPadding) {
        switch textField {
        case emailTextfield:
            return {
                guard let name = emailTextfield.text else {
                    return
                }
                if name.isEmpty {
                    clearEmailButton.isHidden = true
                } else {
                    clearEmailButton.isHidden = false
                }
                emailTextfield.setIcon(UIImage(resource: ImageResource.Registration.mail24))
                dividerEmailView.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
            }()
        case passTextfield:
            return {
                passTextfield.setIcon(UIImage(resource: ImageResource.Registration.lock24))
                dividerPassView.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
            }()
        default:
            break
        }
    }
    @objc func textfieldEditEnd(textField: TextFieldWithPadding) {
        switch textField {
        case emailTextfield:
            return {
                dividerEmailView.backgroundColor = UIColor(red: 223/255, green: 222/255, blue: 221/255, alpha: 1)
                clearEmailButton.isHidden = true
                guard let text = emailTextfield.text, !text.isEmpty else {
                    return
                }
                if !text.isEmail() {
                    showAlertMessage(title: "Некорректный email", message: "Попробуйте снова")
                    return
                }
            }()
        case passTextfield:
            return {
                dividerPassView.backgroundColor = UIColor(red: 223/255, green: 222/255, blue: 221/255, alpha: 1)
            }()
        default:
            return {}()
        }
    }
    @objc func textfieldEditingChanged (textField: TextFieldWithPadding) {
        switch textField {
        case emailTextfield:
            return {
                guard let text = emailTextfield.text, !text.isEmpty else {
                    clearEmailButton.isHidden = true
                    return
                }
                clearEmailButton.isHidden = false
                enableSignIn()
            }()
        case passTextfield:
            return {
                guard let text = passTextfield.text, !text.isEmpty else {
                    return
                }
                enableSignIn()
            }()
        default:
            return {}()
        }
    }
    @objc func textfieldAllEditing(textField: TextFieldWithPadding) {
        switch textField {
        case emailTextfield:
            return {
                enableSignIn()
            }()
        case passTextfield:
            return {
                enableSignIn()
            }()
        default:
            return {
                enableSignIn()
            }()
        }
    }
}
