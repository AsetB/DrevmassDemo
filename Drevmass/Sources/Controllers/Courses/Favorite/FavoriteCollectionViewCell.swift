//
//  FavoriteCollectionViewCell.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 22.03.2024.
//

import UIKit
import SnapKit
import SDWebImage
import Alamofire
import SVProgressHUD
import SwiftyJSON

class FavoriteCollectionViewCell: UICollectionViewCell {
    var lesson = LessonsById()
    
     // MARK: - UI elements
    
    var imageView: UIImageView = {
       var imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.layer.cornerRadius = 24
        imageview.frame.size = CGSize(width: 246, height: 148)
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
        label.font = .addFont(type: .SFProDisplaySemibold, size: 15)
        label.textColor = UIColor(resource: ColorResource.Colors._181715)
        label.numberOfLines = 2
        return label
    }()
    
    var favoriteButton: UIButton = {
       var button = UIButton()
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(selectFavorite(sender: )), for: .touchDown)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    var playButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(resource: ImageResource.Courses.icPlayBlack), for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 2
        layer.borderColor = UIColor(resource: ColorResource.Colors.F_3_F_1_F_0).cgColor
        layer.cornerRadius = 24
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        imageView.addSubview(favoriteButton)
        imageView.addSubview(playButton)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

        guard isUserInteractionEnabled else { return nil }

        guard !isHidden else { return nil }

        guard alpha >= 0.01 else { return nil }

        guard self.point(inside: point, with: event) else { return nil }

        if self.favoriteButton.point(inside: convert(point, to: favoriteButton), with: event) {
            return self.favoriteButton
        }

        return super.hitTest(point, with: event)
    }
    
    // MARK: - other funcs
    
    func setData(lesson: LessonsById ) {
        if lesson.image_src == "" {
            self.imageView.sd_setImage(with: URL(string: "https://img.youtube.com/vi/\(lesson.video_src)/hqdefault.jpg"))
        }else{
            self.imageView.sd_setImage(with: URL(string: "http://45.12.74.158/\(lesson.image_src)"))
        }
        self.titleLabel.text = "\(lesson.id) урок · \(lesson.duration/60) мин"
        self.subtitleLabel.text = lesson.title
    }
    
    
    @objc func selectFavorite(sender: UIButton) {
        
        if lesson.is_favorite {
        favoriteButton.setImage(UIImage(resource: ImageResource.Courses.icFavoriteWhite), for: .normal)
            SVProgressHUD.show()
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(AuthenticationService.shared.token)"
            ]
            AF.request(URLs.FAVORITE_URL + "/\(lesson.id)", method: .delete, headers: headers).responseData { response in
                SVProgressHUD.dismiss()
                var resultString = ""
                if let data = response.data{
                    resultString = String(data: data, encoding: .utf8)!
                }
                    if response.response?.statusCode == 200 {
                        let json = JSON(response.data!)
                        print("JSON: \(json)")
                        // добавить обновление ячеек после удаления
                    }else{
                        var ErrorString = "CONNECTION_ERROR"
                        if let sCode = response.response?.statusCode{
                            ErrorString = ErrorString + "\(sCode)"
                        }
                        ErrorString = ErrorString + "\(resultString)"
                        SVProgressHUD.showError(withStatus: "\(ErrorString)")
                    }
            }
            lesson.is_favorite = false
            print(lesson.id)
        }else{
            favoriteButton.setImage(UIImage(resource: ImageResource.Courses.favoriteSelected), for: .normal)
            lesson.is_favorite = true
            
            SVProgressHUD.show()
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(AuthenticationService.shared.token)"
            ]
            
            let parameters = ["lesson_id": lesson.id]
            AF.upload(multipartFormData: {(multipartFormData) in
                for (key, value) in parameters {
                    multipartFormData.append(Data(value.description.utf8), withName: key)
                }
            }, to: URLs.FAVORITE_URL, headers: headers).responseDecodable(of: Data.self) { response in
                guard let responseCode = response.response?.statusCode else {
                    return
                }
                SVProgressHUD.dismiss()
                if responseCode == 200 {
                    let json = JSON(response.data!)
                    print("JSON: \(json)")
                    
                } else {
                    var resultString = ""
                    if let data = response.data {
                        resultString = String(data: data, encoding: .utf8)!
                    }
                    var ErrorString = "Ошибка"
                    if let statusCode = response.response?.statusCode {
                        ErrorString = ErrorString + " \(statusCode)"
                    }
                    ErrorString = ErrorString + " \(resultString)"
                   print(ErrorString)
                }
            }
        }
    }

    
    // MARK: - setups
    
    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(8)
            make.height.equalTo(148)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).inset(-8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        favoriteButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(12)
            make.height.width.equalTo(24)
        }
        playButton.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.height.equalTo(44)
        }
    }
}
