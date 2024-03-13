//
//  SignUpViewController.swift
//  Drevmass
//
//  Created by Aset Bakirov on 05.03.2024.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class SignUpViewController: UIViewController {
    //- MARK: - Variables
    var previousVC: UIViewController?
    var signUpBottomToSignInTop: Constraint? = nil
    //- MARK: - Local outlets
    private lazy var topLabel: UILabel = {
        let label = UILabel()
        label.text = "Регистрация"
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
    
    private lazy var nameTextfield: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        let placeholderText = "Ваше имя"
        textfield.defaultTextAttributes = [NSAttributedString.Key.font : UIFont.addFont(type: .SFProTextSemiBold, size: 17), NSAttributedString.Key.foregroundColor : UIColor(resource: ColorResource.Colors._181715)]
        textfield.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.font : UIFont.addFont(type: .SFProTextSemiBold, size: 17), NSAttributedString.Key.foregroundColor : UIColor(resource: ColorResource.Colors.A_1_A_1_A_1)])
        textfield.setIcon(UIImage(resource: ImageResource.Registration.profile24))
        textfield.borderStyle = .none
        textfield.addTarget(self, action: #selector(textfieldEditBegin), for: .editingDidBegin)
        textfield.addTarget(self, action: #selector(textfieldEditEnd), for: .editingDidEnd)
        textfield.addTarget(self, action: #selector(textfieldEditingChanged), for: .editingChanged)
        textfield.addTarget(self, action: #selector(textfieldAllEditing), for: .allEditingEvents)
        return textfield
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
    
    private lazy var phoneTextfield: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        let placeholderText = "Номер телефона"
        textfield.defaultTextAttributes = [NSAttributedString.Key.font : UIFont.addFont(type: .SFProTextSemiBold, size: 17), NSAttributedString.Key.foregroundColor : UIColor(resource: ColorResource.Colors._181715)]
        textfield.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.font : UIFont.addFont(type: .SFProTextSemiBold, size: 17), NSAttributedString.Key.foregroundColor : UIColor(resource: ColorResource.Colors.A_1_A_1_A_1)])
        textfield.setIcon(UIImage(resource: ImageResource.Registration.phone24))
        textfield.borderStyle = .none
        textfield.addTarget(self, action: #selector(textfieldEditBegin), for: .editingDidBegin)
        textfield.addTarget(self, action: #selector(textfieldEditEnd), for: .editingDidEnd)
        textfield.addTarget(self, action: #selector(textfieldEditingChanged), for: .editingChanged)
        textfield.addTarget(self, action: #selector(textfieldAllEditing), for: .allEditingEvents)
        textfield.delegate = self
        return textfield
    }()
    
    private lazy var passTextfield: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        let placeholderText = "Придумайте пароль"
        textfield.defaultTextAttributes = [NSAttributedString.Key.font : UIFont.addFont(type: .SFProTextSemiBold, size: 17), NSAttributedString.Key.foregroundColor : UIColor(resource: ColorResource.Colors._181715)]
        textfield.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.font : UIFont.addFont(type: .SFProTextSemiBold, size: 17), NSAttributedString.Key.foregroundColor : UIColor(resource: ColorResource.Colors.A_1_A_1_A_1)])
        textfield.setIcon(UIImage(resource: ImageResource.Registration.lock24))
        textfield.borderStyle = .none
        textfield.isSecureTextEntry = true
        textfield.addTarget(self, action: #selector(textfieldEditBegin), for: .editingDidBegin)
        textfield.addTarget(self, action: #selector(textfieldEditEnd), for: .editingDidEnd)
        textfield.addTarget(self, action: #selector(textfieldAllEditing), for: .allEditingEvents)
        return textfield
    }()
    
    private lazy var clearNameButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: ImageResource.Registration.clear20), for: .normal)
        button.addTarget(self, action: #selector(clearField), for: .touchUpInside)
        return button
    }()
    
    private lazy var clearEmailButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: ImageResource.Registration.clear20), for: .normal)
        button.addTarget(self, action: #selector(clearField), for: .touchUpInside)
        return button
    }()
    
    private lazy var clearPhoneButton: UIButton = {
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
    
    private lazy var dividerNameView: UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor(red: 223/255, green: 222/255, blue: 221/255, alpha: 1) //tint UIColor(resource: ColorResourceUIColor(resource: ColorResource.Colors.B_5_A_380))
        return divider
    }()
    
    private lazy var dividerEmailView: UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor(red: 223/255, green: 222/255, blue: 221/255, alpha: 1) //tint UIColor(resource: ColorResourceUIColor(resource: ColorResource.Colors.B_5_A_380))
        return divider
    }()
    
    private lazy var dividerPhoneView: UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor(red: 223/255, green: 222/255, blue: 221/255, alpha: 1) //tint UIColor(resource: ColorResourceUIColor(resource: ColorResource.Colors.B_5_A_380))
        return divider
    }()
    
    private lazy var dividerPassView: UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor(red: 223/255, green: 222/255, blue: 221/255, alpha: 1) //tint UIColor(resource: ColorResourceUIColor(resource: ColorResource.Colors.B_5_A_380))
        return divider
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Продолжить", for: .normal)
        button.setTitleColor(UIColor(resource: ColorResource.Colors.FFFFFF), for: .normal)
        button.titleLabel?.font = .addFont(type: .SFProTextSemiBold, size: 17)
        button.layer.cornerRadius = 28
        button.backgroundColor = UIColor(resource: ColorResource.Colors.D_3_C_8_B_3)
        button.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        return button
    }()
    
    lazy var goToSignInButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        let stringOne = "Уже есть аккаунт? "
        let stringTwo = "Войти"
        var buttonStringOne = NSMutableAttributedString(string: stringOne, attributes: [NSAttributedString.Key.font : UIFont.addFont(type: .SFProTextSemiBold, size: 15)])
        var buttonStringTwo = NSMutableAttributedString(string: stringTwo, attributes: [NSAttributedString.Key.font : UIFont.addFont(type: .SFProTextSemiBold, size: 15)])
        buttonStringOne.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(resource: ColorResource.Colors._302_C_28)], range: NSRange(location: 0, length: stringOne.count))
        buttonStringTwo.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(resource: ColorResource.Colors.B_5_A_380)], range: NSRange(location: 0, length: stringTwo.count))
        buttonStringOne.append(buttonStringTwo)
        button.setAttributedTitle(buttonStringOne, for: .normal)
        button.contentHorizontalAlignment = .center
        button.configuration = config
        button.addTarget(self, action: #selector(goToSignIn), for: .touchUpInside)
        return button
    }()
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        navigationItem.title = " "
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(resource: ImageResource.Registration.backArrowBrand), style: .done, target: self, action: #selector(dismissView))
        navigationController?.navigationBar.tintColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        addViews()
        setConstraints()
        setViews()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //- MARK: - Add & Set Views
    private func addViews() {
        view.addSubview(topLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(nameTextfield)
        view.addSubview(clearNameButton)
        view.addSubview(dividerNameView)
        view.addSubview(emailTextfield)
        view.addSubview(clearEmailButton)
        view.addSubview(dividerEmailView)
        view.addSubview(phoneTextfield)
        view.addSubview(clearPhoneButton)
        view.addSubview(dividerPhoneView)
        view.addSubview(passTextfield)
        view.addSubview(showPassButton)
        view.addSubview(dividerPassView)
        view.addSubview(signUpButton)
        view.addSubview(goToSignInButton)
    }
    private func setViews() {
        clearNameButton.isHidden = true
        clearEmailButton.isHidden = true
        clearPhoneButton.isHidden = true
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
        nameTextfield.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(48)
        }
        dividerNameView.snp.makeConstraints { make in
            make.top.equalTo(nameTextfield.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(1)
        }
        clearNameButton.snp.makeConstraints { make in
            make.centerY.equalTo(nameTextfield.snp.centerY)
            make.trailing.equalTo(nameTextfield.snp.trailing)
            make.height.equalTo(48)
            make.width.equalTo(40)
        }
        emailTextfield.snp.makeConstraints { make in
            make.top.equalTo(nameTextfield.snp.bottom).offset(1)
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
        phoneTextfield.snp.makeConstraints { make in
            make.top.equalTo(emailTextfield.snp.bottom).offset(1)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(48)
        }
        dividerPhoneView.snp.makeConstraints { make in
            make.top.equalTo(phoneTextfield.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(1)
        }
        clearPhoneButton.snp.makeConstraints { make in
            make.centerY.equalTo(phoneTextfield.snp.centerY)
            make.trailing.equalTo(phoneTextfield.snp.trailing)
            make.height.equalTo(48)
            make.width.equalTo(40)
        }
        passTextfield.snp.makeConstraints { make in
            make.top.equalTo(phoneTextfield.snp.bottom).offset(1)
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
        goToSignInButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(14)
            make.height.equalTo(40)
            make.horizontalEdges.equalToSuperview().inset(32)
        }
        signUpButton.snp.makeConstraints { make in
            self.signUpBottomToSignInTop = make.bottom.equalTo(view.safeAreaLayoutGuide).inset(68).constraint
            make.horizontalEdges.equalTo(goToSignInButton.snp.horizontalEdges)
            make.height.equalTo(56)
        }
    }
    //- MARK: - Set Data
    //- MARK: - Button actions
    @objc func goToSignIn() {
        if let previousVC = previousVC, previousVC is SignInViewController {
            navigationController?.popViewController(animated: true)
        } else {
            let signInVC = SignInViewController()
            signInVC.previousVC = self
            navigationController?.show(signInVC, sender: self)
        }
    }
    @objc func dismissView() {
        navigationController?.popViewController(animated: true)
    }
    @objc func clearField(button: UIButton) {
        switch button {
        case clearNameButton:
            return {
                nameTextfield.text = .none
            }()
            case clearEmailButton:
            return {
                emailTextfield.text = .none
            }()
            case clearPhoneButton:
            return {
                phoneTextfield.text = .none
            }()
        default:
            break
        }
    }
    @objc func showPass() {
        passTextfield.isSecureTextEntry = !passTextfield.isSecureTextEntry
        if passTextfield.isSecureTextEntry {
            showPassButton.setImage(UIImage(resource: ImageResource.Registration.eye24), for: .normal)
        } else {
            showPassButton.setImage(UIImage(resource: ImageResource.Registration.eyeOff24), for: .normal)
        }
    }
    private func enableSignUp() {
        guard let name = nameTextfield.text else {
            return
        }
        guard let email = emailTextfield.text else {
            return
        }
        guard let phone = phoneTextfield.text else {
            return
        }
        guard let pass = passTextfield.text else {
            return
        }
        if !name.isEmpty && !email.isEmpty && !phone.isEmpty && !pass.isEmpty {
            signUpButton.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
            signUpButton.isEnabled = true
        } else {
            signUpButton.backgroundColor = UIColor(resource: ColorResource.Colors.D_3_C_8_B_3)
            signUpButton.isEnabled = false
        }
    }
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.signUpBottomToSignInTop?.update(inset: -16 + keyboardSize.height)
        }
    }
    @objc private func keyboardWillHide(notification: NSNotification) {
        self.signUpBottomToSignInTop?.update(inset: 68)
    }
    @objc private func signUp() {
        guard let name = nameTextfield.text else { return }
        guard let phone = phoneTextfield.text else { return }
        guard let pass = passTextfield.text else { return }
        guard let email = emailTextfield.text else { return }
        
        if !email.isEmail() {
            showAlertMessage(title: "Некорректный email", message: "Попробуйте снова")
            return
        }
        
        let parameters = ["email": email, "name": name, "password": pass, "phone_number": phone]
        
        AF.request(URLs.SIGN_UP_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
            
            guard let responseCode = response.response?.statusCode else {
                self.showAlertMessage(title: "Ошибка соединения", message: "Проверьте подключение")
                return
            }
            if responseCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                if let token = json["access_token"].string {
                    AuthenticationService.shared.token = token
                    self.showAlertMessage(title: "Успех", message: "Для завершения регистрации проверьте почту")
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
    //- MARK: - Textfield actions
    @objc func textfieldEditBegin(textField: TextFieldWithPadding) {
        switch textField {
        case nameTextfield:
            return {
                guard let name = nameTextfield.text else {
                    return
                }
                if name.isEmpty {
                    clearNameButton.isHidden = true
                } else {
                    clearNameButton.isHidden = false
                }
                dividerNameView.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
            }()
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
                dividerEmailView.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
            }()
        case phoneTextfield:
            return {
                guard let name = phoneTextfield.text else {
                    return
                }
                if name.isEmpty {
                    clearPhoneButton.isHidden = true
                } else {
                    clearPhoneButton.isHidden = false
                }
                dividerPhoneView.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
            }()
        case passTextfield:
            return {
                dividerPassView.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
            }()
        default:
            break
        }
    }
    @objc func textfieldEditEnd(textField: TextFieldWithPadding) {
        switch textField {
        case nameTextfield:
            return {
                dividerNameView.backgroundColor = UIColor(red: 223/255, green: 222/255, blue: 221/255, alpha: 1)
                clearNameButton.isHidden = true
            }()
        case emailTextfield:
            return {
                dividerEmailView.backgroundColor = UIColor(red: 223/255, green: 222/255, blue: 221/255, alpha: 1)
                clearEmailButton.isHidden = true
            }()
        case phoneTextfield:
            return {
                dividerPhoneView.backgroundColor = UIColor(red: 223/255, green: 222/255, blue: 221/255, alpha: 1)
                clearPhoneButton.isHidden = true
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
        case nameTextfield:
            return {
                guard let text = nameTextfield.text, !text.isEmpty else {
                    clearNameButton.isHidden = true
                    return
                }
                clearNameButton.isHidden = false
                enableSignUp()
            }()
        case emailTextfield:
            return {
                guard let text = emailTextfield.text, !text.isEmpty else {
                    clearEmailButton.isHidden = true
                    return
                }
                clearEmailButton.isHidden = false
                enableSignUp()
            }()
        case phoneTextfield:
            return {
                guard let text = phoneTextfield.text, !text.isEmpty else {
                    clearPhoneButton.isHidden = true
                    return
                }
                clearPhoneButton.isHidden = false
                enableSignUp()
            }()
        case passTextfield:
            return {
                guard let text = passTextfield.text, !text.isEmpty else {
                    return
                }
                enableSignUp()
            }()
        default:
            return {}()
        }
    }
    @objc func textfieldAllEditing(textField: TextFieldWithPadding) {
        switch textField {
        case nameTextfield:
            return {
                enableSignUp()
            }()
        case emailTextfield:
            return {
                enableSignUp()
            }()
        case phoneTextfield:
            return {
                enableSignUp()
            }()
        case passTextfield:
            return {
                enableSignUp()
            }()
        default:
            return {
                enableSignUp()
            }()
        }
    }
}
//- MARK: - Phone number mask
extension SignUpViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneTextfield {
            let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
            
            let formattedText = newText.applyPatternOnNumbers(pattern: "+# (###) ###-####", replacementCharacter: "#")
            
            let maxLength = "+# ### ### ## ##".count
                if formattedText.count > maxLength {
                return false
            }
            textField.text = formattedText
            return false
        }
        return true
    }
}
