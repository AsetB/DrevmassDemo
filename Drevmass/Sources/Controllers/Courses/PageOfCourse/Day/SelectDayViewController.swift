//
//  SelectDayViewController.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 19.03.2024.
//

import UIKit
import PanModal
import SnapKit
import Alamofire
import SwiftUI
import SVProgressHUD
import SwiftyJSON

class SelectDayViewController: UIViewController, PanModalPresentable, UICollectionViewDataSource, UICollectionViewDelegate {

    var panScrollable: UIScrollView?
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(409)
    }

//    var longFormHeight: PanModalHeight {
//        return .maxHeightWithTopInset(0)
//    }
    var panModalBackgroundColor: UIColor {
        return UIColor(resource: ColorResource.Colors._302C28A65)
    }
    var cornerRadius: CGFloat {
        return 24
    }
    var dragIndicatorBackgroundColor: UIColor {
        return UIColor(resource: ColorResource.Colors.FFFFFF)
    }

    var daysArr = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    var selectedIndex = [false, false, false, false, false, false, false]
    var courseId = 0
    var notificationIsSelected = false
    var days = Days()

    // MARK: - Ui elements
    
    var titleLabel: UILabel = {
       var label = UILabel()
        label.text = "Дни занятий"
        label.font = .addFont(type: .SFProDisplaySemibold, size: 20)
        label.textColor = UIColor(resource: ColorResource.Colors._302_C_28)
        return label
    }()
    
  lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 2
        layout.estimatedItemSize.width = 165
        layout.estimatedItemSize.height = 52
      
        var collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
          collectionview.backgroundColor = .clear
          collectionview.dataSource = self
          collectionview.delegate = self
          collectionview.isPagingEnabled = true
          collectionview.isScrollEnabled = true
          collectionview.showsHorizontalScrollIndicator = false
          collectionview.bounces = false
          collectionview.register(DayCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
      
          return collectionview
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
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()
        collectionView.allowsMultipleSelection = true
        getDays()
    }
    
    // MARK: - collectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DayCollectionViewCell

        cell.titleLabel.text = daysArr[indexPath.row]
 
        if selectedIndex[indexPath.row] {
            cell.isSelected = true
            cell.titleLabel.textColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        }
        
        if cell.isSelected  {
            cell.titleLabel.textColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
            cell.backgroundColor = UIColor(resource: ColorResource.Colors.F_3_F_1_F_0)
            cell.layer.borderColor = UIColor(resource: ColorResource.Colors.B_5_A_380).cgColor
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
        }else{
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DayCollectionViewCell
 
        cell.titleLabel.textColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        cell.backgroundColor = UIColor(resource: ColorResource.Colors.F_3_F_1_F_0)
        cell.layer.borderColor = UIColor(resource: ColorResource.Colors.B_5_A_380).cgColor
        
        selectedIndex[indexPath.row] = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DayCollectionViewCell
        
        cell.titleLabel.textColor = UIColor(resource: ColorResource.Colors._181715)
        cell.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        cell.layer.borderColor = UIColor(resource: ColorResource.Colors.EFEBE_9).cgColor
        
        selectedIndex[indexPath.row] = false
    }
}

extension SelectDayViewController {
    
    // MARK: - other funcs
    
    func setDataToSelectedIndex() {
        selectedIndex[0] = days.mon
        selectedIndex[1] = days.tue
        selectedIndex[2] = days.wed
        selectedIndex[3] = days.thu
        selectedIndex[4] = days.fri
        selectedIndex[5] = days.sat
        selectedIndex[6] = days.sun
    }
    
    // MARK: - network
    
    @objc func saveInfo() {

        if selectedIndex.contains(true) {
            notificationIsSelected = true
        }
        
        let parameters: [String: Any] = [
            "course_id": courseId,
            "mon": selectedIndex[0],
            "tue": selectedIndex[1],
            "wed": selectedIndex[2],
            "thu": selectedIndex[3],
            "fri": selectedIndex[4],
            "sat": selectedIndex[5],
            "sun": selectedIndex[6],
            "time": days.time,
            "notificationIsSelected": notificationIsSelected
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
                    self.setDataToSelectedIndex()
                    self.collectionView.reloadData()
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
        view.addSubview(collectionView)
        view.addSubview(saveButton)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(24)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-24)
            make.left.equalTo(27)
            make.right.equalTo(-27)
            make.height.equalTo(232)
        }
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).inset(-32)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(52)
        }
    }
}
