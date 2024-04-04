//
//  UIViewController + Extensions.swift
//  Drevmass
//
//  Created by Aset Bakirov on 06.03.2024.
//

import UIKit

extension UIViewController {
    ///Shows UIAlertController view
    public func showAlertMessage(title: String, message: String){
        
        let alertMessagePopUpBox = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        
        alertMessagePopUpBox.addAction(okButton)
        self.present(alertMessagePopUpBox, animated: true)
    }
}
