//
//  Social.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 12.03.2024.
//

import Foundation
import SwiftyJSON

class Social {
    var vk: String = ""
    var youtube: String = ""
    
    init() {
        
    }
    
    init(json: JSON) {
        if let temp = json["vk"].string {
            self.vk = temp
        }
        if let temp = json["youtube"].string {
            self.youtube = temp
        }
    }
}
