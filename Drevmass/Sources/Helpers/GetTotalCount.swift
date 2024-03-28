//
//  GetTotalCount.swift
//  Drevmass
//
//  Created by Aset Bakirov on 28.03.2024.
//

import Foundation
import Alamofire
import SwiftyJSON

//сколько штуков товаров в корзине
func getTotalCount(completion: @escaping (Int) -> Void) {
    var totalCount = 0
    var basketArray = [BasketItem]()
    
    let headers: HTTPHeaders = ["Authorization": "Bearer \(AuthenticationService.shared.token)"]
    
    AF.request(URLs.BASKET, method: .get, headers: headers).responseData {  response in
        
        guard let responseCode = response.response?.statusCode else {
            completion(totalCount)
            return
        }
        
        if responseCode == 200 {
            let json = JSON(response.data!)
            print("JSON: \(json)")
            
            //parse basket items
            if let array = json["basket"].array {
                for item in array {
                    let basketItem = BasketItem(json: item)
                    basketArray.append(basketItem)
                }
            }
        } else {
            var ErrorString = "CONNECTION_ERROR"
            if let sCode = response.response?.statusCode {
                ErrorString = ErrorString + " \(sCode)"
            }
            print(ErrorString)
        }
        //count sum of items in basket array
        for item in basketArray {
            totalCount += item.count
        }
        completion(totalCount)
    }
    
}
