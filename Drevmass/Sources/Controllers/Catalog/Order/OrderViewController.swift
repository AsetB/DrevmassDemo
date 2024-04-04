//
//  OrderViewController.swift
//  Drevmass
//
//  Created by Aset Bakirov on 27.03.2024.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class OrderViewController: UIViewController {
    //- MARK: - Variables
    var userData = User()
    var orderData = Order()
    var productData: [ProductOrder] = []
    var orderBottomToViewBottom: Constraint? = nil
    //- MARK: - Local outlets
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    private lazy var topLabel: UILabel = {
        let label = UILabel()
        label.text = "Получатель"
        label.font = .addFont(type: .SFProDisplayBold, size: 22)
        label.textColor = UIColor(resource: ColorResource.Colors._302_C_28)
        return label
    }()
    
    private lazy var recipientSegmentControl: UISegmentedControl = {
        let segControl = UISegmentedControl()
        segControl.insertSegment(withTitle: "Получу я", at: 0, animated: false)
        segControl.insertSegment(withTitle: "Другой получатель", at: 1, animated: false)
        segControl.selectedSegmentIndex = 0
        segControl.backgroundColor = UIColor(resource: ColorResource.Colors.EFEBE_9)
        
        //set actions for Segment Control
        let setAnotherRecipient = UIAction(title: "Другой получатель", handler: { _ in
            self.nameTextfieldLabel.isHidden = true
            self.nameTextfield.text = .none
            self.phoneTextfieldLabel.isHidden = true
            self.phoneTextfield.text = .none
            self.emailTextfieldLabel.isHidden = true
            self.emailTextfield.text = .none
            self.enableOrder()
        })
        let setUserRecipient = UIAction(title: "Получу я", handler: { _ in
            self.nameTextfieldLabel.isHidden = false
            self.nameTextfield.text = self.userData.name
            self.phoneTextfieldLabel.isHidden = false
            self.phoneTextfield.text = self.userData.phone_number
            self.emailTextfieldLabel.isHidden = false
            self.emailTextfield.text = self.userData.email
            self.enableOrder()
        })
        segControl.setAction(setUserRecipient, forSegmentAt: 0)
        segControl.setAction(setAnotherRecipient, forSegmentAt: 1)
        return segControl
    }()
    
    private var nameContainer = UIView()
    
    private lazy var nameTextfieldLabel: UILabel = {
        let label = UILabel()
        label.text = "Имя"
        label.font = .addFont(type: .SFProTextMedium, size: 13)
        label.textColor = UIColor(resource: ColorResource.Colors._989898)
        return label
    }()
    
    lazy var nameTextfield: UITextField = {
        let textfield = UITextField()
        let placeholderText = "Имя"
        textfield.defaultTextAttributes = [NSAttributedString.Key.font : UIFont.addFont(type: .SFProTextSemiBold, size: 17), NSAttributedString.Key.foregroundColor : UIColor(resource: ColorResource.Colors._181715)]
        textfield.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.font : UIFont.addFont(type: .SFProTextSemiBold, size: 17), NSAttributedString.Key.foregroundColor : UIColor(resource: ColorResource.Colors.A_1_A_1_A_1)])
        textfield.borderStyle = .none
        textfield.addTarget(self, action: #selector(textfieldAllEditing), for: .allEditingEvents)
        return textfield
    }()
    
    private lazy var clearNameButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: ImageResource.Registration.clear20), for: .normal)
        button.addTarget(self, action: #selector(clearField), for: .touchUpInside)
        return button
    }()
    
    private lazy var dividerNameView: UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor(red: 223/255, green: 222/255, blue: 221/255, alpha: 1) //tint UIColor(resource: ColorResourceUIColor(resource: ColorResource.Colors.B_5_A_380))
        return divider
    }()
    
    private var phoneContainer = UIView()
    
    private lazy var phoneTextfieldLabel: UILabel = {
        let label = UILabel()
        label.text = "Номер телефона"
        label.font = .addFont(type: .SFProTextMedium, size: 13)
        label.textColor = UIColor(resource: ColorResource.Colors._989898)
        return label
    }()
    
    lazy var phoneTextfield: UITextField = {
        let textfield = UITextField()
        let placeholderText = "Номер телефона"
        textfield.defaultTextAttributes = [NSAttributedString.Key.font : UIFont.addFont(type: .SFProTextSemiBold, size: 17), NSAttributedString.Key.foregroundColor : UIColor(resource: ColorResource.Colors._181715)]
        textfield.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.font : UIFont.addFont(type: .SFProTextSemiBold, size: 17), NSAttributedString.Key.foregroundColor : UIColor(resource: ColorResource.Colors.A_1_A_1_A_1)])
        textfield.borderStyle = .none
        textfield.addTarget(self, action: #selector(textfieldAllEditing), for: .allEditingEvents)
        textfield.delegate = self
        textfield.keyboardType = .phonePad
        return textfield
    }()
    
    private lazy var clearPhoneButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: ImageResource.Registration.clear20), for: .normal)
        button.addTarget(self, action: #selector(clearField), for: .touchUpInside)
        return button
    }()
    
    private lazy var dividerPhoneView: UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor(red: 223/255, green: 222/255, blue: 221/255, alpha: 1) //tint UIColor(resource: ColorResourceUIColor(resource: ColorResource.Colors.B_5_A_380))
        return divider
    }()
    
    private var emailContainer = UIView()
    
    private lazy var emailTextfieldLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = .addFont(type: .SFProTextMedium, size: 13)
        label.textColor = UIColor(resource: ColorResource.Colors._989898)
        return label
    }()
    
    lazy var emailTextfield: UITextField = {
        let textfield = UITextField()
        let placeholderText = "Email"
        textfield.defaultTextAttributes = [NSAttributedString.Key.font : UIFont.addFont(type: .SFProTextSemiBold, size: 17), NSAttributedString.Key.foregroundColor : UIColor(resource: ColorResource.Colors._181715)]
        textfield.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.font : UIFont.addFont(type: .SFProTextSemiBold, size: 17), NSAttributedString.Key.foregroundColor : UIColor(resource: ColorResource.Colors.A_1_A_1_A_1)])
        textfield.borderStyle = .none
        textfield.addTarget(self, action: #selector(textfieldAllEditing), for: .allEditingEvents)
        //textfield.delegate = self
        textfield.keyboardType = .emailAddress
        return textfield
    }()
    
    private lazy var clearEmailButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: ImageResource.Registration.clear20), for: .normal)
        button.addTarget(self, action: #selector(clearField), for: .touchUpInside)
        return button
    }()
    
    private lazy var dividerEmailView: UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor(red: 223/255, green: 222/255, blue: 221/255, alpha: 1) //tint UIColor(resource: ColorResourceUIColor(resource: ColorResource.Colors.B_5_A_380))
        return divider
    }()
    
    private lazy var orderButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отправить заявку", for: .normal)
        button.setTitle("", for: .disabled)
        button.setTitleColor(UIColor(resource: ColorResource.Colors.FFFFFF), for: .normal)
        button.titleLabel?.font = .addFont(type: .SFProTextSemiBold, size: 17)
        button.layer.cornerRadius = 25
        button.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        button.addTarget(self, action: #selector(completeOrder), for: .touchUpInside)
        return button
    }()
    
    private var activityIndicator = MyActivityIndicator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        navigationController?.navigationBar.tintColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        navigationItem.title = "Оформление заказа"
        addViews()
        setViews()
        setConstraints()
        loadUserData()
        setData()
        setIndicator()
        
        //Keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    //- MARK: - Add & set Views
    private func addViews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(topLabel)
        stackView.addArrangedSubview(recipientSegmentControl)
        stackView.addArrangedSubview(nameContainer)
        nameContainer.addSubview(nameTextfield)
        nameContainer.addSubview(clearNameButton)
        nameContainer.addSubview(nameTextfieldLabel)
        nameContainer.addSubview(dividerNameView)
        stackView.addArrangedSubview(phoneContainer)
        phoneContainer.addSubview(phoneTextfield)
        phoneContainer.addSubview(clearPhoneButton)
        phoneContainer.addSubview(phoneTextfieldLabel)
        phoneContainer.addSubview(dividerPhoneView)
        stackView.addArrangedSubview(emailContainer)
        emailContainer.addSubview(emailTextfield)
        emailContainer.addSubview(clearEmailButton)
        emailContainer.addSubview(emailTextfieldLabel)
        emailContainer.addSubview(dividerEmailView)
        view.addSubview(orderButton)
    }
    private func setViews() {
        clearNameButton.isHidden = true
        clearEmailButton.isHidden = true
        clearPhoneButton.isHidden = true
    }
    private func setIndicator() {
        activityIndicator.image = UIImage(resource: ImageResource.Registration.loading24)
        orderButton.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        activityIndicator.isHidden = true
    }
    //- MARK: - Set Constraints
    private func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        topLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
        }
        recipientSegmentControl.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }
        nameContainer.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(56)
        }
        nameTextfield.snp.makeConstraints { make in
            make.height.equalTo(46)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        clearNameButton.snp.makeConstraints { make in
            make.trailing.equalTo(nameTextfield.snp.trailing)
            make.bottom.equalTo(nameTextfield.snp.bottom)
            make.width.equalTo(32)
            make.height.equalTo(48)
        }
        nameTextfieldLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        dividerNameView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        phoneContainer.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(56)
        }
        phoneTextfield.snp.makeConstraints { make in
            make.height.equalTo(46)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        clearPhoneButton.snp.makeConstraints { make in
            make.trailing.equalTo(phoneTextfield.snp.trailing)
            make.bottom.equalTo(phoneTextfield.snp.bottom)
            make.width.equalTo(32)
            make.height.equalTo(48)
        }
        phoneTextfieldLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        dividerPhoneView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        emailContainer.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(56)
        }
        emailTextfield.snp.makeConstraints { make in
            make.height.equalTo(46)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        clearEmailButton.snp.makeConstraints { make in
            make.trailing.equalTo(emailTextfield.snp.trailing)
            make.bottom.equalTo(emailTextfield.snp.bottom)
            make.width.equalTo(32)
            make.height.equalTo(48)
        }
        emailTextfieldLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        dividerEmailView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        orderButton.snp.makeConstraints { make in
            self.orderBottomToViewBottom = make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16).constraint
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
    
    //- MARK: - Network
    private func loadUserData() {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AuthenticationService.shared.token)"
        ]
        AF.request(URLs.USER_INFO_URL, method: .get, headers: headers).responseData { response in
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8) ?? ""
            }

            if response.response?.statusCode == 200{
            
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                self.userData = User(json: json)
                DispatchQueue.main.async {
                    self.setData()
                }
            }else{
                var ErrorString = "CONNECTION_ERROR"
                if let sCode = response.response?.statusCode{
                    ErrorString = ErrorString + "\(sCode)"
                }
                ErrorString = ErrorString + "\(resultString)"
                self.showAlertMessage(title: "Ошибка", message: ErrorString)
            }
        }
    }
    
    private func sendOrder() {
        
        nameTextfield.resignFirstResponder()
        emailTextfield.resignFirstResponder()
        phoneTextfield.resignFirstResponder()
        
        guard let name = nameTextfield.text else { return }
        guard let phone = phoneTextfield.text else { return }
        guard let email = emailTextfield.text else { return }
        
        if !email.isEmail() {
            showAlertMessage(title: "Некорректный email", message: "Попробуйте снова")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AuthenticationService.shared.token)"
        ]
        
        let productParameters = productData.map { product -> [String: Any] in return [
                "name": product.name,
                "price": product.price,
                "product_id": product.productID,
                "quantity": product.quantity
            ]
        }
        
        let parameters = ["bonus": orderData.bonus, "crmlink": "string", "email": email, "phone_number": phone, "products": productParameters, "total_price": orderData.totalPrice, "username": name ] as [String : Any]
        
        orderButton.isEnabled = false
        activityIndicator.startAnimating()
        
        AF.request(URLs.POST_ORDER, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
            
            self.activityIndicator.stopAnimating()
            self.orderButton.isEnabled = true
            
            print(parameters)
            guard let responseCode = response.response?.statusCode else {
                self.showAlertMessage(title: "Ошибка соединения", message: "Проверьте подключение")
                return
            }
            if responseCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                DispatchQueue.main.async {
                    let vc = SuccessOrderViewController()
                    self.navigationController?.presentPanModal(vc)
                }
            } else {
                var resultString = ""
                if let data = response.data {
                    resultString = String(data: data, encoding: .utf8) ?? ""
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
    //- MARK: - Set Data
    private func setData() {
        nameTextfield.text = userData.name
        phoneTextfield.text = userData.phone_number
        emailTextfield.text = userData.email
    }
    //- MARK: - Actions for keyboard observers
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.orderBottomToViewBottom?.update(inset: -68 + keyboardSize.height)
            let defaults = UserDefaults.standard
            defaults.set(keyboardSize.height, forKey: "keyboardHeight")
        }
    }
    @objc private func keyboardWillHide(notification: NSNotification) {
        self.orderBottomToViewBottom?.update(inset: 16)
    }
    //- MARK: - Button actions
    @objc private func textfieldAllEditing(textfield: UITextField) {
        switch textfield {
        case nameTextfield:
            return {
                guard let name = nameTextfield.text else {
                    return
                }
                if name.isEmpty {
                    nameTextfieldLabel.isHidden = true
                    clearNameButton.isHidden = true
                } else {
                    nameTextfieldLabel.isHidden = false
                    clearNameButton.isHidden = false
                }
                enableOrder()
            }()
        case phoneTextfield: 
            return {
                guard let phone = phoneTextfield.text else {
                    return
                }
                if phone.isEmpty {
                    phoneTextfieldLabel.isHidden = true
                    clearPhoneButton.isHidden = true
                } else {
                    phoneTextfieldLabel.isHidden = false
                    clearPhoneButton.isHidden = false
                }
                enableOrder()
            }()
        case emailTextfield: 
            return {
                guard let email = emailTextfield.text else {
                    return
                }
                if email.isEmpty {
                    emailTextfieldLabel.isHidden = true
                    clearEmailButton.isHidden = true
                } else {
                    emailTextfieldLabel.isHidden = false
                    clearEmailButton.isHidden = false
                }
                enableOrder()
            }()
        default:
            break
        }
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
    
    private func enableOrder() {
        guard let name = nameTextfield.text else {
            return
        }
        guard let phone = phoneTextfield.text else {
            return
        }
        guard let email = emailTextfield.text else {
            return
        }
        
        if !name.isEmpty && !phone.isEmpty && !email.isEmpty {
            orderButton.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
            orderButton.isEnabled = true
        } else {
            orderButton.backgroundColor = UIColor(resource: ColorResource.Colors.D_3_C_8_B_3)
            orderButton.isEnabled = false
        }
    }
    @objc func completeOrder() {
        sendOrder()
    }
}
