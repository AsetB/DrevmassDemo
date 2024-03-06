//
//  BurningBonus.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 06.03.2024.
//

import Foundation
import SwiftyJSON

class BurningBonus {
    public var activated_date: String = ""
    public var bonus: Int = 0
    public var burning_date: String = ""
    public var id: Int = 0
    public var userid: Int = 0
    
    init(){
        
    }
    
    init(json: JSON){
        
        if let temp = json["activated_date"].string {
            self.activated_date = temp
        }
        if let temp = json["bonus"].int {
            self.bonus = temp
        }
        if let temp = json["burning_date"].string {
            self.burning_date = temp
        }
        if let temp = json["id"].int {
            self.id = temp
        } 
        if let temp = json["userid"].int {
            self.userid = temp
        }
        
    }
}
