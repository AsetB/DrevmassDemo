//
//  ProductCounting.swift
//  Drevmass
//
//  Created by Aset Bakirov on 28.03.2024.
//

import Foundation

///interface for increment and decrement API
protocol ProductCounting: AnyObject {
    func productDidCount(basketItem: BasketItem, countIs: CountType)
}


enum CountType {
    case increment
    case decrement
}
