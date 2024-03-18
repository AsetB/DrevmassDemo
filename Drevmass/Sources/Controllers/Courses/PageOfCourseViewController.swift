//
//  PageOfCourseViewController.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 17.03.2024.
//

import UIKit

class PageOfCourseViewController: UIViewController {
    
    var course = Course()
    
    // MARK: - UI elements

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()
    }
    


}
extension PageOfCourseViewController {
    
    // MARK: - setups
    
    func setupView() {
        view.backgroundColor = UIColor(resource: ColorResource.Colors.CDC_9_C_1)
    }
    func setupConstraints() {
        
    }
}
