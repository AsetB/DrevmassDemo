//
//  TabBarController.swift
//  Drevmass
//
//  Created by Aset Bakirov on 04.03.2024.
//

import UIKit

class TabBarController: UITabBarController {
    // - MARK: - Variables
    let coursesVC = UINavigationController(rootViewController: CoursesViewController())
    let catalogVC = UINavigationController(rootViewController: CatalogMainViewController())
    let basketVC = UINavigationController(rootViewController: BasketViewController())
    let profileVC = UINavigationController(rootViewController: ProfileViewController())
    // - MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    // - MARK: - Settings
    func setupTabs() {
        tabBar.backgroundColor = UIColor(resource: ColorResource.Colors.A_1_A_1_A_1)
    
        coursesVC.tabBarItem = UITabBarItem(title: "", image: UIImage(resource: ImageResource.TabBarIcon.course), selectedImage: UIImage(resource: ImageResource.TabBarIcon.courseSelected).withRenderingMode(.alwaysOriginal))
        catalogVC.tabBarItem = UITabBarItem(title: "", image: UIImage(resource: ImageResource.TabBarIcon.catalog), selectedImage: UIImage(resource: ImageResource.TabBarIcon.catalogSelected).withRenderingMode(.alwaysOriginal))
        basketVC.tabBarItem = UITabBarItem(title: "", image: UIImage(resource: ImageResource.TabBarIcon.basket), selectedImage: UIImage(resource: ImageResource.TabBarIcon.basketSelected).withRenderingMode(.alwaysOriginal))
        profileVC.tabBarItem = UITabBarItem(title: "", image: UIImage(resource: ImageResource.TabBarIcon.profile), selectedImage: UIImage(resource: ImageResource.TabBarIcon.profileSelected).withRenderingMode(.alwaysOriginal))
 
        setViewControllers([coursesVC, catalogVC, basketVC, profileVC], animated: false)
    }
}
