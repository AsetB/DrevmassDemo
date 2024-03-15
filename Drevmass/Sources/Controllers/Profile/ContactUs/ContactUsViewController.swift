//
//  ContactUsViewController.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 12.03.2024.
//

import UIKit
import PanModal
import SVProgressHUD
import Alamofire
import SwiftyJSON

class ContactUsViewController: UIViewController, PanModalPresentable {
     
    var contact = Contact()
    
    var panScrollable: UIScrollView?
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(317)
    }

    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(40)
    }
    var panModalBackgroundColor: UIColor {
        return UIColor(resource: ColorResource.Colors._302C28A65)
    }
    var cornerRadius: CGFloat {
        return 24
    }
    var dragIndicatorBackgroundColor: UIColor {
        return UIColor(resource: ColorResource.Colors.FFFFFF)
    }
    
    //    MARK: - UI element
    
    var titlLabel : UILabel = {
       var label = UILabel()
        label.text = "Связаться с нами"
        label.font = .addFont(type: .SFProTextSemiBold, size: 20)
        label.textColor = UIColor(resource: ColorResource.Colors._302_C_28) 
        return label
    }()
    
    var stackView: UIStackView = {
       var stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = 8
        return stackview
    }()
    
    var callButton: Button = {
       var button = Button()
        button.setTitle("Позвонить", for: .normal)
        button.leftIcon.image = UIImage(resource: ImageResource.Profile.iconPhone24)
        button.rightIcon.isHidden = true
        button.heightAnchor.constraint(equalToConstant: 64).isActive = true
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(red: 0.94, green: 0.92, blue: 0.91, alpha: 1.00).cgColor
        button.addTarget(self, action: #selector(showNumber), for: .touchUpInside)
        return button
    }()   
    
    var supportButton: Button = {
        var button = Button()
         button.setTitle("Служба поддержки", for: .normal)
         button.leftIcon.image = UIImage(resource: ImageResource.Profile.iconMessage24)
         button.rightIcon.isHidden = true
         button.heightAnchor.constraint(equalToConstant: 64).isActive = true
         button.layer.borderWidth = 2
         button.layer.borderColor = UIColor(red: 0.94, green: 0.92, blue: 0.91, alpha: 1.00).cgColor
         button.addTarget(self, action: #selector(supportVC), for: .touchUpInside)
         return button
    }()
    
    var whatsappButton: Button = {
        var button = Button()
         button.setTitle("WhatsApp", for: .normal)
         button.leftIcon.image = UIImage(resource: ImageResource.Profile.icWhatsapp)
         button.rightIcon.isHidden = true
         button.heightAnchor.constraint(equalToConstant: 64).isActive = true
         button.layer.borderWidth = 2
         button.layer.borderColor = UIColor(red: 0.94, green: 0.92, blue: 0.91, alpha: 1.00).cgColor
         button.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(showWhatsapp), for: .touchUpInside)
         return button
    }()

    //    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()
        getContact()
    }

}

extension ContactUsViewController {
    
    //    MARK: - network
    
    func getContact(){
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AuthenticationService.shared.token)"
        ]
        AF.request(URLs.USER_INFO_URL, method: .get, headers: headers).responseData { response in
         SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            if response.response?.statusCode == 200{
                
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                self.contact = Contact(json: json)
                
            } else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR")
            }
        }
    }
    
    //    MARK: - other funcs
    
    @objc func supportVC() {
        var supportVC = SupportViewController()
        navigationController?.modalPresentationStyle = .overFullScreen
        supportVC.hidesBottomBarWhenPushed = true
        present(supportVC, animated: true)
    } 
    
    @objc func showNumber() {
        if let url = URL(string: "tel: \(contact.number)") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func showWhatsapp() {
        if let url = URL(string: "https://wa.me/\(contact.whatsapp)") {
            UIApplication.shared.open(url)
        }
    }
    
    //    MARK: - setups
    func setupView() {
        
        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
//        view.layer.cornerRadius = 24
//        view.layer.masksToBounds = true
        view.addSubview(titlLabel)
        view.addSubview(stackView)
        stackView.addArrangedSubview(callButton)
        stackView.addArrangedSubview(supportButton)
        stackView.addArrangedSubview(whatsappButton)
        
    }
    
    func setupConstraints() {
        titlLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(24)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titlLabel.snp.bottom).inset(-24)
            make.horizontalEdges.equalToSuperview().inset(24)
            
        }
    }
  
}
