//
//  PriceFormatter.swift
//  Drevmass
//
//  Created by Aset Bakirov on 19.03.2024.
//

import UIKit

///Returns string with rouble sing
func formatPrice(_ price: Int) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.groupingSeparator = " "
    
    let formattedPrice = numberFormatter.string(from: NSNumber(value: price)) ?? "\(price)"
    
    return "\(formattedPrice) ₽"
}

