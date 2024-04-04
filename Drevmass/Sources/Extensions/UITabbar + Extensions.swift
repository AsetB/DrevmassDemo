//
//  UITabbar + Extensions.swift
//  Drevmass
//
//  Created by Aset Bakirov on 26.03.2024.
//

import UIKit

extension UITabBar {
    ///Add badge for UITabBar Basket
    func addBadge(index: Int, value: Int) {
        let stringValue = String(value)
        if let tabItems = self.items {
            let tabItem = tabItems[index]
            
            let itemAppearance = UITabBarItemAppearance()
            itemAppearance.normal.badgePositionAdjustment.horizontal = 33
            itemAppearance.normal.badgePositionAdjustment.vertical = -1
            
            let appearance = UITabBarAppearance()
            appearance.stackedLayoutAppearance = itemAppearance
            appearance.inlineLayoutAppearance = itemAppearance
            appearance.compactInlineLayoutAppearance = itemAppearance
            appearance.backgroundColor = UIColor(resource: ColorResource.Colors.F_9_F_9_F_9)

            self.standardAppearance = appearance
            
            tabItem.badgeValue = stringValue
            tabItem.badgeColor = UIColor(resource: ColorResource.Colors.FA_5_C_5_C)
            tabItem.setBadgeTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .medium)], for: .normal)
        }
    }
    ///Remove badge for UITabBar Basket
    func removeBadge(index: Int) {
        if let tabItems = self.items {
            let tabItem = tabItems[index]
            tabItem.badgeValue = nil
        }
    }
}
