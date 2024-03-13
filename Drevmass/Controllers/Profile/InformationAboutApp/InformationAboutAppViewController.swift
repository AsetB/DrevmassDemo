//
//  InformationAboutAppViewController.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 12.03.2024.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class InformationAboutAppViewController: UIViewController {
    
    var social = Social()
    // - MARK: - UI elements
    
    var aboutCompanyButton: UIButton = {
       var button = UIButton()
        button.setTitle("О компании", for: .normal)
        button.setTitleColor(UIColor(resource: ColorResource.Colors._181715) , for: .normal)
        button.titleLabel?.font = .addFont(type: .SFProTextSemiBold, size: 17)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(showAboutCompanyViewController), for: .touchUpInside)
        return button
    }()
    
    var arrowForCompanyButton: UIButton = {
       var button = UIButton()
        button.setImage(.Profile.arrowBeigeProfile, for: .normal)
        button.addTarget(self, action: #selector(showAboutCompanyViewController), for: .touchUpInside)
        return button
    }()
    
    var viewUnderCompany: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(resource: ColorResource.Colors.E_0_DEDD) 
        return view
    }()   
    
    var aboutAppButton: UIButton = {
       var button = UIButton()
        button.setTitle("О приложении", for: .normal)
        button.setTitleColor(UIColor(resource: ColorResource.Colors._181715) , for: .normal)
        button.titleLabel?.font = .addFont(type: .SFProTextSemiBold, size: 17)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(showAboutAppViewController), for: .touchUpInside)
        return button
    }()
    
    var arrowForAppButton: UIButton = {
       var button = UIButton()
        button.setImage(.Profile.arrowBeigeProfile, for: .normal)
        return button
    }()
    
    var viewUnderApp: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(resource: ColorResource.Colors.E_0_DEDD) 
        return view
    }()
    
    var YouTubeButton: UIButton = {
       var button = UIButton()
        button.setImage(.Profile.iconYouTube, for: .normal)
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.frame.size = CGSize(width: 64, height: 64)
        button.addTarget(self, action: #selector(showYouTube), for: .touchUpInside)
        return button
    }() 
    
    var VKButton: UIButton = {
       var button = UIButton()
        button.setImage(.Profile.iconVK, for: .normal)
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.frame.size = CGSize(width: 64, height: 64)
        button.addTarget(self, action: #selector(showVK), for: .touchUpInside)
        return button
    }()
    
    var StackViewForYoutubeVk: UIStackView = {
       var stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.spacing = 16
        return stackview
    }()
    
    var titleLabel: UILabel = {
       var label = UILabel()
        label.text = "Мы в соцсетях:"
        label.textColor = UIColor(resource: ColorResource.Colors._787878)
        label.font = .addFont(type: .SFProTextRegular, size: 15)
        return label
    }()
    
    
    // - MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()
        setupNavigationBar()
        getSocial()
    }
    
}

extension InformationAboutAppViewController {
    
    // - MARK: - network
    
    func getSocial(){
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AuthenticationService.shared.token)"
        ]
        AF.request(URLs.SOCIAL_URL, method: .get, headers: headers).responseData { response in
         SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            if response.response?.statusCode == 200{
                
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                self.social = Social(json: json)
                
            } else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR")
            }
        }
    }
    
    // - MARK: - other funcs
    
    @objc func dismissView() {
        navigationController?.popViewController(animated: true)
    } 
    
    @objc func showVK() {
        guard let url = URL(string: social.vk) else { return }
        UIApplication.shared.open(url)
    }   
    
    @objc func showYouTube() {
        guard let url = URL(string: social.youtube) else { return }
        UIApplication.shared.open(url)
    }
    
    @objc func showAboutCompanyViewController() {
        var aboutCompanyVC = AboutCompanyViewController()
        aboutCompanyVC.hidesBottomBarWhenPushed = true
        navigationController?.modalPresentationStyle = .overFullScreen
        present(aboutCompanyVC, animated: true)
    }   
    
    @objc func showAboutAppViewController() {
        var aboutAppVC = AboutAppViewController()
        aboutAppVC.hidesBottomBarWhenPushed = true
        navigationController?.modalPresentationStyle = .overFullScreen
        present(aboutAppVC, animated: true)
    }
    
    // - MARK: - setups
    
    func setupNavigationBar(){
        navigationItem.title = "Информация"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .Profile.iconBack, style: .done, target: self, action: #selector(dismissView))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
    }
    
    func setupView() {
        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        view.addSubview(aboutCompanyButton)
        view.addSubview(arrowForCompanyButton)
        view.addSubview(viewUnderCompany)
        view.addSubview(aboutAppButton)
        view.addSubview(arrowForAppButton)
        view.addSubview(viewUnderApp)
        view.addSubview(StackViewForYoutubeVk)
        StackViewForYoutubeVk.addArrangedSubview(YouTubeButton)
        StackViewForYoutubeVk.addArrangedSubview(VKButton)
        view.addSubview(titleLabel)
    }
    
    func setupConstraints() {
        aboutCompanyButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(52)
        }
        arrowForCompanyButton.snp.makeConstraints { make in
            make.centerY.equalTo(aboutCompanyButton)
            make.right.equalTo(aboutCompanyButton.snp.right)
            make.height.width.equalTo(16)
        }
        viewUnderCompany.snp.makeConstraints { make in
            make.top.equalTo(aboutCompanyButton.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        aboutAppButton.snp.makeConstraints { make in
            make.top.equalTo(viewUnderCompany.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(52)
        }
        arrowForAppButton.snp.makeConstraints { make in
            make.centerY.equalTo(aboutAppButton)
            make.right.equalTo(aboutAppButton.snp.right)
            make.height.width.equalTo(16)
        }
        viewUnderApp.snp.makeConstraints { make in
            make.top.equalTo(aboutAppButton.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        StackViewForYoutubeVk.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(36)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(StackViewForYoutubeVk.snp.top).inset(-16)
        }
    }
}
