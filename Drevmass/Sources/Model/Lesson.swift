//
//  Lesson.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 18.03.2024.
//

import Foundation
import UIKit
import SwiftyJSON

class Lesson {
    var id: Int = 0
    var courseTitle: String = ""
    var courseID: Int = 0
    var name: String = ""
    var title: String = ""
    var description: String = ""
    var image_src: String = ""
    var video_src: String = ""
    var duration: Int = 0
    var is_favorite: Bool = false
    var completed: Bool = false
    var order_id: Int = 0
    
    init() {
        
    }
    
    init(json:JSON) {
        if let temp = json["id"].int {
            self.id = temp
        } 
        if let temp = json["CourseTitle"].string {
            self.courseTitle = temp
        }
        if let temp = json["CourseID"].int {
            self.courseID = temp
        } 
        if let temp = json["name"].string {
            self.name = temp
        }
        if let temp = json["title"].string {
            self.title = temp
        }
        if let temp = json["description"].string {
            self.description = temp
        }
        if let temp = json["image_src"].string {
            self.image_src = temp
        }
        if let temp = json["video_src"].string {
            self.video_src = temp
        }
        if let temp = json["duration"].int {
            self.duration = temp
        } 
        if let temp = json["is_favorite"].bool {
            self.is_favorite = temp
        }
        if let temp = json["completed"].bool {
            self.completed = temp
        }
        if let temp = json["order_id"].int {
            self.order_id = temp
        }
    }
}
