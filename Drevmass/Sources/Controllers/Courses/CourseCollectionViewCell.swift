//
//  CourseCollectionViewCell.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 01.04.2024.
//

import UIKit
import SnapKit
import SkeletonView

class CourseCollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView = {
       var imageview = UIImageView()
        imageview.layer.cornerRadius = 24
        imageview.clipsToBounds = true
        imageview.isSkeletonable = true
        imageview.skeletonCornerRadius = 16
        return imageview
    }()
    
    var subtitleLabel: UILabel = {
       var label = UILabel()
        label.isSkeletonable = true
        label.skeletonLineSpacing = 8
        label.skeletonTextLineHeight = .fixed(12)
        label.linesCornerRadius = 4
        label.font = .addFont(type: .SFProTextRegular, size: 13)
        label.textColor = UIColor(resource: ColorResource.Colors._989898)
        return label
    }()
    
    var titleLabel: UILabel = {
       var label = UILabel()
        label.isSkeletonable = true
        label.skeletonLineSpacing = 8
        label.skeletonTextLineHeight = .fixed(12)
        label.skeletonTextNumberOfLines = 2
        label.linesCornerRadius = 4
        label.font = .addFont(type: .SFProTextSemiBold, size: 17)
        label.textColor = UIColor(resource: ColorResource.Colors._181715)
        label.numberOfLines = 2
        return label
    }()
    
    var viewForBonus: BonusUIView = {
        var view = BonusUIView()
        view.isSkeletonable = true
        view.skeletonCornerRadius = 12
        view.backgroundColor = UIColor(resource: ColorResource.Colors.EFEBE_9)
        view.layer.cornerRadius = 12
        view.bonusImageview.image = UIImage(resource: ImageResource.Profile.iconBonusBeige)
        return view
    }()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        isSkeletonable = true
        contentView.isSkeletonable = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(viewForBonus)
        
        imageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(8)
            make.width.equalTo(96)
            make.height.equalTo(108)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.left.equalTo(imageView.snp.right).inset(-12)
            make.right.equalToSuperview().inset(80)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(viewForBonus.snp.bottom).inset(-4)
            make.left.equalTo(imageView.snp.right).inset(-12)
            make.right.equalToSuperview().inset(55)
        }
        viewForBonus.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(8)
            make.height.equalTo(24)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
