//
//  Basket.swift
//  Drevmass
//
//  Created by Aset Bakirov on 26.03.2024.
//

import Foundation
import SwiftyJSON

class Basket {
    //public var basket: [BasketItem] = []
    public var bonus: Int = 0
    //public var products: [Product] = []
    public var totalPrice: Int = 0
    public var usedBonus: Int = 0
    public var basketPrice: Int = 0
    public var discount: Int = 0
    public var countProducts: Int = 0
    
    init(json: JSON) {
//        if let array = json["basket"].array {
//            for item in array {
//                let data = BasketItem(json: item)
//                self.basket.append(data)
//            }
//        }
        if let data = json["bonus"].int {
            self.bonus = data
        }
//        if let array = json["products"].array {
//            for item in array {
//                let data = Product(json: item)
//                self.products.append(data)
//            }
//        }
        if let data = json["total_price"].int {
            self.totalPrice = data
        }
        if let data = json["used_bonus"].int {
            self.usedBonus = data
        }
        if let data = json["basket_price"].int {
            self.basketPrice = data
        }
        if let data = json["discount"].int {
            self.discount = data
        }
        if let data = json["count_products"].int {
            self.countProducts = data
        }
    }
    
    init() {}
}
