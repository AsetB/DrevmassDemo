//
//  ProfileViewController.swift
//  Drevmass
//
//  Created by Aset Bakirov on 04.03.2024.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import PanModal

class ProfileViewController: UIViewController {
    
    // - MARK: - IU elements
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
            view.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        return view
    }()
    
    var nameTitle: UILabel = {
        var label = UILabel()
        label.textColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        label.font = UIFont(name: "SFProDisplay-Bold", size: 28)
        return label
    }() 
    
    var numberTitle: UILabel = {
        var label = UILabel()
        label.textColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        label.font = UIFont(name: "SFProText-Semibold", size: 15)
        return label
    }()
    
     //    viewForBonus
    var viewForBonus: UIView = {
       var view = UIView()
        view.backgroundColor = UIColor(resource: ColorResource.Colors.CCB_995)
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        return view
    }()
    
    var myPointsButton: UIButton = {
       var button = UIButton()
        button.setTitle("Мои баллы", for: .normal)
        button.setTitleColor(UIColor(resource: ColorResource.Colors.FFFFFF), for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 15)
        button.addTarget(self, action: #selector(showMyPoints), for: .touchUpInside)
        return button
    }()
    
    var arrow: UIImageView = {
       var imageview = UIImageView()
        imageview.image = UIImage(resource: ImageResource.Profile.arrowInProfile)
        return imageview
    }()
    
    var patternTreeImageview: UIImageView = {
       var imageview = UIImageView()
        imageview.image = UIImage(resource: ImageResource.Profile.patternProfile)
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        return imageview
    }()
    
    var iconBonus: UIImageView = {
       var imageview = UIImageView()
        imageview.image = UIImage(resource: ImageResource.Profile.iconBonusProfile)
        imageview.contentMode = .scaleAspectFit
        imageview.clipsToBounds = true
        return imageview
    }()
    
    var pointsLabel: UILabel = {
       var label = UILabel()
        label.isSkeletonable = true
        label.skeletonTextLineHeight = .fixed(24)
        label.linesCornerRadius = 8
        label.textColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        label.font = UIFont(name: "SFProDisplay-Bold", size: 28)
        return label
    }()
    
     //    viewMain
    
    var viewMain: UIView = {
       var view = UIView()
        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    var promocodesButton: Button = {
       var button = Button()
        button.setTitle("Промокоды", for: .normal)
        button.layer.borderColor = UIColor(red: 0.95, green: 0.95, blue: 0.94, alpha: 1.00).cgColor
        button.addTarget(self, action: #selector(showPromoCodeViewController), for: .touchUpInside)
        button.leftIcon.image = UIImage(resource: ImageResource.Profile.iconPromocodeProfile)
        button.rightIcon.image = UIImage(resource: ImageResource.Profile.arrowBeigeProfile)
        return button
    }()

    //    StackviewForFirstThreeButtons
    
    var stackViewForFirstThreeButtons: UIStackView = {
       var stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = 1
        stackview.frame = CGRect(x: 0, y: 0, width: stackview.frame.width, height: 162)
        stackview.contentMode = .scaleAspectFill
        stackview.layer.borderWidth = 2
        stackview.layer.cornerRadius = 24
        stackview.layer.borderColor = UIColor(red: 0.95, green: 0.95, blue: 0.94, alpha: 1.00).cgColor
        stackview.layer.shouldRasterize = false
        return stackview
    }()
    
    var infoAboutMeButton: Button = {
       var button = Button()
        button.setTitle("Мои данные", for: .normal)
        button.heightAnchor.constraint(equalToConstant: 53).isActive = true
        button.layer.borderWidth = 0
        button.addTarget(self, action: #selector(showInfoAboutMeViewController), for: .touchUpInside)
        button.leftIcon.image = UIImage(resource: ImageResource.Profile.iconInfoProfile)
        button.rightIcon.image = UIImage(resource: ImageResource.Profile.arrowBeigeProfile)
        return button
    }() 
    
    var changePasswordButton: Button = {
       var button = Button()
        button.setTitle("Сменить пароль", for: .normal)
        button.heightAnchor.constraint(equalToConstant: 53).isActive = true
        button.layer.borderWidth = 0
        button.addTarget(self, action: #selector(showChangePasswordVC), for: .touchUpInside)
        button.leftIcon.image = UIImage(resource: ImageResource.Profile.iconChangePasswordProfile)
        button.rightIcon.image = UIImage(resource: ImageResource.Profile.arrowBeigeProfile)
        return button
    }()
    
    var notificationsButton: Button = {
       var button = Button()
        button.setTitle("Уведомления", for: .normal)
        button.heightAnchor.constraint(equalToConstant: 53).isActive = true
        button.layer.borderWidth = 0
        button.addTarget(self, action: #selector(showNotificationViewController), for: .touchUpInside)
        button.leftIcon.image = UIImage(resource: ImageResource.Profile.iconNotificationProfile)
        button.rightIcon.image = UIImage(resource: ImageResource.Profile.arrowBeigeProfile)

        return button
    }()
    
    //    StackviewForFirstThreeButtons
    
    var stackViewForSecondThreeButtons: UIStackView = {
       var stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = 1
        stackview.frame = CGRect(x: 0, y: 0, width: stackview.frame.width, height: 162)
        stackview.contentMode = .scaleAspectFill
        stackview.layer.borderWidth = 2
        stackview.layer.cornerRadius = 24
        stackview.layer.borderColor = UIColor(red: 0.95, green: 0.95, blue: 0.94, alpha: 1.00).cgColor
        stackview.layer.shouldRasterize = false
        return stackview
    }()
    
    var contactUSButton: Button = {
       var button = Button()
        button.setTitle("Связаться с нами", for: .normal)
        button.heightAnchor.constraint(equalToConstant: 53).isActive = true
        button.layer.borderWidth = 0
        button.addTarget(self, action: #selector(showContactUsViewController), for: .touchUpInside)
        button.leftIcon.image = UIImage(resource: ImageResource.Profile.iconConnectUsProfile)
        button.rightIcon.image = UIImage(resource: ImageResource.Profile.arrowBeigeProfile)

        return button
    }()
    
    var leaveFeedbackButton: Button = {
       var button = Button()
        button.setTitle("Оставить отзыв", for: .normal)
        button.heightAnchor.constraint(equalToConstant: 53).isActive = true
        button.layer.borderWidth = 0
        button.leftIcon.image = UIImage(resource: ImageResource.Profile.iconLeaveFeedbackProfile)
        button.rightIcon.image = UIImage(resource: ImageResource.Profile.arrowBeigeProfile)
        return button
    }()
    
    var infoButton: Button = {
       var button = Button()
        button.setTitle("Информация", for: .normal)
        button.heightAnchor.constraint(equalToConstant: 53).isActive = true
        button.layer.borderWidth = 0
        button.addTarget(self, action: #selector(showInformationAboutAppViewController), for: .touchUpInside)
        button.leftIcon.image = UIImage(resource: ImageResource.Profile.iconInfoBeigeProfile)
        button.rightIcon.image = UIImage(resource: ImageResource.Profile.arrowBeigeProfile)
        return button
    }()
    
    //    UIButton Exit
    
    var logoutButton: Button = {
       var button = Button()
        button.setTitle("Выйти", for: .normal)
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.layer.borderWidth = 0

        button.setTitleColor(UIColor(resource: ColorResource.Colors._787878), for: .normal)
        button.leftIcon.image = UIImage(resource: ImageResource.Profile.iconLogoutProfile)

        button.rightIcon.isHidden = true
        button.addTarget(self, action: #selector(logout), for: .touchUpInside)
        return button
    }()
    
    // - MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)

        setupView()
        setupConstraints()
        getProfileInfo()
        downlaodBonus()

        pointsLabel.showAnimatedSkeleton(usingColor: UIColor(resource: ColorResource.Colors.ffffffA40))

    }
    override func viewWillAppear(_ animated: Bool) {
        getProfileInfo()
    }
}

extension ProfileViewController {
    
    // - MARK: - other funcs
    
    @objc func showPromoCodeViewController(){
        let promoCodeVC = PromoCodeViewController()
        promoCodeVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(promoCodeVC, animated: true)
    } 
    @objc func showNotificationViewController(){
        let notificationVC = NotificationViewController()
        notificationVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(notificationVC, animated: true)
    }
    @objc func showInfoAboutMeViewController(){
        let infoAboutMeVC = InfoAboutMeViewController()
        infoAboutMeVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(infoAboutMeVC, animated: true)
    }
    
    @objc func showMyPoints() {
        let myPointsVC = MyBonusViewController()
        myPointsVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(myPointsVC, animated: true)
    } 
    
    @objc func showInformationAboutAppViewController() {
        let infoVc = InformationAboutAppViewController()
        infoVc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(infoVc, animated: true)
    } 
    
    @objc func showContactUsViewController() {
        let contactUsVc = ContactUsViewController()
        contactUsVc.hidesBottomBarWhenPushed = true
        contactUsVc.modalPresentationStyle = .overFullScreen
        var panModalHeight: PanModalHeight = .contentHeight(400)
        presentPanModal(contactUsVc)
    }
    
    @objc func showChangePasswordVC() {
        let changePasswordVC = ChangePasswordViewController()
        changePasswordVC.hidesBottomBarWhenPushed = true
        navigationController?.modalPresentationStyle = .overFullScreen
        present(changePasswordVC, animated: true)
    }

    @objc private func logout() {
        let refreshAlert = UIAlertController(title: "Вы действительно хотите выйти?", message: "", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Остаться", style: .default, handler: { (action: UIAlertAction!) in
        }))

        refreshAlert.addAction(UIAlertAction(title: "Выйти", style: .destructive, handler: { (action: UIAlertAction!) in
            AuthenticationService.shared.tokenClear()
            //тут прописать удаление данных пользователя если они хранятся в UserDefaults
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
            sceneDelegate.setRootViewController(SignInViewController())
        }))
        present(refreshAlert, animated: true, completion: nil)
        
    }

    
    // - MARK: - network
    
    func getProfileInfo(){
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
                
                self.nameTitle.text = json["name"].string
                self.numberTitle.text = json["phone_number"].string
                
            } else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR")
            }
        }
    }
    func downlaodBonus() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AuthenticationService.shared.token)"
        ]
        AF.request(URLs.GET_BONUS_URL, method: .get, headers: headers).responseData { response in
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }

            if response.response?.statusCode == 200{
            
                let json = JSON(response.data!)
                print("JSON: \(json)")
        
                DispatchQueue.main.async{
                    self.pointsLabel.hideSkeleton()
                    self.pointsLabel.text = String(json["bonus"].int ?? 0)
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
   
    
    
    // - MARK: - Setups
    func setupView() {
        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        view.addSubview(scrollView)
        scrollView.addSubview(contentview)
        contentview.addSubview(nameTitle)
        contentview.addSubview(numberTitle)
        contentview.addSubview(viewForBonus)
        viewForBonus.addSubview(patternTreeImageview)
        viewForBonus.addSubview(myPointsButton)
        viewForBonus.addSubview(arrow)
        viewForBonus.addSubview(iconBonus)
        viewForBonus.addSubview(pointsLabel)
        contentview.addSubview(viewMain)
        viewMain.addSubview(promocodesButton)
        viewMain.addSubview(stackViewForFirstThreeButtons)
        stackViewForFirstThreeButtons.addArrangedSubview(infoAboutMeButton)
        stackViewForFirstThreeButtons.addArrangedSubview(changePasswordButton)
        stackViewForFirstThreeButtons.addArrangedSubview(notificationsButton)
        viewMain.addSubview(stackViewForSecondThreeButtons)
        stackViewForSecondThreeButtons.addArrangedSubview(contactUSButton)
        stackViewForSecondThreeButtons.addArrangedSubview(leaveFeedbackButton)
        stackViewForSecondThreeButtons.addArrangedSubview(infoButton)
        viewMain.addSubview(logoutButton)
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        contentview.snp.makeConstraints { make in
            make.horizontalEdges.top.bottom.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        nameTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(92)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        numberTitle.snp.makeConstraints { make in
            make.top.equalTo(nameTitle.snp.bottom).inset(-2)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        viewForBonus.snp.makeConstraints { make in
            make.top.equalTo(numberTitle.snp.bottom).inset(-16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(114)
        }
        patternTreeImageview.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.left.equalTo(arrow.snp.right).inset(-5)
        }
        myPointsButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.left.equalToSuperview().inset(24)
        }
        arrow.snp.makeConstraints { make in
            make.centerY.equalTo(myPointsButton)
            make.height.width.equalTo(12)
            make.left.equalTo(myPointsButton.snp.right).inset(-4)
        }
        iconBonus.snp.makeConstraints { make in
            make.top.equalTo(myPointsButton.snp.bottom).inset(-9)
            make.left.equalToSuperview().inset(24)
            make.height.width.equalTo(32)
        }
        pointsLabel.snp.makeConstraints { make in
            make.top.equalTo(myPointsButton.snp.bottom).inset(-8)
            make.left.equalTo(iconBonus.snp.right).inset(-9)
            make.right.equalToSuperview().inset(24)
        }
        viewMain.snp.makeConstraints { make in
            make.top.equalTo(viewForBonus.snp.bottom).inset(-24)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        promocodesButton.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(64)
        }
        stackViewForFirstThreeButtons.snp.makeConstraints { make in
            make.top.equalTo(promocodesButton.snp.bottom).inset(-8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        stackViewForSecondThreeButtons.snp.makeConstraints { make in
            make.top.equalTo(stackViewForFirstThreeButtons.snp.bottom).inset(-8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(stackViewForSecondThreeButtons.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(32)
        }
    }
}
