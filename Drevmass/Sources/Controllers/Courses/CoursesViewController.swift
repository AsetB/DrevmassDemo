//
//  CoursesViewController.swift
//  Drevmass
//
//  Created by Aset Bakirov on 04.03.2024.
//

import UIKit

class CoursesViewController: UIViewController {
    
    //    MARK: UI elements

    
    //    MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
    }
    

}

extension CoursesViewController {
    
    //    MARK: other funcs
    
    
    
    
   //    MARK: - setups
    
    func setupView() {
        view.backgroundColor = UIColor(resource: ColorResource.Colors.F_3_F_1_F_0)
    }
    
    func setupConstraints() {
        
    }
}
