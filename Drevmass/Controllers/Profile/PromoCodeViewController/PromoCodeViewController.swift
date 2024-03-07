//
//  PromoCodeViewController.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 07.03.2024.
//

import UIKit

class PromoCodeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()
        setupNavigationBar()
    }
}

extension PromoCodeViewController {
    
    @objc func showInfoVC() {
         let infoVc = InformationViewController()
        navigationController?.modalPresentationStyle = .overFullScreen
        present(infoVc, animated: true)
     }
     @objc func dismissView() {
         navigationController?.popViewController(animated: true)
     }
    
    func setupView() {
        view.backgroundColor = .Colors.FFFFFF
    }
    func setupNavigationBar(){
        navigationItem.title = "Промокоды"
        let rightBarButton = UIBarButtonItem(image: .Profile.iconInfoBeigeProfile, style: .plain, target: self, action: #selector(showInfoVC))
        navigationItem.setRightBarButton(rightBarButton, animated: true)
        rightBarButton.tintColor = .Colors.B_5_A_380
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .Profile.iconBack, style: .done, target: self, action: #selector(dismissView))
        navigationItem.leftBarButtonItem?.tintColor = .Colors.B_5_A_380
    }
    func setupConstraints() {
        
    }
}
