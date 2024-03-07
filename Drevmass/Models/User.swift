//
//  User.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 07.03.2024.
//

import Foundation
import UIKit
import SwiftyJSON

class User {
    
    public var id: Int = 0
    public var email: String = ""
    public var name: String = ""
    public var gender: Int = 0
    public var height: Int = 0
    public var weight: Int = 0
    public var birth: String = ""
    public var activity: Int = 0
    public var phone_number: String = ""
    
    init(){
        
    }
    
    init(json: JSON){
        if let temp = json["id"].int {
            self.id = temp
        }
        if let temp = json["email"].string {
            self.email = temp
        } 
        if let temp = json["name"].string {
            self.name = temp
        }
        if let temp = json["gender"].int {
            self.gender = temp
        }
        if let temp = json["height"].int {
            self.height = temp
        }
        if let temp = json["weight"].int {
            self.weight = temp
        }
        if let temp = json["birth"].string {
            self.birth = temp
        }
        if let temp = json["activity"].int {
            self.activity = temp
        }
        if let temp = json["phone_number"].string {
            self.phone_number = temp
        }
        
        
        
    }
    
}
