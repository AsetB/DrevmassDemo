//
//  Bonus.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 06.03.2024.
//

import Foundation
import SwiftyJSON

class Bonus {
    public var bonus: String = ""
    public var burning: [BurningBonus] = []
    public var transactions: [Transactions] = []
    
    init(){
        
    }
    
    init(json: JSON){
        if let temp = json["bonus"].string{
            self.bonus = temp
        }
        
        if let array = json["burning"].array{
            
            for item in array{
                let temp = BurningBonus(json: item)
                self.burning.append(temp)
            }
        } 
        if let array = json["transactions"].array{
            
            for item in array{
                let temp = Transactions(json: item)
                self.transactions.append(temp)
            }
        }

        
        
    }
}
