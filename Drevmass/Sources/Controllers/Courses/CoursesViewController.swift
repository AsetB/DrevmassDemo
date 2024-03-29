//
//  CoursesViewController.swift
//  Drevmass
//
//  Created by Aset Bakirov on 04.03.2024.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import SDWebImage
import ShimmerSwift
import Network

class CoursesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    var course: [Course] = []
    var request: Request?
    var nosignalView = NoSignalUIView()
    private let monitor = NWPathMonitor(requiredInterfaceType: .wifi)
  
    //    MARK: UI elements
    
  lazy var scrollView: UIScrollView = {
       var scrollview = UIScrollView()
           scrollview.backgroundColor = .clear
           scrollview.showsVerticalScrollIndicator = true
           scrollview.isScrollEnabled = true
           scrollview.clipsToBounds = true
           scrollview.contentMode = .scaleAspectFill
           scrollview.contentInsetAdjustmentBehavior = .never
           scrollview.alwaysBounceVertical = true
           scrollview.delegate = self
        return scrollview
    }()
    var contentview: UIView = {
        var view = UIView()
          view.backgroundColor =  UIColor(resource: ColorResource.Colors.F_3_F_1_F_0)
        return view
    }()
    
    var backgroundView: UIView = {
      var view = UIView()
        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
   lazy var favoriteButton: Button = {
       var button = Button()
        button.setTitle("Мои закладки", for: .normal)
        button.leftIcon.image = UIImage(resource: ImageResource.Courses.icFavorite)
        button.rightIcon.image = UIImage(resource: ImageResource.Profile.arrowBeigeProfile)
        button.layer.borderColor = UIColor(resource: ColorResource.Colors.F_3_F_1_F_0).cgColor
        button.addTarget(self, action: #selector(showFavoriteVc), for: .touchUpInside)
      
        return button
    }()
    
   //    bannerView
    
    var bannerImageView: UIImageView = {
       var imageview = UIImageView()
        imageview.image = UIImage(resource: ImageResource.Courses.bannerCourses)
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.layer.cornerRadius = 24
        imageview.isUserInteractionEnabled = true
        return imageview
    }()

    var titleForBannerLabel: UILabel = {
       var label = UILabel()
        label.text = "Получайте бонусы за\nпрохождение курсов"
        label.numberOfLines = 2
        label.font = .addFont(type: .SFProTextSemiBold, size: 17)
        label.textColor = UIColor(resource: ColorResource.Colors._302_C_28)
        return label
    }() 
    
    var subtitleForBannerLabel: UILabel = {
       var label = UILabel()
        label.font = .addFont(type: .SFProTextRegular, size: 15)
        label.textColor = UIColor(resource: ColorResource.Colors._787878)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
//        layout.estimatedItemSize.width = 343
//        layout.estimatedItemSize.height = 124
        layout.estimatedItemSize = .zero
        
      var collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.backgroundColor = .clear
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.isPagingEnabled = true
        collectionview.isScrollEnabled = true
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.bounces = false
            collectionview.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionview
    }()
    
    //    MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        setupNavigation()
        getCourseInfo()
        getCourseBonusInfo()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showInfoVC))
        bannerImageView.addGestureRecognizer(tap)
        

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      let yOffset = scrollView.contentOffset.y
    
        if yOffset > 88 {
            
            let rightBarButton = UIBarButtonItem(image: UIImage(resource: ImageResource.Courses.icFavorite), style: .plain, target: self, action: #selector(showFavoriteVc))
            rightBarButton.tintColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
            navigationItem.rightBarButtonItem = rightBarButton
            navigationItem.rightBarButtonItem?.isHidden = false
        }else{
            
            navigationItem.rightBarButtonItem?.isHidden = true
        }
    }
    
    
    //    MARK: CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return course.count
   }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            cell.layer.cornerRadius = 24
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor(resource: ColorResource.Colors.EFEBE_9).cgColor
        
        let imageview = UIImageView()
            imageview.layer.cornerRadius = 24
            imageview.frame.size = CGSize(width: 96, height: 108)
            imageview.clipsToBounds = true
            imageview.sd_setImage(with: URL(string: "http://45.12.74.158/\(course[indexPath.row].image_src)"))
        
        let lessonAttributed = NSMutableAttributedString(string: "\(course[indexPath.row].lesson_cnt) ")
            lessonAttributed.addAttributes([.font: UIFont.addFont(type:.SFProTextBold, size: 13), .foregroundColor: UIColor(resource: ColorResource.Colors._989898)], range: NSRange(location: 0, length: lessonAttributed.length))
        
        let durationAttributed = NSMutableAttributedString(string:  "\(course[indexPath.row].duration / 60) ")
            durationAttributed.addAttributes([.font: UIFont.addFont(type: .SFProTextBold, size: 13), .foregroundColor: UIColor(resource: ColorResource.Colors._989898)], range: NSRange(location: 0, length: durationAttributed.length))
        
        let combinedAttributedString = NSMutableAttributedString()
        
            combinedAttributedString.append(lessonAttributed)
            combinedAttributedString.append(NSAttributedString(string: "уроков · ", attributes: [.font: UIFont.addFont(type: .SFProTextRegular, size: 13), .foregroundColor: UIColor(resource: ColorResource.Colors._989898)]))
            combinedAttributedString.append(durationAttributed)
            combinedAttributedString.append(NSAttributedString(string: "мин", attributes: [.font: UIFont.addFont(type: .SFProTextRegular, size: 13), .foregroundColor: UIColor(resource: ColorResource.Colors._989898)]))
        
        let titleLabel = UILabel()
            titleLabel.font = .addFont(type: .SFProTextRegular, size: 13)
            titleLabel.textColor = UIColor(resource: ColorResource.Colors._989898)
            titleLabel.attributedText = combinedAttributedString
        
        let subtitleLabel = UILabel()
            subtitleLabel.font = .addFont(type: .SFProTextSemiBold, size: 17)
            subtitleLabel.textColor = UIColor(resource: ColorResource.Colors._181715)
            subtitleLabel.numberOfLines = 2
            subtitleLabel.text = course[indexPath.row].name
        
        
        let viewForBonus = BonusUIView()
            viewForBonus.backgroundColor = UIColor(resource: ColorResource.Colors.EFEBE_9)
            viewForBonus.layer.cornerRadius = 12
            viewForBonus.bonusImageview.image = UIImage(resource: ImageResource.Profile.iconBonusBeige)
            viewForBonus.bonusTitleLabel.text = "\(course[indexPath.row].bonus_info.price)"
        
        cell.addSubview(imageview)
        cell.addSubview(titleLabel)
        cell.addSubview(subtitleLabel)
        cell.addSubview(viewForBonus)

        imageview.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(8)
            make.width.equalTo(96)
            make.height.equalTo(108)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.left.equalTo(imageview.snp.right).inset(-12)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(viewForBonus.snp.bottom).inset(-4)
            make.left.equalTo(imageview.snp.right).inset(-12)
            make.right.equalToSuperview().inset(8)
        }
        viewForBonus.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(8)
            make.height.equalTo(24)
        }
        
        
        
       return cell
   }
   
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       collectionView.deselectItem(at: indexPath, animated: true)
      let pageOfCourse = PageOfCourseViewController()
       pageOfCourse.course = course[indexPath.row]
       pageOfCourse.navigationItem.largeTitleDisplayMode = .never
       navigationController?.show(pageOfCourse, sender: self)
   }
}

extension CoursesViewController {
    
    //    MARK: other funcs
    
    @objc func showFavoriteVc() {
        let favoriteVC = FavoriteViewController()
        navigationController?.pushViewController(favoriteVC, animated: true)
    }
    
    @objc func showInfoVC() {
        print("tapped")
        let infoVC = InformationViewController()
        navigationController?.modalPresentationStyle = .overFullScreen
        present(infoVC, animated: true)
    }
    
    //    MARK: network
    func getCourseInfo() {
        SVProgressHUD.show()
        request?.cancel()
        
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(AuthenticationService.shared.token)"
            ]
        
        request = AF.request(URLs.GET_COURSE_URL, method: .get, headers: headers).responseData { response in
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
            }
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
               
                self.nosignalView.isHidden = true
                
                if let array = json.array {
                    for item in array {
                        let course = Course(json: item)
                        self.course.append(course)
                        print("ffffff \(course.id)")
                    }
            
                    self.collectionView.reloadData()
                }
            }else{

                self.monitor.pathUpdateHandler = { path in
                    
                    if path.status == .unsatisfied {
                        print("Network disconnected")
                        DispatchQueue.main.async {
                            self.view.addSubview(self.nosignalView)
                            self.nosignalView.snp.makeConstraints { make in
                                make.top.equalToSuperview().inset(160)
                                make.horizontalEdges.equalToSuperview()
                                make.bottom.equalToSuperview()
                            }
                            self.nosignalView.button.addAction(UIAction(handler: { _ in
                                self.getCourseBonusInfo()
                                self.getCourseInfo()
                                self.nosignalView.isHidden = true
                            }), for: .touchUpInside)
                        }
                    } else {
                        
                        print("Network connected")
                        DispatchQueue.main.async {
                            self.nosignalView.removeFromSuperview()
                        }
                    }
                }
                self.monitor.start(queue: DispatchQueue(label: "network_monitor"))
                
                
            }
        }
    }
    
    //1500
    func getCourseBonusInfo() {
        SVProgressHUD.show()

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AuthenticationService.shared.token)"
        ]
        AF.request(URLs.GET_COURSE_BONUS_URL, method: .get, headers: headers).responseData { response in
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
            }

                if response.response?.statusCode == 200 {
                    let json = JSON(response.data!)
                    print("JSON: \(json)")

                    let bonus = json["price"].int
                    self.subtitleForBannerLabel.text = "Начислим до \(String(bonus ?? 0)) ₽ \nбонусами...."

                }
        }
    }
        
        //    MARK: - setups
    func setupNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.addFont(type: .SFProDisplayBold, size: 28), .foregroundColor: UIColor(resource: ColorResource.Colors._302_C_28)]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(resource: ColorResource.Colors._302_C_28)]
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.title = "Курсы"
    }
        
    func setupView() {
        view.backgroundColor = UIColor(resource: ColorResource.Colors.F_3_F_1_F_0)
        view.addSubview(scrollView)
        scrollView.addSubview(contentview)
        contentview.addSubview(backgroundView)
        backgroundView.addSubview(favoriteButton)
        backgroundView.addSubview(bannerImageView)
        backgroundView.addSubview(titleForBannerLabel)
        backgroundView.addSubview(subtitleForBannerLabel)
        backgroundView.addSubview(collectionView)
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentview.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.height.equalTo(scrollView.frameLayoutGuide)
        }
        backgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(160)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        favoriteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(64)
        }
        bannerImageView.snp.makeConstraints { make in
            make.top.equalTo(favoriteButton.snp.bottom).inset(-24)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(128)
        }
        titleForBannerLabel.snp.makeConstraints { make in
            make.top.equalTo(bannerImageView.snp.top).inset(20)
            make.left.equalTo(bannerImageView.snp.left).inset(20)
        }
        subtitleForBannerLabel.snp.makeConstraints { make in
            make.top.equalTo(titleForBannerLabel.snp.bottom).inset(-4)
            make.left.equalTo(bannerImageView.snp.left).inset(20)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(bannerImageView.snp.bottom).inset(-24)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(40)
        }
    }
}

extension CoursesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - 32
        return CGSize(width: width, height: 124)
    }
//    layout.estimatedItemSize.width = 343
//    layout.estimatedItemSize.height = 124
}
