//
//  InfoAboutMeViewController.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 08.03.2024.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import SnapKit

class InfoAboutMeViewController: UIViewController {
    
//    uipickerview
    
    var user = User()
    var scrollViewBottomConstraint: Constraint?
    // - MARK: - UI elements
    
    
    var scrollView: UIScrollView = {
       var scrollview = UIScrollView()
           scrollview.backgroundColor = .clear
           scrollview.showsVerticalScrollIndicator = true
           scrollview.isScrollEnabled = true
           scrollview.clipsToBounds = true
           scrollview.contentMode = .scaleAspectFill
           scrollview.contentInsetAdjustmentBehavior = .never
        return scrollview
    }()
    var contentview: UIView = {
        var view = UIView()
            view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        return view
    }()
    
    var stackViewForTextfiels: UIStackView = {
       var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    var nameTextFieldView: TextFieldView = {
        var textfieldView = TextFieldView()
        textfieldView.titleLabel.text = "Имя"
        textfieldView.textfield.keyboardType = .namePhonePad
//        нужно ли добавить еще блокировку кнопку для других текстфилдов?
        textfieldView.textfield.addTarget(self, action: #selector(activationSaveButton), for: .editingChanged)
        textfieldView.clearButton.addTarget(self, action: #selector(activationSaveButton), for: .touchUpInside)

        return textfieldView
    }() 
    
    var numberTextFieldView: TextFieldView = {
        var textfieldView = TextFieldView()
        textfieldView.titleLabel.text = "Номер телефона"
        textfieldView.textfield.keyboardType = .numberPad
        
        return textfieldView
    }() 
    
    var emailTextFieldView: TextFieldView = {
        var textfieldView = TextFieldView()
        textfieldView.titleLabel.text = "Email"
        textfieldView.textfield.isUserInteractionEnabled = false
        return textfieldView
    }()
    
    var birthdateTextFieldView: TextFieldView = {
        var textfieldView = TextFieldView()
        textfieldView.titleLabel.text = "  "
        textfieldView.textfield.attributedPlaceholder = NSAttributedString(string: "Дата рождения")
        return textfieldView
    }()
    
    var genderLabel: UILabel = {
        let label = UILabel()
        label.font = .addFont(type: .SFProTextMedium, size: 13)
        label.textColor = UIColor(resource: ColorResource.Colors._989898) 
        label.text = "Пол"
        return label
    }()
    
    var genderSegmentedControl: UISegmentedControl = {
       var segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "Не указано", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Мужской", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "Женский", at: 2, animated: false)
        segmentedControl.backgroundColor = UIColor(resource: ColorResource.Colors.EFEBE_9) 
        return segmentedControl
    }()
    
    var stackViewForHeightWeight: UIStackView = {
       var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 24
        return stackView
    }()
    
    var heightTextField: TextFieldView = {
       var textfieldview = TextFieldView()
        textfieldview.titleLabel.text = "  "
        textfieldview.textfield.attributedPlaceholder = NSAttributedString(string: "Рост", attributes: [.font: UIFont.addFont(type: .SFProTextSemiBold, size: 17), .foregroundColor: UIColor(resource: ColorResource.Colors.A_1_A_1_A_1) ])
        textfieldview.widthAnchor.constraint(equalToConstant: 159.5).isActive = true
        textfieldview.textfield.keyboardType = .numberPad
        return textfieldview
    }() 
    
    var weightTextField: TextFieldView = {
       var textfieldview = TextFieldView()
        textfieldview.titleLabel.text = "  "
        textfieldview.textfield.attributedPlaceholder = NSAttributedString(string: "Вес", attributes: [.font: UIFont.addFont(type: .SFProTextSemiBold, size: 17), .foregroundColor: UIColor(resource: ColorResource.Colors.A_1_A_1_A_1) ])
        textfieldview.widthAnchor.constraint(equalToConstant: 159.5).isActive = true
        textfieldview.textfield.keyboardType = .numberPad
        return textfieldview
    }()
    
    var yourActivityLabel: UILabel = {
        let label = UILabel()
        label.font = .addFont(type: .SFProTextMedium, size: 13)
        label.textColor = UIColor(resource: ColorResource.Colors._989898) 
        label.text = "Ваша активность"
        return label
    }()
    
    var activitySegmentedControl: UISegmentedControl = {
       var segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "Низкая", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Средняя", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "Высокая", at: 2, animated: false)
        segmentedControl.backgroundColor = UIColor(resource: ColorResource.Colors.EFEBE_9) 
        return segmentedControl
    }()
    
    var deleteAccountButton: UIButton = {
       var button = UIButton()
        button.setTitle("Удалить аккаунт", for: .normal)
        button.setTitleColor(UIColor(resource: ColorResource.Colors.FA_5_C_5_C) , for: .normal)
        button.titleLabel?.font = .addFont(type: .SFProTextSemiBold, size: 15)
        button.addTarget(self, action: #selector(showAlertForDeleteAccount), for: .touchUpInside)
        return button
    }()
    
    var saveButton: UIButton = {
       var button = UIButton()
        button.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        button.setTitle("Сохранить изменения", for: .normal)
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(postUserInfo), for: .touchUpInside)
        button.titleLabel?.font = .addFont(type: .SFProTextSemiBold, size: 17)
        return button
    }()
    
    lazy var datePicker: UIDatePicker = {
         let datePicker = UIDatePicker()
         datePicker.datePickerMode = .date
         datePicker.locale = .autoupdatingCurrent
         datePicker.preferredDatePickerStyle = .wheels
         datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
         datePicker.locale = Locale(identifier: "ru_RU")
         return datePicker
     }()
    
    // - MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupNavigationBar()
        getUserInfo()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension InfoAboutMeViewController {
    // - MARK: - network
    func getUserInfo() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AuthenticationService.shared.token)"
        ]
        AF.request(URLs.USER_INFO_URL, method: .get, headers: headers).responseData { response in
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)! 
            }

            if response.response?.statusCode == 200{
            
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                self.user = User(json: json)
                DispatchQueue.main.async {
                    self.nameTextFieldView.textfield.text = self.user.name
                    self.numberTextFieldView.textfield.text = self.user.phone_number
                    self.emailTextFieldView.textfield.text = self.user.email
                    self.birthdateTextFieldView.textfield.text = self.user.birth
                    self.activitySegmentedControl.selectedSegmentIndex = self.user.activity
                    self.heightTextField.textfield.text = "\(self.user.height)"
                    self.weightTextField.textfield.text = "\(self.user.weight)"
                    self.genderSegmentedControl.selectedSegmentIndex = self.user.gender
                }
            }else{
                var ErrorString = "CONNECTION_ERROR"
                if let sCode = response.response?.statusCode{
                    ErrorString = ErrorString + "\(sCode)"
                }
                ErrorString = ErrorString + "\(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
        }
    }
    
    @objc func postUserInfo() {
        SVProgressHUD.show()
        let activity = activitySegmentedControl.selectedSegmentIndex
        let birth = birthdateTextFieldView.textfield.text ?? ""
        let gender = genderSegmentedControl.selectedSegmentIndex
        let height = Int(heightTextField.textfield.text ?? "") ?? 0
        let weight = Int(weightTextField.textfield.text ?? "") ?? 0
        let name = nameTextFieldView.textfield.text ?? ""
        let phone_number = numberTextFieldView.textfield.text ?? ""
        
        let parametrs = ["activity": activity, "birth": birth, "gender": gender, "height": height, "weight": weight, "name": name, "phone_number": phone_number] as [String : Any]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AuthenticationService.shared.token)"
        ]
        AF.request(URLs.USER_INFO_URL, method: .post,parameters: parametrs, encoding: JSONEncoding.default, headers: headers).responseData { response in
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
            }
            if response.response?.statusCode == 200{
                let json = JSON(response.data!)
                print("JSON: \(json)")
                self.user = User(json: json)
            }else{
                var ErrorString = "CONNECTION_ERROR"
                if let sCode = response.response?.statusCode{
                    ErrorString = ErrorString + "\(sCode)"
                }
                ErrorString = ErrorString + "\(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
            self.dismissView()
        }
    }
    
    func deleteUser(){
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AuthenticationService.shared.token)"
        ]
        AF.request(URLs.DELETE_USER_URL, method: .delete, headers: headers).responseData { response in
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
            let rootViewController = UINavigationController(rootViewController: OnboardingViewController())
             window.rootViewController = rootViewController
        }
    }
    // - MARK: - other funcs
     @objc func dismissView() {
         navigationController?.popViewController(animated: true)
     }
    
    @objc func showAlertForDeleteAccount() {
        let alert = UIAlertController(title: "Вы уверены, что хотите удалить аккуант?", message: "Ваши личные данные и накопленные бонусы будут удалены без возможности восстановления.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Оставить", style: .default, handler: { _ in
            alert.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { UIAlertAction in
            self.deleteUser()
        }))
        present(alert, animated: true, completion: nil)
     }
    
   @objc  func activationSaveButton() {
       if nameTextFieldView.textfield.text == "" {
           saveButton.isEnabled = false
           saveButton.backgroundColor = UIColor(resource: ColorResource.Colors.D_3_C_8_B_3) 
       }else{
           saveButton.isEnabled = true
           saveButton.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
       }
    }
    
    @objc func datePickerChanged(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        self.birthdateTextFieldView.textfield.text = dateFormatter.string(from: datePicker.date)
    }

    @objc func doneButtonAction(){
        birthdateTextFieldView.textfield.resignFirstResponder()
        nameTextFieldView.textfield.resignFirstResponder()
        numberTextFieldView.textfield.resignFirstResponder()
        heightTextField.textfield.resignFirstResponder()
        weightTextField.textfield.resignFirstResponder()
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
               scrollViewBottomConstraint?.update(inset: keyboardSize.height)
            }
        }
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollViewBottomConstraint?.update(inset: 0)
    }
    
    // - MARK: - Setups
    
    func setupNavigationBar(){
        navigationItem.title = "Мои данные"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(resource: ImageResource.Profile.iconBack), style: .done, target: self, action: #selector(dismissView))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
    }
    
    func setupView() {
        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        view.addSubview(scrollView)
        scrollView.addSubview(contentview)
        contentview.addSubview(stackViewForTextfiels)
        stackViewForTextfiels.addArrangedSubview(nameTextFieldView)
        stackViewForTextfiels.addArrangedSubview(numberTextFieldView)
        stackViewForTextfiels.addArrangedSubview(emailTextFieldView)
        stackViewForTextfiels.addArrangedSubview(birthdateTextFieldView)
        contentview.addSubview(genderLabel)
        contentview.addSubview(genderSegmentedControl)
        contentview.addSubview(stackViewForHeightWeight)
        stackViewForHeightWeight.addArrangedSubview(heightTextField)
        stackViewForHeightWeight.addArrangedSubview(weightTextField)
        contentview.addSubview(yourActivityLabel)
        contentview.addSubview(activitySegmentedControl)
        contentview.addSubview(deleteAccountButton)
        contentview.addSubview(saveButton)
        
        birthdateTextFieldView.textfield.inputView = datePicker
        
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
        birthdateTextFieldView.textfield.inputAccessoryView = doneToolbar
        nameTextFieldView.textfield.inputAccessoryView = doneToolbar
        numberTextFieldView.textfield.inputAccessoryView = doneToolbar
        heightTextField.textfield.inputAccessoryView = doneToolbar
        weightTextField.textfield.inputAccessoryView = doneToolbar
        
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            scrollViewBottomConstraint = make.bottom.equalToSuperview().constraint
        }
        contentview.snp.makeConstraints { make in
            make.horizontalEdges.top.bottom.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.greaterThanOrEqualTo(scrollView.frameLayoutGuide)
        }
        stackViewForTextfiels.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(16)
        }
        genderLabel.snp.makeConstraints { make in
            make.top.equalTo(stackViewForTextfiels.snp.bottom).inset(-16)
            make.left.equalToSuperview().inset(16)
        }
        genderSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(genderLabel.snp.bottom).inset(-14)
            make.horizontalEdges.equalToSuperview().inset(18)
        }
        stackViewForHeightWeight.snp.makeConstraints { make in
            make.top.equalTo(genderSegmentedControl.snp.bottom).inset(-16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        yourActivityLabel.snp.makeConstraints { make in
            make.top.equalTo(stackViewForHeightWeight.snp.bottom).inset(-16)
            make.left.equalToSuperview().inset(16)
        }
        activitySegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(yourActivityLabel.snp.bottom).inset(-14)
            make.horizontalEdges.equalToSuperview().inset(18)
        }
        deleteAccountButton.snp.makeConstraints { make in
            make.top.equalTo(activitySegmentedControl.snp.bottom).inset(-28)
            make.left.equalToSuperview().inset(16)
        }
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(contentview.safeAreaLayoutGuide).inset(16)
            make.top.greaterThanOrEqualTo(deleteAccountButton.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
}
