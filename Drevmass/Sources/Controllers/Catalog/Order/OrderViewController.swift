//
//  OrderViewController.swift
//  Drevmass
//
//  Created by Aset Bakirov on 27.03.2024.
//

import UIKit
import SnapKit

class OrderViewController: UIViewController {
    //- MARK: - Variables

    //- MARK: - Local outlets
    private lazy var topLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var recipientSegmentControl: UISegmentedControl = {
        let segControl = UISegmentedControl()
        segControl.insertSegment(withTitle: "Получу я", at: 0, animated: false)
        segControl.insertSegment(withTitle: "Другой получатель", at: 1, animated: false)
        //segControl.backgroundColor = UIColor(resource: ColorResource.Colors.EFEBE_9) 
        return segControl
    }()
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        navigationItem.title = "Оформление заказа"

    }
    //- MARK: - Add & set Views
    private func addViews() {
        
    }
    
    //- MARK: - Set Constraints
    private func setConstraints() {
        
    }
}
