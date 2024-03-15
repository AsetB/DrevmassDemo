//
//  UIFont + Extensions.swift
//  Drevmass
//
//  Created by Aset Bakirov on 04.03.2024.
//

import UIKit

extension UIFont {
    public enum FontType: String {
        case SFProDisplayBold = "SFProDisplay-Bold"
        case SFProDisplaySemibold = "SFProDisplay-Semibold"
        case SFProTextRegular = "SFProText-Regular"
        case SFProTextMedium = "SFProText-Medium"
        case SFProTextSemiBold = "SFProText-Semibold"
        case SFProTextBold = "SFProText-Bold"
    }
    public static func addFont(type: FontType, size: CGFloat) -> UIFont{
        return UIFont(name: type.rawValue, size: size)!
    }
}
