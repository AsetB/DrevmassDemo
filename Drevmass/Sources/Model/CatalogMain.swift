//
//  CatalogMain.swift
//  Drevmass
//
//  Created by Aset Bakirov on 11.03.2024.
//

import Foundation
import SwiftyJSON

/*
 "id": 17,
 "title": "Ролик для прямой осанки",
 "description": "Используется после основного комплекса на Древмасс для более глубокой работы с поясничным, грудным и шейным отделом. 4-6 прокатов позволяют более глубоко проработать и расслабить паравертебральные мышцы спины и расправить осанку. Комфортная проработка шейного отдела.",
 "price": 2390,
 "height": "для всех",
 "size": "10.2 x 20.5 см",
 "basket_count": 0,
 "image_src": "images/1690447073.png",
 "video_src": "qEKlbrmQ6BM",
 "viewed": 224
 */
class CatalogMain {
    public var id: Int = 0
    public var title: String = ""
    public var description: String = ""
    public var price: Int = 0
    public var height: String = ""
    public var size: String = ""
    public var basketCount: Int = 0
    public var imageSource: String = ""
    public var videoSource: String = ""
    public var viewed: Int = 0
    
    init(json: JSON) {
        if let data = json["id"].int {
            self.id = data
        }
        if let data = json["title"].string {
            self.title = data
        }
        if let data = json["description"].string {
            self.description = data
        }
        if let data = json["price"].int {
            self.price = data
        }
        if let data = json["height"].string {
            self.height = data
        }
        if let data = json["size"].string {
            self.size = data
        }
        if let data = json["basket_count"].int {
            self.basketCount = data
        }
        if let data = json["image_src"].string {
            self.imageSource = data
        }
        if let data = json["video_src"].string {
            self.videoSource = data
        }
        if let data = json["viewed"].int {
            self.viewed = data
        }
    }
    
    init() {}
}
