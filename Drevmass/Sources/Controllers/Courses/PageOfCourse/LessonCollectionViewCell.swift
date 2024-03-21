//
//  LessonCollectionViewCell.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 18.03.2024.
//

import UIKit
import SnapKit
import SDWebImage

class LessonCollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView = {
       var imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.layer.cornerRadius = 24
        return imageview
    }()
    
    var titleLabel: UILabel = {
       var label = UILabel()
        label.font = .addFont(type: .SFProTextMedium, size: 13)
        label.textColor = UIColor(resource: ColorResource.Colors._989898)
        return label
    }() 
    
    var subtitleLabel: UILabel = {
       var label = UILabel()
        label.numberOfLines = 0
        label.font = .addFont(type: .SFProTextSemiBold, size: 17)
        label.textColor = UIColor(resource: ColorResource.Colors._181715)
        return label
    }()
    
    var favoriteImageView: UIImageView = {
       var imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.image = UIImage(resource: ImageResource.Courses.icFavoriteWhite)
        return imageview
    }()
    
    var playButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(resource: ImageResource.Courses.icPlayBlack), for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 2
        layer.borderColor = UIColor(resource: ColorResource.Colors.F_3_F_1_F_0).cgColor
        layer.cornerRadius = 24
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        imageView.addSubview(favoriteImageView)
        imageView.addSubview(playButton)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(lesson: Lesson ) {
        self.imageView.sd_setImage(with: URL(string: "http://45.12.74.158/\(lesson.image_src)"))
        self.titleLabel.text = "\(lesson.id) урок · \(lesson.duration/60) мин"
        self.subtitleLabel.text = lesson.title
    }
    
    
    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(8)
            make.height.equalTo(185)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).inset(-8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        favoriteImageView.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(12)
            make.height.width.equalTo(24)
        }
        playButton.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.height.equalTo(44)
        }
    }
}


