//
//  SortSelecting.swift
//  Drevmass
//
//  Created by Aset Bakirov on 19.03.2024.
//

import Foundation

protocol SortSelecting: AnyObject {
    func sortDidSelected(_ sortSelected: SortType)
}

enum SortType {
    case famous
    case priceup
    case pricedown
}
