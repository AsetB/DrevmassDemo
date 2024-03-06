//
//  ProfileViewController.swift
//  Drevmass
//
//  Created by Aset Bakirov on 04.03.2024.
//

import UIKit
import SnapKit

            // ДОБАВИТЬ ЗАПРОС В СЕТЬ И УСТАНОВИТЬ ЗНАЧЕНИЯ ЛЭЙБЛАМ !!!!!

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
            view.backgroundColor = .Colors.B_5_A_380
        return view
    }()
    
    var nameTitle: UILabel = {
        var label = UILabel()
        label.textColor = .Colors.FFFFFF
        label.font = UIFont(name: "SFProDisplay-Bold", size: 28)
        label.text = "Катерина"
        return label
    }() 
    
    var numberTitle: UILabel = {
        var label = UILabel()
        label.textColor = .Colors.FFFFFF
        label.font = UIFont(name: "SFProText-Semibold", size: 15)
        label.text = "+7 905 666 69 96"
        return label
    }()
    
     //    viewForBonus
    var viewForBonus: UIView = {
       var view = UIView()
        view.backgroundColor = .Colors.CCB_995
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        return view
    }()
    
    var myPointsButton: UIButton = {
       var button = UIButton()
        button.setTitle("Мои баллы", for: .normal)
        button.setTitleColor(.Colors.FFFFFF, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 15)
        button.addTarget(self, action: #selector(showMyPoints), for: .touchUpInside)
        return button
    }()
    
    var arrow: UIImageView = {
       var imageview = UIImageView()
        imageview.image = .Profile.arrowInProfile
        return imageview
    }()
    
    var patternTreeImageview: UIImageView = {
       var imageview = UIImageView()
        imageview.image = .Profile.patternProfile
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        return imageview
    }()
    
    var iconBonus: UIImageView = {
       var imageview = UIImageView()
        imageview.image = .Profile.iconBonusProfile
        imageview.contentMode = .scaleAspectFit
        imageview.clipsToBounds = true
        return imageview
    }()
    
    var pointsLabel: UILabel = {
       var label = UILabel()
        label.textColor = .Colors.FFFFFF
        label.font = UIFont(name: "SFProDisplay-Bold", size: 28)
        label.text = "500"
        return label
    }()
    
     //    viewMain
    
    var viewMain: UIView = {
       var view = UIView()
        view.backgroundColor = .Colors.FFFFFF
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    var promocodesButton: Button = {
       var button = Button()
        button.setTitle("Промокоды", for: .normal)
        button.layer.borderColor = UIColor(red: 0.95, green: 0.95, blue: 0.94, alpha: 1.00).cgColor
        button.leftIcon.image = .Profile.iconPromocodeProfile
        button.rightIcon.image = .Profile.arrowBeigeProfile
    
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
    
    var myInfoButton: Button = {
       var button = Button()
        button.setTitle("Мои данные", for: .normal)
        button.heightAnchor.constraint(equalToConstant: 53).isActive = true
        button.layer.borderWidth = 0
        button.leftIcon.image = .Profile.iconInfoProfile
        button.rightIcon.image = .Profile.arrowBeigeProfile
        return button
    }() 
    
    var changePasswordButton: Button = {
       var button = Button()
        button.setTitle("Сменить пароль", for: .normal)
        button.heightAnchor.constraint(equalToConstant: 53).isActive = true
        button.layer.borderWidth = 0
        button.leftIcon.image = .Profile.iconChangePasswordProfile
        button.rightIcon.image = .Profile.arrowBeigeProfile
        return button
    }()
    
    var notificationsButton: Button = {
       var button = Button()
        button.setTitle("Уведомления", for: .normal)
        button.heightAnchor.constraint(equalToConstant: 53).isActive = true
        button.layer.borderWidth = 0
        button.leftIcon.image = .Profile.iconNotificationProfile
        button.rightIcon.image = .Profile.arrowBeigeProfile
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
    
    var connectUSButton: Button = {
       var button = Button()
        button.setTitle("Связаться с нами", for: .normal)
        button.heightAnchor.constraint(equalToConstant: 53).isActive = true
        button.layer.borderWidth = 0
        button.leftIcon.image = .Profile.iconConnectUsProfile
        button.rightIcon.image = .Profile.arrowBeigeProfile
        return button
    }()
    
    var leaveFeedbackButton: Button = {
       var button = Button()
        button.setTitle("Оставить отзыв", for: .normal)
        button.heightAnchor.constraint(equalToConstant: 53).isActive = true
        button.layer.borderWidth = 0
        button.leftIcon.image = .Profile.iconLeaveFeedbackProfile
        button.rightIcon.image = .Profile.arrowBeigeProfile
        return button
    }()
    
    var infoButton: Button = {
       var button = Button()
        button.setTitle("Информация", for: .normal)
        button.heightAnchor.constraint(equalToConstant: 53).isActive = true
        button.layer.borderWidth = 0
        button.leftIcon.image = .Profile.iconInfoBeigeProfile
        button.rightIcon.image = .Profile.arrowBeigeProfile
        return button
    }()
    
    //    UIButton Exit
    
    var logoutButton: Button = {
       var button = Button()
        button.setTitle("Выйти", for: .normal)
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.layer.borderWidth = 0
        button.setTitleColor(.Colors._787878, for: .normal)
        button.leftIcon.image = .Profile.iconLogoutProfile
        button.rightIcon.isHidden = true
        return button
    }()
    
    // - MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
    }
}

extension ProfileViewController {
    // - MARK: - functions
    @objc func showMyPoints() {
        let myPointsVC = MyBonusViewController()
        myPointsVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(myPointsVC, animated: true)
    }
    
    
    // - MARK: - setupView
    func setupView() {
        view.backgroundColor = .Colors.FFFFFF
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
        stackViewForFirstThreeButtons.addArrangedSubview(myInfoButton)
        stackViewForFirstThreeButtons.addArrangedSubview(changePasswordButton)
        stackViewForFirstThreeButtons.addArrangedSubview(notificationsButton)
        viewMain.addSubview(stackViewForSecondThreeButtons)
        stackViewForSecondThreeButtons.addArrangedSubview(connectUSButton)
        stackViewForSecondThreeButtons.addArrangedSubview(leaveFeedbackButton)
        stackViewForSecondThreeButtons.addArrangedSubview(infoButton)
        viewMain.addSubview(logoutButton)
    }
    
    // - MARK: - setupConstraints
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
            make.top.equalToSuperview().inset(24)
            make.left.equalToSuperview().inset(24)
        }
        arrow.snp.makeConstraints { make in
            make.centerY.equalTo(myPointsButton)
            make.height.width.equalTo(12)
            make.left.equalTo(myPointsButton.snp.right).inset(-4)
        }
        iconBonus.snp.makeConstraints { make in
            make.top.equalTo(myPointsButton.snp.bottom).inset(-13)
            make.left.equalToSuperview().inset(24)
            make.height.width.equalTo(32)
        }
        pointsLabel.snp.makeConstraints { make in
            make.top.equalTo(myPointsButton.snp.bottom).inset(-12)
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
