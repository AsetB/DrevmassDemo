//
//  InformationViewController.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 07.03.2024.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class InformationViewController: UIViewController {
    
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
    
    var titleLabel: UILabel = {
       var label = UILabel()
        label.text = "Бонусная программа"
        label.font = UIFont(name: "SFProText-Semibold", size: 17)
        label.textColor = .black
        return label
    }()
    
   lazy var leftButton: UIButton = {
       var button = UIButton()
        button.setImage(.Profile.iconBack, for: .normal)
        button.tintColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        button.contentMode = .scaleAspectFill
       button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()
    
    var fullDescriptionsLabel: UILabel = {
        var label = UILabel()
         label.font = UIFont(name: "SFProText-Regular", size: 16)
         label.textColor = UIColor(resource: ColorResource.Colors._181715) 
         label.numberOfLines = 0
         label.contentMode = .topLeft
         return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        view.addSubview(titleLabel)
        view.addSubview(leftButton)
        view.addSubview(scrollView)
        scrollView.addSubview(contentview)
        contentview.addSubview(fullDescriptionsLabel)
        downlaodDesriptions()
        setupConstraints()
    }
    
    func downlaodDesriptions() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AuthenticationService.shared.token)"
        ]
        AF.request(URLs.BONUS_INFO_URL, method: .get, headers: headers).responseData { response in
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            if response.response?.statusCode == 200{
                let json = JSON(response.data!)
                print("JSON: \(json)")
                self.fullDescriptionsLabel.text = String(json["text"].string ?? "")
            }else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR")
                }
            }
        }
    
    @objc func dismissView() {
        dismiss(animated: true)
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
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-27)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        contentview.snp.makeConstraints { make in
            make.horizontalEdges.top.bottom.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        fullDescriptionsLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
