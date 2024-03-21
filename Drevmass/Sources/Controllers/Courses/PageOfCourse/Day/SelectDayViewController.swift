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

class SelectDayViewController: UIViewController, PanModalPresentable, UICollectionViewDataSource, UICollectionViewDelegate {

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
    
    var daysArr = [("Понедельник", "Пн"), ("Вторник", "Вт"), ("Среда", "Ср"), ("Четверг", "Чт"), ("Пятница", "Пт"), ("Суббота", "Сб"), ("Воскресенье", "Вс")]
    
    var selectedIndex: [Int] = []
    var selectedDayForCoursePage: [String] = []
//    var delegateCell: DidSelectCellDayProtocol?
    
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
        
        if let savedIndexes = UserDefaults.standard.array(forKey: "selectedCell") as? [Int] {
            selectedIndex = savedIndexes
            
        }

        collectionView.reloadData()
    }
    
    
    
    // MARK: - collectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DayCollectionViewCell

        cell.titleLabel.text = daysArr[indexPath.row].0

        cell.isSelected = selectedIndex.contains(indexPath.row)
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
        cell.isSelected.toggle()
    
        cell.titleLabel.textColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        cell.backgroundColor = UIColor(resource: ColorResource.Colors.F_3_F_1_F_0)
        cell.layer.borderColor = UIColor(resource: ColorResource.Colors.B_5_A_380).cgColor
        
        
        selectedIndex.append(indexPath.row)
        UserDefaults.standard.set(selectedIndex, forKey: "selectedCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DayCollectionViewCell
        
        cell.titleLabel.textColor = UIColor(resource: ColorResource.Colors._181715)
        cell.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        cell.layer.borderColor = UIColor(resource: ColorResource.Colors.EFEBE_9).cgColor
        
        UserDefaults.standard.set(selectedIndex, forKey: "selectedCell")
    }
}

extension SelectDayViewController {
    
    // MARK: - other funcs
    
    @objc func saveInfo() {
        if let savedIndexes = UserDefaults.standard.array(forKey: "selectedIndexes") as? [Int] {
            selectedIndex = savedIndexes
        }
        dismiss(animated: true)
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
