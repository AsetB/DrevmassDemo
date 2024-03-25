//
//  DetailLessonViewController.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 20.03.2024.
//

import UIKit
import SnapKit
import SDWebImage
import SVProgressHUD
import Alamofire
import SwiftyJSON
import YouTubePlayerKit

//protocol GestureRecognazerProtocol {
//    func didTap(id: Int)
//}

class DetailLessonViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
//    var delegate: GestureRecognazerProtocol?
    
    var lesson = LessonsById()
    var lessonId = 0
    var courseId = 0
    var courseName = ""
    var used_products: [Product] = []
    // MARK: - UI elements
    
     lazy var scrollView: UIScrollView = {
          var scrollview = UIScrollView()
           scrollview.backgroundColor = .clear
           scrollview.showsVerticalScrollIndicator = false
           scrollview.isScrollEnabled = true
           scrollview.clipsToBounds = true
           scrollview.contentMode = .scaleAspectFill
           scrollview.contentInsetAdjustmentBehavior = .never
           scrollview.delegate = self
           return scrollview
       }()
       
       var contentview: UIView = {
           var view = UIView()
               view.backgroundColor =  UIColor(resource: ColorResource.Colors.FFFFFF)
           return view
       }()
    
    var posterButton: UIButton = {
        var button = UIButton()
           button.contentMode = .scaleAspectFill
           button.clipsToBounds = true
           button.layer.cornerRadius = 24
           button.addTarget(self, action: #selector(showYouTubePlayer), for: .touchUpInside)
        return button
    }()
    
    var playButton: UIButton = {
        var button = UIButton()
            button.contentMode = .scaleAspectFill
            button.clipsToBounds = true
            button.setImage(UIImage(resource: ImageResource.Courses.icPlayBlack), for: .normal)
            button.addTarget(self, action: #selector(showYouTubePlayer), for: .touchUpInside)
        return button
    }()
    
    var minLabel: UILabel = {
       var label = UILabel()
        
        return label
    }()
    
    var watchImageView: UIImageView = {
       var imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.image = UIImage(resource: ImageResource.Courses.icwathc)
        return imageview
    }()
    
    var favoriteButton: UIButton = {
       var button = UIButton()
        button.setImage(UIImage(resource: ImageResource.Courses.icFavorite), for: .normal)
        button.addTarget(self, action: #selector(selectFavorite), for: .touchUpInside)
        return button
    }()
    
    var titleLable: UILabel = {
       var label = UILabel()
        label.font = .addFont(type: .SFProDisplayBold, size: 22)
        label.textColor = UIColor(resource: ColorResource.Colors._302_C_28)
        label.numberOfLines = 0
        return label
    }()   
    
    var subtitleLable: UILabel = {
       var label = UILabel()
        label.font = .addFont(type: .SFProTextRegular, size: 16)
        label.textColor = UIColor(resource: ColorResource.Colors._787878)
        label.numberOfLines = 0
        return label
    }() 
    
    var usedProductsLable: UILabel = {
       var label = UILabel()
        label.text = "Товары используемые на видео"
        label.font = .addFont(type: .SFProDisplaySemibold, size: 20)
        label.textColor = UIColor(resource: ColorResource.Colors._181715)
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 12
        layout.estimatedItemSize.width = 165
        layout.estimatedItemSize.height = 180
        
      var collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.backgroundColor = .clear
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.isPagingEnabled = true
        collectionview.isScrollEnabled = true
        collectionview.showsHorizontalScrollIndicator = true
        collectionview.bounces = false
        collectionview.register(CatalogCollectionViewCell.self, forCellWithReuseIdentifier: "catalogCell")
        return collectionview
    }()
    
    // MARK: - Lificycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()
        setupNavigation()
        getLessonInfo()
        print(used_products.count)
        
//        let tapRecognazer = UIGestureRecognizer(target: self, action: #selector(handelTapped))
//        posterButton.addGestureRecognizer(tapRecognazer)
    }
    
//    @objc func handelTapped() {
//        delegate?.didTap(id: lessonId)
//        print(lessonId)
//    }
    
    // MARK: - Collection view
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(used_products.count)
        return used_products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catalogCell", for: indexPath) as! CatalogCollectionViewCell
        cell.setCell(catalog: used_products[indexPath.row])
        print(used_products[indexPath.row].title)
        return cell
    }
    

}

extension DetailLessonViewController {
    
    // MARK: - other funcs
    
    @objc func selectFavorite() {
        
        if lesson.is_favorite {
        favoriteButton.setImage(UIImage(resource: ImageResource.Courses.icFavorite), for: .normal)
            
            SVProgressHUD.show()
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(AuthenticationService.shared.token)"
            ]
            AF.request(URLs.FAVORITE_URL + "/\(lessonId)", method: .delete, headers: headers).responseData { response in
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
            lesson.is_favorite = false
        }else{
            favoriteButton.setImage(UIImage(resource: ImageResource.Courses.favoriteSelectedBeige), for: .normal)
            lesson.is_favorite = true
            
            SVProgressHUD.show()
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(AuthenticationService.shared.token)"
            ]
            
            var parameters = ["lesson_id": lessonId]
            AF.upload(multipartFormData: {(multipartFormData) in
                for (key, value) in parameters {
                    multipartFormData.append(Data(value.description.utf8), withName: key)
                }
            }, to: URLs.FAVORITE_URL, headers: headers).responseDecodable(of: Data.self) { response in
                guard let responseCode = response.response?.statusCode else {
                    self.showAlertMessage(title: "Ошибка соединения", message: "Проверьте подключение")
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
                    self.showAlertMessage(title: "Ошибка соединения", message: "\(ErrorString)")
                }
            }
        }
    }

    
    func updateUI() {
        self.posterButton.sd_setImage(with:  URL(string: "http://45.12.74.158/\(lesson.image_src)"), for: .normal)
        
        
        let digit = NSAttributedString(string: "\(lesson.duration / 60)", attributes: [.font: UIFont.addFont(type: .SFProTextSemiBold, size: 13), .foregroundColor: UIColor(resource: ColorResource.Colors._989898)])
        let min = NSAttributedString(string: " мин", attributes: [.font: UIFont.addFont(type: .SFProTextRegular, size: 13), .foregroundColor: UIColor(resource: ColorResource.Colors._989898)])
        let mutating = NSMutableAttributedString()
        mutating.append(digit)
        mutating.append(min)
        
        self.minLabel.attributedText = mutating
        self.titleLable.text = lesson.title
        self.subtitleLable.text = lesson.description
        
        if self.lesson.is_favorite {
            favoriteButton.setImage(UIImage(resource: ImageResource.Courses.favoriteSelectedBeige), for: .normal)
        }else{
            favoriteButton.setImage(UIImage(resource: ImageResource.Courses.icFavorite), for: .normal)
        }
    }

    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    @objc func share() {
        let text = "Я рекомендую тебе курс '\(courseName)'"
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true)
    }
    @objc func showYouTubePlayer() {
        
        
        SVProgressHUD.show()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AuthenticationService.shared.token)"
        ]
        
        var parameters = ["lesson_id": lessonId, "course_id": courseId]
        AF.upload(multipartFormData: {(multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append(Data(value.description.utf8), withName: key)
            }
        }, to: URLs.LESSONS_COMPLETE_URL, headers: headers).responseDecodable(of: Data.self) { response in
            guard let responseCode = response.response?.statusCode else {
                self.showAlertMessage(title: "Ошибка соединения", message: "Проверьте подключение")
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
                self.showAlertMessage(title: "Ошибка соединения", message: "\(ErrorString)")
            }
        }
    
    

        
        
        let youTubePlayerVC = YouTubePlayerViewController(player: "")
        youTubePlayerVC.player.source = .video(id: lesson.video_src, startSeconds: nil, endSeconds: nil)
        youTubePlayerVC.hidesBottomBarWhenPushed = true
        youTubePlayerVC.navigationController?.navigationItem.leftBarButtonItem?.tintColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        self.show(youTubePlayerVC, sender: self)
    }
    
    // MARK: - network
    
    func getLessonInfo() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AuthenticationService.shared.token)"
        ]
        AF.request(URLs.GET_COURSE_BY_ID_URL + "\(courseId)/lessons/\(lessonId)", method: .get, headers: headers).responseData { response in
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
            }
                if response.response?.statusCode == 200 {
                    let json = JSON(response.data!)
                    print("JSON: \(json)")
                    
                    self.lesson = LessonsById(json: json)
                    if let array = json["used_products"].array {
                        for item in array {
                            let product = Product(json: item)
                            self.used_products.append(product)
                            print(self.used_products.description)
                        }
                    }
                    
                    self.collectionView.reloadData()
                    self.updateUI()
                    
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
    
    func setupNavigation() {
        let leftBarButton = UIBarButtonItem(image: UIImage(resource: ImageResource.Profile.iconBack), style: .plain, target: self, action: #selector(goBack))
        leftBarButton.tintColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        navigationItem.leftBarButtonItem = leftBarButton
        
        let rightBarButton = UIBarButtonItem(image: UIImage(resource: ImageResource.Profile.iconShare), style: .plain, target: self, action: #selector(share))
        navigationItem.rightBarButtonItem = rightBarButton
        rightBarButton.tintColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        navigationItem.title = "\(lesson.name)"
    }
    
    func setupView() {
        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        view.addSubview(scrollView)
        scrollView.addSubview(contentview)
        
        contentview.addSubview(posterButton)
        posterButton.addSubview(playButton)
        contentview.addSubview(watchImageView)
        contentview.addSubview(minLabel)
        contentview.addSubview(favoriteButton)
        contentview.addSubview(titleLable)
        contentview.addSubview(subtitleLable)
        contentview.addSubview(usedProductsLable)
        contentview.addSubview(collectionView)
    }
    
    func setupConstraints() {
//        scrollView.snp.makeConstraints { make in
//            make.top.bottom.equalToSuperview()
////            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
//            make.horizontalEdges.equalToSuperview()
//
//        }
//        contentview.snp.makeConstraints { make in
//            make.edges.equalTo(scrollView.contentLayoutGuide)
//            make.width.equalTo(scrollView.frameLayoutGuide)
//        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        contentview.snp.makeConstraints { make in
            make.horizontalEdges.top.bottom.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        posterButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(4)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(212)
        }
        playButton.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.height.width.equalTo(44)
        }
        watchImageView.snp.makeConstraints { make in
            make.top.equalTo(posterButton.snp.bottom).inset(-22)
            make.left.equalToSuperview().inset(16)
            make.width.height.equalTo(12)
        }
        minLabel.snp.makeConstraints { make in
            make.centerY.equalTo(watchImageView)
            make.left.equalTo(watchImageView.snp.right).inset(-6)
        }
        favoriteButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalTo(watchImageView)
        }
        titleLable.snp.makeConstraints { make in
            make.top.equalTo(posterButton.snp.bottom).inset(-48)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        subtitleLable.snp.makeConstraints { make in
            make.top.equalTo(titleLable.snp.bottom).inset(-12)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        usedProductsLable.snp.makeConstraints { make in
            make.top.equalTo(subtitleLable.snp.bottom).inset(-32)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(usedProductsLable.snp.bottom).inset(-16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(180)
            make.bottom.equalToSuperview().inset(24)
        }
    }
}
