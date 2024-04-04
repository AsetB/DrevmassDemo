//
//  FavoriteViewController.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 22.03.2024.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class FavoriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var favorite: [Favorite] = []
    
//    var lessonArray: [LessonsById] = []
//    var courseName: [String] = []
    
    var illustrationImageView: UIImageView = {
       var imageview = UIImageView()
        imageview.image = UIImage(resource: ImageResource.Courses.ilustration112)
        imageview.frame.size = CGSize(width: 112, height: 112)
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        return imageview
    }()
    
    var illustrationTitleLabel: UILabel = {
       var label = UILabel()
        label.text = "В закладках пока ничего нет"
        label.font = .addFont(type: .SFProTextSemiBold, size: 17)
        label.textColor = UIColor(resource: ColorResource.Colors._181715)
        label.textAlignment = .center
        return label
    }() 
    
    var illustrationSubtitleLabel: UILabel = {
       var label = UILabel()
        label.text = "Смотрите курсы и сохраняйте полезные уроки здесь"
        label.font = .addFont(type: .SFProTextRegular, size: 16)
        label.textColor = UIColor(resource: ColorResource.Colors._989898)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.separatorInset.bottom = 24
        tableView.register(FavoriteCourseTableViewCell.self, forCellReuseIdentifier: "Cell")
//        tableView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
        return tableView
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()
        setupNavigation()
        getFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.addFont(type: .SFProDisplayBold, size: 28), .foregroundColor: UIColor(resource: ColorResource.Colors._302_C_28)]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(resource: ColorResource.Colors._302_C_28)]
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.title = "Мои закладки"
    }
    
    
    // MARK: - tableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorite.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FavoriteCourseTableViewCell
        
        cell.titleLabel.text = favorite[indexPath.row].course_name
        cell.lessonArray = favorite[indexPath.row].lessons
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 286
        return 310
    }
}

extension FavoriteViewController {
    
    // MARK: - other func
    
    @objc func dismissVC() {
        navigationController?.popViewController(animated: true)
    }
    
    func checkingFavorites() {
        if favorite.isEmpty == false {
            tableView.snp.remakeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
                make.right.equalToSuperview()
                make.left.equalToSuperview().inset(16)
                make.bottom.equalToSuperview()
            }
            print("\(favorite.count) во vc")
        }
    }
    
    // MARK: - network
    
    func getFavorites() {
        SVProgressHUD.show()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AuthenticationService.shared.token)"
        ]
        AF.request(URLs.FAVORITE_URL, method: .get, headers: headers).responseData { response in
            
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8) ?? ""
            }
                if response.response?.statusCode == 200 {
                    let json = JSON(response.data!)
                    print("JSON: \(json)")
    
                    if let array = json.array {
                        for item in array {
                            let favor = Favorite(json: item)
                            self.favorite.append(favor)
                        }
                    }

                    self.tableView.reloadData()
                }else{
                    var ErrorString = "CONNECTION_ERROR"
                    if let sCode = response.response?.statusCode{
                        ErrorString = ErrorString + "\(sCode)"
                    }
                    ErrorString = ErrorString + "\(resultString)"
                    SVProgressHUD.showError(withStatus: "\(ErrorString)")
                }
            self.checkingFavorites()
        }
        
    }
    
 
    
    // MARK: - setups
    
    func setupNavigation() {
        navigationController?.navigationBar.tintColor =  UIColor(resource: ColorResource.Colors.B_5_A_380)

    }
    
    func setupView() {
        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        view.addSubview(illustrationImageView)
        view.addSubview(illustrationTitleLabel)
        view.addSubview(illustrationSubtitleLabel)
        view.addSubview(tableView)
    }
    
    func setupConstraints() {

        illustrationImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(120)
        }
        illustrationTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(illustrationImageView.snp.bottom).inset(-24)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        illustrationSubtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(illustrationTitleLabel.snp.bottom).inset(-4)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(illustrationImageView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
}
