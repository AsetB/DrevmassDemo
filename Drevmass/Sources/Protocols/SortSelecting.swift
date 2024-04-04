//
//  SortSelecting.swift
//  Drevmass
//
//  Created by Aset Bakirov on 19.03.2024.
//

import Foundation
///interface for handling current sort on Catalog Main Screen
protocol SortSelecting: AnyObject {
    func sortDidSelect(_ sortSelected: SortType)
}

enum SortType {
    case famous
    case priceup
    case pricedown
}
