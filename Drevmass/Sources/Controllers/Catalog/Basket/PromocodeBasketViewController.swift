//
//  PromocodeBasketViewController.swift
//  Drevmass
//
//  Created by Aset Bakirov on 27.03.2024.
//

import UIKit
import SnapKit
import PanModal
import Alamofire
import SwiftyJSON

class PromocodeBasketViewController: UIViewController, PanModalPresentable {
    //- MARK: - Variables
    //- MARK: - Local outlets
    private lazy var promoTextfield: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        let placeholderText = "Введите промокод"
        textfield.defaultTextAttributes = [NSAttributedString.Key.font : UIFont.addFont(type: .SFProDisplaySemibold, size: 20), NSAttributedString.Key.foregroundColor : UIColor(resource: ColorResource.Colors._181715)]
        textfield.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.font : UIFont.addFont(type: .SFProDisplaySemibold, size: 20), NSAttributedString.Key.foregroundColor : UIColor(resource: ColorResource.Colors.A_1_A_1_A_1)])
        textfield.setIcon(UIImage(resource: ImageResource.Basket.promocode))
        textfield.borderStyle = .none
        textfield.addTarget(self, action: #selector(promocodeEditDidBegin), for: .allEditingEvents)
        textfield.autocapitalizationType = .allCharacters
        return textfield
    }()
    
    private lazy var dashedLineView: DashedLineView = {
        var view = DashedLineView()
        view.dashColor = UIColor(resource: ColorResource.Colors.D_6_D_1_CE)
        view.backgroundColor = .clear
        view.spaceBetweenDash = 6
        view.perDashLength = 5
        return view
    }()
    
    private lazy var emptyErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите промокод"
        label.font = .addFont(type: .SFProTextMedium, size: 13)
        label.textColor = UIColor(resource: ColorResource.Colors.FA_5_C_5_C)
        return label
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Неверный промокод"
        label.font = .addFont(type: .SFProTextMedium, size: 13)
        label.textColor = UIColor(resource: ColorResource.Colors.FA_5_C_5_C)
        return label
    }()
    
    lazy var applyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Применить", for: .normal)
        button.setTitle("", for: .disabled)
        button.setTitleColor(UIColor(resource: ColorResource.Colors.FFFFFF), for: .normal)
        button.titleLabel?.font = .addFont(type: .SFProTextSemiBold, size: 15)
        button.layer.cornerRadius = 24
        button.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        button.addTarget(self, action: #selector(sendPromocode), for: .touchUpInside)
        return button
    }()
    private var activityIndicator = MyActivityIndicator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    private var notificationView = NotificationView()
    //- MARK: - Pan Modal setup
    var panScrollable: UIScrollView? {
        return nil
    }
    let keybHeight = UserDefaults.standard.value(forKey: "keyboardHeight") as? CGFloat
    var longFormHeight: PanModalHeight {
        return .contentHeight(150 + (keybHeight ?? 0))
    }
    
    var panModalBackgroundColor: UIColor {
        return UIColor(resource: ColorResource.Colors._302C28A65)
    }
    var cornerRadius: CGFloat {
        return 24
    }
    var dragIndicatorBackgroundColor: UIColor {
        return UIColor(resource: ColorResource.Colors.E_0_DEDD)
    }
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        errorLabel.isHidden = true
        emptyErrorLabel.isHidden = true
        notificationView.alpha = 0
        addViews()
        setIndicator()
        setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        promoTextfield.becomeFirstResponder()
    }
    
    //- MARK: - Add & set Views
    private func addViews() {
        view.addSubview(promoTextfield)
        view.addSubview(dashedLineView)
        view.addSubview(applyButton)
        view.addSubview(errorLabel)
        view.addSubview(emptyErrorLabel)
    }
    private func setIndicator() {
        activityIndicator.image = UIImage(resource: ImageResource.Registration.loading24)
        applyButton.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(applyButton.snp.center)
        }
        activityIndicator.isHidden = true
    }
    //- MARK: - Set Constraints
    private func setConstraints() {
        promoTextfield.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        dashedLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(promoTextfield.snp.bottom)
            make.horizontalEdges.equalTo(promoTextfield.snp.horizontalEdges)
        }
        applyButton.snp.makeConstraints { make in
            make.top.equalTo(dashedLineView.snp.bottom).offset(31.5)
            make.horizontalEdges.equalTo(dashedLineView.snp.horizontalEdges)
            make.height.equalTo(48)
        }
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(dashedLineView.snp.bottom).offset(4)
            make.leading.equalTo(dashedLineView.snp.leading)
            make.height.equalTo(18)
        }
        emptyErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(dashedLineView.snp.bottom).offset(4)
            make.leading.equalTo(dashedLineView.snp.leading)
            make.height.equalTo(18)
        }
    }
    //- MARK: - Set Errors
    private func showRedError() {
        errorLabel.isHidden = false
        promoTextfield.setIcon(UIImage(resource: ImageResource.Basket.promocodeRed))
        dashedLineView.updateDashColor(UIColor(resource: ColorResource.Colors.FA_5_C_5_C))
    }
    
    private func hideRedError() {
        errorLabel.isHidden = true
        emptyErrorLabel.isHidden = true
        promoTextfield.setIcon(UIImage(resource: ImageResource.Basket.promocode))
        dashedLineView.updateDashColor(UIColor(resource: ColorResource.Colors.D_6_D_1_CE))
    }
    //- MARK: - Button actions
    @objc func promocodeEditDidBegin() {
        hideRedError()
    }
    @objc func sendPromocode() {
        guard let promocode = promoTextfield.text else {
            return
        }
        
        if promocode.isEmpty {
            emptyErrorLabel.isHidden = false
            promoTextfield.setIcon(UIImage(resource: ImageResource.Basket.promocodeRed))
            dashedLineView.updateDashColor(UIColor(resource: ColorResource.Colors.FA_5_C_5_C))
            return
        }
        let headers: HTTPHeaders = ["Authorization": "Bearer \(AuthenticationService.shared.token)"]
        let parameters = ["promocode": promocode]
        
        applyButton.isEnabled = false
        activityIndicator.startAnimating()
        
        AF.upload(multipartFormData: {(multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append(Data(value.utf8), withName: key)
            }
        }, to: URLs.ACTIVATE_PROMOCODE, method: .post, headers: headers).responseDecodable(of: Data.self) { response in
            
            self.activityIndicator.stopAnimating()
            self.applyButton.isEnabled = true
            guard let responseCode = response.response?.statusCode else {
                self.showAlertMessage(title: "Ошибка соединения", message: "Проверьте подключение")
                return
            }
            if responseCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                self.notificationView.show(viewController: self, notificationType: .success)
                self.notificationView.titleLabel.text = "Промокод успешно применен"
//                self.showAlertMessage(title: "Success promocode", message: "Success promocode")
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            } else {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                self.showRedError()
            }
        }
    }
}
