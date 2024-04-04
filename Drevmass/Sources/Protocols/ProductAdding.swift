//
//  ProductAdding.swift
//  Drevmass
//
//  Created by Aset Bakirov on 27.03.2024.
//

import Foundation
import SwiftyJSON
import Alamofire

///Interface for adding product to basket
protocol ProductAdding: AnyObject {
    func productDidAdd(product: Product)
}
