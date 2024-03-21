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

protocol DidSelectCellDayProtocol {
    func chanceLabel(array: [String])
}

class PageOfCourseViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate{
    
//    func chanceLabel(array: [String]) {
//        <#code#>
//    }
    

    var course = Course()
    var courseBonus = CourseBonus()
    var courseById = CourseById()
    var lessonArray: [Lesson] = []
    
    
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
    
    var gradientView: GradientView = {
       var gradient = GradientView()
        gradient.endColor = UIColor(resource: ColorResource.Colors._161616)
        gradient.startColor = UIColor(resource: ColorResource.Colors._161616A0)
        return gradient
    }()
    
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
    
    var stackViewForCalendar: UIStackView = {
       var stackview = UIStackView()
        stackview.axis = .vertical
        stackview.layer.cornerRadius = 20
        stackview.layer.borderWidth = 2
        stackview.layer.borderColor = UIColor(resource: ColorResource.Colors.EFEBE_9).cgColor
//        stackview.layoutMargins = UIEdgeInsets(top: 4, left: 0, bottom: 8, right: 0)
        return stackview
    }()
    
    var calendarWithSwitch: Button = {
        var button = Button()
        button.setTitle("Календарь занятий", for: .normal)
        button.leftIcon.image = UIImage(resource: ImageResource.Courses.icCalendar)
        button.setTitleColor(UIColor(resource: ColorResource.Colors._302_C_28), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 63).isActive = true
        button.layer.borderWidth = 0
        return button
    }()
    
    var switchForCalendar: UISwitch = {
       var switchForCalendar = UISwitch()
        switchForCalendar.onTintColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        switchForCalendar.frame.size = CGSize(width: 51, height: 31)
        switchForCalendar.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        return switchForCalendar
    }()
    
    var dayOfClassButton: Button = {
       var button = Button()
        button.setTitle("Дни занятий", for: .normal)
        button.titleLabel?.font = .addFont(type: .SFProTextRegular, size: 17)
        button.setTitleColor(UIColor(resource: ColorResource.Colors._302_C_28), for: .normal)
        button.rightIcon.image = UIImage(resource: ImageResource.Profile.arrowBeigeProfile)
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.layer.borderWidth = 0
        button.leftIcon.isHidden = true
        button.contentEdgeInsets.left = 16
        button.isHidden = true
        button.addTarget(self, action: #selector(showSelectDayViewController), for: .touchUpInside)
        return button
    }()
    
    var titleForDayLabel: UILabel = {
       var label = UILabel()
        label.text = "Пн"
        label.textColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        label.font = .addFont(type: .SFProTextSemiBold, size: 17)
        return label
    }()   
    
    var timeOfClassButton: Button = {
       var button = Button()
        button.setTitle("Время", for: .normal)
        button.titleLabel?.font = .addFont(type: .SFProTextRegular, size: 17)
        button.setTitleColor(UIColor(resource: ColorResource.Colors._302_C_28), for: .normal)
        button.rightIcon.image = UIImage(resource: ImageResource.Profile.arrowBeigeProfile)
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.layer.borderWidth = 0
        button.leftIcon.isHidden = true
        button.contentEdgeInsets.left = 16
        button.isHidden = true
        return button
    }()
    
    var titleForTimeLabel: UILabel = {
       var label = UILabel()
        label.text = "9:00"
        label.textColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        label.font = .addFont(type: .SFProTextSemiBold, size: 17)
        return label
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
       collectionView.contentSize.height = 331
          return collectionView
    }()
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getCourseInfo()
        setupView()
        setupConstraints()
        setData()
        setupNavigation()
        
    }
    
    // MARK: - collectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lessonArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LessonCollectionViewCell
        
        cell.setData(lesson: lessonArray[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let detailLessonVC = DetailLessonViewController()
        detailLessonVC.lesson = lessonArray[indexPath.row]
        navigationController?.pushViewController(detailLessonVC, animated: true)
        
    }
    
}
extension PageOfCourseViewController {
    
    // MARK: - other funcs
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY > 88 {
            let leftBarButton = UIBarButtonItem(image: UIImage(resource: ImageResource.Profile.iconBack), style: .plain, target: self, action: #selector(goBack))
            leftBarButton.tintColor = UIColor(resource: ColorResource.Colors._302_C_28)
            navigationItem.leftBarButtonItem = leftBarButton
            
            let rightBarButton = UIBarButtonItem(image: UIImage(resource: ImageResource.Profile.iconShare), style: .plain, target: self, action: #selector(share))
            navigationItem.rightBarButtonItem = rightBarButton
            rightBarButton.tintColor = UIColor(resource: ColorResource.Colors._302_C_28)
            
//            navigationItem.title = "Авторская методика Древмасс"
//            navigationController?.navigationBar.isTranslucent = true
        }else{
            setupNavigation()
        }
    }
    
    func setData() {
        
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
        if switchForCalendar.isOn {
            dayOfClassButton.isHidden = false
            timeOfClassButton.isHidden = false
        }else{
            dayOfClassButton.isHidden = true
            timeOfClassButton.isHidden = true
        }
        
//        let userDefaults = UserDefaults.standard.setValue(switchForCalendar.isOn, forKey: "switchCalendar")
    }
    
    
    @objc func showSelectDayViewController() {
        
        let selectDayVC = SelectDayViewController()
        selectDayVC.hidesBottomBarWhenPushed = true
        selectDayVC.modalPresentationStyle = .overFullScreen
        presentPanModal(selectDayVC)
    }
    
    // MARK: - network
    
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
                            let lesson = Lesson(json: item)
                            self.lessonArray.append(lesson)
                        }
                    }
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
        
        backgroundView.addSubview(descriptionLabel)
        backgroundView.addSubview(BonusView)
        BonusView.addSubview(patternImageView)
        BonusView.addSubview(bonusLabel)
        BonusView.addSubview(plusBonusUIView)
        backgroundView.addSubview(stackViewForCalendar)
        
        stackViewForCalendar.addArrangedSubview(calendarWithSwitch)
        calendarWithSwitch.addSubview(switchForCalendar)
        stackViewForCalendar.addArrangedSubview(dayOfClassButton)
        dayOfClassButton.addSubview(titleForDayLabel)
        stackViewForCalendar.addArrangedSubview(timeOfClassButton)
        timeOfClassButton.addSubview(titleForTimeLabel)
        
        backgroundView.addSubview(lessonsLabel)
        backgroundView.addSubview(collectionView)
        
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
//            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
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
        descriptionLabel.snp.makeConstraints { make in
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
        stackViewForCalendar.snp.makeConstraints { make in
            make.top.equalTo(BonusView.snp.bottom).inset(-24)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        switchForCalendar.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
        }
        titleForDayLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(40)
        } 
        titleForTimeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(40)
        }
        lessonsLabel.snp.makeConstraints { make in
            make.top.equalTo(stackViewForCalendar.snp.bottom).inset(-24)
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

