//
//  PromoCodeViewController.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 07.03.2024.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class PromoCodeViewController: UIViewController {
    
    // - MARK: - Ui elements

    var viewForPromocode: UIView = {
      var view = UIView()
        view.backgroundColor = UIColor(resource: ColorResource.Colors._765657) 
        view.layer.cornerRadius = 24
        return view
    }()
    
    var titleLabel: UILabel = {
       var label = UILabel()
        label.text = "Промокод для друга"
        label.textColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        label.font = .addFont(type: .SFProTextBold, size: 20)
        return label
    }()
    
    var subtitleLabel: UILabel = {
       var label = UILabel()
        label.textColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        label.font = .addFont(type: .SFProTextRegular, size: 15)
        label.numberOfLines = 2
        return label
    }()
    
    var codeLabel: UILabel = {
       var label = UILabel()
        label.text = "JD58KA6H"
        label.textColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        label.font = .addFont(type: .SFProDisplayBold, size: 22)
        label.textAlignment = .center
        return label
    }()
    
    var dashedLineView: DashedLineView = {
       var view = DashedLineView()
        view.backgroundColor = .clear
        view.dashColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        view.spaceBetweenDash = 8
        view.perDashLength = 8
        return view
    }()
    
    var stackView: UIStackView = {
       var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        return stackView
    }()
    
    var shareButton: UIButton = {
       var button = UIButton()
        button.setTitle("Поделиться", for: .normal)
        button.setTitleColor(UIColor(resource: ColorResource.Colors.FFFFFF), for: .normal)
        button.titleLabel?.font = .addFont(type: .SFProTextSemiBold, size: 15)
        button.setImage(UIImage(resource: ImageResource.Profile.iconShare), for: .normal)
        button.contentHorizontalAlignment = .left
        button.layer.borderWidth = 0
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.contentEdgeInsets.left = 0
        button.titleEdgeInsets.left = 10
        button.addTarget(self, action: #selector(share), for: .touchUpInside)
        return button
    }()
    var copyButton: UIButton = {
       var button = UIButton()
        button.setTitle("Скопировать", for: .normal)
        button.setTitleColor(UIColor(resource: ColorResource.Colors.FFFFFF), for: .normal)
        button.titleLabel?.font = .addFont(type: .SFProTextSemiBold, size: 15)
        button.setImage(UIImage(resource: ImageResource.Profile.iconCopy), for: .normal)
        button.titleLabel?.textAlignment = .left
        button.layer.borderWidth = 0
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.addTarget(self, action: #selector(copyText), for: .touchUpInside)
        button.imageEdgeInsets.left = -10
        return button
    }()
    
    var existPromoButton: UIButton = {
       var button = UIButton()
        button.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        button.setTitle("У меня есть промокод", for: .normal)
        button.layer.cornerRadius = 28
        button.addTarget(self, action: #selector(showAddPromocodeVC), for: .touchUpInside)
        button.titleLabel?.font = .addFont(type: .SFProTextSemiBold, size: 17)
        return button
    }()
    
    var viewForShare: UIView = {
       var view = UIView()
        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF_A_10)
        view.layer.cornerRadius = 12
        return view
    }()
    
    var shareTitle: UILabel = {
       var label = UILabel()
        label.text = "Вы поделились"
        label.textColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        label.font = .addFont(type: .SFProTextRegular, size: 15)
        return label
    }()
    
    var sharedLabel: UILabel = {
       var label = UILabel()
        label.text = "5"
        label.font = .addFont(type: .SFProTextSemiBold, size: 17)
        label.textColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        return label
    }()
    
     var shareCountLabel: UILabel = {
       var label = UILabel()
        label.text = "/6"
         label.font = .addFont(type: .SFProTextSemiBold, size: 17)
         label.textColor = UIColor(resource: ColorResource.Colors.ffffffA60)
        return label
    }()
    
    var viewForCondition: UIView = {
       var view = UIView()
        view.backgroundColor = UIColor(resource: ColorResource.Colors.EFEBE_9)
        view.layer.cornerRadius = 20
        return view
    }()
    
    var conditiontLabel: UILabel = {
      var label = UILabel()
       label.text = "*начислим вам 500 бонусов при условии покупки массажера вашим другом"
        label.numberOfLines = 2
        label.font = .addFont(type: .SFProTextRegular, size: 13)
        label.textColor = UIColor(resource: ColorResource.Colors._787878)
       return label
   }()
   
    
    var notificationView = NotificationView()

    // - MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()
        setupNavigationBar()
        getPromocodeInfo()
    }
}


extension PromoCodeViewController {
    
    // - MARK: - network
    
    func getPromocodeInfo() {
        
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AuthenticationService.shared.token)"
        ]
        AF.request(URLs.GET_PROMOCODE_INFO_URL, method: .get, headers: headers).responseData { response in
         SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            if response.response?.statusCode == 200{
                
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if json.exists(){
                    self.subtitleLabel.text = "Промокод \(json["bonus"].int!) бонусов на покупку массажера для двух друзей!"
                    self.codeLabel.text = json["promocode"].string
                    self.sharedLabel.text = "\(json["used"].int!)"
                    self.shareCountLabel.text = "/\(json["all_attempt"].int!)"
                }
                self.checkSharedCount()
            } else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR")
            }
        }
    }
    
    // - MARK: - other funcs
    
    func checkSharedCount() {
        
        if sharedLabel.text == "2" {
            codeLabel.textColor = UIColor(resource: ColorResource.Colors.ffffffA60)
            shareButton.setTitleColor(UIColor(resource: ColorResource.Colors.ffffffA60), for: .normal)
            shareButton.setImage(UIImage(resource: ImageResource.Profile.icShareFFFFFF60), for: .normal)
            shareButton.isUserInteractionEnabled = false
            copyButton.setTitleColor(UIColor(resource: ColorResource.Colors.ffffffA60), for: .normal)
            copyButton.setImage(UIImage(resource: ImageResource.Profile.icCopyFFFFFF60), for: .normal)
            copyButton.isUserInteractionEnabled = false
            dashedLineView.dashColor = UIColor(resource: ColorResource.Colors.ffffffA60)
            
        }
        
    }
    
    @objc func showAddPromocodeVC() {
        let promocodeBasketVC = PromocodeBasketViewController()
        promocodeBasketVC.modalPresentationStyle = .overFullScreen
        presentPanModal(promocodeBasketVC)
    }
    
    @objc func copyText() {
        UIPasteboard.general.string = codeLabel.text
        self.notificationView.show(viewController: self, notificationType: .success)
        self.notificationView.titleLabel.text = "Промокод успешно скопирован"
    }
    
    @objc func share() {
        let text = codeLabel.text
        
        let shareAll = [text] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        // вспылающее окно где можно отправить либо скопировать и тд
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func showInfoVC() {
         let infoVc = InformationViewController()
        navigationController?.modalPresentationStyle = .overFullScreen
        present(infoVc, animated: true)
     }
     @objc func dismissView() {
         navigationController?.popViewController(animated: true)
     }
    
    // - MARK: - Setups
    
    func setupNavigationBar(){
        navigationItem.title = "Промокоды"
        let rightBarButton = UIBarButtonItem(image: UIImage(resource: ImageResource.Profile.iconInfoBeigeProfile), style: .plain, target: self, action: #selector(showInfoVC))
        navigationItem.setRightBarButton(rightBarButton, animated: true)
        rightBarButton.tintColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(resource: ImageResource.Profile.iconBack), style: .done, target: self, action: #selector(dismissView))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
    }
    
    func setupView() {
        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        view.addSubview(viewForPromocode)
        viewForPromocode.addSubview(titleLabel)
        viewForPromocode.addSubview(subtitleLabel)
        viewForPromocode.addSubview(codeLabel)
        viewForPromocode.addSubview(dashedLineView)
        viewForPromocode.addSubview(stackView)
        stackView.addArrangedSubview(shareButton)
        stackView.addArrangedSubview(copyButton)
        viewForPromocode.addSubview(viewForShare)
        viewForShare.addSubview(shareTitle)
        viewForShare.addSubview(sharedLabel)
        viewForShare.addSubview(shareCountLabel)
        view.addSubview(viewForCondition)
        viewForCondition.addSubview(conditiontLabel)
        view.addSubview(existPromoButton)
    }
    
    func setupConstraints() {
        viewForPromocode.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(270)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-4)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        codeLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).inset(-16)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        dashedLineView.snp.makeConstraints { make in
            make.height.equalTo(3)
            make.top.equalTo(codeLabel.snp.bottom).inset(-8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(dashedLineView.snp.bottom).inset(-16)
        }
        viewForShare.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).inset(-16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(46)
        }
        shareTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(16)
        }
        sharedLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(shareCountLabel.snp.left)
        }
        shareCountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
        }
        viewForCondition.snp.makeConstraints { make in
            make.top.equalTo(viewForPromocode.snp.bottom).inset(-12)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
        conditiontLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        existPromoButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }
    }
}
