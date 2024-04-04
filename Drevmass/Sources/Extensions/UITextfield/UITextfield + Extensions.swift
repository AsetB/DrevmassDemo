//
//  UITextfield + Extensions.swift
//  Drevmass
//
//  Created by Aset Bakirov on 05.03.2024.
//

import UIKit

//- MARK: - textfiled with image icon on the left
extension UITextField {
    ///set icon with padding for Textfield
    func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame:
                                    CGRect(x: 0, y: 4, width: 24, height: 24))
        iconView.image = image
        
        let iconContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
}
//- MARK: - adds padding to text inside TextField
class TextFieldWithPadding: UITextField {
    
    var padding = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 16)
    
    init(){
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
//- MARK: - Checks email mask
public let __firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
public let __serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
public let __emailRegex = __firstpart + "@" + __serverpart + "[A-Za-z]{2,8}"
public let __emailPredicate = NSPredicate(format: "SELF MATCHES %@", __emailRegex)

extension String {
    func isEmail() -> Bool {
        return __emailPredicate.evaluate(with: self)
    }
}

extension UITextField {
    ///If string isEmail returns true
    func isEmail() -> Bool {
        return self.text?.isEmail() ?? false
    }
}

//- MARK: - Checks phone mask
extension String {
    func applyPatternOnNumbers(pattern: String, replacementCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
}

//- MARK: - Phone number mask
extension SignUpViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneTextfield {
            let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
            
            let formattedText = newText.applyPatternOnNumbers(pattern: "+# ### ### ## ##", replacementCharacter: "#")
            
            let maxLength = "+# ### ### ## ##".count
                if formattedText.count > maxLength {
                return false
            }
            textField.text = formattedText
            return false
        }
        return true
    }
}

extension OrderViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneTextfield {
            let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
            
            let formattedText = newText.applyPatternOnNumbers(pattern: "+# ### ### ## ##", replacementCharacter: "#")
            
            let maxLength = "+# ### ### ## ##".count
                if formattedText.count > maxLength {
                return false
            }
            textField.text = formattedText
            return false
        }
        return true
    }
}
