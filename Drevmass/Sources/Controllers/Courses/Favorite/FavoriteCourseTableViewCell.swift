//
//  FavoriteCourseTableViewCell.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 22.03.2024.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class FavoriteCourseTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var lessonArray: [LessonsById] = []
//    var courseName: [String] = []
    
    // MARK: - UI elements
    
    var titleLabel: UILabel = {
        var label = UILabel()
         label.font = .addFont(type: .SFProDisplaySemibold, size: 20)
         label.textColor = UIColor(resource: ColorResource.Colors._181715)
        label.textAlignment = .left
         return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.estimatedItemSize = .zero
//        layout.estimatedItemSize.width = 280
      var collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.backgroundColor = .clear
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.isPagingEnabled = true
        collectionview.isScrollEnabled = true
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.bounces = false
        collectionview.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionview
    }()
    
    // MARK: - Lifecycle

    override init(style: FavoriteCourseTableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        setupConstraints()
        print(lessonArray.count)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    // MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lessonArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FavoriteCollectionViewCell
        
        cell.setData(lesson: lessonArray[indexPath.row])
        cell.lesson = lessonArray[indexPath.row]
        
        if lessonArray[indexPath.row].is_favorite {
            cell.favoriteButton.setImage(UIImage(resource: ImageResource.Courses.favoriteSelected), for: .normal)
            print(lessonArray[indexPath.row].name)
        }else{
            cell.favoriteButton.setImage(UIImage(resource: ImageResource.Courses.icFavoriteWhite), for: .normal)
        }
        
        return cell
    }

}

extension FavoriteCourseTableViewCell {
    
    
    // MARK: - setups
    
    func setupView() {
        contentView.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        contentView.addSubview(titleLabel)
        contentView.addSubview(collectionView)
     
    }
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-16)
            make.bottom.equalToSuperview().inset(24)
            make.horizontalEdges.equalToSuperview()
        }
    }
}

extension FavoriteCourseTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: 280, height: 244)
        }
}

