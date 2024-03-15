//
//  Contact.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 12.03.2024.
//

import Foundation
import SwiftyJSON

class Contact {
    var number: String = ""
    var whatsapp: String = ""
    
    init() {
        
    }
    
    init(json: JSON) {
        if let temp = json["number"].string {
            self.number = temp
        }
        if let temp = json["whatsapp"].string {
            self.whatsapp = temp
        }
    }
}
