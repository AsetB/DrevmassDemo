//
//  SupportViewController.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 12.03.2024.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import Alamofire
import SnapKit

class SupportViewController: UIViewController {
    
    var sentButtonBottomConstraint: Constraint?
    
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
        button.setImage(UIImage(resource: ImageResource.Profile.iconBack), for: .normal)
        button.tintColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()
    
    var textViewForText: UITextView = {
       var textview = UITextView()
        textview.textAlignment = .left
        textview.textColor = UIColor(resource: ColorResource.Colors._181715) 
        textview.font = .addFont(type: .SFProTextRegular, size: 17)
        textview.tintColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        textview.textContainerInset = UIEdgeInsets(top: 0, left: 16, bottom: 30, right: 16)
        return textview
    }()
    
    var placeholderLabel: UILabel = {
       var label = UILabel()
       label.text = "Опишите проблему"
       label.textColor = UIColor(resource: ColorResource.Colors.A_1_A_1_A_1)
       label.font = .addFont(type: .SFProTextRegular, size: 17)
        return label
    }()
    
    var sentButton: UIButton = {
        var button = UIButton()
        button.setTitle("Отправить", for: .normal)
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(sentMessage), for: .touchUpInside)
        button.titleLabel?.font = .addFont(type: .SFProTextSemiBold, size: 15)
        button.isEnabled = false
        button.backgroundColor = UIColor(resource: ColorResource.Colors.D_3_C_8_B_3)
        return button
    }()
    
    var notificationView = NotificationView()
    
    // - MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()
        
        textViewForText.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension SupportViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        editingChange()
     }
     func textViewDidEndEditing(_ textView: UITextView) {
         placeholderLabel.isHidden = !textView.text.isEmpty
         editingChange()
     }
     func textViewDidBeginEditing(_ textView: UITextView) {
         placeholderLabel.isHidden = true
         editingChange()
     }
   
}

extension SupportViewController {
    
    // - MARK: - network
    
    @objc func sentMessage(){
        SVProgressHUD.show()
        
        let message = textViewForText.text
        let parameteres = ["message": message]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AuthenticationService.shared.token)"
        ]
        AF.request(URLs.POST_SUPPORT_URL, method: .post, parameters: parameteres, encoding: JSONEncoding.default, headers: headers).responseData { response in
            
         SVProgressHUD.dismiss()
            
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            if response.response?.statusCode == 200{
                
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                self.notificationView.show(viewController: self, notificationType: .success)
                self.notificationView.titleLabel.text = "Сообщение отправлено"
                self.dismissView()
                
            } else {
                let json = JSON(response.data!)
                let error = json["code"].stringValue
                self.notificationView.show(viewController: self, notificationType: .attantion)
                self.notificationView.titleLabel.text = error
            }
        }
       
    }
        
    // - MARK: - other funcs
    
    @objc func dismissView() {
        dismiss(animated: true)
    }
    
    func editingChange() {
        if !textViewForText.hasText {
            sentButton.isEnabled = false
            sentButton.backgroundColor = UIColor(resource: ColorResource.Colors.D_3_C_8_B_3)
        }else{
            sentButton.isEnabled = true
            sentButton.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        }
    }
   
//    func backToProfile() {
//        let profileVC = ProfileViewController()
////        dismissView()
//        self.navigationController?.popToViewController(profileVC, animated: true)
//    }
    @objc private func keyboardWillShow(notification: NSNotification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
               sentButtonBottomConstraint?.update(inset: -16 + keyboardSize.height)
            }
        }
    @objc private func keyboardWillHide(notification: NSNotification) {
        sentButtonBottomConstraint?.update(inset: 16)
    }
    
   
    // - MARK: - setups

    func setupView() {
        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        view.addSubview(titleLabel)
        view.addSubview(leftButton)
        view.addSubview(textViewForText)
        textViewForText.addSubview(placeholderLabel)
        view.addSubview(sentButton)
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
        textViewForText.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-11)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(sentButton.snp.top).inset(10)
        }
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(16)
        }
        sentButton.snp.makeConstraints { make in
            self.sentButtonBottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16).constraint
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
}
