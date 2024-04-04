//
//  Order.swift
//  Drevmass
//
//  Created by Aset Bakirov on 02.04.2024.
//

import Foundation
import SwiftyJSON

///Model
class Order {
    public var bonus: Int = 0
    public var crmLink: String = ""
    public var email: String = ""
    public var phoneNumber: String = ""
    public var products: [ProductOrder] = []
    public var totalPrice: Int = 0
    public var username: String = ""
    
    init(json: JSON) {
        if let data = json["bonus"].int {
            self.bonus = data
        }
        if let data = json["crmlink"].string {
            self.crmLink = data
        }
        if let data = json["email"].string {
            self.email = data
        }
        if let data = json["phone_number"].string {
            self.phoneNumber = data
        }
        if let array = json["products"].array{
            for item in array{
                let data = ProductOrder(json: item)
                self.products.append(data)
            }
        }
        if let data = json["total_price"].int {
            self.totalPrice = data
        }
        if let data = json["username"].string {
            self.username = data
        }
    }
    init() {}
}
