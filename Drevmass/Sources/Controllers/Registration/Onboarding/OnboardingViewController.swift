//
//  OnboardingViewController.swift
//  Drevmass
//
//  Created by Aset Bakirov on 04.03.2024.
//

import UIKit
import SnapKit

class OnboardingViewController: UIViewController, SGSegmentedProgressBarDataSource, SGSegmentedProgressBarDelegate {
    //- MARK: - Local outlets
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.bounces = false
        scrollView.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        var image = UIImageView()
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        image.image = UIImage(resource: ImageResource.Onboarding.image1)
        return image
    }()
    
    private lazy var topLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .addFont(type: .SFProDisplayBold, size: 28)
        label.textColor = UIColor(resource: ColorResource.Colors._181715)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .addFont(type: .SFProTextRegular, size: 17)
        label.textColor = UIColor(resource: ColorResource.Colors._787878)
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вход", for: .normal)
        button.setTitleColor(UIColor(resource: ColorResource.Colors.FFFFFF), for: .normal)
        button.titleLabel?.font = .addFont(type: .SFProTextSemiBold, size: 17)
        button.layer.cornerRadius = 28
        button.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        button.addTarget(self, action: #selector(goToSignIn), for: .touchUpInside)
        return button
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Регистрация", for: .normal)
        button.setTitleColor(UIColor(resource: ColorResource.Colors.B_5_A_380), for: .normal)
        button.titleLabel?.font = .addFont(type: .SFProTextSemiBold, size: 17)
        button.layer.cornerRadius = 28
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(resource: ColorResource.Colors.B_5_A_380).cgColor
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(goToSignUp), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonContainer: UIView = {
        let container = UIView()
        return container
    }()
    
    private lazy var leftView: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(tappedLeftOfView), for: .touchUpInside)
        return button
    }()
    
    private lazy var rightView: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(tappedRightOfView), for: .touchUpInside)
        return button
    }()
    
    private var segmentBar: SGSegmentedProgressBar?
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        setSegmentBar()
        setViews()
        setConstraints()
        setData()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        imageView.image = UIImage(resource: ImageResource.Onboarding.image1)
        self.segmentBar?.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.title = " "
        self.segmentBar?.reset()
    }
    //- MARK: - Set Views
    private func setViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(self.segmentBar!)
        contentView.addSubview(topLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(leftView)
        contentView.addSubview(rightView)
        contentView.addSubview(buttonContainer)
        buttonContainer.addSubview(signInButton)
        buttonContainer.addSubview(signUpButton)
    }
    //- MARK: - Constraints
    private func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.edges.horizontalEdges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalTo(scrollView.frameLayoutGuide).priority(.medium)
        }
        imageView.snp.makeConstraints { make in
            //make.top.equalToSuperview()
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            //make.height.equalTo(646)
        }
        topLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.top).inset(30)
            make.horizontalEdges.equalTo(imageView).inset(24)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(imageView).inset(24)
        }
        leftView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.top)
            make.bottom.equalTo(imageView.snp.bottom)
            make.leading.equalTo(imageView.snp.leading)
            make.trailing.equalToSuperview().inset(220)
        }
        rightView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.top)
            make.bottom.equalTo(imageView.snp.bottom)
            make.trailing.equalTo(imageView.snp.trailing)
            make.leading.equalToSuperview().inset(220)
        }
        buttonContainer.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            //make.bottom.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            //make.width.equalTo(343)
            make.height.equalTo(56)
            make.centerX.equalToSuperview()
        }
        signInButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(56)
            make.width.equalTo(167.5)
            make.leading.equalToSuperview()
            make.trailing.equalTo(signUpButton.snp.leading).inset(-8)
        }
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.leading.equalTo(signInButton.snp.trailing).inset(-8)
            make.trailing.equalToSuperview()
            make.height.equalTo(56)
        }
        segmentBar!.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.top).inset(8)
            make.horizontalEdges.equalTo(imageView).inset(16)
        }
    }
    //- MARK: - Set Data
    func setData() {
        topLabel.text = Onboarding.topLabel1
        descriptionLabel.text = Onboarding.descriptionLabel
    }
    //- MARK: - Button Actions
    @objc func goToSignIn() {
        let signUpVC = SignInViewController()
        navigationController?.show(signUpVC, sender: self)
    }
    @objc func goToSignUp() {
        let signUpVC = SignUpViewController()
        navigationController?.show(signUpVC, sender: self)
    }
    @objc func tappedLeftOfView() {
        self.segmentBar?.previousSegment()
        guard let currentPlayingIndex = self.segmentBar?.currentIndex else { return }
        if currentPlayingIndex == 0 {
            imageView.image = UIImage(resource: ImageResource.Onboarding.image1)
            topLabel.text = Onboarding.topLabel1
        }
        if currentPlayingIndex == 1 {
            imageView.image = UIImage(resource: ImageResource.Onboarding.image2)
            topLabel.text = Onboarding.topLabel2
        }
        if currentPlayingIndex == 2 {
            imageView.image = UIImage(resource: ImageResource.Onboarding.image3)
            topLabel.text = Onboarding.topLabel3
        }
    }

    @objc func tappedRightOfView() {
        segmentedProgressBarFinished(finishedIndex: 0, isLastIndex: false)
        self.segmentBar?.nextSegment()
    }
    //- MARK: - Set SegmentBar
    func setSegmentBar() {
        let rect = CGRect(x: 20, y: 100, width: self.view.frame.size.width-40, height: 2)
        self.segmentBar = SGSegmentedProgressBar(frame: rect, delegate: self, dataSource: self)
    }
    func segmentedProgressBarFinished(finishedIndex: Int, isLastIndex: Bool) {
        guard let currentPlayingIndex = self.segmentBar?.currentIndex else { return }
        if currentPlayingIndex == 0 {
            imageView.image = UIImage(resource: ImageResource.Onboarding.image2)
            topLabel.text = Onboarding.topLabel2
        }
        if currentPlayingIndex == 1 {
            imageView.image = UIImage(resource: ImageResource.Onboarding.image3)
            topLabel.text = Onboarding.topLabel3
        }
    }
    
    var numberOfSegments: Int = 3
    
    var segmentDuration: TimeInterval = 4.0
    
    var paddingBetweenSegments: CGFloat = 2.0
    
    var trackColor: UIColor { return UIColor(resource: ColorResource.Colors._302C28A30) }
    
    var progressColor: UIColor {  return UIColor(resource: ColorResource.Colors.FFFFFF) }
    
    var roundCornerType: SGCornerType { return .roundCornerBar(cornerRadious: 5) }
}
    
    

