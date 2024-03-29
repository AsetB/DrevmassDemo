//
//  SelectTimeViewController.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 23.03.2024.
//

import UIKit
import SnapKit
import PanModal
import Alamofire
import SVProgressHUD
import SwiftyJSON

class SelectTimeViewController: UIViewController, PanModalPresentable {
    
    var panScrollable: UIScrollView?
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(420)
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
    
    var days = Days()
    var courseId = 0
    var time = ""
    
    // MARK: - UI elements
    
    var titleLabel: UILabel = {
       var label = UILabel()
        label.text = "Дни занятий"
        label.font = .addFont(type: .SFProDisplaySemibold, size: 20)
        label.textColor = UIColor(resource: ColorResource.Colors._302_C_28)
        return label
    }()
    
    var timePicker: UIDatePicker = {
       var picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.locale = .autoupdatingCurrent
        picker.preferredDatePickerStyle = .wheels
        picker.addTarget(self, action: #selector(timePiker), for: .valueChanged)
        return picker
    }()
    
    var saveButton: UIButton = {
       var button = UIButton()
        button.setTitle("Сохранить", for: .normal)
        button.titleLabel?.font = .addFont(type: .SFProTextSemiBold, size: 15)
        button.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(saveInfo), for: .touchUpInside)
        return button
    }()
    
    var notificationView = NotificationView()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        getDays()
    }
    
    // MARK: - other func
    
    @objc func timePiker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        self.time = dateFormatter.string(from: timePicker.date)
        print(time)
    }
    
    // MARK: - network
    
    @objc func saveInfo() {
        
        let parameters: [String: Any] = [
            "course_id": courseId,
            "mon": days.mon,
            "tue": days.tue,
            "wed": days.wed,
            "thu": days.thu,
            "fri": days.fri,
            "sat": days.sat,
            "sun": days.sun,
            "time": time,
            "notificationIsSelected": days.notificationIsSelected
         ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AuthenticationService.shared.token)"
        ]
        AF.request(URLs.GET_DAY_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
            }
                if response.response?.statusCode == 200 {
                    let json = JSON(response.data!)
                    print("JSON: \(json)")
                    self.notificationView.show(viewController: self, notificationType: .success)
                     self.notificationView.titleLabel.text = "Настройки успешно сохранены"
                }else{
                    var ErrorString = "CONNECTION_ERROR"
                    if let sCode = response.response?.statusCode{
                        ErrorString = ErrorString + "\(sCode)"
                    }
                    ErrorString = ErrorString + "\(resultString)"
                    SVProgressHUD.showError(withStatus: "\(ErrorString)")
                }
        }
        dismiss(animated: true)
    }
    
    func getDays() {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AuthenticationService.shared.token)"
        ]
        AF.request(URLs.GET_DAY_URL + "/\(courseId)", method: .get, headers: headers).responseData { response in
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
            }
                if response.response?.statusCode == 200 {
                    let json = JSON(response.data!)
                    print("JSON: \(json)")
                    self.days = Days(json: json)
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

    
    // MARK: - setups
    
    func setupView() {
        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        view.addSubview(titleLabel)
        view.addSubview(timePicker)
        view.addSubview(saveButton)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(24)
        }
        timePicker.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(208)
        }
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(timePicker.snp.bottom).inset(-32)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(52)
        }
    }

}
