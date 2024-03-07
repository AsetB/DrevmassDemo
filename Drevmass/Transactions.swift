//
//  Transactions.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 06.03.2024.
//

import Foundation
import SwiftyJSON

class Transactions {
    public var bonus_id: Int = 0
    public var description: String = ""
    public var promo_price: Int = 0
    public var promo_type: String = ""
    public var promocode: String = ""
    public var transaction_date: String = ""
    public var transaction_type: String = ""
    public var userid: Int = 0
    
    
    init(){
        
    }
    
    init(json: JSON){
        
        if let temp = json["bonus_id"].int {
            self.bonus_id = temp
        }
        if let temp = json["description"].string {
            self.description = temp
        } 
        if let temp = json["promo_price"].int {
            self.promo_price = temp
        }
        if let temp = json["promo_type"].string {
            self.promo_type = temp
        }
        if let temp = json["promocode"].string {
            self.promocode = temp
        }
        if let temp = json["transaction_date"].string {
            self.transaction_date = temp
        }
        if let temp = json["transaction_type"].string {
            self.transaction_type = temp
        }
        if let temp = json["userid"].int {
            self.userid = temp
        }
       
    }
}
