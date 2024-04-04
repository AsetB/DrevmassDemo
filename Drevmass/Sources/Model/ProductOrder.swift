//
//  ProductOrder.swift
//  Drevmass
//
//  Created by Aset Bakirov on 02.04.2024.
//

import Foundation
import SwiftyJSON

///Model for product ordering
class ProductOrder {
    public var name: String = ""
    public var price: Int = 0
    public var productID: Int = 0
    public var quantity: Int = 0
    
    init(json: JSON) {
        if let data = json["name"].string {
            self.name = data
        }
        if let data = json["price"].int {
            self.price = data
        }
        if let data = json["product_id"].int {
            self.productID = data
        }
        if let data = json["quantity"].int {
            self.quantity = data
        }
    }
    init() {}
}
