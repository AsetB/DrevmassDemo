//
//  CourseBonus.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 16.03.2024.
//

import Foundation
import UIKit
import SwiftyJSON

class CourseBonus {
    var promo_type: String = ""
    var price: Int = 0
    var description: String = ""
    var deadline: String = ""
    
    init() {
        
    }
    
    init(json: JSON){
        
        if let temp = json["promo_type"].string {
            self.promo_type = temp
        } 
        if let temp = json["price"].int {
            self.price = temp
        } 
        if let temp = json["description"].string {
            self.description = temp
        }
        if let temp = json["deadline"].string {
            self.deadline = temp
        }
    }
}
