//
//  MyPointsViewController.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 05.03.2024.
//

import UIKit
import SnapKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class MyPointsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var bonus = Bonus()
    var transactionBonusArray: [TransactionsBonus] = []
    
    
    // - MARK: - IU elements
    var scrollView: UIScrollView = {
        var scrollview = UIScrollView()
        scrollview.backgroundColor = .clear
        scrollview.showsVerticalScrollIndicator = true
        scrollview.isScrollEnabled = true
        scrollview.clipsToBounds = true
        scrollview.contentMode = .scaleAspectFill
        scrollview.contentInsetAdjustmentBehavior = .never
        return scrollview
    }()
    var contentview: UIView = {
        var view = UIView()
        view.backgroundColor = .Colors.B_5_A_380
        return view
    }()
    
    var patternTreeImageview: UIImageView = {
        var imageview = UIImageView()
        imageview.image = .Profile.patternMyPointsProfile
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        return imageview
    }()
    
    var iconBonus: UIImageView = {
        var imageview = UIImageView()
        imageview.image = .Profile.iconBonusProfile
        imageview.contentMode = .scaleAspectFit
        imageview.clipsToBounds = true
        return imageview
    }()
    
    var pointsLabel: UILabel = {
        var label = UILabel()
        label.textColor = .Colors.FFFFFF
        label.font = UIFont(name: "SFProDisplay-Bold", size: 34)
        label.text = "0"
        return label
    }()
    
    var stackViewForBonus: UIStackView = {
        var stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = 12
        return stackview
    }()
    
    var bonusToRUBLabel: UILabel = {
        var label = UILabel()
        label.textColor = .Colors.FFFFFF
        label.font = UIFont(name: "SFProText-Semibold", size: 15)
        label.text = "1 балл = 1 ₽"
        return label
    }()
    
    var bonusExpireLabel: UILabel = {
        var label = UILabel()
        label.textColor = .Colors.FFFFFF
        label.font = UIFont(name: "SFProText-Regular", size: 13)
        // доделать атрибутер стринг
        label.text = "400 сгорят 22.12.27"
        //        label.isHidden = true
        label.backgroundColor = .Colors._302C28A20
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        return label
    }()
    
    //  viewMain
    var viewMain: ViewNoTransactions = {
        var view = ViewNoTransactions()
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    // UI TableView
    lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(BonusHistoryTableViewCell.self, forCellReuseIdentifier: "BonusHistoryCell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        //
        //        if transactionBonusArray.isEmpty == false {
        //            aboutBonusTitlteLabel.isHidden
        //            aboutBonusSubtitlteLabel.isHidden
        //            twoEmptyBonusesEmageView.isHidden
        //        }
    }
    
    // - MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bonus.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BonusHistoryCell", for: indexPath) as! BonusHistoryTableViewCell
        
        
        cell.titleLabel.text = transactionBonusArray[indexPath.row].description
        cell.subtitleLabel.text = transactionBonusArray[indexPath.row].transaction_date
        cell.bonusLabel.text = "\(transactionBonusArray[indexPath.row].transaction_type)\(transactionBonusArray[indexPath.row].promo_price) "
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

extension MyPointsViewController {
    
    func downlaodTransactions() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiQXNldCIsImlkIjoxMjZ9.AhS0U4qjjRB1f-D63GkyFsOPDrwLsyen5y1av-o1vf4"
        ]
        AF.request(Urls.GET_BONUS_URL, method: .get, headers: headers).responseData { [self] response in
          
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            if response.response?.statusCode == 200{
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let array = json.array {
                    for item in array {
                        let transactions = TransactionsBonus(json: item)
                        self.transactionBonusArray.append(transactions)
                    }
                    self.tableView.reloadData()
                } else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR")
                }
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
    
    func setupView() {
        view.backgroundColor = .Colors.FFFFFF
        navigationItem.title = "Мои баллы"
        var leftBarButton = UIBarButtonItem(image: .Profile.iconBack, style: .plain, target: self, action: nil)
//        var rightBarButton = UIBarButtonItem(image: .Profile.iconInfoBeigeProfile, style: .plain, target: self, action: nil)
        navigationItem.setLeftBarButton(leftBarButton, animated: true)
//        navigationItem.setRightBarButton(rightBarButton, animated: true)
//        rightBarButton.tintColor = .white
        leftBarButton.tintColor = .white

        view.addSubview(scrollView)
        scrollView.addSubview(contentview)
        contentview.addSubview(patternTreeImageview)
        contentview.addSubview(iconBonus)
        contentview.addSubview(pointsLabel)
        contentview.addSubview(stackViewForBonus)
        stackViewForBonus.addArrangedSubview(bonusToRUBLabel)
        stackViewForBonus.addArrangedSubview(bonusExpireLabel)
        contentview.addSubview(viewMain)

//        contentview.addSubview(tableView)
        
        
        
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        contentview.snp.makeConstraints { make in
            make.horizontalEdges.top.bottom.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            
        }
        patternTreeImageview.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.left.equalTo(105)
            make.bottom.equalTo(viewMain.snp.top)
        }
        iconBonus.snp.makeConstraints { make in
            make.height.width.equalTo(32)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(36)
            make.left.equalToSuperview().inset(16)
        }
        pointsLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.left.equalTo(iconBonus.snp.right).inset(-8)
            make.right.equalToSuperview().inset(16)
        }
        stackViewForBonus.snp.makeConstraints { make in
            make.top.equalTo(pointsLabel.snp.bottom).inset(-4)
            make.left.equalToSuperview().inset(16)
        }
        
        viewMain.snp.makeConstraints { make in
            make.top.equalTo(stackViewForBonus.snp.bottom).inset(-32)
            make.horizontalEdges.bottom.equalToSuperview()
        }

        
//        tableView.snp.makeConstraints { make in
//            make.top.equalTo(-4)
//            make.horizontalEdges.equalToSuperview().inset(16)
//           
//        }
    }
}
