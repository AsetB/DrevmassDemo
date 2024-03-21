//
//  CourseById.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 18.03.2024.
//

import Foundation
import UIKit
import SwiftyJSON

class CourseById {
    var all_lessons: Int = 0
    var completed_lessons: Int = 0
    var course: [Course] = []
    
    init() {
        
    }
    
    init(json:JSON) {
        if let temp = json["all_lessons"].int{
            self.all_lessons = temp
        }
        if let temp = json["completed_lessons"].int{
            self.completed_lessons = temp
        }
        if let array = json["course"].array{
            for item in array{
                let temp = Course(json: item)
                self.course.append(temp)
            }
        }
    }
    
}
