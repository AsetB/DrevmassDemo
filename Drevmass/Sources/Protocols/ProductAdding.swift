//
//  ProductAdding.swift
//  Drevmass
//
//  Created by Aset Bakirov on 27.03.2024.
//

import Foundation
import SwiftyJSON
import Alamofire

protocol ProductAdding: AnyObject {
    func productDidAdd(product: Product)
}
