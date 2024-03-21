//
//  DetailLessonViewController.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 20.03.2024.
//

import UIKit

class DetailLessonViewController: UIViewController {
    
    var lesson = Lesson()
    
    // MARK: - UI elements
    
    var posterButton: UIButton = {
        var button = UIButton()
       button.contentMode = .scaleAspectFill
       button.clipsToBounds = true
       button.layer.cornerRadius = 24
        return button
    }()

    
    // MARK: -Lificycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()
        setupNavigation()
        posterButton.setImage(UIImage(named: "http://45.12.74.158/\(lesson.image_src)"), for: .normal)
    }
    

}

extension DetailLessonViewController {
    
    // MARK: - other funcs
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    @objc func share() {
//        let text = "Я рекомендую тебе курс '\(titleLabelOnPoster.text ?? "")'"
//        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
//        activityVC.popoverPresentationController?.sourceView = self.view
//        self.present(activityVC, animated: true)
    }
    
    // MARK: - setups
    
    func setupNavigation() {
        let leftBarButton = UIBarButtonItem(image: UIImage(resource: ImageResource.Profile.iconBack), style: .plain, target: self, action: #selector(goBack))
        leftBarButton.tintColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        navigationItem.leftBarButtonItem = leftBarButton
        
        let rightBarButton = UIBarButtonItem(image: UIImage(resource: ImageResource.Profile.iconShare), style: .plain, target: self, action: #selector(share))
        navigationItem.rightBarButtonItem = rightBarButton
        rightBarButton.tintColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        navigationItem.title = ""
    }
    
    func setupView() {
        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        view.addSubview(posterButton)
    }
    
    func setupConstraints() {
        posterButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(212)
        }
    }
}
