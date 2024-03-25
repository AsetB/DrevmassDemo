//
//  Days.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 23.03.2024.
//

import Foundation
import SwiftyJSON
import UIKit

class Days {
    var course_id: Int = 0
    var fri: Bool = false
    var mon: Bool = false
    var notificationIsSelected: Bool = false
    var sat: Bool = false
    var sun: Bool = false
    var thu: Bool = false
    var time: String = ""
    var tue: Bool = false
    var user_id: Int = 0
    var wed: Bool = false
    
    init() {
        
    }
    
    init(json: JSON) {
        if let temp = json["course_id"].int {
            self.course_id = temp
        }
        if let temp = json["fri"].bool {
            self.fri = temp
        } 
        if let temp = json["mon"].bool {
            self.mon = temp
        }
        if let temp = json["notificationIsSelected"].bool {
            self.notificationIsSelected = temp
        }
        if let temp = json["sat"].bool {
            self.sat = temp
        } 
        if let temp = json["sun"].bool {
            self.sun = temp
        }
        if let temp = json["thu"].bool {
            self.thu = temp
        } 
        if let temp = json["time"].string {
            self.time = temp
        } 
        if let temp = json["tue"].bool {
            self.tue = temp
        }
        if let temp = json["user_id"].int {
            self.user_id = temp
        }  
        if let temp = json["wed"].bool {
            self.wed = temp
        }
    }
}
