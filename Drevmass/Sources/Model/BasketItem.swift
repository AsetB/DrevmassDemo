//
//  BasketItem.swift
//  Drevmass
//
//  Created by Aset Bakirov on 26.03.2024.
//

import Foundation
import SwiftyJSON


class BasketItem {
    public var productID: Int = 0
    public var productTitle: String = ""
    public var price: Int = 0
    public var productImg: String = ""
    public var count: Int = 0
    
    init(json: JSON) {
        if let data = json["product_id"].int {
            self.productID = data
        }
        if let data = json["product_title"].string {
            self.productTitle = data
        }
        if let data = json["price"].int {
            self.price = data
        }
        if let data = json["product_img"].string {
            self.productImg = data
        }
        if let data = json["count"].int {
            self.count = data
        }
    }
    
    init() {}
}
