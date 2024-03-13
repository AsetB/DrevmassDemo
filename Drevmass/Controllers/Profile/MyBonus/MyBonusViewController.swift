//
//  MyBonusViewController.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 05.03.2024.
//

import UIKit
import SnapKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
 
class MyBonusViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var burningBonus = BurningBonus()
    var transactionBonusArray: [Transactions] = []
    
    
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
        view.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
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
        label.textColor = UIColor(resource: ColorResource.Colors.FFFFFF)
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
        label.textColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        label.font = UIFont(name: "SFProText-Semibold", size: 15)
        label.text = "1 балл = 1 ₽"
        return label
    }()

   lazy var burningBonusLabel: UILabel = {
        var label = UILabel()
        label.textColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        label.font = UIFont(name: "SFProText-Regular", size: 13)
        label.backgroundColor = UIColor(resource: ColorResource.Colors._302C28A20) 
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        return label
    }()
    
    //  viewMain
    var transactionsView: NoTransactionsUIView = {
        var view = NoTransactionsUIView()
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    // UI TableView
    lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        tableView.separatorStyle = .none
        tableView.register(BonusHistoryTableViewCell.self, forCellReuseIdentifier: "BonusHistoryCell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNavigationBar()
        setupConstraints()
        downlaodTransactions()
        
        if burningBonus.burning_date.isEmpty {
            burningBonusLabel.isHidden = true
        }else{
      //            ПРОВЕРИТЬ ПРАВИЛЬНО ЛИ ПЕРЕДАЮТСЯ ДАННЫЕ
            let firstAttributedString = NSAttributedString(string: " 🔥 \(burningBonus.bonus)", attributes: [.font : UIFont.addFont(type: .SFProTextBold , size: 13), .foregroundColor : UIColor(resource: ColorResource.Colors.FFFFFF) ])
            let secondAttributedString = NSAttributedString(string: "\(burningBonus.burning_date) ", attributes: [.font : UIFont.addFont(type: .SFProTextRegular , size: 13), .foregroundColor : UIColor(resource: ColorResource.Colors.FFFFFF) ])
            
            let combinedString = NSMutableAttributedString()
            combinedString.append(firstAttributedString)
            combinedString.append(secondAttributedString)
            burningBonusLabel.attributedText = combinedString
        }
    }
    
    // - MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionBonusArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BonusHistoryCell", for: indexPath) as! BonusHistoryTableViewCell
        
        
        cell.titleLabel.text = transactionBonusArray[indexPath.row].description
        cell.subtitleLabel.text = transactionBonusArray[indexPath.row].transaction_date
        
        //ПРОВЕРЬТЕ НИЖНИЙ КОД ПРАВИЛЬНО ЛИ Я ЕГО НАПИСАЛА ДЛЯ МИНУСОВЫХ ТРАНЗАКЦИЙ
        if transactionBonusArray[indexPath.row].promo_price == 0 {
            cell.bonusLabel.text = "\(transactionBonusArray[indexPath.row].promo_price)"
        }else{
            cell.bonusLabel.text = "\(transactionBonusArray[indexPath.row].transaction_type)\(transactionBonusArray[indexPath.row].promo_price) "
        }
        
        if transactionBonusArray[indexPath.row].transaction_type == "-" {
            cell.bonusLabel.textColor = UIColor(resource: ColorResource.Colors.FA_5_C_5_C) 
        }
        
           let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
           if let date = dateFormatter.date(from: transactionBonusArray[indexPath.row].transaction_date){
                dateFormatter.dateFormat = "dd MMM yyyy"
            cell.subtitleLabel.text = dateFormatter.string(from: date)
            }

        return cell
    }
}
// - MARK: - Extension MyBonusViewController
extension MyBonusViewController {
    
    func chekingTransactions() {
        
        if transactionBonusArray.description.isEmpty == false {
            tableView.snp.remakeConstraints { make in
                make.top.equalTo(transactionsView.historyPointsLabel.snp.bottom).inset(-4)
                make.horizontalEdges.equalToSuperview().inset(16)
                make.bottom.equalTo(view.safeAreaLayoutGuide)
            }
        }
    }
    
   @objc func showInfoVC() {
        let infoVc = InformationViewController()
       navigationController?.modalPresentationStyle = .overFullScreen
       present(infoVc, animated: true)
    }
    @objc func dismissView() {
        navigationController?.popViewController(animated: true)
    }
    
    func downlaodTransactions() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AuthenticationService.shared.token)"
        ]
        AF.request(URLs.GET_BONUS_URL, method: .get, headers: headers).responseData { response in
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200{
            
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                self.pointsLabel.text = String(json["bonus"].int ?? 0)
                
               
                if let arrayTransactions = json["Transactions"].array{
                    for item in arrayTransactions {
                        let transactions = Transactions(json: item)
                        self.transactionBonusArray.append(transactions)
                    }
                    self.tableView.reloadData()
    
                }else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR")
                }
                
                if let burningBonus = json["Burning"]["bonus"].int{
                    self.burningBonus.bonus = burningBonus
                }
                
                if let burningDate = json["Burning"]["burning_date"].string{
                    self.burningBonus.burning_date = burningDate
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
        chekingTransactions()
    }
    
    // - MARK: - setups
    
    func setupView() {
        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        view.addSubview(scrollView)
        scrollView.addSubview(contentview)
        contentview.addSubview(patternTreeImageview)
        contentview.addSubview(iconBonus)
        contentview.addSubview(pointsLabel)
        contentview.addSubview(stackViewForBonus)
        stackViewForBonus.addArrangedSubview(bonusToRUBLabel)
        stackViewForBonus.addArrangedSubview(burningBonusLabel)
        contentview.addSubview(transactionsView)
        contentview.addSubview(tableView)
    }
    func setupNavigationBar(){
        navigationItem.title = "Мои баллы"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let rightBarButton = UIBarButtonItem(image: .Profile.iconInfoBeigeProfile, style: .plain, target: self, action: #selector(showInfoVC))
        navigationItem.setRightBarButton(rightBarButton, animated: true)
        rightBarButton.tintColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .Profile.iconBack, style: .done, target: self, action: #selector(dismissView))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(resource: ColorResource.Colors.FFFFFF)
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
            make.bottom.equalTo(transactionsView.snp.top).inset(20)
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
        
        transactionsView.snp.makeConstraints { make in
            make.top.equalTo(stackViewForBonus.snp.bottom).inset(-32)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(transactionsView.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
