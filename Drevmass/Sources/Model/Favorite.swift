//
//  Favorite.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 22.03.2024.
//

import Foundation
import UIKit
import SwiftyJSON

class Favorite {
    var course_id: Int = 0
    var course_name: String = ""
    var lessons: [LessonsById] = []
    
    init() {
        
    }
    
    init(json: JSON) {
        if let temp = json["course_id"].int{
            self.course_id = temp
        }
        if let temp = json["course_name"].string{
            self.course_name = temp
        }
        if let array = json["lessons"].array{
            for item in array{
                let temp = LessonsById(json: item)
                self.lessons.append(temp)
            }
        }
    }
}
