//
//  PageOfCourseViewController.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 17.03.2024.
//

import UIKit
import SnapKit
import SDWebImage
import SVProgressHUD
import Alamofire
import SwiftyJSON
import PanModal

class PageOfCourseViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate{
    
    var course = Course()
    var courseBonus = CourseBonus()
    var courseById = CourseById()
    var lessonArray: [LessonsById] = []
    var days = Days()
    var daysForTitle: [String] = []
    
    // MARK: - UI elements
    
 private lazy var scrollView: UIScrollView = {
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
    
    var posterImageView: UIImageView = {
       var imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    
    var gradientView = CustomGradientView(startColor:  UIColor(resource: ColorResource.Colors._161616A0), midColor: UIColor(resource: ColorResource.Colors._161616), endColor: UIColor(resource: ColorResource.Colors._161616), startLocation: 0.1, midLocation: 0.9, endLocation: 1.0, horizontalMode: false, diagonalMode: false)
    
    var titleLabelOnPoster: UILabel = {
       var label = UILabel()
        label.font = .addFont(type: .SFProDisplayBold, size: 28)
        label.textColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        label.numberOfLines = 2
        return label
    }() 
    
    var stackViewForPosterSubtitle: UIStackView = {
       var stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.spacing = 6
        return stackview
    }()
    
    var playImageView: UIImageView = {
       var imageview = UIImageView()
        imageview.image = UIImage(resource: ImageResource.Courses.icPlay)
        imageview.frame.size = CGSize(width: 12, height: 12)
        return imageview
    }()
    
    var subtitleLabel = UILabel()
    
    var startButton: UIButton = {
       var button = UIButton()
        button.setTitle("Начать курс", for: .normal)
        button.setTitleColor(UIColor(resource: ColorResource.Colors.FFFFFF), for: .normal)
        button.backgroundColor = UIColor(resource: ColorResource.Colors.ffffffA20)
        button.titleLabel?.font = .addFont(type: .SFProTextSemiBold, size: 15)
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(hideStartButton), for: .touchUpInside)
        return button
    }()
    
//    backgroundView
    
    var backgroundView: UIView = {
       var view = UIView()
        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    var stackViewForProgressAndDescription: UIStackView = {
       var stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = 12
        return stackview
    }()
    
    var progressView: ProgressView = {
       var view = ProgressView()
        view.backgroundColor = UIColor(resource: ColorResource.Colors.EFEBE_9)
        view.heightAnchor.constraint(equalToConstant: 66).isActive = true
        view.layer.cornerRadius = 16
        view.isHidden = true
        return view
    }()
    
    var descriptionLabel: UILabel = {
       var label = UILabel()
        label.font = .addFont(type: .SFProTextRegular, size: 16)
        label.textColor = UIColor(resource: ColorResource.Colors._787878)
        label.numberOfLines = 0
        return label
    }()
    
    // bonusView
    
    var BonusView: UIView = {
       var view = UIView()
        view.backgroundColor = UIColor(resource: ColorResource.Colors.E_0_DEDD)
        view.layer.cornerRadius = 24
        return view
    }()
    
    var patternImageView: UIImageView = {
       var imageview = UIImageView()
        imageview.image = UIImage(resource: ImageResource.Courses.patternCourses)
        imageview.clipsToBounds = true
        return imageview
    }()
    
    var bonusLabel: UILabel = {
       var label = UILabel()
        label.font = .addFont(type: .SFProTextSemiBold, size: 15)
        label.textColor = UIColor(resource: ColorResource.Colors._302_C_28)
        label.numberOfLines = 2
        return label
    }()
    
    var plusBonusUIView: BonusUIView = {
       var view = BonusUIView()
        view.bonusImageview.image = UIImage(resource: ImageResource.Profile.iconBonusBeige)
        view.layer.cornerRadius = 12
        view.backgroundColor = UIColor(resource: ColorResource.Colors.ffffffA60)
        return view
    }()
    
    // calendar
    
    var calendarView: CalendarView = {
        var view = CalendarView()
        view.switchForCalendar.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        view.dayOfClassButton.addTarget(self, action: #selector(showSelectDayViewController), for: .touchUpInside)
        view.timeOfClassButton.addTarget(self, action: #selector(showSelectTimeViewController), for: .touchUpInside)
        return view
    }()
    
    // lessons
    
    var lessonsLabel: UILabel = {
       var label = UILabel()
        label.text = "Уроки"
        label.font = .addFont(type: .SFProDisplayBold, size: 22)
        label.textColor = UIColor(resource: ColorResource.Colors._302_C_28)
        return label
    }()
    
   lazy var collectionView: SelfSizingCollectionView = {
       let layout = UICollectionViewFlowLayout()
       layout.minimumLineSpacing = 12
       layout.estimatedItemSize = .zero
       layout.scrollDirection = .vertical
       let collectionView = SelfSizingCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
       collectionView.delegate = self
       collectionView.dataSource = self
       collectionView.register(LessonCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
       collectionView.collectionViewLayout = layout
       collectionView.showsHorizontalScrollIndicator = false
       collectionView.showsVerticalScrollIndicator = false
       collectionView.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
       collectionView.isScrollEnabled = false
       collectionView.bounces = false
//       collectionView.contentSize.height = 331
          return collectionView
    }()
    
    var notificationView = NotificationView()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getCourseInfo()
        setupView()
        setupConstraints()
        updateData()
        setupNavigation()
        gradientView.updateColors()
        gradientView.updateLocations()
 
        if course.is_started {
            hideStartButton()
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        calendarView.titleForDayLabel.text = ""
        daysForTitle = []
        getDays()
    }
   
    // MARK: - collectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lessonArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LessonCollectionViewCell
        
        cell.setData(lesson: lessonArray[indexPath.row])
        cell.lesson = lessonArray[indexPath.row]
        cell.allLessonCount = lessonArray.count
        
        if lessonArray[indexPath.row].is_favorite {
            cell.favoriteButton.setImage(UIImage(resource: ImageResource.Courses.favoriteSelected), for: .normal)
            print(lessonArray[indexPath.row].name)
        }else{
            cell.favoriteButton.setImage(UIImage(resource: ImageResource.Courses.icFavoriteWhite), for: .normal)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let detailLessonVC = DetailLessonViewController()
        detailLessonVC.lessonId = lessonArray[indexPath.row].id
        detailLessonVC.courseId = course.id
        detailLessonVC.courseName = course.name
        navigationController?.pushViewController(detailLessonVC, animated: true)
        
    }
    
}
extension PageOfCourseViewController {
    
    // MARK: - other funcs
    
    @objc func hideStartButton() {
        
        titleLabelOnPoster.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(256)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        stackViewForPosterSubtitle.snp.remakeConstraints { make in
            make.top.equalTo(titleLabelOnPoster.snp.bottom).inset(-12)
            make.left.equalToSuperview().inset(16)
        }
        startButton.snp.remakeConstraints { make in
            make.top.equalTo(stackViewForPosterSubtitle.snp.bottom).inset(-12)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(0)
        }
        startButton.isHidden = true
        progressView.isHidden = false
        
   
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY > 200 {
            let appearance = UINavigationBarAppearance()

            appearance.backgroundColor = .white

            navigationController?.navigationBar.standardAppearance = appearance
         
            let leftBarButton = UIBarButtonItem(image: UIImage(resource: ImageResource.Profile.iconBack), style: .plain, target: self, action: #selector(goBack))
            leftBarButton.tintColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
            navigationItem.leftBarButtonItem = leftBarButton
            
            let rightBarButton = UIBarButtonItem(image: UIImage(resource: ImageResource.Profile.iconShare), style: .plain, target: self, action: #selector(share))
            navigationItem.rightBarButtonItem = rightBarButton
            rightBarButton.tintColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
            navigationItem.title = "Авторская методика Древмасс"

        }else{
            setupNavigation()
        }
    }
    
    func updateData() {
        
        posterImageView.sd_setImage(with: URL(string: "http://45.12.74.158/\(course.image_src)"))
        titleLabelOnPoster.text = course.name
        
        
        let lessonAttributed = NSMutableAttributedString(string: "\(course.lesson_cnt) ")
        lessonAttributed.addAttributes([.font: UIFont.addFont(type:.SFProTextBold, size: 13), .foregroundColor: UIColor(resource: ColorResource.Colors.FFFFFF)], range: NSRange(location: 0, length: lessonAttributed.length))
        
        let durationAttributed = NSMutableAttributedString(string:  "\(course.duration / 60) ")
        durationAttributed.addAttributes([.font: UIFont.addFont(type: .SFProTextBold, size: 13), .foregroundColor: UIColor(resource: ColorResource.Colors.FFFFFF)], range: NSRange(location: 0, length: durationAttributed.length))
        
        let combinedAttributedString = NSMutableAttributedString()
        
        combinedAttributedString.append(lessonAttributed)
        combinedAttributedString.append(NSAttributedString(string: "уроков · ", attributes: [.font: UIFont.addFont(type: .SFProTextRegular, size: 13), .foregroundColor: UIColor(resource: ColorResource.Colors.FFFFFF)]))
        combinedAttributedString.append(durationAttributed)
        combinedAttributedString.append(NSAttributedString(string: "мин", attributes: [.font: UIFont.addFont(type: .SFProTextRegular, size: 13), .foregroundColor: UIColor(resource: ColorResource.Colors.FFFFFF)]))
        
        subtitleLabel.attributedText = combinedAttributedString
        
        var count = 0
        for lesson in lessonArray {
            if lesson.completed {
                count += 1
            }
        }
        progressView.countLabel.text = "\(count) из \(lessonArray.count)"
        progressView.progressView.progress = Float(count) / Float(lessonArray.count)
        
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    @objc func share() {
        let text = "Я рекомендую тебе курс '\(titleLabelOnPoster.text ?? "")'"
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true)
    }
    
    @objc func switchValueChanged() {
        if calendarView.switchForCalendar.isOn {
            calendarView.dayOfClassButton.isHidden = false
            calendarView.timeOfClassButton.isHidden = false
            calendarView.dayOfClassButton.snp.remakeConstraints { make in
                make.height.equalTo(48)
                make.top.equalTo(calendarView.calendarWithSwitch.snp.bottom)
                make.horizontalEdges.equalToSuperview()
            }
            calendarView.timeOfClassButton.snp.remakeConstraints { make in
                make.height.equalTo(48)
                make.top.equalTo(calendarView.dayOfClassButton.snp.bottom)
                make.horizontalEdges.equalToSuperview()
            }
            calendarView.snp.remakeConstraints { make in
                make.top.equalTo(BonusView.snp.bottom).inset(-24)
                make.horizontalEdges.equalToSuperview().inset(16)
                make.height.equalTo(163)
            }
            
            let parameters: [String: Any] = ["course_id": course.id,
                                             "mon": days.mon,
                                             "tue": days.tue,
                                             "wed": days.wed,
                                             "thu": days.thu,
                                             "fri": days.fri,
                                             "sat": days.sat,
                                             "sun": days.sun,
                                             "time": days.time,
                                             "notificationIsSelected": true]
                
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
        }else{
            calendarView.dayOfClassButton.isHidden = true
            calendarView.timeOfClassButton.isHidden = true
            calendarView.dayOfClassButton.snp.remakeConstraints { make in
                make.height.equalTo(0)
                make.top.equalTo(calendarView.calendarWithSwitch.snp.bottom)
                make.horizontalEdges.equalToSuperview()
            }
            calendarView.timeOfClassButton.snp.remakeConstraints { make in
                make.height.equalTo(0)
                make.top.equalTo(calendarView.dayOfClassButton.snp.bottom)
                make.horizontalEdges.equalToSuperview()
            }
            calendarView.snp.remakeConstraints { make in
                make.top.equalTo(BonusView.snp.bottom).inset(-24)
                make.horizontalEdges.equalToSuperview().inset(16)
                make.height.equalTo(63)
            }
            
            let parameters: [String: Any] = ["course_id": course.id, "notificationIsSelected": false]
                
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
        }
        
    }
    //код повторяется внутри условия с выше функцией
    func changeStateOfSwitch() {
        if days.notificationIsSelected {
            calendarView.switchForCalendar.isOn = true
            calendarView.dayOfClassButton.isHidden = false
            calendarView.timeOfClassButton.isHidden = false
            calendarView.dayOfClassButton.snp.remakeConstraints { make in
                make.height.equalTo(48)
                make.top.equalTo(calendarView.calendarWithSwitch.snp.bottom)
                make.horizontalEdges.equalToSuperview()
            }
            calendarView.timeOfClassButton.snp.remakeConstraints { make in
                make.height.equalTo(48)
                make.top.equalTo(calendarView.dayOfClassButton.snp.bottom)
                make.horizontalEdges.equalToSuperview()
            }
            calendarView.snp.remakeConstraints { make in
                make.top.equalTo(BonusView.snp.bottom).inset(-24)
                make.horizontalEdges.equalToSuperview().inset(16)
                make.height.equalTo(163)
            }
        }else{
            calendarView.switchForCalendar.isOn = false
            calendarView.dayOfClassButton.isHidden = true
            calendarView.timeOfClassButton.isHidden = true
            calendarView.dayOfClassButton.snp.remakeConstraints { make in
                make.height.equalTo(0)
                make.top.equalTo(calendarView.calendarWithSwitch.snp.bottom)
                make.horizontalEdges.equalToSuperview()
            }
            calendarView.timeOfClassButton.snp.remakeConstraints { make in
                make.height.equalTo(0)
                make.top.equalTo(calendarView.dayOfClassButton.snp.bottom)
                make.horizontalEdges.equalToSuperview()
            }
            calendarView.snp.remakeConstraints { make in
                make.top.equalTo(BonusView.snp.bottom).inset(-24)
                make.horizontalEdges.equalToSuperview().inset(16)
                make.height.equalTo(63)
            }
        }
    }
    
    @objc func showSelectDayViewController() {
        
        let selectDayVC = SelectDayViewController()
        selectDayVC.hidesBottomBarWhenPushed = true
        selectDayVC.modalPresentationStyle = .overFullScreen
        selectDayVC.courseId = course.id
        presentPanModal(selectDayVC)
    }
    @objc func showSelectTimeViewController() {
        
        let selectTimeVC = SelectTimeViewController()
        selectTimeVC.hidesBottomBarWhenPushed = true
        selectTimeVC.modalPresentationStyle = .overFullScreen
        selectTimeVC.courseId = course.id
        presentPanModal(selectTimeVC)
    }
    
    // MARK: - network
    
    func getDays() {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AuthenticationService.shared.token)"
        ]
        AF.request(URLs.GET_DAY_URL + "/\(course.id)", method: .get, headers: headers).responseData { response in
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
            }
                if response.response?.statusCode == 200 {
                    let json = JSON(response.data!)
                    print("JSON: \(json)")
                    self.days = Days(json: json)
                    
                    if self.days.mon { self.daysForTitle.append("Пн") }
                    if self.days.tue { self.daysForTitle.append("Вт") }
                    if self.days.wed { self.daysForTitle.append("Ср") }
                    if self.days.thu { self.daysForTitle.append("Чт") }
                    if self.days.fri { self.daysForTitle.append("Пт") }
                    if self.days.sat { self.daysForTitle.append("Сб") }
                    if self.days.sun { self.daysForTitle.append("Вс") }
                   
                    if self.daysForTitle.count == 7 {
                        self.calendarView.titleForDayLabel.text = "Каждый день"
                    }else{
                        for day in self.daysForTitle {
                            self.calendarView.titleForDayLabel.text! += " \(day),"
                        }
                        // удалить последнюю запятую
                    }
                    
                    self.calendarView.titleForTimeLabel.text = self.days.time
                    self.changeStateOfSwitch()
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
    
    func getCourseInfo() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AuthenticationService.shared.token)"
        ]
        AF.request(URLs.GET_COURSE_BY_ID_URL + String(course.id), method: .get, headers: headers).responseData { [self] response in
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
            }
                if response.response?.statusCode == 200 {
                    let json = JSON(response.data!)
                    print("JSON: \(json)")
                    
                    self.courseById = CourseById(json: json)
                    self.course = Course(json: json["course"])
                    self.courseBonus = CourseBonus(json: json["course"]["bonus_info"])
                    bonusLabel.text = "Начислим \(courseBonus.price) бонусов за прохождение курса"
                    plusBonusUIView.bonusTitleLabel.text = "+\(courseBonus.price)"
                    descriptionLabel.text = course.description
                    if let array = json["course"]["lessons"].array {
                        for item in array {
                            let lesson = LessonsById(json: item)
                            self.lessonArray.append(lesson)
                        }
                    }
                    updateData()
                    collectionView.reloadData()
                    
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
        
        let appearance = UINavigationBarAppearance()
       appearance.configureWithTransparentBackground()

       navigationController?.navigationBar.standardAppearance = appearance
        
        navigationController?.navigationBar.standardAppearance.awakeFromNib()
        
        let leftBarButton = UIBarButtonItem(image: UIImage(resource: ImageResource.Profile.iconBack), style: .plain, target: self, action: #selector(goBack))
        leftBarButton.tintColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        navigationItem.leftBarButtonItem = leftBarButton
        
        let rightBarButton = UIBarButtonItem(image: UIImage(resource: ImageResource.Profile.iconShare), style: .plain, target: self, action: #selector(share))
        navigationItem.rightBarButtonItem = rightBarButton
        rightBarButton.tintColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        navigationItem.title = ""
    }
    
    func setupView() {
        view.backgroundColor = UIColor(resource: ColorResource.Colors.CDC_9_C_1)
        view.addSubview(scrollView)
        scrollView.addSubview(contentview)
        contentview.addSubview(posterImageView)
        contentview.addSubview(gradientView)
        contentview.addSubview(titleLabelOnPoster)
        contentview.addSubview(stackViewForPosterSubtitle)
        stackViewForPosterSubtitle.addArrangedSubview(playImageView)
        stackViewForPosterSubtitle.addArrangedSubview(subtitleLabel)
        contentview.addSubview(startButton)
        contentview.addSubview(backgroundView)
        
        backgroundView.addSubview(stackViewForProgressAndDescription)
        stackViewForProgressAndDescription.addArrangedSubview(progressView)
        stackViewForProgressAndDescription.addArrangedSubview(descriptionLabel)
        
        backgroundView.addSubview(BonusView)
        BonusView.addSubview(patternImageView)
        BonusView.addSubview(bonusLabel)
        BonusView.addSubview(plusBonusUIView)
        backgroundView.addSubview(calendarView)
        backgroundView.addSubview(lessonsLabel)
        backgroundView.addSubview(collectionView)
        
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
//            make.top.bottom.equalToSuperview()
//            make.horizontalEdges.equalToSuperview()
        }
        contentview.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        posterImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(420)
        }
        gradientView.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.top).inset(183)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(237)
        }
        titleLabelOnPoster.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(200)
            make.horizontalEdges.equalTo(16)
        }
        stackViewForPosterSubtitle.snp.makeConstraints { make in
            make.top.equalTo(titleLabelOnPoster.snp.bottom).inset(-12)
            make.left.equalToSuperview().inset(16)
        }
        startButton.snp.makeConstraints { make in
            make.top.equalTo(stackViewForPosterSubtitle.snp.bottom).inset(-12)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.top).inset(376)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        stackViewForProgressAndDescription.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        BonusView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).inset(-24)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(72)
        }
        patternImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
        plusBonusUIView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(24)
        }
        bonusLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(20)
            make.width.equalTo(205)
        }
        
        if days.notificationIsSelected {
            calendarView.snp.makeConstraints { make in
                make.top.equalTo(BonusView.snp.bottom).inset(-24)
                make.horizontalEdges.equalToSuperview().inset(16)
                make.height.equalTo(163)
            }
        }else {
            calendarView.snp.makeConstraints { make in
                make.top.equalTo(BonusView.snp.bottom).inset(-24)
                make.horizontalEdges.equalToSuperview().inset(16)
                make.height.equalTo(63)
            }
        }
        lessonsLabel.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).inset(-24)
            make.left.equalToSuperview().inset(16)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(lessonsLabel.snp.bottom).inset(-16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(24)
        }
    }
}

extension PageOfCourseViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - 32
        return CGSize(width: width, height: width)
    }
   
}

