//
//  Course.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 16.03.2024.
//

import Foundation
import UIKit
import SwiftyJSON

class Course {
    var id: Int = 0
    var name: String = ""
    var description: String = ""
    var duration: Int = 0
    var lesson_cnt:  Int = 0
    var image_src: String = ""
    var completed: Bool = false
    var is_started: Bool = false
    var bonus_info: [CourseBonus] = []
    var lessons: [Lesson] = []
    
    init(){
        
    }
    
    init(json: JSON) {
        if let temp = json["name"].string{
            self.name = temp
        }
        if let temp = json["id"].int{
            self.id = temp
        }
        if let temp = json["description"].string{
            self.description = temp
        }
        if let temp = json["lesson_cnt"].int{
            self.lesson_cnt = temp
        }
        if let temp = json["duration"].int{
            self.duration = temp
        }
        if let temp = json["image_src"].string{
            self.image_src = temp
        }
        if let temp = json["completed"].bool{
            self.completed = temp
        }
        if let temp = json["is_started"].bool{
            self.is_started = temp
        }
        if let array = json["bonus_info"].array{
            for item in array{
                let temp = CourseBonus(json: item)
                self.bonus_info.append(temp)
            }
        } 
        if let array = json["lessons"].array{
            for item in array{
                let temp = Lesson(json: item)
                self.lessons.append(temp)
            }
        }
    }
}
