//
//  AboutCompanyViewController.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 12.03.2024.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class AboutCompanyViewController: UIViewController {
    
    // - MARK: - UI elements
    
    var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "О компании"
        label.font = UIFont(name: "SFProText-Semibold", size: 17)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
     var rightButton: UIButton = {
        var button = UIButton()
        button.setTitle("Закрыть", for: .normal)
        button.setTitleColor(UIColor(resource: ColorResource.Colors._007_AFF) , for: .normal)
         button.titleLabel?.font = .addFont(type: .SFProTextSemiBold, size: 15)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()
    
    var scrollView: UIScrollView = {
       var scrollview = UIScrollView()
           scrollview.backgroundColor = .clear
           scrollview.showsVerticalScrollIndicator = false
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
    
    var imageView: UIImageView = {
       var imageview = UIImageView()
        imageview.image = .Profile.imageFounder
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.layer.cornerRadius = 24
        return imageview
    }()
    
    var textLabel: UILabel = {
       var label = UILabel()
        label.font = .addFont(type: .SFProTextRegular, size: 16)
        label.textColor = UIColor(resource: ColorResource.Colors._787878)
        label.numberOfLines = 0
        return label
    }()

    // - MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()
        getInfo()
    }
}

extension AboutCompanyViewController {
    
    // - MARK: - other funcs
    
    @objc func dismissView() {
        dismiss(animated: true)
    }

    // - MARK: - network
    
    func getInfo(){
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AuthenticationService.shared.token)"
        ]
        AF.request(URLs.INFO_URL, method: .get, headers: headers).responseData { response in
         SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            if response.response?.statusCode == 200{
                
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                self.textLabel.text = json["text"].string
                
            } else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR")
            }
        }
    }
    
    // - MARK: - setups
    
    func setupView() {
        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        view.addSubview(titleLabel)
        view.addSubview(rightButton)
        view.addSubview(scrollView)
        scrollView.addSubview(contentview)
        contentview.addSubview(imageView)
        contentview.addSubview(textLabel)
        
    }
    func setupConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(13)
        }
        rightButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(12)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-27)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        contentview.snp.makeConstraints { make in
            make.horizontalEdges.top.bottom.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(189)
        }
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).inset(-24)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
