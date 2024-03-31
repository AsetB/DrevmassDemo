//
//  URLs.swift
//  Drevmass
//
//  Created by Aset Bakirov on 07.03.2024.
//

import Foundation

enum URLs {
    static let BASE_URL = "http://185.100.67.103/api/"
    static let SIGN_IN_URL = BASE_URL + "login"
    static let SIGN_UP_URL = BASE_URL + "signup"
    static let FORGOT_PASS_URL = BASE_URL + "forgot_password"
    static let GET_BONUS_URL = BASE_URL + "bonus"
    static let BONUS_INFO_URL = BASE_URL + "bonus/info"
    static let USER_INFO_URL = BASE_URL + "user/information"
    static let GET_PROMOCODE_INFO_URL = BASE_URL + "user/promocode"
    static let DELETE_USER_URL = BASE_URL + "user"
    static let RESET_PASSWORD_URL = BASE_URL + "reset_password"
    static let INFO_URL = BASE_URL + "info"
    static let SOCIAL_URL = BASE_URL + "social"
    static let CONTACT_URL = BASE_URL + "contacts"
    static let POST_SUPPORT_URL = BASE_URL + "support"
    static let GET_COURSE_URL = BASE_URL + "course"
    static let GET_COURSE_BY_ID_URL = BASE_URL + "course/"
    static let GET_COURSE_BONUS_URL = BASE_URL + "course/bonus"
    static let GET_PRODUCT_FAMOUS = BASE_URL + "products/famous"
    static let GET_PRODUCT_PRICEDOWN = BASE_URL + "products/pricedown"
    static let GET_PRODUCT_PRICEUP = BASE_URL + "products/priceup"
    static let GET_PRODUCT_BY_ID = BASE_URL + "products/"
    static let FAVORITE_URL = BASE_URL + "favorites"
    static let LESSONS_COMPLETE_URL = BASE_URL + "lessons/complete"
    static let GET_DAY_URL = BASE_URL + "days"
    static let BASKET = BASE_URL + "basket"
    static let DELETE_ITEM_BASKET = BASE_URL + "basket/"
    static let INCREASE_ITEM_BASKET = BASE_URL + "increase"
    static let DECREASE_ITEM_BASKET = BASE_URL + "decrease"
    static let ACTIVATE_PROMOCODE = BASE_URL + "activate"
}

enum imageSource {
    static let BASE_URL = "http://45.12.74.158/"
}

